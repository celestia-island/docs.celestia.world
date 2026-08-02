# Карта проектов

Полный перечень репозиториев celestia-island, сгруппированных по слоям.
Репозитории, отмеченные сайтом документации, несут собственные документы *как*
на `<name>.docs.celestia.world`; всё остальное документируется в своём
репозитории.

## Слой 0 — Аутентификация

| Проект | Роль | Документация |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Аутентификация с нулевым доверием и RBAC: JWT-сессии, хеширование Argon2id, ограничение частоты входа, движок прав | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Слой 1 — Платформа

| Проект | Роль | Документация |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Общие типы, клиент и сервер JSON-RPC, SSE-сессии, предохранители, учёт и тарификация LLM, оболочка админ-UI | репозиторий |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Реестр моделей и провайдеров (формат entrypoint TOML) | репозиторий |

## Слой 2 — UI

| Проект | Роль | Документация |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | Библиотека UI-компонентов (Vue/TS + Rust), общая для всех webUI | репозиторий |

## Слой 3 — Сервисы

| Проект | Роль | Документация |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | Облачная API-админка: учётные записи, API key, развёртывание моделей, бэкенды, записи использования | репозиторий |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | Чат desktop/webUI и оболочка | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | Платформа мультиагентной совместной работы: exec-only микроядро, сервер оркестрации scepter, конвейер выполнения IEPL | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | Брокер промышленных протоколов: Modbus, S7comm, OPC UA; удалённые операции, телеметрия, шлюзы записи | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | Инструментарий наблюдения за сервисами: rolling-обновления, проверки здоровья, обратный прокси, восстановление после краш-петли | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | Движок Markdown-документации, питающий этот сайт и все сайты документации проектов | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## Инструменты и библиотеки

| Проект | Роль | Документация |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | AI-ориентированное распределённое управление версиями: изоляция рабочих пространств агентов, append-only JSONL-журналы, история снимков | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | Библиотека веб-поиска с несколькими движками и CLI | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Макросы конвейеров с пулом потоков (каналы сообщений на основе flume) | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | Процедурный макрос для генерации сложных вложенных структур из простого макроса | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | CLI для Modbus и источников данных | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | Отдельный движок виртуального терминала: управление PTY, VT100/ANSI | репозиторий |
| [hifumi](https://github.com/celestia-island/hifumi) | Библиотека сериализации для миграции данных между версиями | репозиторий |
| [aris](https://github.com/celestia-island/aris) | Браузерный движок на основе servo, встраиваемый как библиотека (WebGL для цифровых двойников) | репозиторий |
| [shirabe](https://github.com/celestia-island/shirabe) | Лёгкая Rust-библиотека автоматизации и отладки браузера | репозиторий |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Full-stack фреймворк на базе WASM Component Model | репозиторий |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | Рендеринг Markdown для ratatui TUI | репозиторий |
| [arcaea](https://github.com/celestia-island/arcaea) | Rust-библиотека для протокола персон celestia | репозиторий |
| [scriptum](https://github.com/celestia-island/scriptum) | Терминальный интерфейс (TUI) для entelecheia: «немой дисплей», говорящий с сервером scepter | репозиторий |

## Периферия и оборудование

| Проект | Роль | Документация |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Rust-ядро ОС для периферийных устройств ARM64/RISC-V; детерминированное ядро реального времени для долгого горизонта | репозиторий |

## Инфраструктура и инструментарий

| Проект | Роль | Документация |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Общий инструментарий разработки: рецепты justfile, регистрация патчей, линтинг | репозиторий |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | Наборы интеграционных тестов на реальном оборудовании для полного цикла | репозиторий |
| [sysl](https://github.com/celestia-island/sysl) | Synthetic Source License (SySL): лицензия, разработанная для AI-сгенерированного кода | репозиторий |

## Веб-присутствие

| Ресурс | Роль | Документация |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Присутствие организации | репозиторий |
| [docs.celestia.world](https://docs.celestia.world) | Этот сайт — философия, карта, начало работы | репозиторий |
| [e.celestia.world](https://e.celestia.world) | Публичная лендинг-страница | репозиторий |
| [dev.celestia.world](https://dev.celestia.world) | Портал разработчика | репозиторий |
| [arona.celestia.world](https://arona.celestia.world) | Облачная API-админка (продукт) | — |

## Подробнее

- [Слоистая архитектура](../philosophy/layered-architecture.md) — почему существуют эти слои.
- [Замкнутый цикл](../philosophy/closed-loop.md) — как проекты сотрудничают вдоль цикла.
- [Сайты и владельцы](./sites.md) — кто что документирует и где.
