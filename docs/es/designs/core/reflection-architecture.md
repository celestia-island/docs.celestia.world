# Arquitectura de Reflexión: Duda Continua en la Cadena de Skills

> **Estado**: Especificación de diseño. Implementación en curso.
> Escrito el 2026-06-27.

## El problema

El pipeline actual de la cadena de skills se ejecuta en una **única pasada hacia adelante**: una skill produce su salida, el orquestador comprueba la corrección estructural (¿llamó a `report()`? ¿ejecutó `cargo check`?) y luego avanza a la siguiente skill. No existe ninguna fase en la que el sistema se pregunte:

1. *¿Fue sólido el razonamiento de este paso?* (reflexión semántica)
1. *Dado lo que acaba de ocurrir, ¿deberíamos cambiar de dirección?* (reflexión adaptativa)
1. *¿Qué deberíamos recordar para la próxima vez?* (sedimentación de lecciones)

Los mecanismos existentes — los empujes (nudges) de verificación, el rollback post-cirugía, las auditorías diarias de YOLO — son todos **reactivos y binarios**: detectan fallos técnicos, no fallos de razonamiento. Una skill puede producir código sintácticamente correcto y que compila, pero que resuelve el problema equivocado, y nada en el pipeline actual lo detectará hasta que un humano revise la salida final.

## Principios de diseño

1. **La reflexión es una fase del pipeline, no un hook añadido a posteriori.** Tiene su propio hueco entre la validación de la salida y el envío del reporte — el mismo peso estructural que cualquier otra fase.

1. **Tres niveles, tres costos.** No todos los pasos merecen una crítica filosófica profunda. El sistema debe seleccionar automáticamente la profundidad de reflexión adecuada en función de lo que acaba de ocurrir.

1. **OreXis es el agente de reflexión.** Su diseño existente — el Titán que cuestiona, el que traslada la incertidumbre al operador — encaja perfectamente con el rol de reflexión. No hace falta un agente nuevo.

1. **Las lecciones deben fluir hacia adelante.** Una reflexión que no cambia el comportamiento futuro es solo un diario. El almacén de lecciones debe retroalimentarse en la preparación del contexto, de modo que la próxima cadena se beneficie de los errores de la anterior.

1. **La reflexión autoactivada es una herramienta de primera clase.** Cualquier agente debe poder solicitar un ciclo de reflexión desde dentro de su script IEPL, no solo esperar a que el orquestador lo programe.

## Sistema de reflexión de tres niveles

```text
┌──────────────────────────────────────────────────────────────────┐
│                    SKILL CHAIN PIPELINE                          │
│                                                                  │
│  ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐   ┌──────────────┐  │
│  │ A:   │   │ D:   │   │ E:   │   │ F:   │   │ REFLECTION   │  │
│  │Guard │──▶│Build │──▶│Invoke│──▶│Valid │──▶│ (NEW)        │  │
│  │Check │   │Prompt│   │Skill │   │Report│   │              │  │
│  └──────┘   └──────┘   └──────┘   └──────┘   └──────┬───────┘  │
│                                                  │            │
│                                    ┌─────────────┼─────────┐ │
│                                    ▼             ▼         ▼ │
│                              ┌──────────┐ ┌─────────┐ ┌──────┐│
│                              │Tier 0:   │ │Tier 1:  │ │Tier 2││
│                              │Heuristic │ │Semantic │ │Deep  ││
│                              │(free)    │ │(1 LLM)  │ │(OreXis││
│                              └──────────┘ └─────────┘ │critiq││
│                                    │         │       │ue)   ││
│                                    ▼         ▼       └──┬───┘│
│                              ┌──────────────────────────────┐│
│                              │  ReflectionVerdict           ││
│                              │  Accept / Adjust / Backtrack ││
│                              │  / Abort                     ││
│                              └──────────────┬───────────────┘│
│                                             ▼                 │
│  ┌──────┐   ┌──────┐                   ┌──────────┐          │
│  │ G:   │   │ H:   │ ◀──────────────── │ Lesson   │          │
│  │Disp  │   │Stack │                   │ Store    │          │
│  │Report│   │Resolv│                   │ (write)  │          │
│  └──────┘   └──────┘                   └──────────┘          │
└──────────────────────────────────────────────────────────────────┘
```

### Nivel 0: Reflexión heurística (costo cero, siempre activa)

**Qué**: Comprobaciones basadas en reglas sobre la salida de la skill y la traza de ejecución.

**Cuándo**: En cada skill, sin excepciones.

**Cómo**: Lógica pura en Rust, sin llamada al LLM. Versión ampliada de la función `validate_report_capture()` existente, con heurísticas adicionales:

- Verificación de la longitud de la salida (demasiado corta / sospechosamente larga)
- Anomalías en el patrón de llamadas a herramientas (llamó a herramientas fuera del dominio esperado de la skill)
- Valores atípicos en el tiempo de ejecución (la skill tardó 10 veces más que su media histórica)
- Tasa de error en las llamadas a herramientas (más del 50 % de las llamadas fallaron)
- Detección de referencias circulares en la salida

**Costo**: Prácticamente cero (microsegundos de CPU).

**Veredicto**: Puede emitir `Accept` (aprobar) o `NeedsTier1` (escalar a semántica).

### Nivel 1: Reflexión semántica (1 llamada al LLM, en los puntos de decisión)

**Qué**: Evaluación basada en LLM: "¿Esta salida consigue el objetivo declarado de la skill? ¿La cadena de razonamiento es internamente consistente?"

**Cuándo**: Se activa por:

- Escalado del Nivel 0 (`NeedsTier1`)
- Skills marcadas explícitamente como `requires_reflection` en su definición
- Skills en puntos de decisión de la cadena (tras `task_decompose`, `plan_execute`, `workplan_generate`)
- Primera aparición de una skill en una cadena (disparador por novedad)
- Autoactivada por cualquier agente mediante la herramienta `orexis::request_reflection`

**Cómo**: Se invoca al agente OreXis con un prompt de skill específico de reflexión. El prompt incluye:

- El objetivo declarado de la skill
- La salida de la skill
- El resumen de la traza de ejecución (llamadas a herramientas realizadas y sus resultados)
- El contexto de la cadena (qué vino antes, qué viene después)

**Costo**: 1 llamada al LLM (~500-2000 tokens de salida).

**Veredicto**: `Accept`, `Adjust` (con la modificación sugerida), `Backtrack` (volver a la skill anterior y reintentar con un enfoque distinto) o `NeedsTier2` (escalar a la crítica profunda).

### Nivel 2: Crítica profunda (revisión filosófica de OreXis, en los límites de la cadena)

**Qué**: Examen de toda la cadena impulsado por OreXis: "¿Fue correcto el enfoque global? ¿Qué supuestos eran erróneos? ¿Qué deberíamos aprender?"

**Cuándo**: Se activa por:

- Escalado del Nivel 1 (`NeedsTier2`)
- Finalización de la cadena (éxito o fallo) — se ejecuta como un hook post-cadena
- Periodicidad configurada por el operador (p. ej., cada N cadenas)
- Nivel estratégico de YOLO

**Cómo**: Agente OreXis con la skill `deep_critique`. Revisa:

- La traza completa de la cadena (todas las skills, todas las salidas, todas las llamadas a herramientas)
- El objetivo original frente al resultado conseguido
- Las lecciones históricas del almacén de lecciones (para coincidencia de patrones)

**Costo**: 1-2 llamadas al LLM (~1000-5000 tokens de salida).

**Veredicto**: Produce un `DeepCritiqueReport` que contiene:

- Análisis de causa raíz (si la cadena falló)
- Auditoría de supuestos (cuáles eran válidos y cuáles no)
- Candidatos a lección (para escribir en el almacén de lecciones)
- Evaluación de confianza

## Modelo de datos

### ReflectionResult

```rust
pub struct ReflectionResult {
    pub tier: ReflectionTier,
    pub verdict: ReflectionVerdict,
    pub confidence: f32,
    pub reasoning: String,
    pub lessons: Vec<LessonCandidate>,
    pub suggested_adjustment: Option<String>,
    pub created_at: DateTime<Utc>,
}

pub enum ReflectionTier {
    Heuristic,
    Semantic,
    Deep,
}

pub enum ReflectionVerdict {
    Accept,
    Adjust { modification: String },
    Backtrack { to_skill: String, reason: String },
    Abort { reason: String },
}
```

### Almacén de lecciones

```rust
pub struct Lesson {
    pub id: Uuid,
    pub context_signature: String,      // semantic hash of the situation
    pub context_embedding: Vec<f32>,    // for similarity matching (pgvector)
    pub lesson_text: String,
    pub severity: LessonSeverity,
    pub source_chain_id: Uuid,
    pub source_skill: String,
    pub created_at: DateTime<Utc>,
    pub times_applied: u32,
    pub effectiveness_score: f32,       // updated when lesson is applied
    pub deprecated: bool,
}

pub enum LessonSeverity {
    Info,
    Warning,
    Critical,
}
```

### ReflectionTrigger

```rust
pub enum ReflectionTrigger {
    Always,                              // Tier 0 for every skill
    SkillFlagged(String),                // skill has requires_reflection
    DecisionPoint,                       // task_decompose, plan_execute, etc.
    NovelSkill,                          // first occurrence in chain
    Escalation(ReflectionTier),          // lower tier escalated
    SelfRequested { by_agent: String },  // orexis::request_reflection
    PostChain,                           // after chain completes
    Periodic { interval_secs: u64 },     // YOLO-style periodic
}
```

## Puntos de integración

### 1. Inserción en el pipeline (pipeline.rs)

Entre la Fase F (`post_execution_cleanup`) y la Fase G (`dispatch_report_and_check_termination`), se inserta:

```rust
// NEW: Reflection phase
let reflection_result = Self::reflect_on_output(
    st, &s, &setup, &invoke_result, &cleanup,
).await;

match reflection_result.verdict {
    ReflectionVerdict::Accept => { /* proceed to Phase G */ },
    ReflectionVerdict::Adjust { modification } => {
        // Inject modification into next skill's context
        s.pending_adjustment = Some(modification);
    },
    ReflectionVerdict::Backtrack { to_skill, reason } => {
        // Roll back chain state to the specified skill
        s.current_skill = to_skill;
        s.executed_skills.remove(&to_skill);
        // Continue loop from the earlier skill
    },
    ReflectionVerdict::Abort { reason } => {
        break 'chain false;
    },
}
```

### 2. Preparación del contexto (inyección de lecciones)

En la Fase D (`build_prompts`), antes de ensamblar el prompt del sistema, se consulta el almacén de lecciones para obtener las contextualmente relevantes:

```rust
let relevant_lessons = lesson_store
    .find_similar(&s.current_skill_context, TOP_K_LESSONS)
    .await;

let lesson_section = format_lessons_for_prompt(&relevant_lessons);
// Inject into system prompt after skill description
```

### 3. Reflexión autoactivada (herramienta IEPL)

Se expone `orexis::request_reflection` al espacio de nombres IEPL. Cualquier agente puede llamarla desde su código TypeScript:

```typescript
import { request_reflection } from 'orexis';

const review = await request_reflection({
  reason: "I'm about to execute a potentially destructive operation",
  context: { operation: "file_delete", path: "/etc/..." },
  urgency: "high",
});
```

Esto lanza un ciclo de reflexión de OreXis de forma síncrona, bloqueando al agente que lo llama hasta que la reflexión termina.

### 4. Hook de crítica profunda post-cadena

Se registra un nuevo hook del pipeline en el espacio de nombres `surgery_hooks`:

```text
pipeline.reflection.post_chain  (priority 30, after PostSurgeryRollback)
```

Este hook ejecuta la crítica profunda del Nivel 2 tras una cadena con éxito, produciendo lecciones que benefician a cadenas futuras.

## Ciclo de vida de las lecciones

```text
┌─────────────┐     ┌──────────────┐     ┌───────────────┐
│  Created    │────▶│  Applied     │────▶│  Evaluated    │
│  (Tier 2)   │     │  (injected   │     │  (did it help?│
│             │     │   into next  │     │   track score)│
│             │     │   chain)     │     │               │
└─────────────┘     └──────────────┘     └───────┬───────┘
                                                 │
                                    ┌────────────┼────────────┐
                                    ▼            ▼            ▼
                              ┌──────────┐ ┌──────────┐ ┌──────────┐
                              │Reinforced│ │Adjusted  │ │Deprecated│
                              │(score ↑) │ │(text     │ │(score ↓, │
                              │          │ │ updated) │ │ removed) │
                              └──────────┘ └──────────┘ └──────────┘
```

Las lecciones son artefactos vivos:

- **Reforzadas** cuando aplicarlas se correlaciona con resultados exitosos
- **Ajustadas** cuando el texto de la lección necesita refinarse a la vista de nuevas evidencias
- **Descontinuadas** cuando sistemáticamente no ayudan o dejan de ser relevantes

## Gestión de costos

| Nivel | Costo en tokens | Frecuencia | Presupuesto diario de tokens |
| --- | --- | --- | --- |
| Heurístico | 0 | En cada skill | 0 |
| Semántico | ~2K tokens | Puntos de decisión (~30 % de las skills) | ~20K tokens/cadena |
| Profundo | ~5K tokens | Por cadena + escalados | ~5K-10K tokens/cadena |

Sobrecarga total: aproximadamente un 10-15 % adicional de consumo de tokens por cadena, intercambiando tokens por calidad. Configurable mediante variables de entorno.

## Configuración

```env
# Reflection system configuration
REFLECTION_ENABLED=true
REFLECTION_TIER0_ENABLED=true                    # always-on heuristics
REFLECTION_TIER1_ENABLED=true                    # semantic reflection
REFLECTION_TIER2_ENABLED=true                    # deep critique
REFLECTION_TIER1_SKILL_THRESHOLD=0.3             # % of skills that get Tier 1
REFLECTION_POST_CHAIN_ENABLED=true               # deep critique after chain
REFLECTION_LESSON_TOP_K=5                        # max lessons injected per skill
REFLECTION_LESSON_MIN_EFFECTIVENESS=0.3          # don't inject useless lessons
REFLECTION_BACKTRACK_MAX=2                       # max backtracks per chain
```

## Relación con los sistemas existentes

| Sistema existente | Relación |
| --- | --- |
| `validate_report_capture()` | Absorbida por el Nivel 0 como una heurística entre muchas |
| Empuje de verificación (Verify nudge) | Se convierte en una heurística del Nivel 0 que puede escalar al Nivel 1 |
| `PostSurgeryRollback` | Permanece tal cual; la reflexión se ejecuta antes, sin reemplazarlo |
| Auditorías diarias de YOLO | Complementadas por la reflexión; las auditorías verifican cumplimiento, la reflexión verifica razonamiento |
| `RetroReview` | Absorbido por la crítica profunda del Nivel 2 para la revisión a nivel de objetivo |
| Campos `quality_score` / `lesson` | Conectados al almacén de lecciones; por fin tienen un lector |
| `context_preparation` | Ampliado para inyectar lecciones relevantes |
| `agent-consensus` | El consenso valida hechos; la reflexión valida razonamiento. Complementarios |
| `memory-and-self.md` | El almacén de lecciones es la implementación operativa de la "sedimentación de memoria para el yo" |

## Nomenclatura

Los componentes internos del sistema de reflexión siguen la convención de nomenclatura filosófica griega ya existente:

- **OreXis** (ὄρεξις, "deseo/anhelo") — ya es el agente que cuestiona.

Su deseo es saber si las cosas están *bien*, no solo *hechas*.

- **Lesson** — coherente con los nombres de campo `quality_score` / `lesson` ya existentes en `TaskState`.

- **`ReflectionResult`** — nomenclatura funcional, en consonancia con `ReportCaptureDecision` y otros tipos del pipeline.
