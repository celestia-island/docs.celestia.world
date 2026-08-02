# Arquitetura em Camadas

O ecossistema permanece administrável porque é estritamente em camadas. As
dependências apontam apenas numa direção: **serviços a jusante consomem
capacidade a montante; capacidade genérica nunca é reimplementada.**

## As quatro camadas

| Camada | Projetos | O que fornecem |
| --- | --- | --- |
| **Camada 0 — Auth** | [kirino](https://github.com/celestia-island/kirino) | Primitivas de confiança zero: assinatura e renovação de JWT, hash de senhas Argon2id, limite de taxa de login, motor RBAC, armazenamento de convites, sessões |
| **Camada 1 — Plataforma** | [plana](https://github.com/celestia-island/plana) | Facilidades compartilhadas: tipos e roteamento JSON-RPC 2.0, DTOs de serviço, detecção de rede, sessões SSE, circuit breakers, medição e preços de LLM |
| **Camada 2 — UI** | [hikari](https://github.com/celestia-island/hikari) | Biblioteca de componentes de UI (Vue/TS + Rust) compartilhada por todos os webUIs |
| **Camada 3 — Serviços** | [arona](https://github.com/celestia-island/arona), [shittim-chest](https://github.com/celestia-island/shittim-chest), [entelecheia](https://github.com/celestia-island/entelecheia), [evernight](https://github.com/celestia-island/evernight), [malkuth](https://github.com/celestia-island/malkuth), [lagrange](https://github.com/celestia-island/lagrange) | Somente lógica de negócio. Consomem as Camadas 0–2 e acrescentam o comportamento que torna cada produto real |

## A doutrina

1. **Nunca implementar duas vezes.** Antes de escrever código, pergunte: o
   kirino tem? o plana tem? o hikari tem? Exemplo: tipos JSON-RPC vêm do plana,
   JWT do kirino, limite de taxa de login do kirino, circuit breakers do plana,
   DTOs de saúde do plana, preços do plana.
2. **Capacidade genérica vai a montante.** Um recurso que dois ou mais serviços
   reutilizarão é construído primeiro no kirino, no plana ou no hikari e depois
   consumido.
3. **Sem dependências reversas.** Serviços dependem de kirino/plana/hikari; o
   plana pode depender do kirino; o kirino nunca depende do plana nem do hikari.
4. **Estender a montante antes de consumir.** Se faltar capacidade a montante,
   estenda a montante e depois consuma. Nova capacidade nunca é prototipada
   num serviço e reimplementada depois.
5. **Dependências entre repositórios são referências git.** Todos os
   repositórios consomem a montante via referências git à branch `master` (ou
   versões fixadas), nunca dependências de caminho local. Cada repositório
   compila de forma idêntica em todas as máquinas.

## Por que isso importa

- **Uma correção se propaga.** Uma correção de segurança no kirino chega a todo
  serviço com um bump de dependência, não numa caçada por reimplementações.
- **A revisão é proporcional ao risco.** Mudanças na Camada 3 são lógica de
  produto; mudanças na Camada 0 são infraestrutura — o padrão de revisão
  reflete isso.
- **O mapa permanece legível.** Novos engenheiros leem esta página e sabem onde
  mora qualquer capacidade. O [Mapa de Projetos](../ecosystem/projects.md) é o
  inventário completo.

## Aprofundar-se

- [Por que celestia-island](./why.md) — o problema por trás das camadas.
- [Princípios de Segurança](./safety.md) — a doutrina que se assenta sobre as camadas.
- [Mapa de Projetos](../ecosystem/projects.md) — todos os repositórios, por camada.
