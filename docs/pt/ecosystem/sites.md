# Sites e Responsabilidade

A documentação deste ecossistema segue uma única regra: **o hub explica o
porquê e o onde; cada site de projeto explica o como.** Isso mantém o hub
enxuto e os sites de projeto autoritativos.

## Quem é responsável pelo quê

| Site | É dono de | Conteúdo |
| --- | --- | --- |
| [docs.celestia.world](https://docs.celestia.world) | do ecossistema | Filosofia, mapa do ecossistema, primeiros passos, governança (licença, CLA, CoC, segurança, contribuição) |
| `<name>.docs.celestia.world` | de cada projeto | Guias, arquitetura, designs, referências — construídos a partir do próprio repositório do projeto |
| [celestia-island.github.io](https://celestia-island.github.io) | da organização | Presença, links, ativos de marca |
| [e.celestia.world](https://e.celestia.world) | da face pública | Página de destino, preços, blog, chamada para ação |
| [dev.celestia.world](https://dev.celestia.world) | dos desenvolvedores | Portal do desenvolvedor e status |

## A única regra: nada de duplicação

- O hub **nunca copia** a documentação dos projetos. Se um assunto pertence a
  um projeto (como um protocolo funciona, como configurar um serviço), o hub
  linka para o site do projeto em vez de resumir.
- Os sites de projeto **podem linkar de volta** para o hub por filosofia e
  contexto entre projetos.
- Quando um projeto é substancial o suficiente para manter a própria
  documentação, o hub reduz a sua cobertura a uma entrada no mapa mais links.

## Como os sites são construídos

Todo site de docs (este incluído) é construído com
[lagrange](https://github.com/celestia-island/lagrange) a partir de Markdown no
repositório do projeto, com um seletor de idioma compartilhado. O conteúdo é
redigido em inglês; as traduções seguem a mesma estrutura e são marcadas
quando parciais.

## Aprofundar-se

- [Mapa de Projetos](./projects.md) — quais sites existem e para quais projetos.
- [Contribuindo](../meta/CONTRIBUTING.md) — como contribuir com a documentação.
