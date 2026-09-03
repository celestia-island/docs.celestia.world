# Contribuir para o Celestia Island

Obrigado pelo seu interesse em contribuir! O Celestia Island é uma família de projetos que abrange toda a plataforma — kirino (auth), plana (plataforma), hikari (UI), a camada de serviços e os webUIs e sites em torno deles. Este guia cobre a política de contribuição compartilhada por todo o grupo de projetos; as instruções de build e desenvolvimento de um projeto individual ficam no repositório próprio desse projeto e no site de documentação correspondente.

## Política de contribuição (leia isto primeiro)

O grupo é construído como camadas de criticalidade mista — Camada 0 (kirino, auth), Camada 1 (plana, plataforma), Camada 2 (hikari, UI) e os serviços da Camada 3 por cima — de modo que **correção, compatibilidade retroativa e estabilidade prevalecem sobre o volume de contribuições**. Leia esta seção antes de abrir um pull request.

- **Barra alta de merge, não um roadmap público.** Abrir um PR não implica que ele será mesclado. Aceitamos um número deliberadamente pequeno de alterações, e somente quando elas se encaixam na arquitetura e passam pela revisão. Isso é intencional, não falta de educação.
- **O que acolhemos:** relatórios de bugs, correções focadas, recursos e campos de protocolo aditivos (sem quebra de compatibilidade), documentação aprimorada e discussões de design antes do código.
- **O que geralmente não mesclaremos:** grandes reescritas não solicitadas, alterações que quebram contratos compartilhados e superfícies de protocolo (por exemplo, os tipos de protocolo JSON-RPC 2.0 compartilhados pela plataforma Entelecheia), mudanças arquiteturais sem discussão de design prévia, PRs em massa feitos por "vibe-coding" e qualquer coisa que reduza a barra de compatibilidade, segurança ou proteção de uma camada inferior.
- **Núcleo vs. periferia.** O núcleo de autenticação de confiança zero, os tipos de plataforma compartilhados e a biblioteca de componentes de UI compartilhada são submetidos à barra mais rigorosa e mantidos pela equipe central; mudanças propostas nesses pontos devem começar como uma discussão de design.
- **CLA obrigatório.** Toda contribuição aceita requer um Acordo de Licença de Contribuinte (CLA) assinado. Veja [`CLA.md`](cla.md). Os commits devem conter uma linha `Signed-off-by` (`git commit -s`).

> **A licença pode se abrir; a barra de merge não.** Em **2030-01-01**, os projetos do grupo convertem-se de BUSL-1.1 para Apache-2.0 ou MIT (à escolha do destinatário) — veja [`LICENSE`](../../../LICENSE). Isso amplia *o que você pode fazer com o código*; **não** reduz a barra de revisão, não remove o CLA e não significa que aceitaremos mais PRs. A política de contribuição permanece inalterada antes e depois da data de mudança.

## Segurança

**Não** abra issues públicas para vulnerabilidades de segurança. Reporte-as de forma privada via GitHub Security Advisories no repositório afetado, ou por e-mail para <security@celestia.world>. Veja [`SECURITY.md`](security.md).

## Código de Conduta

Seja respeitoso, construtivo e inclusivo. Seguimos o [Código de Conduta do Contributor Covenant](code-of-conduct.md).

## Primeiros passos

Escolha o repositório em que deseja trabalhar e siga o README e o site de documentação dele. Projetos Rust verificam-se com `cargo fmt`, `cargo clippy -D warnings` e `cargo test`; projetos web, com `pnpm lint`, `pnpm build` e `pnpm test`. O [mapa do ecossistema](../ecosystem/sites.md) lista todos os projetos e onde fica a documentação de cada um.

## Processo de pull request

1. Faça um fork e crie uma branch a partir da branch padrão do repositório.
1. Discuta primeiro, numa issue, as alterações grandes ou que afetem contratos compartilhados.
1. Faça commits atômicos: cada assunto de commit é um único gitmoji seguido de uma frase em inglês com inicial maiúscula e terminada por ponto final, com os detalhes no corpo do commit.
1. Garanta que as verificações do projeto passam antes de fazer push.
1. Assine o CLA e adicione `Signed-off-by` a cada commit.
1. Atenda ao feedback da revisão; mantenha os force-pushes apenas para rebase.

## Licença & CLA

Os projetos deste grupo são licenciados sob a **Business Source License 1.1 (BUSL-1.1)** com uma **Data de Mudança em 2030-01-01**, a partir da qual cada um converte-se, à escolha do destinatário, para **Apache-2.0 ou MIT**. Para uso interno, acadêmico, governamental, educacional e não comercial, já são hoje equivalentes a Apache-2.0 ou MIT (veja a Concessão de Uso Adicional no [`LICENSE`](../../../LICENSE) de cada repositório). Usos comerciais restritos (hospedagem, revenda ou rebranding como serviço) exigem uma licença comercial separada até a Data de Mudança.

Ao contribuir, você concorda que suas contribuições são licenciadas sob a licença do projeto e que você assina o CLA ([`CLA.md`](cla.md)). O CLA concede ao projeto uma licença permissiva **incluindo o direito de relicenciar**, para que os projetos possam manter sua trajetória de licenciamento BUSL→Apache/MIT e adaptar seu licenciamento no futuro.

## Aprofundar-se

- [CLA](cla.md) — o Acordo de Licença de Contribuinte que você assina.
- [Política de segurança](security.md) — como reportar vulnerabilidades de forma privada.
- [Código de Conduta](code-of-conduct.md) — o comportamento que exigimos uns dos outros.
- [Mapa do ecossistema](../ecosystem/sites.md) — todos os projetos e sites, e onde fica a documentação de cada um.
