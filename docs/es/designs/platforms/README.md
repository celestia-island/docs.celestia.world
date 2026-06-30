
# Documentos de Diseño de Plataforma

> **Alcance.** Estos documentos son de *nivel plataforma*: atraviesan
> `core` (entelecheia), `webui` (shittim-chest) y `router`
> (evernight). Los diseños por proyecto viven bajo sus propias
> subcategorías.

## Índice

| Documento | Resumen |
| --- | --- |
| [Supervisión, Rolling Update y Replicación](supervision-and-rolling-update.md) | Una única columna vertebral de árbol de supervisión compartida por los tres proyectos: semántica uniforme de señales/drain, systemd socket activation para el traspaso sin tiempo de inactividad, un trait enchufable de coordination-lock, y dos estrategias de tolerancia a fallos (Réplica = balanceo de carga ⊃ rolling update; Leader/Follower = HA de edge) construidas sobre las mismas primitivas Worker + Supervisor. |

## Directorios de idiomas

| Código | Idioma |
| --- | --- |
| `en/` | Inglés (canónico) |
| `zhs/` | 简体中文 (chino simplificado) |
| `zht/` | 繁體中文 (chino tradicional) |
| `ja/` | 日本語 (japonés) |
| `ko/` | 한국어 (coreano) |
| `fr/` | Français (francés) |
| `es/` | Español |
| `ru/` | Русский (ruso) |
