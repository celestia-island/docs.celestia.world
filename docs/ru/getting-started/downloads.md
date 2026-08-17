# Загрузки

Что именно вам нужно устанавливать, зависит от вашего места в замкнутом
контуре. Во время внутренней беты большинству участников достаточно
desktop-приложения; всё остальное размещает ваш администратор или оно
опционально.

## Desktop-приложение (shittim-chest)

Desktop-приложение shittim-chest публикуется в
[GitHub Releases](https://github.com/celestia-island/shittim-chest/releases)
из каждого тега `v*`. Установщики **не подписаны** — ожидайте предупреждение
безопасности ОС при первом запуске. Страница остаётся пустой, пока не будет
отправлен первый бета-тег.

| Платформа | Артефакт |
| --- | --- |
| Linux | `.AppImage` или `.deb` |
| Windows 10+ | `.exe` (NSIS) или `.msi` |
| macOS | пока не публикуется |

Релизные сборки охватывают только Linux и Windows; macOS не входит в релизный
конвейер. До первого релиза (или если вы предпочитаете обходиться без
установки) используйте [webUI](https://shittim-chest.docs.celestia.world)
shittim-chest.

## Админ-панель (arona)

Arona размещается на сервере — локально устанавливать нечего. Откройте URL
панели, выданный вашим администратором (`https://arona.celestia.world` в
публичном развёртывании или `http://<host>:8420` во внутреннем), и войдите
с приглашением.

## Рантайм агентов (entelecheia/scepter, опционально)

Продвинутым пользователям, которые запускают агентов самостоятельно, README
entelecheia предписывает единый установщик из репозитория plana
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)):

```bash
git clone https://github.com/celestia-island/plana.git
# Также склонируйте entelecheia, evernight, scriptum, shittim-chest рядом с arona/
cd arona/scripts/install
bash celestia-install.sh --source-root ../../..
```

Эквивалент для Windows (WSL2): `.\celestia-install.ps1 -SourceRoot ..\..\..`

Чтобы собрать сам entelecheia из исходников: `just bootstrap` устанавливает
workspace, затем `just dev` запускает TUI. Предварительные требования —
Rust 1.85+, Docker и раннер задач `just`.

## Подробнее

- [Краткое руководство](./quickstart.md) — путь по замкнутому контуру за 30 минут.
- [Руководство по закрытой бете](./beta-guide.md) — что охватывает бета и как сообщать об ошибках.
- [Карта проектов](../ecosystem/projects.md) — полный перечень проектов.
