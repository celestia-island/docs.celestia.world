# Documentos de Design da Plataforma

> **Escopo.** Estes documentos são de *nível de plataforma*: abrangem `core` (entelecheia), `webui` (shittim-chest) e `router` (evernight). Designs específicos de cada projeto residem em suas próprias subcategorias.

## Índice

| Documento | Resumo |
| --- | --- |
| [Supervisão, Rolling Update & Replicação](https://malkuth.docs.celestia.world/en/design/supervision-and-rolling-update.html) | Uma espinha dorsal única de árvore de supervisão compartilhada pelos três projetos: semântica uniforme de sinal/dreno, ativação de socket systemd para transferência sem tempo de inatividade, um trait de trava de coordenação plugável e duas estratégias de tolerância a falhas (Replica = balanceamento de carga ⊃ rolling update; Leader/Follower = HA de borda) construídas sobre as mesmas primitivas Worker + Supervisor. |

## Diretórios de Idioma

| Código | Idioma |
| --- | --- |
| `en/` | English (canônico) |
| `zhs/` | 简体中文 (Chinês Simplificado) |
| `zht/` | 繁體中文 (Chinês Tradicional) |
| `ja/` | 日本語 (Japonês) |
| `ko/` | 한국어 (Coreano) |
| `fr/` | Français (Francês) |
| `es/` | Español (Espanhol) |
| `ru/` | Русский (Russo) |
