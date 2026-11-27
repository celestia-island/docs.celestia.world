# Downloads

O que você instala depende do seu lugar no ciclo fechado. Durante a beta
interna, a maioria dos participantes precisa apenas do aplicativo desktop;
todo o resto é hospedado pelo seu administrador ou é opcional.

## Aplicativo desktop (shittim-chest)

O aplicativo desktop do shittim-chest é publicado a partir de toda tag `v*`. Os
instaladores são **não assinados** — espere um aviso de segurança do sistema
operacional no primeiro lançamento. A página de download fica vazia até que a
primeira tag de beta seja enviada.

| Plataforma | Asset |
| --- | --- |
| Linux | `.AppImage` ou `.deb` |
| Windows 10+ | `.exe` (NSIS) ou `.msi` |
| macOS | ainda não publicado |

Builds de release cobrem somente Linux e Windows; macOS não faz parte do
pipeline de release. Até o primeiro release (ou se você preferir não
instalar nada), use o [webUI](https://dev.celestia.world) do
shittim-chest.

## Painel de administração (arona)

A Arona é hospedada no servidor — não há nada para instalar localmente. Abra a
URL do painel que o seu administrador fornece e entre com o seu convite.

## Runtime de agentes (opcional)

Quem executa a plataforma de agentes por conta própria usa o instalador
unificado em
[plana](https://github.com/celestia-island/plana/tree/master/scripts/install)
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)).
Tudo é construído a
partir dos próprios repositórios do ecossistema, então os pré-requisitos são um
toolchain Rust, Docker e o executor de tarefas `just`.

## Aprofundar-se

- [Início Rápido](./quickstart.md) — o caminho de 30 minutos pelo ciclo.
- [Guia do Beta Fechado](./beta-guide.md) — o que a beta cobre e como reportar bugs.
- [Mapa de Projetos](../ecosystem/projects.md) — a lista completa de projetos.
