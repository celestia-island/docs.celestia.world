# Mapa de Projetos

O inventário dos repositórios e produtos da plataforma celestia-island,
agrupados por camada. Um nome com link é um repositório público que você pode
ler hoje; um nome sem link é um produto que acompanha a plataforma mas cujo
código-fonte ainda não é público. Repositórios marcados com um site de
documentação carregam as suas próprias docs de *como*; todo o resto é
documentado no próprio repositório, o que exige acesso a ele.

## Camada 0 — Auth

| Projeto | Papel | Docs |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Autenticação e autorização de confiança zero: sessões, permissões, limite de taxa | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Camada 1 — Plataforma

| Projeto | Papel | Docs |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Tipos de protocolo compartilhados, transporte, medição e as facilidades que todo serviço consome | repositório |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Catálogo de modelos e provedores compartilhado entre os produtos | repositório |

## Camada 2 — UI

| Projeto | Papel | Docs |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | A biblioteca de componentes de UI compartilhada por toda webUI | repositório |

## Camada 3 — Serviços

| Projeto | Papel | Docs |
| --- | --- | --- |
| arona | Gateway de modelos e painel de implantação: chaves, backends, roteamento, uso | [Arona](../platforms/arona.md) |
| shittim-chest | Chat, painéis e integrações — a superfície da bancada | [Shittim Chest](../platforms/chest.md) |
| entelecheia | Plataforma de agentes: agentes, memória de longo prazo, busca semântica, integração industrial | [Entelecheia](../platforms/entelecheia.md) |
| evernight | Broker de protocolos industriais: protocolos de campo, alarmes, gravação, inferência de borda | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | Supervisão de serviços: atualizações graduais, sondas de saúde, proxy reverso, recuperação de falhas | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | O motor de documentação por trás deste site e de todo site de documentação de projeto | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | Back office empresarial: organizações, faturamento, faturas | — |
| electrode_recon | Motor de cálculo da microestrutura de eletrodos — a primeira instância externa na malha de motores | — |

## Ferramentas e bibliotecas

| Projeto | Papel | Docs |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | Controle de versão distribuído nativo de agentes, com workspaces isolados | [repositório](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | Busca na web com múltiplos motores | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | CLI de depuração e simulação multiprotocolo (Modbus RTU e afins) | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Pipelines de pool de threads sobre pipes de mensagens | repositório |
| [yuuka](https://github.com/celestia-island/yuuka) | Macros para estruturas aninhadas compostas e merge/patch de JSON | repositório |
| [kou](https://github.com/celestia-island/kou) | Motor de terminal virtual: PTY, VT100/ANSI, gráficos em linha | repositório |
| [hifumi](https://github.com/celestia-island/hifumi) | Serialização para migrar dados entre versões | repositório |
| [lacrymira](https://github.com/celestia-island/lacrymira) | Acesso tipado a dados para SQL e KV por uma única superfície de comandos | repositório |
| [himari](https://github.com/celestia-island/himari) | Representação intermediária de fórmulas dimensionadas | repositório |
| [kotama](https://github.com/celestia-island/kotama) | Kit de engenharia reversa: dissecção, descompilação, referências cruzadas | repositório |
| [ayane](https://github.com/celestia-island/ayane) | Serviço de e-mail: plano de controle, webmail e proteção | repositório |
| [aris](https://github.com/celestia-island/aris) | Um motor de navegador em Rust puro derivado do servo, embutível como biblioteca | repositório |
| [shirabe](https://github.com/celestia-island/shirabe) | Automação e depuração de navegador headless | repositório |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Framework full-stack sobre o WASM Component Model | repositório |
| [akivili](https://github.com/celestia-island/akivili) | Hospedeiro de plugins e SDK para extensões de agentes | repositório |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | SDK de plugins em Python e de motores | repositório |
| [shun](https://github.com/celestia-island/shun) | Instaladores, gravadores e entrega de carga em modo portátil | repositório |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | Renderização de Markdown dentro de UIs de terminal | repositório |
| arcaea | Biblioteca do protocolo de personas | — |
| scriptum | Interface de terminal para a plataforma de agentes | — |
| official-plugins | Os pacotes de plugins oficiais | — |

## Borda e hardware

| Projeto | Papel | Docs |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Kernel em Rust para gateways de borda ARM64 e RISC-V | repositório |
| [hare](https://github.com/celestia-island/hare) | Biblioteca de ponte `no_std` para nós industriais embarcados | repositório |
| evernight-appliance | A distribuição de appliance: firmware de boot, gravador, contrato de driver | — |

## Infraestrutura e ferramental

| Projeto | Papel | Docs |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Toolchain de desenvolvimento compartilhado: receitas de build, linting, portões de release | repositório |
| [cherino](https://github.com/celestia-island/cherino) | Abstração de contêiner em sandbox para a execução de agentes | repositório |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | Hospedagem pública de binários e imagens para releases | repositório |
| celestia-integration | Testes de integração entre repositórios para todo o ciclo | — |
| fuuka | Plano de execução de CI auto-hospedada | — |
| [sysl](https://github.com/celestia-island/sysl) | A Synthetic Source License que a maior parte deste código usa | repositório |

## Presença na web

| Propriedade | Papel | Docs |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Presença da organização | repositório |
| [docs.celestia.world](https://docs.celestia.world) | Este site — filosofia, mapa, primeiros passos | repositório |
| [e.celestia.world](https://e.celestia.world) | Página de destino pública | repositório |
| [dev.celestia.world](https://dev.celestia.world) | Painel e dashboard do desenvolvedor (por convite durante o beta) | repositório |
| [celestia.ac.cn](https://celestia.ac.cn) | Site da empresa e dos serviços empresariais | repositório |

## Aprofundar-se

- [Arquitetura em Camadas](../philosophy/layered-architecture.md) — por que estas camadas existem.
- [O Ciclo Fechado](../philosophy/closed-loop.md) — como os projetos cooperam ao longo do ciclo.
- [Sites e Responsabilidade](./sites.md) — quem documenta o quê, e onde.
