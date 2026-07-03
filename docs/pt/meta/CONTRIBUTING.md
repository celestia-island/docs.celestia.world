# Contribuindo com Arona
> Esta é uma tradução de referência da comunidade. Em caso de divergência, prevalece a versão original em inglês [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) na raiz do repositório.

Obrigado pelo seu interesse em contribuir! Este guia cobre tudo o que você precisa para começar.

## Política de contribuição (leia primeiro)

Arona define os tipos de protocolo JSON-RPC 2.0 compartilhados consumidos em toda a plataforma Entelecheia, portanto **correção, compatibilidade retroativa e estabilidade prevalecem sobre o volume de contribuições**. Por favor, leia isto antes de abrir um pull request.

- **Barra alta de merge, não um roadmap público.** Abrir um PR não implica que ele será mesclado. Aceitamos um número deliberadamente pequeno de alterações, e apenas quando se encaixam na arquitetura e passam pela revisão. Isso é intencional, não falta de educação.

- **O que acolhemos:** relatórios de bugs, correções focadas, campos aditivos de protocolo (não disruptivos), documentação aprimorada e discussões de design prévias antes do código.

- **O que geralmente não mesclaremos:** grandes reescritas não solicitadas, alterações disruptivas na superfície de tipos do protocolo, mudanças arquitetônicas sem discussão de design prévia, PRs em massa feitos por "vibe-coding" e qualquer coisa que reduza a barra de compatibilidade do contrato de tipos.

- **Núcleo vs. periferia.** As definições de tipos de protocolo e sua superfície de serialização são mantidas no padrão mais rigoroso e gerenciadas pela equipe central.

- **CLA obrigatório.** Toda contribuição aceita requer um Acordo de Licença de Contribuinte assinado. Veja [`CLA.md`](cla.md). Os commits devem conter uma linha `Signed-off-by` (`git commit -s`).

> **A licença pode se abrir; a barra de merge não.** Em **2030-01-01** este projeto converte de BUSL-1.1 para Apache-2.0 ou MIT (escolha do destinatário) — veja [`LICENSE`](LICENSE). Isso amplia *o que você pode fazer com o código*; **não** reduz a barra de revisão, não remove o CLA e não significa que aceitaremos mais PRs. A política de contribuição permanece inalterada antes e depois da data de mudança.

## Segurança

**Não** abra issues públicas para vulnerabilidades de segurança. Relate-as de forma privada via [GitHub Security Advisories](https://github.com/celestia-island/arona/security/advisories/new). Veja [`SECURITY.md`](security.md).

## Código de Conduta

Seja respeitoso, construtivo e inclusivo. Seguimos o [Código de Conduta Contributor Covenant](code-of-conduct.md).

## Desenvolvimento

Arona é uma pequena crate Rust. Início rápido:

```bash
git clone https://github.com/celestia-island/arona.git
cd arona
cargo build
cargo test
cargo clippy -- -D warnings
```

- Rust 1.85+.
- Os tipos derivam `ts-rs` (`#[derive(TS)]`) para gerar bindings TypeScript — mantenha os atributos `serde` e as anotações `ts-rs` consistentes.

- Não introduza alterações disruptivas nos tipos de protocolo existentes; prefira campos aditivos com `#[serde(default)]`.

## Processo de pull request

1. Faça um fork e crie um branch a partir de `main`.
2. Discuta alterações grandes ou que afetem o protocolo primeiro em uma issue.
3. Faça commits atômicos seguindo [Conventional Commits](https://www.conventionalcommits.org/).
4. Certifique-se de que `cargo fmt`, `cargo clippy -D warnings` e `cargo test` passem.
5. Assine o CLA e adicione `Signed-off-by` a cada commit.
6. Atenda ao feedback da revisão; mantenha force-pushes apenas para rebase.

## Licença & CLA

Arona é licenciado sob a **Business Source License 1.1 (BUSL-1.1)** com uma **Data de Mudança de 2030-01-01**, quando converte para a escolha do destinatário entre **Apache-2.0 ou MIT**. Para todo uso interno, acadêmico, governamental, educacional e não comercial, já é equivalente a Apache-2.0 ou MIT hoje (veja a Concessão de Uso Adicional em [`LICENSE`](LICENSE)). Usos comerciais restritos (hospedagem, revenda ou rebranding como serviço) exigem uma licença comercial separada até a Data de Mudança.

Ao contribuir, você concorda que suas contribuições sejam licenciadas sob a licença do projeto e que você assina o CLA ([`CLA.md`](cla.md)). O CLA concede ao projeto uma licença permissiva **incluindo o direito de relicenciar**, para que o projeto possa manter sua trajetória BUSL→Apache/MIT e adaptar seu licenciamento no futuro.
