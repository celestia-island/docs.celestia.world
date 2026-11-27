# Добро пожаловать в celestia-island

**celestia-island** — это набор проектов для промышленного ИИ-управления:
совместная работа мультиагентов, удалённые операции и автоматизация, критичная
к безопасности. Этот сайт — его *почему*. *Как* описано на сайтах
документации отдельных проектов.

## Проекты

Название со ссылкой — это публичный репозиторий, который можно прочитать уже
сейчас. Название без ссылки — продукт, который поставляется с платформой, но
его исходный код пока не публичен. Подробная таблица — в разделе
[Карта проектов](./ecosystem/projects.md).

**Платформа** — [kirino](https://github.com/celestia-island/kirino)
(аутентификация с нулевым доверием),
[plana](https://github.com/celestia-island/plana) (протокол и платформенные
средства), [hikari](https://github.com/celestia-island/hikari) (UI-компоненты),
[provider-registry](https://github.com/celestia-island/provider-registry)
(каталог моделей), arona (панель развёртывания моделей), entelecheia
(оркестрация агентов), shittim-chest (чат и рабочее место), scriptum
(терминальный клиент).

**Промышленность и периферия** — evernight (брокер протоколов),
[aoba](https://github.com/celestia-island/aoba) (CLI для Modbus),
[hare](https://github.com/celestia-island/hare) (мост `no_std`),
[kei](https://github.com/celestia-island/kei) (периферийное ядро),
[shun](https://github.com/celestia-island/shun) (установщики и прошивальщики),
electrode_recon (вычислительный движок).

**Библиотеки и инструменты** — [noa](https://github.com/celestia-island/noa)
(версионирование, нативное для агентов),
[seia](https://github.com/celestia-island/seia) (веб-поиск),
[aris](https://github.com/celestia-island/aris) (браузерный движок),
[shirabe](https://github.com/celestia-island/shirabe) (автоматизация браузера),
[kou](https://github.com/celestia-island/kou) (виртуальный терминал),
[ichika](https://github.com/celestia-island/ichika) (конвейеры потоков),
[yuuka](https://github.com/celestia-island/yuuka) (макросы структур),
[hifumi](https://github.com/celestia-island/hifumi) (версионированная
сериализация), [lacrymira](https://github.com/celestia-island/lacrymira)
(типизированный доступ к данным),
[himari](https://github.com/celestia-island/himari) (промежуточное
представление формул),
[kotama](https://github.com/celestia-island/kotama) (реверс-инжиниринг),
[ayane](https://github.com/celestia-island/ayane) (почтовый сервис),
[tairitsu](https://github.com/celestia-island/tairitsu) (полный стек на
Component Model), [akivili](https://github.com/celestia-island/akivili) (хост
плагинов), [celestia-plugin](https://github.com/celestia-island/celestia-plugin)
(Python SDK), [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown)
(Markdown в терминале), arcaea (протокол персон), official-plugins (пакеты
плагинов).

**Инфраструктура** —
[celestia-devtools](https://github.com/celestia-island/celestia-devtools)
(инструментарий сборки и линтинга),
[cherino](https://github.com/celestia-island/cherino) (контейнеры агентов),
[malkuth](https://github.com/celestia-island/malkuth) (наблюдение за сервисами),
[lagrange](https://github.com/celestia-island/lagrange) (движок документации,
собирающий этот сайт),
[celestia-artifacts](https://github.com/celestia-island/celestia-artifacts)
(релизные артефакты),
[sysl](https://github.com/celestia-island/sysl) (лицензия),
celestia-integration (интеграционные тесты), fuuka (собственный CI),
celestia-erp (бизнес-бэк-офис).

**Сайты** — [celestia-island.github.io](https://celestia-island.github.io),
[e.celestia.world](https://e.celestia.world),
[dev.celestia.world](https://dev.celestia.world) (панель, во время беты по
приглашениям), [celestia.ac.cn](https://celestia.ac.cn) и этот хаб.

## Куда двигаться дальше

- [Почему celestia-island](./philosophy/why.md) — проблема, замкнутый цикл, доктрина безопасности.
- [Замкнутый цикл](./philosophy/closed-loop.md) — обнаружить → установить → аутентифицироваться → развернуть → чат и агенты → промышленное управление → проверить.
- [Краткое руководство](./getting-started/quickstart.md) — путь через всё это за 30 минут.

Используйте переключатель языков (внизу справа), чтобы читать этот сайт на
другом языке. Контент пишется на английском; переводы следуют той же
структуре.
