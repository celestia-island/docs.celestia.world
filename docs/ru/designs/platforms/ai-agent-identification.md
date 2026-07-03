# Идентификация AI-агентов и стратегия соавторства в коммитах

## Обзор

`evernight` участвует в стратегии соавторства celestia-island двумя способами:

1. **Как хост коммитов**: когда AI-агент оркестрирует коммит через evernight (агент на хосте A → evernight SSH/exec → хост B → `git commit`), хук `commit-msg` на стороне хоста (устанавливаемый `noa`) срабатывает локально и штампует коммит метаданными происхождения (provenance).
2. **Как транзитный провайдер**: когда evernight ретранслирует трафик модели, он может фигурировать в email автора как обслуживающая платформа, делая транспортный переход (transport hop) аудируемым.

Этот документ описывает роль evernight. Авторитетный механизм определён в проектном документе `noa`; здесь рассматривается интеграция, специфичная для evernight.

## Модель идентичности провайдера

Email автора использует пространство имён доверия `celestia.world`:

```
Display Name <provider-or-platform-id@celestia.world>
```

Когда evernight ретранслирует модель, идентификатор провайдера отражает эту ретрансляцию:

```
GLM 5 <evernight.celestia.world@celestia.world>   # GLM 5 через ретрансляцию evernight
```

Провайдеры первого уровня сохраняют собственный домен (`anthropic.com`, `deepseek.com`, `zhipuai.cn`, ...); сторонние ретрансляторы сохраняют свой (`opencode.ai`, `jdcloud.com`, `openrouter.ai`, ...). Это делает цепочку «какая модель, через кого» видимой в каждом коммите.

## Трейлер соавтора

- Ключ трейлера: `Co-authored-by` (распознаваемый git).
- Один трейлер на каждую отдельную модель, в порядке использования.
- Цепочка, полностью выполненная под круиз-контролем YOLO, дополнительно получает:
  `Co-authored-by: Entelecheia <demiurge@celestia.world>`.

## Встроенное использование токенов

Добавляется после трейлеров соавторов (отделяется пустой строкой):

```
Co-authored-by: Claude Opus 4.8 (↑ 12.5k ↓ 8.3k ●45.2k) <anthropic.com@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 5.1k ↓ 3.2k) <deepseek.com@celestia.world>
```

- `Upload` = входные токены; `Download` = выходные токены.
- `Cache` появляется только тогда, когда сообщены токены кэшированного ввода и они > 0.
- Количество указывается в тысячах (`k`), один десятичный знак, с обрезкой конечных нулей.

## Точки интеграции evernight

### Хук на стороне хоста

Коммиты, сделанные через JSON-RPC `Command.Exec` `evernight` (используется конвейером surgery entelecheia и циклом `KaLos:auto_fix`), вызывают системный `git`, поэтому хук `.git/hooks/commit-msg`, устанавливаемый `noa hook install`, применяется без изменений. Изменений в коде evernight для коммитов на хосте с установленным хуком не требуется.

### Идентичность транзитного провайдера

Когда evernight проксирует LLM-трафик (напр., направляет вызов модели на локальный инференс удалённого хоста), резолверу соавторов можно сообщить конечную точку ретрансляции, чтобы идентификатор провайдера стал `evernight.celestia.world`. Это настраивается через тот же список провайдеров `aporia.toml`, который читает `noa co-author resolve`.

## Пример полного сообщения коммита

```
perf(screen): cache X11 connection to avoid per-frame reconnect

X11CaptureBackend previously called x11rb::connect on every capture_frame.
Cache the connection in a Mutex<Option<..>>, reusing it across frames.

Co-authored-by: Entelecheia <demiurge@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 18.2k ↓ 2.1k) <deepseek.com@celestia.world>
```

## Соображения безопасности

- Трейлеры соавторов — это самостоятельно сообщаемое происхождение, а не криптографическое доказательство.
- Резолвер безопасно деградирует: отсутствующий `noa` или ошибка парсинга дают пустой блок, и коммит проходит без изменений.
- Идентификаторы провайдеров берутся из локального `aporia.toml`, отражая настроенных провайдеров.

## Справочник идентификаторов провайдеров (начальный реестр)

| Идентификатор провайдера | Бренд | Подсказка точки подключения |
| --- | --- | --- |
| `zhipuai.cn` | GLM | `open.bigmodel.cn` |
| `deepseek.com` | Deepseek | `api.deepseek.com` |
| `anthropic.com` | Claude | `api.anthropic.com` |
| `openai.com` | GPT / OpenAI | `api.openai.com` |
| `evernight.celestia.world` | (ретранслятор) | прокси evernight |
| `opencode.ai` | (ретранслятор) | `opencode.ai` |
| `jdcloud.com` | (ретранслятор) | `jdcloud.com` |
