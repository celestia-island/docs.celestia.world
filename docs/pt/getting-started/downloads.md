# Downloads

O que você instala depende do seu lugar no ciclo fechado. Durante a beta
interna, a maioria dos participantes precisa apenas do aplicativo desktop;
todo o resto é hospedado pelo seu administrador ou é opcional.

## Aplicativo desktop (shittim-chest)

O aplicativo desktop do shittim-chest é publicado no
[GitHub Releases](https://github.com/celestia-island/shittim-chest/releases)
a partir de toda tag `v*`. Os instaladores são **não assinados** — espere um
aviso de segurança do sistema operacional no primeiro lançamento. A página
fica vazia até a primeira tag de beta ser enviada.

| Plataforma | Asset |
| --- | --- |
| Linux | `.AppImage` ou `.deb` |
| Windows 10+ | `.exe` (NSIS) ou `.msi` |
| macOS | ainda não publicado |

Builds de release cobrem somente Linux e Windows; macOS não faz parte do
pipeline de release. Até o primeiro release (ou se você preferir não
instalar nada), use o [webUI](https://shittim-chest.docs.celestia.world) do
shittim-chest.

## Painel de administração (arona)

A Arona é hospedada no servidor — não há nada para instalar localmente. Abra
a URL do painel que o seu administrador fornece
(`https://arona.celestia.world` numa implantação pública, ou
`http://<host>:8420` internamente) e entre com o seu convite.

## Runtime de agentes (entelecheia/scepter, opcional)

Para usuários avançados que executam agentes por conta própria, o README do
entelecheia prescreve o instalador unificado do repositório plana
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)):

```bash
git clone https://github.com/celestia-island/plana.git
# Clone também entelecheia, evernight, scriptum e shittim-chest ao lado de arona/
cd arona/scripts/install
bash celestia-install.sh --source-root ../../..
```

Equivalente no Windows (WSL2): `.\celestia-install.ps1 -SourceRoot ..\..\..`

Para compilar o próprio entelecheia a partir do código-fonte: `just
bootstrap` instala o workspace, depois `just dev` inicia a TUI. Os
pré-requisitos são Rust 1.85+, Docker e o executor de tarefas `just`.

## Aprofundar-se

- [Início Rápido](./quickstart.md) — o caminho de 30 minutos pelo ciclo.
- [Guia do Beta Fechado](./beta-guide.md) — o que a beta cobre e como reportar bugs.
- [Mapa de Projetos](../ecosystem/projects.md) — a lista completa de projetos.
