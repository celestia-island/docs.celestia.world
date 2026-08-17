# Web UI — путешествие с первой фразы

Две поверхности, один поток: **arona** — управляющий слой без интерфейса
(модели, ключи, журнал операций, память); **shittim-chest** — «рабочий
стол», за которым вы реально работаете (чат, панели, наблюдение за миром).
Каждый экран ниже — представление chest: chest общается с arona по её
RPC-поверхности, интерфейса у arona нет.

![Консоль бэкенда chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## Модели: от источника до вызова

Модель проходит путь от «существует» до «готова к чату» за четыре этапа:
**источник** (каталог Providers — метаданные, а не инференс) →
**регистрация** (бэкенд `ollama` или OpenAI-совместимый `external`,
сохраняемый между перезапусками) → **развёртывание** (страница Agents
передаёт ID модели узлу `arona-agent`; пустое имя модели само выбирает
наименее загруженный узел) → **маршрутизация** (страница Models;
балансировка по минимуму незавершённых запросов с привязкой сессии).
Внешние бэкенды закрыты до успеха первого зонда. Точный API каждого шага
описан в [документации arona](https://arona.docs.celestia.world).

## Идентичность и учёт

![API-ключи chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Тарификация chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**API-ключи** — это ваша идентичность: шлюз аутентифицирует `/v1/*`
Bearer-токенами, и `curl`, и chest предъявляют его на входе. **Usage** —
журнал вызовов по каждому ключу: токены, модель, бэкенд, стоимость.
**Billing** задаёт квоты по уровням (USD / токены / лимиты частоты);
достижение квоты — жёсткий отказ, а не замедление.

## Чат и память

![Чат chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

Каждый ход чата проходит через сервис памяти — значок у хода говорит, было
ли это. `Memory on` — релевантные долгосрочные воспоминания внедрены до
маршрутизации; `Memory offline` — сервис памяти недоступен (сигнал
честности, а не баг); `disabled` — ничего релевантного не найдено.
Завершённые ходы извлекаются в эпизоды и сохраняются, поэтому память
переживает перезапуски — а элементы обратной записи можно удалять прямо со
страницы Memory.

## Панели и промышленное управление

![Агенты chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

Один промпт создаёт панель; движок генерирует разметку и сохраняет её в
хранилище рабочей области scepter. Редактирование структурно — привязки
источников данных, списки компонентов, состояния соединений — а не чёрный
ящик. Топология и Holographic — два представления одного парка устройств;
Reports добавляет семантический поиск по истории. Промышленные записи
проходят проверку политик и **подтверждение человеком** прежде чем что-то
сдвинется: конец замкнутого контура и его самый тяжёлый шаг.

![Вход в chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## Копать глубже

- Полный справочник платформы arona — [документация arona](https://arona.docs.celestia.world)
- Рабочий стол chest и его панели — [документация shittim-chest](https://shittim-chest.docs.celestia.world)
- Агенты, рабочие области и шлюз промышленной записи — [документация entelecheia](https://entelecheia.docs.celestia.world)
