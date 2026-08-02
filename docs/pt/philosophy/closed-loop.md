# O Ciclo Fechado

O produto é o ciclo, não um projeto isolado:

> descobrir → instalar → autenticar → implantar um modelo → conversar e executar
> agentes → controlar equipamentos industriais → verificar e dar suporte

Cada segmento é de responsabilidade de um conjunto específico de projetos. Se
um segmento se quebra, a plataforma não está terminada.

## Segmento por segmento

| # | Segmento | O que acontece | Projetos |
| --- | --- | --- | --- |
| 1 | **Descobrir** | Um usuário em potencial encontra o ecossistema, entende a sua filosofia e escolhe um ponto de entrada | [docs.celestia.world](https://docs.celestia.world) (este site), [celestia-island.github.io](https://celestia-island.github.io), [e.celestia.world](https://e.celestia.world) |
| 2 | **Instalar** | O usuário obtém um sistema em funcionamento: painel de administração, shell desktop/web, serviços supervisionados | [arona](https://github.com/celestia-island/arona) (painel de administração da API em nuvem), [shittim-chest](https://github.com/celestia-island/shittim-chest) (chat desktop/webUI), [malkuth](https://github.com/celestia-island/malkuth) (supervisão de serviços) |
| 3 | **Autenticar** | Identidade de confiança zero: registro (por convite), login com limite de taxa, API keys, RBAC | [kirino](https://github.com/celestia-island/kirino) (primitivas de autenticação e motor RBAC) |
| 4 | **Implantar um modelo** | Escolher um runtime de modelo, implantá-lo num nó, vinculá-lo a um backend de chat e medir o uso | [arona](https://github.com/celestia-island/arona) (painel + backends), [entelecheia](https://github.com/celestia-island/entelecheia) (runtime scepter), [plana](https://github.com/celestia-island/plana) (medição e preços) |
| 5 | **Chat e agentes** | Conversar com modelos, executar colaboração multiagente, persistir conversas e gerenciar memória | [shittim-chest](https://github.com/celestia-island/shittim-chest) (UI e chat), [entelecheia](https://github.com/celestia-island/entelecheia) (orquestração de agentes), [noa](https://github.com/celestia-island/noa) (controle de versão nativo de IA) |
| 6 | **Controle industrial** | Operações remotas e intermediação de protocolos: Modbus, S7comm, OPC UA; telemetria e portões de escrita | [evernight](https://github.com/celestia-island/evernight) (broker de protocolos), [aoba](https://github.com/celestia-island/aoba) (CLI de Modbus e fontes de dados) |
| 7 | **Verificar e dar suporte** | Testes de integração em hardware real, supervisão e autocorreção, registros de uso, canais de feedback | [celestia-integration](https://github.com/celestia-island/celestia-integration), [malkuth](https://github.com/celestia-island/malkuth), [plana](https://github.com/celestia-island/plana) (registros de uso) |

## Como o ciclo se comporta

- **Cada etapa é testável.** Cada segmento tem um teste de aceite definido em
  [celestia-integration](https://github.com/celestia-island/celestia-integration);
  um release não fica verde até que todo o ciclo passe em nós reais.
- **Cada etapa é observável.** Supervisão, endpoints de saúde e registros de
  uso tornam o estado de cada segmento visível em vez de presumido.
- **Sem degradação silenciosa.** Quando um segmento degrada (por exemplo, memória
  offline ou backend inalcançável), a resposta da API e a UI dizem isso
  explicitamente. Falhas são barulhentas por design.
- **A segurança não é um segmento.** Portões de escrita, validação de políticas
  e confirmação humana estão entretecidos nos segmentos 5 e 6, não aparafusados
  no final. Veja [Princípios de Segurança](./safety.md).

## Aprofundar-se

- [Por que celestia-island](./why.md) — o problema que define o ciclo.
- [Arquitetura em Camadas](./layered-architecture.md) — como as peças permanecem ordenadas.
- [Mapa de Projetos](../ecosystem/projects.md) — o inventário completo dos repositórios.
- [Início Rápido](../getting-started/quickstart.md) — percorra o ciclo em 30 minutos.
