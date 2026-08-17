# Shittim Chest — Chat, Painéis e Integrações

O Shittim Chest é a face do usuário: chat, painéis e integrações multicanal
— a camada que transforma capacidades de modelos e agentes em algo que você
usa todos os dias. Ele recebe modelos e memória da Arona, e agentes, painéis
e fluxos de trabalho industriais do scepter do entelecheia. Este guia é
organizado por capacidade: chat, painéis, canais, busca e auth.

## Arquitetura num relance

```text
Você
 │  aplicativo desktop · web UI · 12+ canais de IM (discord/slack/matrix/lark/…)
 ▼
Núcleo do Shittim Chest (node-2:8425)
 ├─ Chat: conversas persistidas no Postgres, streaming SSE/WS
 ├─ Painéis: grade de dados / pipeline de mídia / gêmeo 3D (motor de painéis)
 ├─ Pipeline de mídia: revisão de visão LLM, geração de imagens, geração 3D (stub)
 ├─ Ponte de canais: IM ↔ núcleo, bidirecional (webhooks + WS)
 └─ Ponte RPC → scepter (agentes, busca semântica, base de conhecimento)
        │
        ▼
Arona (modelos, memória) · scepter (agentes, painéis, busca)
```

## 1. Chat

- Conversas e mensagens persistem no Postgres (tabelas `conversations` /
  `messages`). O histórico completo é montado no servidor.
- Streaming via SSE com replay de chunks; o shell desktop mostra chunks de
  raciocínio e chamadas de ferramentas dos agentes do scepter.
- O `chat.send` suporta id de conversa, sobrescrita de modelo e flags de
  memória (veja o [guia da Arona](./arona.md) para a semântica do gateway
  de memória).

## 2. Painéis

Painéis são criados a partir de um único prompt: a engine gera o layout e os
widgets e os persiste no armazenamento de workspace do scepter
(`.amphoreus/workspace.toml` + `.noa/views/*.view.toml`). A edição é
estruturada, não caixa-preta: o binding bruto da fonte de dados, a lista de
widgets e o estado da conexão são visíveis, com um diálogo de edição
profunda por linha e uma caixa recolhida de ajuste em linguagem natural.

Três tipos de painel:

- **Grade de dados** — visualizações em tabela com campos tipados,
  ordenação/filtro/agrupamento; escritas passam por tipos de edição
  `table.*` com validação e rollback reais.
- **Pipeline de mídia** — um grafo de nós estilo Dify (nós de LLM, geração
  de imagens, HTTP, recuperação de conhecimento, ramificação); pipelines
  rodam no servidor com progresso em streaming e podem ser invocados como
  ferramentas por agentes.
- **Gêmeo 3D** — árvores de modelos de dispositivos com coordenadas de
  mundo, configuração de cena e marcadores de câmera.

## 3. Integrações multicanal

A ponte de canais conecta o núcleo a plataformas de IM (Discord, Slack,
Matrix, Lark, …). Mensagens de entrada tornam-se turnos de chat; respostas
de saída voltam em streaming pelo mesmo canal. Cada canal exige a sua
aplicação OAuth aprovada para uso em produção.

## 4. Busca semântica e conhecimento

- O `search.semantic` faz a ponte para a busca vetorial do scepter (índice
  de workspace do ApoRia + memórias de longo prazo do PhiLia fundidos numa
  única lista ranqueada).
- Bases de conhecimento (criar / adicionar documentos / assinar) persistem
  no Postgres e são pesquisáveis pela mesma superfície RPC.
- Relatórios de agentes são indexados automaticamente, então relatórios
  passados são recuperáveis semanticamente.

## 5. Auth

A autenticação é delegada: o scepter confia no id de usuário do chamador
fornecido pelo gateway do chest (`X-User-Id` / `user_id`), que o chest
obtém da Arona ou do fluxo de convites. Papéis RBAC (admin / operator /
viewer / agent) controlam as operações de escrita em painéis e workspaces.

## Referência de env (subconjunto)

| Variável | Finalidade |
|---|---|
| `DATABASE_URL` | Postgres (obrigatório) |
| `ENTELECHEIA_SCEPTER_URL` / `WS_URL` | Endpoints RPC/WS da engine de agentes |
| `LLM_DEFAULT_PROVIDER_ENDPOINT` / `_API_KEY` / `_MODELS` | Provedor de modelo de chat (normalmente a Arona) |
| `BIGMODEL_API_KEY*` | Pipeline de mídia (visão GLM / geração de imagens CogView) |
| `CHANNEL_*` | Credenciais de canais de IM por plataforma |
