# Arona — Gateway de Modelos, Memória e Cluster

A Arona é o plano de controle da plataforma: gateway de modelos, gerenciador
de runtime com autoimplantação e dashboard web. O problema que ela resolve é
transformar "um modelo baixado em alguma máquina" em algo que a plataforma
inteira consiga rotear, medir e lembrar. Este guia é organizado por
capacidade: roteamento de modelos, memória de longo prazo e clusters
multinó.

## Arquitetura num relance

```text
shittim-chest / qualquer cliente OpenAI
        │  /v1/chat/completions (Bearer API key)
        ▼
   gateway Arona (node-2:8420)
   ├─ Router: aliases → balanceamento least-count entre backends
   ├─ Memory Gateway: recall injetado → chat → writeback (episódios)
   └─ Plano de controle de agentes (/ws/agent) ──► arona-agent em nós GPU
        │
        ▼
   Backends: ollama · externos (compatíveis com OpenAI) · engines implantadas por agentes
```

Todo o tráfego de gerenciamento (dashboard, agentes, memória) roda sobre
WebSocket com mensagens JSON-RPC 2.0; a única superfície REST são os
endpoints compatíveis com OpenAI `/v1/*`.

## 1. Modelos

### Registrar um backend

Backends são registrados como `ollama` ou `external` (qualquer servidor
compatível com OpenAI — vLLM, TGI, LMDeploy, roteador do TileRT, …):

```bash
POST /api/admin/backends        # Bearer ADMIN_TOKEN
  {"type": "ollama", "name": "node3-ollama", "url": "http://host:11434"}
  {"type": "external", "name": "my-vllm", "url": "http://host:8000",
   "api_key": "...", "models": ["qwen2.5-72b"]}
```

Backends registrados persistem entre reinicializações (tabela
`backend_configs`) e recebem sondas de saúde contínuas: backends externos
falham fechados até a sua primeira sonda `/v1/models` bem-sucedida, e a sua
lista de modelos é atualizada dinamicamente.

### Autoimplantar um modelo num nó

O binário `arona-agent` roda em máquinas com GPU e conecta de volta ao
painel. Implante um modelo pela página **Agents** do dashboard (ou via
`agents.deploy` com um `agent_id` vazio para mirar automaticamente o nó
menos carregado). O agente baixa o modelo (registro HuggingFace ou Ollama),
inicia a engine (llama.cpp / vLLM / Ollama) e reporta o endpoint da engine —
o painel o registra automaticamente como um backend roteável
`agent-{model}` e o remove na parada.

Endereço de bind da engine: defina `ARONA_AGENT_BIND_ADDR=0.0.0.0` em nós que
precisam servir tráfego para o painel. Nota: as portas das engines não são
autenticadas — implante somente em redes confiáveis.

### Afinidade de conversa

Conversas são fixadas num único backend (afinidade de sessão), o que permite
reutilizar caches KV de runtime. Se um backend fixado deixa de estar
saudável, o roteador faz fallback e refixa.

## 2. Memória de longo prazo

A Arona é um **gateway de memória**: ela não treina modelos — orquestra um
serviço de memória (o agente PhiLia do entelecheia) em volta do seu modelo
existente.

### Ativar

```bash
ARONA_MEMORY_URL=ws://<scepter-host>:8424/ws
ARONA_MEMORY_TOKEN=<token de conexão do scepter>
ARONA_MEMORY_WRITEBACK=1        # ligado por padrão; 0 desativa o writeback
```

### O que acontece por chat

1. **Recall** — a última mensagem do usuário é convertida em embedding e
   consultada no serviço de memória; memórias relevantes são injetadas como
   uma seção de sistema `## Relevant Long-Term Memories` (idempotente).
2. **Chat** — o contexto montado é roteado para o modelo.
3. **Writeback** — o turno concluído é extraído heuristicamente
   (`User: … / Assistant: …`, zero chamadas de LLM) e armazenado como um
   episódio no grafo de memória (com suporte a pgvector, sobrevive a
   reinicializações).
4. **Estado** — toda resposta reporta `memory: enabled | disabled |
   offline`; a superfície REST adiciona um cabeçalho `X-Arona-Memory`.
   Falhas nunca bloqueiam o chat; `offline` significa que o serviço de
   memória está inalcançável e isso é sempre visível na UI.

Sobrescrita por chamada: `chat.send` aceita `memory: true|false`.

### Gerenciar

A página **Memory** do dashboard mostra atividade de recall/writeback/
exclusão e permite excluir nós armazenados. Sessões persistem no servidor:
passe `conversation_id` para o `chat.send` e o servidor monta o histórico em
vez do cliente.

## 3. Operações

- **Auth**: o registro trava após o primeiro bootstrap do admin
  (`ARONA_REGISTRATION_OPEN=1` reabre). Endpoints admin exigem
  `ARONA_ADMIN_TOKEN`; falham fechados sem ele.
- **Medição**: uso e custo são registrados por API key (`usage.list`, níveis
  de cobrança com cota e limite de taxa).
- **Saúde**: `/api/health` e `/v1/health` reportam versão e hash de build.

## Referência de env

| Variável | Finalidade |
|---|---|
| `DATABASE_URL` | Postgres (obrigatório) |
| `JWT_SECRET` | Assinatura de tokens (obrigatório fora do modo mock) |
| `ARONA_HOST` / `ARONA_PORT` | Endereço de bind (padrão `0.0.0.0:8420`) |
| `ARONA_ADMIN_TOKEN` | Bearer token para `/api/admin/*` |
| `ARONA_REGISTRATION_OPEN` | Reabrir o auto-registro |
| `ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK` | Gateway de memória |
| `ARONA_AGENT_NAME` / `ARONA_PANEL_URL` / `ARONA_AGENT_BIND_ADDR` | Nó de agente |
