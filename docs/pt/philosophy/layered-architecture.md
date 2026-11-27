# Arquitetura em Camadas

O ecossistema continua administrável porque é estritamente em camadas. As
dependências só apontam numa direção: **os serviços a jusante consomem
capacidade de montante; capacidade genérica nunca é reimplementada.**

## As quatro camadas

| Camada | Projetos | O que fornecem |
| --- | --- | --- |
| **Camada 0 — Auth** | [kirino](https://github.com/celestia-island/kirino) | Identidade de confiança zero: autenticação, sessões, permissões |
| **Camada 1 — Plataforma** | [plana](https://github.com/celestia-island/plana) | Tipos de protocolo compartilhados, transporte e as facilidades de que todo serviço precisa |
| **Camada 2 — UI** | [hikari](https://github.com/celestia-island/hikari) | A biblioteca de componentes compartilhada por toda webUI |
| **Camada 3 — Serviços** | arona, shittim-chest, entelecheia, evernight, [malkuth](https://github.com/celestia-island/malkuth), [lagrange](https://github.com/celestia-island/lagrange) | Apenas lógica de negócio. Consomem as Camadas 0–2 e acrescentam o comportamento que torna cada produto real |

## A doutrina

1. **Nunca implementar duas vezes.** Antes de escrever código, pergunte: o
   kirino tem isso? o plana tem isso? o hikari tem isso? Um serviço que
   reimplementa uma capacidade de montante é um defeito, não um recurso.
2. **Capacidade genérica vai para montante.** Um recurso que dois ou mais
   serviços vão reutilizar é construído primeiro no kirino, no plana ou no
   hikari, e depois consumido.
3. **Sem dependências reversas.** Os serviços dependem de kirino/plana/hikari;
   o plana pode depender do kirino; o kirino nunca depende do plana nem do
   hikari.
4. **Estender a montante antes de consumir.** Se a montante não tem uma
   capacidade necessária, estenda a montante e só então consuma. Capacidade
   nova nunca é prototipada num serviço para ser reimplementada depois.
5. **Dependências entre repositórios são referências git.** Todos os
   repositórios consomem a montante via referências git para a branch `master`
   (ou versões fixadas), nunca dependências de caminho local. Todo repositório
   compila de forma idêntica em toda máquina.

## Por que isso importa

- **Uma correção se propaga.** Uma correção de segurança no kirino chega a
  todos os serviços com um bump de dependência, não com uma caçada por
  reimplementações.
- **A revisão é proporcional ao risco.** Mudanças na Camada 3 são lógica de
  produto; mudanças na Camada 0 são infraestrutura — a barra de revisão
  reflete isso.
- **O mapa continua legível.** Engenheiros novos leem esta página e sabem onde
  mora qualquer capacidade. O [Mapa de Projetos](../ecosystem/projects.md) é o
  inventário completo.

## Aprofundar-se

- [Por que celestia-island](./why.md) — o problema por trás das camadas.
- [Princípios de Segurança](./safety.md) — a doutrina que se assenta sobre as camadas.
- [Mapa de Projetos](../ecosystem/projects.md) — cada repositório, por camada.
