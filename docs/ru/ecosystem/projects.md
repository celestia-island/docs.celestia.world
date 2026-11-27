# Карта проектов

Перечень репозиториев и продуктов платформы celestia-island, сгруппированный по
слоям. Название со ссылкой — это публичный репозиторий, который можно прочитать
уже сейчас; название без ссылки — продукт, который поставляется с платформой,
но его исходный код пока не публичен. Репозитории, отмеченные сайтом
документации, несут собственные документы *как*; всё остальное описано внутри
самого репозитория, для чего нужен доступ к нему.

## Слой 0 — Аутентификация

| Проект | Роль | Документация |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Аутентификация и авторизация с нулевым доверием: сессии, разрешения, ограничение частоты | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Слой 1 — Платформа

| Проект | Роль | Документация |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Общие типы протокола, транспорт, учёт и средства, которые потребляет каждый сервис | репозиторий |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Каталог моделей и провайдеров, общий для всех продуктов | репозиторий |

## Слой 2 — UI

| Проект | Роль | Документация |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | Библиотека UI-компонентов, общая для всех webUI | репозиторий |

## Слой 3 — Сервисы

| Проект | Роль | Документация |
| --- | --- | --- |
| arona | Шлюз моделей и панель развёртывания: ключи, бэкенды, маршрутизация, использование | [Arona](../platforms/arona.md) |
| shittim-chest | Чат, панели и интеграции — поверхность рабочего места | [Shittim Chest](../platforms/chest.md) |
| entelecheia | Агентная платформа: агенты, долгосрочная память, семантический поиск, промышленная интеграция | [Entelecheia](../platforms/entelecheia.md) |
| evernight | Брокер промышленных протоколов: полевые протоколы, аварии, запись, периферийный инференс | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | Наблюдение за сервисами: постепенные обновления, пробы здоровья, обратный прокси, восстановление после сбоев | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | Движок документации, на котором работают этот сайт и все документационные сайты проектов | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | Бизнес-бэк-офис: организации, расчёты, счета | — |
| electrode_recon | Вычислительный движок микроструктуры электродов — первый внешний экземпляр на движковой фабрике | — |

## Инструменты и библиотеки

| Проект | Роль | Документация |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | Распределённое версионирование, нативное для агентов, с изолированными рабочими пространствами | [репозиторий](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | Веб-поиск через несколько движков | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | CLI для отладки и симуляции множества протоколов (Modbus RTU и компания) | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Конвейеры на пулах потоков поверх обмена сообщениями | репозиторий |
| [yuuka](https://github.com/celestia-island/yuuka) | Макросы для составных вложенных структур и слияния/патчей JSON | репозиторий |
| [kou](https://github.com/celestia-island/kou) | Движок виртуального терминала: PTY, VT100/ANSI, встроенная графика | репозиторий |
| [hifumi](https://github.com/celestia-island/hifumi) | Сериализация для переноса данных между версиями | репозиторий |
| [lacrymira](https://github.com/celestia-island/lacrymira) | Типизированный доступ к данным для SQL и KV за одной командной поверхностью | репозиторий |
| [himari](https://github.com/celestia-island/himari) | Промежуточное представление формул с размерностями | репозиторий |
| [kotama](https://github.com/celestia-island/kotama) | Инструментарий реверс-инжиниринга: разбор, декомпиляция, перекрёстные ссылки | репозиторий |
| [ayane](https://github.com/celestia-island/ayane) | Почтовый сервис: плоскость управления, веб-почта и защита | репозиторий |
| [aris](https://github.com/celestia-island/aris) | Браузерный движок на чистом Rust, основанный на servo, встраиваемый как библиотека | репозиторий |
| [shirabe](https://github.com/celestia-island/shirabe) | Автоматизация и отладка браузера без интерфейса | репозиторий |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Полностековый фреймворк на WASM Component Model | репозиторий |
| [akivili](https://github.com/celestia-island/akivili) | Хост плагинов и SDK для расширений агентов | репозиторий |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | Python SDK для плагинов и движков | репозиторий |
| [shun](https://github.com/celestia-island/shun) | Установщики, прошивальщики и доставка полезной нагрузки в портативном режиме | репозиторий |
| arcaea | Библиотека протокола персон | — |
| scriptum | Терминальный интерфейс для агентной платформы | — |
| official-plugins | Пакеты плагинов от первой стороны | — |

## Периферия и оборудование

| Проект | Роль | Документация |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Rust-ядро для периферийных шлюзов на ARM64 и RISC-V | репозиторий |
| [hare](https://github.com/celestia-island/hare) | Библиотека моста `no_std` для встраиваемых промышленных узлов | репозиторий |
| evernight-appliance | Дистрибутив устройства: загрузочная прошивка, прошивальщик, контракт драйверов | — |

## Инфраструктура и инструментарий

| Проект | Роль | Документация |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Общий инструментарий разработки: рецепты сборки, линтинг, релизные шлюзы | репозиторий |
| [cherino](https://github.com/celestia-island/cherino) | Абстракция изолированных контейнеров для выполнения агентов | репозиторий |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | Публичный хостинг бинарных артефактов и образов для релизов | репозиторий |
| celestia-integration | Межрепозиторные интеграционные тесты для всего цикла | — |
| fuuka | Плоскость выполнения собственного CI | — |
| [sysl](https://github.com/celestia-island/sysl) | Synthetic Source License, под которой распространяется большая часть этого кода | репозиторий |

## Присутствие в вебе

| Ресурс | Роль | Документация |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Присутствие организации | репозиторий |
| [docs.celestia.world](https://docs.celestia.world) | Этот сайт — философия, карта, начало работы | репозиторий |
| [e.celestia.world](https://e.celestia.world) | Публичный лендинг | репозиторий |
| [dev.celestia.world](https://dev.celestia.world) | Панель и панель управления для разработчиков (во время беты по приглашениям) | репозиторий |
| [celestia.ac.cn](https://celestia.ac.cn) | Сайт компании и корпоративных услуг | репозиторий |

## Подробнее

- [Слоистая архитектура](../philosophy/layered-architecture.md) — почему эти слои существуют.
- [Замкнутый цикл](../philosophy/closed-loop.md) — как проекты взаимодействуют вдоль цикла.
- [Сайты и владельцы](./sites.md) — кто что документирует и где.
