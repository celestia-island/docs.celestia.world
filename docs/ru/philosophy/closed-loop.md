# Замкнутый цикл

Продукт — это цикл, а не какой-то отдельный проект:

> обнаружить → установить → аутентифицироваться → развернуть модель → общаться
> и запускать агентов → управлять промышленным оборудованием → проверять и
> сопровождать

Каждый сегмент принадлежит определённому набору проектов. Если сегмент
сломан, платформа не закончена.

## По сегментам

| № | Сегмент | Что происходит | Проекты |
| --- | --- | --- | --- |
| 1 | **Обнаружение** | Потенциальный пользователь находит экосистему, понимает её философию и выбирает точку входа | [docs.celestia.world](https://docs.celestia.world) (этот сайт), [celestia-island.github.io](https://celestia-island.github.io), [e.celestia.world](https://e.celestia.world) |
| 2 | **Установка** | Пользователь получает работающую систему: админ-панель, desktop/web оболочку, наблюдаемые сервисы | [arona](https://github.com/celestia-island/arona) (облачная API-админка), [shittim-chest](https://github.com/celestia-island/shittim-chest) (чат desktop/webUI), [malkuth](https://github.com/celestia-island/malkuth) (наблюдение за сервисами) |
| 3 | **Аутентификация** | Идентичность с нулевым доверием: регистрация (по приглашению), вход с ограничением частоты, API key, RBAC | [kirino](https://github.com/celestia-island/kirino) (примитивы аутентификации и движок RBAC) |
| 4 | **Развёртывание модели** | Выбор рантайма модели, развёртывание на узел, привязка к чат-бэкенду, учёт использования | [arona](https://github.com/celestia-island/arona) (панель + бэкенды), [entelecheia](https://github.com/celestia-island/entelecheia) (рантайм scepter), [plana](https://github.com/celestia-island/plana) (учёт и тарификация) |
| 5 | **Чат и агенты** | Общение с моделями, мультиагентная совместная работа, сохранение диалогов, управление памятью | [shittim-chest](https://github.com/celestia-island/shittim-chest) (UI и чат), [entelecheia](https://github.com/celestia-island/entelecheia) (оркестрация агентов), [noa](https://github.com/celestia-island/noa) (AI-ориентированное управление версиями) |
| 6 | **Промышленное управление** | Удалённые операции и брокеринг протоколов: Modbus, S7comm, OPC UA; телеметрия и шлюзы записи | [evernight](https://github.com/celestia-island/evernight) (брокер протоколов), [aoba](https://github.com/celestia-island/aoba) (CLI для Modbus и источников данных) |
| 7 | **Проверка и поддержка** | Интеграционные тесты на реальном оборудовании, наблюдение и самовосстановление, записи использования, каналы обратной связи | [celestia-integration](https://github.com/celestia-island/celestia-integration), [malkuth](https://github.com/celestia-island/malkuth), [plana](https://github.com/celestia-island/plana) (записи использования) |

## Как ведёт себя цикл

- **Каждый шаг тестируем.** Для каждого сегмента есть определённый приёмочный
  тест в [celestia-integration](https://github.com/celestia-island/celestia-integration);
  релиз не считается зелёным, пока весь цикл не пройдёт на реальных узлах.
- **Каждый шаг наблюдаем.** Наблюдение, конечные точки здоровья и записи
  использования делают состояние каждого сегмента видимым, а не
  предполагаемым.
- **Без тихой деградации.** Когда сегмент деградирует (например, память
  офлайн или бэкенд недоступен), ответ API и UI говорят об этом явно. Сбои
  громкие по замыслу.
- **Безопасность — не сегмент.** Шлюзы записи, проверка политик и
  подтверждение человеком вплетены в сегменты 5 и 6, а не прикручены в конце.
  См. [Принципы безопасности](./safety.md).

## Подробнее

- [Почему celestia-island](./why.md) — проблема, определяющая цикл.
- [Слоистая архитектура](./layered-architecture.md) — как компоненты сохраняют порядок.
- [Карта проектов](../ecosystem/projects.md) — полный перечень репозиториев.
- [Краткое руководство](../getting-started/quickstart.md) — пройти цикл за 30 минут.
