# Princípios de Segurança

O controle industrial é de segurança crítica: uma falha pode mover
equipamentos físicos. Por isso, a segurança é projetada na arquitetura, não
acrescentada no final.

## 1. O LLM nunca toca o mundo diretamente

No [entelecheia](https://github.com/celestia-island/entelecheia), o modelo vê
apenas um punhado de ferramentas primitivas (`exec`, `write_to_var`). Todo o
trabalho real acontece dentro de um pipeline de execução em sandbox, no qual o
código dos agentes despacha para uma grande superfície de ferramentas MCP
entre agentes. O modelo não pode inventar comportamento; ele só pode chamar as
primitivas que a plataforma expõe.

## 2. Profundidade de segurança em múltiplas camadas

Toda operação que pode afetar o mundo físico passa pela cadeia completa, nesta
ordem:

1. **Revisão de instruções** — o que foi dito ao modelo para fazer
2. **Execução em sandbox** — o código roda isolado, com restrições de política
3. **Validação de política** — o portão de escrita: a operação corresponde à política?
4. **Confirmação humana** — a palavra final para ações irreversíveis
5. **Trilha de auditoria** — tudo é registrado, nada é silencioso

## 3. Criticidade mista: o tempo real nunca depende do LLM

Os sistemas são divididos por tempo de resposta, e **as camadas mais rápidas
nunca dependem de um modelo estar online**:

| Camada | Cadência | Roda em | Dependência de LLM |
| --- | --- | --- | --- |
| L3 — Cognição | segundos–minutos | arona, shittim-chest, entelecheia (Linux) | consumidora principal |
| L2 — Modelo de mundo | 10–50 Hz | serviços de plataforma | opcional |
| L1 — Reativo / borda | 10–100 Hz | evernight em SBCs; pequenos modelos locais | nenhuma |
| L0 — Controle em tempo real | 100 Hz–1 kHz | loop rápido em MCU, intertravamentos locais | nunca |

Se o LLM cair offline, a plataforma degrada com elegância: ou para um estado
seguro, ou continua executando uma trajetória já aprovada. Watchdogs de
hardware ancoram essa semântica — o controle nunca espera por uma chamada de
rede.

## 4. Zero trust, bloqueio por padrão

- Autenticação e autorização vêm do [kirino](https://github.com/celestia-island/kirino):
  JWT com sessões de curta duração, hash de senhas Argon2id, limite de taxa de
  login e um motor RBAC.
- O registro é fechado por convite por padrão; o primeiro usuário de uma
  implantação torna-se o admin, após o que o auto-registro trava.
- Tudo o que não é explicitamente permitido é negado. Quando um serviço tem um
  modo *mock*, o modo mock está desligado por padrão e se recusa a rodar em
  implantações de produção sem um flag explícito.

## 5. Falhas são ruidosas

A degradação silenciosa é tratada como um bug de segurança. Se a memória
falha, um backend está inalcançável ou uma implantação falha, a resposta da
API e a UI devem dizê-lo explicitamente — sem sucesso falso, sem cair para
dados fictícios. Essa regra existe porque incidentes reais mostraram que as
falhas invisíveis são as perigosas.

## Aprofundar-se

- [O Ciclo Fechado](./closed-loop.md) — onde os portões de segurança se situam no fluxo.
- [Arquitetura em Camadas](./layered-architecture.md) — as camadas que a segurança atravessa.
- [Documentação do kirino](https://kirino.docs.celestia.world) — o modelo de autenticação em detalhe.
- [Documentação do evernight](https://evernight.docs.celestia.world) — intermediação de protocolos e portões de escrita.
