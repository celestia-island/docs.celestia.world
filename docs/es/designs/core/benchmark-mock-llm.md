# Diseño del Servidor Benchmark & Mock LLM

> Propuesta central: **¿Cuántas tareas puede completar cualquier modelo + el sistema de herramientas de Entelecheia?**
>
> No se predefine una clasificación "débil/fuerte". La variable de entorno indica la key de qué provider; se crea la configuración del plan de codificación de ese modelo y se prueba. Si no hay ninguna key → se reporta el error y se sale directamente.

## 0. Hallazgo clave: reutilizar el registro de providers existente

Entelecheia **ya tiene** un sistema completo de descubrimiento de providers basado en variables de entorno:

- Repositorio `provider-registry`: 926 archivos TOML que cubren todos los providers principales (OpenAI / Anthropic / DeepSeek / GLM / Qwen / Kimi / MiniMax, etc.)
- `derive_config_from_env()`: recorre todos los entrypoint TOML; cualquier provider cuyo `env_var` esté establecido se activa automáticamente
- `ModelTier` (Deep / Normal / Basic), tres niveles + cadena de fallback
- `_shared_llm_provider::ProviderRegistry`: registro global, 5 protocolos (OpenAI Chat / Responses / Anthropic v1/v2 / Gemini)

**No hace falta crear un nuevo registro de providers**: el benchmark runner reutiliza directamente `_shared_config` + `_shared_llm_provider`.

## 1. Concepto de plan de codificación (Coding Plan)

Cada modelo disponible genera automáticamente un benchmark profile:

| Campo | Origen | Descripción |
|------|------|------|
| provider_id | entrypoint TOML | p. ej. `deepseek` / `zhipu_glm` |
| model_id | entrypoint defaults | p. ej. `deepseek-coder` / `glm-4-plus` |
| tier | ModelTier::Deep | Las tareas de codificación usan el tier Deep |
| base_url | entrypoint api.base_url | API remota real |
| api_key | Variable de entorno (entrypoint api.env_var) | Se lee en tiempo de ejecución |
| protocol | entrypoint api.protocol | Valor del enum GenProtocol |
| context_window | model card | Se lee de `models/<provider>/<model>.toml` |
| max_output_tokens | model card | Igual que arriba |
| supports_function_calling | model card | Determina el modo de llamada a herramientas |

El profile se construye dinámicamente en tiempo de ejecución a partir de las variables de entorno; no se almacena previamente en ningún archivo de configuración.

## 2. Arquitectura

```text
┌─────────────────────────────────────────────────────────┐
│                    Benchmark Runner                      │
│  (recorre instancias, recopila resultados, salida JSONL) │
└──────────────┬──────────────────────┬───────────────────┘
               │                      │
       ┌───────▼────────┐    ┌────────▼────────┐
       │  Task Adapter   │    │  Result Collector│
       │ (SWE-bench /    │    │  (git diff →     │
       │  Aider / etc.)  │    │   JSONL output)  │
       └───────┬────────┘    └────────▲─────────┘
               │                      │
       ┌───────▼──────────────────────┴─────────┐
       │        Entelecheia Agent Runtime        │
       │  (SkoPeo orquesta → HubRis → skills)    │
       │                                         │
       │  ┌─────────┐  ┌─────────┐  ┌────────┐  │
       │  │ Tool    │  │ Skill   │  │ Soul   │  │
       │  │ Layer   │  │ Chain   │  │ Layer  │  │
       │  │(MCP)    │  │ Router  │  │(Identity)│ │
       │  └────┬────┘  └─────────┘  └────────┘  │
       └───────┼─────────────────────────────────┘
               │
       ┌───────▼─────────────────────────────────┐
       │          LLM Backend Switch              │
       │                                         │
       │  ┌─────────────┐    ┌─────────────────┐ │
       │  │ Mock Server  │    │ Real API Proxy  │ │
       │  │(record/replay)│   │(OpenAI/etc.)    │ │
       │  └─────────────┘    └─────────────────┘ │
       └─────────────────────────────────────────┘
               │
       ┌───────▼─────────┐
       │  Docker Sandbox  │
       │ (entorno tarea)  │
       │ - repositorio    │
       │ - toolchain      │
       │ - test suite     │
       └─────────────────┘
```

## 3. Servidor Mock LLM

### 3.1 Protocolo Record/Replay

El servidor Mock es compatible con la API de OpenAI Chat Completions (`/v1/chat/completions`) y soporta dos modos de funcionamiento:

**Modo de grabación (al ejecutar el modelo real por primera vez)**:
```text
Client → Mock Server → Real API → Mock Server (grabar respuesta) → Client
```

**Modo de reproducción (CI / sin conexión)**:
```text
Client → Mock Server (coincide petición → devuelve respuesta grabada) → Client
```

### 3.2 Estrategia de coincidencia de peticiones

Las peticiones se emparejan mediante el hash de los siguientes campos:
- `model` (nombre del modelo)
- Hash del contenido de `messages` (tras normalización)
- Hash de la estructura de `tools` (si existe)
- Parámetros como `temperature`, `max_tokens`, etc.

**Modo Strict** (activado por defecto en CI): cualquier petición no coincidente produce un error inmediato; no se hace fallback a la API real. Garantiza que los fixtures estén completos.

**Modo Lenient** (para desarrollo): ante una falta de coincidencia, hace fallback a la API real y lo graba.

### 3.3 Almacenamiento de fixtures

```text
tests/fixtures/llm/
├── swe-bench-verified/
│   ├── gpt-4o/
│   │   ├── <request_hash>.json      # respuesta grabada
│   │   └── index.toml                # índice de resúmenes de peticiones
│   ├── claude-sonnet/
│   └── llama-8b/
└── aider-polyglot/
    └── ...
```

### 3.4 Elección de implementación

| Opción | Ventajas | Desventajas |
|------|------|------|
| **AIMock** (CopilotKit) | Maduro, soporta streaming/tool-calls/MCP, imagen Docker | Dependencia externa |
| **Servidor simple propio** | Control total, cero dependencias externas | Hay que gestionar a mano streaming y casos límite |
| **VCR.py / wiremock** | Ecosistema maduro del lenguaje | No es específico para LLM; requiere adaptación |

**Recomendación**: empezar con un servidor simple propio (una ruta axum/actix que empareje y devuelva JSON) y, más adelante, si se necesita streaming, migrar a AIMock.

## 4. Adaptador SWE-bench

### 4.1 Flujo de ejecución de tareas

```text
for instance in dataset:
    1. Descargar la imagen Docker de SWE-bench (3 capas: base + env + instance)
    2. Iniciar el contenedor y montar el repositorio de código
    3. Inyectar el texto del issue como descripción de la tarea
    4. Iniciar el Entelecheia Agent Runtime (conectado al bash/sistema de archivos del contenedor)
    5. El agente se ejecuta hasta completar o agotar el tiempo (límite de pasos: 50, wall-clock: 15 min)
    6. Ejecutar git diff dentro del contenedor → extraer el patch
    7. Generar salida JSONL: {instance_id, model_name_or_path, model_patch}
    8. Destruir el contenedor
```

### 4.2 Inyección del Agent Runtime

Cuando Entelecheia se ejecuta dentro del contenedor de SWE-bench, necesita:
- Herramientas de operaciones sobre archivos → mapeadas al sistema de archivos del contenedor
- Herramientas de ejecución de comandos → mapeadas al bash del contenedor
- Herramientas de búsqueda → `rg`/`grep` (preinstalados en el contenedor)
- **Desactivar** los agentes no relacionados con la tarea (PoleMos / protocolos industriales, etc.) para reducir el ruido de contexto

### 4.3 Evaluación

Se usa directamente el harness nativo de SWE-bench:
```bash
python -m swebench.harness.run_evaluation \
    --dataset_name princeton-nlp/SWE-bench_Verified \
    --predictions_path entelecheia_predictions.jsonl \
    --max_workers 8 --run_id entelecheia-eval
```

Salida: cada instancia marcada como resolved/unresolved; se agrega la tasa de resolución (resolution rate).

## 5. Matriz de experimentos

### 5.1 Comparación central

Se fija el dataset (SWE-bench Verified) y se varían dos dimensiones:

|  | Baseline (mini-SWE-agent) | Entelecheia |
|--|---------------------------|-------------|
| **GPT-4o** | A₁ | B₁ |
| **Claude Sonnet** | A₂ | B₂ |
| **Llama 3.1 8B** | A₃ | B₃ |
| **Qwen 2.5 7B** | A₄ | B₄ |

- Bᵢ/Aᵢ = factor de amplificación del modelo i
- Comparación entre filas: ¿el AF de los modelos débiles (Llama/Qwen) es mayor que el de los modelos fuertes (GPT-4o)?

### 5.2 Experimentos de ablación

| Configuración | Objetivo |
|------|------|
| Entelecheia completo (12 agentes + todas las skills) | Línea base a plena potencia |
| Solo HubRis + KaLos + SkeMma (planificación + archivos + ejecución) | Medir el incremento por la orquestación multi-agente |
| Solo KaLos + bash (un solo agente + herramientas de archivo) | Cerca del baseline; medir el incremento de la skill chain |
| Sin soul identity (sin prompts de identidad/metáfora) | Medir el efecto del prompt de persona |

## 6. Hoja de ruta de implementación

### Fase 1: Servidor Mock LLM (1-2 días)
- [ ] Implementar un servidor record/replay compatible con OpenAI
- [ ] Coincidencia por hash de peticiones + modos strict/lenient
- [ ] Estructura de almacenamiento de fixtures
- [ ] Conmutación mediante la variable de entorno `ENTELECHEIA_LLM_BASE_URL`

### Fase 2: Adaptador SWE-bench (2-3 días)
- [ ] Cargador de tareas JSONL
- [ ] Orquestación de contenedores Docker (reutilizar las imágenes de SWE-bench)
- [ ] Inyección del Agent Runtime en el contenedor
- [ ] Extracción del patch + salida JSONL
- [ ] Conexión con la evaluación del harness nativo

### Fase 3: Primera evaluación (1 día)
- [ ] Ejecutar el baseline + entelecheia con GPT-4o sobre SWE-bench Lite (300 problemas)
- [ ] Grabar los fixtures (para uso posterior en CI)
- [ ] Calcular el AF y emitir el primer informe comparativo

### Fase 4: Comparación multi-modelo (2-3 días)
- [ ] Incorporar Claude / Llama / Qwen
- [ ] Ejecutar la matriz completa de experimentos
- [ ] Experimentos de ablación
- [ ] Emitir el informe final

## 7. Puntos de integración con la arquitectura existente de Entelecheia

| Componente | Modo de integración |
|------|---------|
| `ApoRia::llm_chat` | Conmutar base_url para que apunte al mock o a la API real |
| `SkoPeo` orquestación | Añadir un modo de ejecución `benchmark` que omita las confirmaciones interactivas |
| `HubRis` planificación | Aceptar la descripción de la tarea del benchmark como entrada |
| `NeiKos` contenedor | Gestionar el ciclo de vida de los contenedores Docker de SWE-bench |
| `KaLos` archivos | Mapear al sistema de archivos del contenedor |
| `OreXis` seguridad | Relajar las políticas de seguridad en modo benchmark (permitir ejecución arbitraria de código) |

## 8. Consideraciones

- **Control de costos**: SWE-bench Verified completo, 500 problemas × 4 modelos × 2 configuraciones = 4000 ejecuciones. Estimando una media de 50 pasos por problema y ~2K tokens por paso, son unos 400M tokens. Conviene fijar un límite con `--max_cost`.
- **Recursos de contenedor**: cada instancia de SWE-bench necesita un contenedor Docker independiente; se recomiendan ≥120 GB de disco y ≥32 GB de RAM.
- **Determinismo**: el modo Mock garantiza reproducibilidad en CI; en modo Real se fija `temperature=0` + se registra el hash de la petición para detectar desviaciones.
- **Detección de contaminación**: SWE-bench presenta un problema de fugas de memoria (arXiv:2506.12286); se recomienda reservar parte de las tareas autogeneradas como holdout.
