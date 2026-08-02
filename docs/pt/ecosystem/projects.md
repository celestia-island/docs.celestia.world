# Mapa de Projetos

O inventário completo dos repositórios do celestia-island, agrupados por
camada. Repositórios marcados com um site de documentação carregam as suas
próprias docs de *como* em `<name>.docs.celestia.world`; todo o resto é
documentado no próprio repositório.

## Camada 0 — Auth

| Projeto | Papel | Docs |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Autenticação de confiança zero e RBAC: sessões JWT, hash Argon2id, limite de taxa de login, motor de permissões | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Camada 1 — Plataforma

| Projeto | Papel | Docs |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Tipos compartilhados, cliente e servidor JSON-RPC, sessões SSE, circuit breakers, medição e preços de LLM, shell da UI de administração | repositório |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Registro de modelos e provedores (formato TOML de entrypoint) | repositório |

## Camada 2 — UI

| Projeto | Papel | Docs |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | Biblioteca de componentes de UI (Vue/TS + Rust) compartilhada por todos os webUIs | repositório |

## Camada 3 — Serviços

| Projeto | Papel | Docs |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | Painel de administração da API em nuvem: contas, API keys, implantação de modelos, backends, registros de uso | repositório |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | Chat desktop/webUI e shell | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | Plataforma de colaboração multiagente: microkernel exec-only, servidor de orquestração scepter, pipeline de execução IEPL | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | Broker de protocolos industriais: Modbus, S7comm, OPC UA; operações remotas, telemetria, portões de escrita | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | Kit de supervisão de serviços: atualizações contínuas, sondas de saúde, proxy reverso, recuperação de crash loops | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | Motor de documentação Markdown que alimenta este site e todos os sites de docs dos projetos | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## Ferramentas e bibliotecas

| Projeto | Papel | Docs |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | Controle de versão distribuído nativo de IA: isolamento de workspace por agente, logs append-only em JSONL, histórico de snapshots | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | Biblioteca e CLI de busca web multi-motor | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Macros de pipeline com pool de threads (pipes de mensagens baseados em flume) | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | Proc-macro para gerar estruturas aninhadas complexas a partir de um macro simples | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | CLI de Modbus e fontes de dados | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | Motor de terminal virtual autônomo: gerenciamento de PTY, VT100/ANSI | repositório |
| [hifumi](https://github.com/celestia-island/hifumi) | Biblioteca de serialização para migrar dados entre versões | repositório |
| [aris](https://github.com/celestia-island/aris) | Motor de navegador derivado do servo, incorporável como biblioteca (WebGL para gêmeos digitais) | repositório |
| [shirabe](https://github.com/celestia-island/shirabe) | Biblioteca leve de automação e depuração de navegador nativa em Rust | repositório |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Framework full-stack alimentado pelo Modelo de Componentes WASM | repositório |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | Renderização de Markdown para TUIs ratatui | repositório |
| [arcaea](https://github.com/celestia-island/arcaea) | Biblioteca Rust para o protocolo de persona celestia | repositório |
| [scriptum](https://github.com/celestia-island/scriptum) | Interface de terminal (TUI) para o entelecheia: um "display burro" que conversa com o servidor scepter | repositório |

## Edge e hardware

| Projeto | Papel | Docs |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Kernel de SO Rust para dispositivos edge ARM64/RISC-V; núcleo de tempo real determinístico para o horizonte de longo prazo | repositório |

## Infraestrutura e ferramentas

| Projeto | Papel | Docs |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Toolchain de desenvolvimento compartilhado: receitas justfile, registro de patches, linting | repositório |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | Suites de teste de integração em hardware real para o ciclo completo | repositório |
| [sysl](https://github.com/celestia-island/sysl) | Synthetic Source License (SySL): uma licença projetada para código gerado por IA | repositório |

## Presença web

| Propriedade | Papel | Docs |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Presença da organização | repositório |
| [docs.celestia.world](https://docs.celestia.world) | Este site — filosofia, mapa, primeiros passos | repositório |
| [e.celestia.world](https://e.celestia.world) | Página pública de destino | repositório |
| [dev.celestia.world](https://dev.celestia.world) | Portal do desenvolvedor | repositório |
| [arona.celestia.world](https://arona.celestia.world) | Painel de administração da API em nuvem (produto) | — |

## Aprofundar-se

- [Arquitetura em Camadas](../philosophy/layered-architecture.md) — por que essas camadas existem.
- [O Ciclo Fechado](../philosophy/closed-loop.md) — como os projetos cooperam ao longo do ciclo.
- [Sites e Responsabilidade](./sites.md) — quem documenta o quê e onde.
