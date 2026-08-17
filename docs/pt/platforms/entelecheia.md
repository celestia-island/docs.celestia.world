# Entelecheia — Plataforma de Agentes e Memória

O Entelecheia é a plataforma de agentes: o runtime scepter que orquestra
agentes especializados (as "almas"), mantém memória de longo prazo (PhiLia),
fornece busca semântica e hospeda a camada de integração industrial. Atrás
das capacidades da Arona e do Chest está esta plataforma. Este guia é
organizado por capacidade: agentes, memória, busca, conhecimento e conexões.

## Arquitetura num relance

```text
Clientes: Arona (gateway) · Shittim Chest (chat/painéis) · TUI/CLI
        │  JSON-RPC 2.0 sobre WebSocket (token ou API key)
        ▼
   runtime scepter (node-3:8424)
   ├─ Gerenciador de agentes: almas L1 (PhiLia, Skopeo, Hubris, Kalos, …)
   ├─ Cadeias de habilidades: pipelines de LLM + chamadas de ferramentas com prefetch RAG
   ├─ PhiLia: memória de longo prazo (vetorial + grafo, com suporte a pgvector)
   ├─ ApoRia: base de conhecimento + índice de workspace (busca semântica)
   ├─ OreXis: portões de política/segurança na execução de ferramentas
   └─ Reflexão: armazenamento de lições reinjetadas nos prompts
```

## 1. Agentes (almas)

Cada alma é um agente especializado com o seu próprio documento de
identidade, ferramentas (estilo MCP) e habilidades. Cadeias de habilidades
compõem chamadas de LLM com execução de ferramentas; antes de cada chamada,
memórias de longo prazo relevantes e conteúdo da base de conhecimento são
pré-buscados e injetados no prompt de sistema.

Segurança: a execução de ferramentas passa pelos portões de política do
OreXis, e escritas industriais exigem fluxos de aprovação explícitos.

## 2. Memória de longo prazo (PhiLia)

O PhiLia é o serviço de memória por trás do gateway de memória da Arona:

- **Armazenar** — episódios, entidades e artefatos são guardados como nós num
  grafo de memória, convertidos em embeddings e espelhados no pgvector
  (`philia_chunks`).
- **Consultar** — a recuperação semântica combina similaridade vetorial,
  travessia de grafo e decaimento de recência (meia-vida de 14 dias).
- **Consolidar** — fusões periódicas ligam nós relacionados.
- **Superfície de transmissão** — métodos de primeira classe
  `Sync.MemoryStoreRequest` / `MemoryQueryRequest` / `MemoryDeleteRequest`
  (RBAC: SystemWrite / SystemRead) ao lado da rota genérica `Mcp.CallTool`.

Embedding: configurado via `OLLAMA_HOST` + `OLLAMA_EMBED_MODEL` (p. ex.
`nomic-embed-text`), ou uma API remota, com fallback para um modelo ONNX
local.

## 3. Busca semântica

O `Sync.SearchRequest` funde dois armazenamentos numa única lista ranqueada:

- **ApoRia** — índice de workspace, relatórios de agentes e documentos da
  base de conhecimento (híbrido vetorial + palavras-chave com RRF).
- **PhiLia** — memórias de longo prazo (fonte `philia_memory`).

## 4. Base de conhecimento

Crie bases de conhecimento, adicione documentos e assine inscrições rag —
tudo persistido no Postgres. Documentos são convertidos em embeddings no
armazenamento do ApoRia e recuperáveis pela mesma superfície de busca.

## 5. Reflexão

Lições aprendidas são guardadas num armazenamento de lições (pgvector) e
reinjetadas em prompts futuros — uma segunda memória persistente e leve ao
lado do PhiLia.

## 6. Conectando clientes

- WebSocket `ws://<host>:8424/ws` — autentique no upgrade com
  `?token=<connection token>` (ou Bearer); depois `Sync.ConnectHandshake`.
- HTTP JSON-RPC `POST /api/rpc?token=…` para uso de requisição/resposta.
- Token de conexão: `~/.config/entelecheia/scepter.token` no nó do scepter.

## Referência de env (subconjunto)

| Variável | Finalidade |
|---|---|
| `SERVER_BIND_ADDRESS` | Endereço de bind (padrão 127.0.0.1; defina 0.0.0.0:8424 para clientes remotos) |
| `DATABASE_URL` | Postgres (config.toml ou env) |
| `OLLAMA_HOST` / `OLLAMA_EMBED_MODEL` | Backend de embedding |
| `JWT_SECRET` | Tokens de autenticação persistentes (aleatórios por sessão quando não definido) |
| `connection_token` | Arquivo de token de conexão do scepter |
