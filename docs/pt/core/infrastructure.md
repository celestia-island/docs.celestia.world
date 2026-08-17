# Infraestrutura Central — Auth, RPC e Fundações

Toda plataforma que você usa repousa sobre a mesma fundação. Leia isto uma
vez e os guias de plataforma se encaixam: kirino (auth de confiança zero e
RBAC), plana (tipos de protocolo, transporte JSON-RPC, medição, motor de
sincronização) e hikari (a biblioteca de componentes de UI).

## Autenticação e autorização (kirino)

- **Identidade**: hash de senhas com Argon2id; tokens JWT de
  acesso/renovação (`TokenManager`, `kirino-session`); limite de taxa de
  login e bloqueio de conta.
- **RBAC**: permissões hierárquicas (agent.*, system.*, knowledge.*, …)
  resolvidas por um `GrantResolver`; papéis agrupam permissões (admin vê
  tudo, viewer é somente leitura). As atribuições persistem no Postgres.
- **Delegação**: o scepter confia no id de usuário do chamador fornecido
  pelo gateway do chest (`X-User-Id` / `user_id`) e o usa apenas para
  isolamento de workspace — a camada de autenticação está sempre a montante.
- **Superfície de administração**: os endpoints admin do painel exigem um
  `ARONA_ADMIN_TOKEN` dedicado e falham fechados sem ele.

## Protocolo e RPC (plana)

- Todo o tráfego da plataforma é **JSON-RPC 2.0 sobre WebSocket** (e
  requisição/resposta via HTTP POST `/api/rpc`). Os métodos são nomeados
  `<Domain>.<Action>` — p. ex. `Sync.MemoryQueryRequest`, `Cli.Search`,
  `Mcp.CallTool`.
- Os tipos do protocolo de transmissão vivem no plana (`plana-state-sync` /
  `plana-types`): uma única fonte de verdade para o protocolo; repositórios
  a jusante fixam uma tag lançada.
- Notificações (sem `id`) fazem push de eventos como chunks de streaming e
  atualizações de painel; requisições carregam um `id` ecoado na resposta.
- O motor de sincronização (`plana-sync`) é uma árvore de estado
  autoritativa do servidor: clientes declaram viewports, o servidor difunde
  diffs com snapshots completos periódicos.

## Medição e preços (plana)

O uso é medido por API key e precificado a partir de uma tabela canônica
(medição do `plana-llm-provider`): tokens de prompts/completions, estimativa
de custo e imposição de cotas são compartilhados entre os serviços.

## Componentes de UI (hikari)

A biblioteca de componentes Vue (`@celestia-island/hikari`) fornece botões,
badges, tabelas, modais e diálogos de confirmação usados por todos os
webUIs; as páginas das plataformas os compõem com o shell de UI do plana.
Componentes compartilhados devem subir para cá, a montante, em vez de serem
reimplementados por repositório.

## Regras de dependência

- Camada 0: kirino (auth) → Camada 1: plana (protocolo/fundações) →
  Camada 2: hikari (UI) → Camada 3: serviços (arona, chest, entelecheia,
  evernight).
- Serviços implementam somente lógica de negócio; capacidades compartilhadas
  vêm das camadas a montante. Dependências entre repositórios usam
  referências git ou tags fixadas — nunca dependências de caminho local.
