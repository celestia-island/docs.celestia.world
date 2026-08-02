# Bem-vindo ao celestia-island

**celestia-island** é um conjunto de projetos para controle industrial com IA:
colaboração multiagente, operações remotas e automação de segurança crítica.
Este site é o seu *porquê* — a filosofia, o mapa do ecossistema e o ponto de
entrada. O *como* mora nos sites de documentação de cada projeto, com links a
partir daqui.

## Respondendo a três perguntas

| Pergunta | Onde | O que você vai encontrar |
| --- | --- | --- |
| **Por que isso existe?** | [Filosofia](./philosophy/why.md) | O problema que resolvemos, o ciclo fechado, a doutrina de segurança e o horizonte de longo prazo |
| **O que há dentro?** | [Ecossistema](./ecosystem/projects.md) | Cada projeto, seu papel no ciclo e onde mora a sua documentação |
| **Como começo?** | [Começar](./getting-started/quickstart.md) | O caminho de 30 minutos da conta até um agente de chat funcional e controle industrial |

## O resumo em um parágrafo

celestia-island constrói o **ciclo fechado** da descoberta à verificação para o
controle industrial com IA: descobrir → instalar → autenticar → implantar um
modelo → conversar e executar agentes → controlar equipamentos industriais →
verificar tudo. O ciclo é montado a partir de peças pequenas e estritamente em
camadas: primitivas de autenticação ([kirino](https://github.com/celestia-island/kirino)),
facilidades de plataforma ([plana](https://github.com/celestia-island/plana)),
componentes de UI ([hikari](https://github.com/celestia-island/hikari)) e
serviços que implementam apenas lógica de negócio ([arona](https://github.com/celestia-island/arona),
[shittim-chest](https://github.com/celestia-island/shittim-chest),
[entelecheia](https://github.com/celestia-island/entelecheia),
[evernight](https://github.com/celestia-island/evernight)). Nada é nunca
implementado duas vezes: capacidade genérica é construída uma vez a montante e
consumida por todos os serviços a jusante.

A razão de tudo isso é uma observação simples: na Lua, uma ida e volta leva 2,6
segundos; em Marte, de 6 a 44 minutos. Robôs lá fora não podem esperar por um
humano na Terra — eles precisam ser localmente autônomos. A camada de decisão,
o modelo de mundo e os portões de segurança que construímos hoje para o
controle industrial têm a mesma forma que a autonomia precisará amanhã.

## Onde tudo mora

- **Documentação por projeto** — `<name>.docs.celestia.world`, construída a
  partir de cada repositório. A lista completa está em
  [Sites e Responsabilidade](./ecosystem/sites.md).
- **Presença da organização** — [celestia-island no GitHub](https://github.com/celestia-island).
- **Painéis de produto (WIP durante a beta)** — [arona](https://arona.celestia.world)
  (administração da API em nuvem), [dev](https://dev.celestia.world)
  (portal do desenvolvedor); o painel ao vivo roda internamente em `arona:8420`
  até o fim da beta.

Use o seletor de idioma (canto inferior direito) para ler este site em outro
idioma. O conteúdo é redigido em inglês; as traduções seguem a mesma estrutura.
