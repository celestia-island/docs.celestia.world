# Architecture de Réflexion : Auto-Remise en Question Continue dans la Skill Chain

> **Statut** : spécification de conception. Implémentation en cours.
> Rédigé le 2026-06-27.

## Le Problème

Le pipeline actuel de la skill chain s'exécute en **une seule passe avant** : une skill produit un résultat, l'orchestrateur vérifie la correction structurelle (a-t-elle appelé `report()` ? a-t-elle lancé `cargo check` ?), puis passe à la skill suivante. Il n'y a aucune phase où le système se demande :

1. *Le raisonnement de cette étape était-il fondé ?* (réflexion sémantique)
1. *Compte tenu de ce qui vient de se passer, devrions-nous changer de direction ?* (réflexion adaptative)
1. *Que devrions-nous retenir pour la prochaine fois ?* (sédimentation des leçons)

Les mécanismes existants — relances de vérification (verify nudges), retour en arrière après chirurgie (post-surgery rollback), audits quotidiens YOLO — sont tous **réactifs et binaires** : ils détectent les défaillances techniques, pas les défaillances de raisonnement. Une skill peut produire un code syntaxiquement correct, qui compile, mais qui résout le mauvais problème, et rien dans le pipeline actuel ne l'interceptera tant qu'un humain n'aura pas revu le résultat final.

## Principes de Conception

1. **La réflexion est une phase du pipeline, pas un hook ajouté après coup.** Elle dispose de son propre créneau entre la validation de la sortie et la distribution du rapport — le même poids structurel que toute autre phase.

1. **Trois niveaux, trois coûts.** Toutes les étapes ne méritent pas une critique philosophique approfondie. Le système doit sélectionner automatiquement la profondeur de réflexion appropriée en fonction de ce qui vient de se passer.

1. **OreXis est l'agent de réflexion.** Sa conception existante — le Titan questionneur, celui qui remonte l'incertitude à l'opérateur — correspond parfaitement au rôle de réflexion. Aucun nouvel agent n'est nécessaire.

1. **Les leçons doivent se propager vers l'avant.** Une réflexion qui ne modifie pas le comportement futur n'est qu'un journal. Le magasin de leçons (lesson store) doit se réinjecter dans la préparation du contexte afin que la prochaine chaîne bénéficie des erreurs de la précédente.

1. **La réflexion auto-déclenchée est un outil de premier ordre.** N'importe quel agent doit pouvoir demander un cycle de réflexion depuis son script IEPL, sans simplement attendre que l'orchestrateur en planifie un.

## Système de Réflexion à Trois Niveaux

```text
┌──────────────────────────────────────────────────────────────────┐
│                    SKILL CHAIN PIPELINE                          │
│                                                                  │
│  ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐   ┌──────────────┐  │
│  │ A:   │   │ D:   │   │ E:   │   │ F:   │   │ REFLECTION   │  │
│  │Guard │──▶│Build │──▶│Invoke│──▶│Valid │──▶│ (NEW)        │  │
│  │Check │   │Prompt│   │Skill │   │Report│   │              │  │
│  └──────┘   └──────┘   └──────┘   └──────┘   └────┬───────┘  │
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

### Tier 0 : Réflexion heuristique (coût nul, toujours active)

**Quoi** : vérifications basées sur des règles portant sur la sortie de la skill et la trace d'exécution.

**Quand** : chaque skill, sans exception.

**Comment** : logique purement Rust, sans appel au LLM. Version étendue de l'existant `validate_report_capture()` avec des heuristiques supplémentaires :

- Cohérence de la longueur de sortie (trop court / suspectément long)
- Anomalies dans les motifs d'appels d'outils (outils appelés hors du domaine attendu de la skill)
- Valeurs aberrantes de temps d'exécution (la skill a pris 10 fois plus de temps que sa moyenne historique)
- Taux d'erreur parmi les appels d'outils (plus de 50 % des appels d'outils ont échoué)
- Détection de références circulaires dans la sortie

**Coût** : quasi nul (microsecondes de CPU).

**Verdict** : peut émettre `Accept` (réussite) ou `NeedsTier1` (escalade vers le niveau sémantique).

### Tier 1 : Réflexion sémantique (1 appel LLM, aux points de décision)

**Quoi** : évaluation basée sur le LLM : « Cette sortie atteint-elle l'objectif déclaré de la skill ? La chaîne de raisonnement est-elle cohérente en interne ? »

**Quand** : déclenchée par :

- Escalade du Tier 0 (`NeedsTier1`)
- Skills explicitement marquées `requires_reflection` dans leur définition
- Skills aux points de décision de la chaîne (après `task_decompose`, `plan_execute`,

`workplan_generate`)

- Première occurrence d'une skill dans une chaîne (déclencheur de nouveauté)
- Auto-déclenchée par n'importe quel agent via l'outil `orexis::request_reflection`

**Comment** : agent OreXis invoqué avec un prompt de skill spécifique à la réflexion. Le prompt comprend :

- L'objectif déclaré de la skill
- La sortie de la skill
- Le résumé de la trace d'exécution (appels d'outils effectués, leurs résultats)
- Le contexte de la chaîne (ce qui précède, ce qui suit)

**Coût** : 1 appel LLM (~500-2000 tokens de sortie).

**Verdict** : `Accept`, `Adjust` (avec modification suggérée), `Backtrack`
(retour à la skill précédente et nouvelle tentative avec une approche différente), ou `NeedsTier2`
(escalade vers la critique approfondie).

### Tier 2 : Critique approfondie (revue philosophique d'OreXis, aux frontières de chaîne)

**Quoi** : examen piloté par OreXis de l'ensemble de la chaîne : « L'approche globale était-elle correcte ? Quelles hypothèses étaient erronées ? Que devrions-nous apprendre ? »

**Quand** : déclenchée par :

- Escalade du Tier 1 (`NeedsTier2`)
- Fin de chaîne (succès ou échec) — s'exécute comme un hook post-chaîne
- Périodicité configurée par l'opérateur (par ex. toutes les N chaînes)
- Niveau YOLO Strategic

**Comment** : agent OreXis avec la skill `deep_critique`. Examine :

- La trace complète de la chaîne (toutes les skills, toutes les sorties, tous les appels d'outils)
- L'objectif initial par rapport au résultat atteint
- Les leçons historiques issues du magasin de leçons (pour la mise en correspondance de motifs)

**Coût** : 1-2 appels LLM (~1000-5000 tokens de sortie).

**Verdict** : produit un `DeepCritiqueReport` contenant :

- Analyse de cause racine (si la chaîne a échoué)
- Audit des hypothèses (quelles hypothèses étaient valides, lesquelles ne l'étaient pas)
- Candidats-leçons (à écrire dans le magasin de leçons)
- Évaluation de la confiance

## Modèle de Données

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

### Magasin de Leçons (Lesson Store)

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

## Points d'Intégration

### 1. Insertion dans le pipeline (pipeline.rs)

Entre la Phase F (`post_execution_cleanup`) et la Phase G
(`dispatch_report_and_check_termination`), insérer :

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

### 2. Préparation du contexte (injection de leçons)

Dans la Phase D (`build_prompts`), avant d'assembler le prompt système, interroger le magasin de leçons pour récupérer les leçons pertinentes contextuellement :

```rust
let relevant_lessons = lesson_store
    .find_similar(&s.current_skill_context, TOP_K_LESSONS)
    .await;

let lesson_section = format_lessons_for_prompt(&relevant_lessons);
// Inject into system prompt after skill description
```

### 3. Réflexion auto-déclenchée (outil IEPL)

Exposer `orexis::request_reflection` dans l'espace de noms IEPL. N'importe quel agent peut l'appeler depuis son code TypeScript :

```typescript
import { request_reflection } from 'orexis';

const review = await request_reflection({
  reason: "I'm about to execute a potentially destructive operation",
  context: { operation: "file_delete", path: "/etc/..." },
  urgency: "high",
});
```

Ceci lance un cycle de réflexion OreXis de manière synchrone, bloquant l'agent appelant jusqu'à ce que la réflexion soit terminée.

### 4. Hook de critique approfondie post-chaîne

Enregistrer un nouveau hook de pipeline dans l'espace de noms `surgery_hooks` :

```text
pipeline.reflection.post_chain  (priority 30, after PostSurgeryRollback)
```

Ce hook exécute la critique approfondie du Tier 2 après une chaîne réussie, produisant des leçons bénéfiques aux chaînes futures.

## Cycle de Vie des Leçons

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

Les leçons sont des artefacts vivants :

- **Renforcées** lorsque leur application est corrélée à des résultats réussis
- **Ajustées** lorsque le texte de la leçon doit être affiné au vu de nouveaux éléments
- **Dépréciées** lorsqu'elles échouent systématiquement à aider ou deviennent non pertinentes

## Gestion des Coûts

| Tier | Coût en tokens | Fréquence | Budget quotidien de tokens |
| --- | --- | --- | --- |
| Heuristic | 0 | Chaque skill | 0 |
| Semantic | ~2K tokens | Points de décision (~30 % des skills) | ~20K tokens/chaîne |
| Deep | ~5K tokens | Par chaîne + escalades | ~5K-10K tokens/chaîne |

Surcoût total : environ 10-15 % de consommation de tokens supplémentaire par chaîne, échangeant des tokens contre de la qualité. Configurable via des variables d'environnement.

## Configuration

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

## Relation avec les Systèmes Existants

| Système existant | Relation |
| --- | --- |
| `validate_report_capture()` | Englobé par le Tier 0 comme une heuristique parmi d'autres |
| Relance de vérification (Verify nudge) | Devient une heuristique du Tier 0 pouvant escalader vers le Tier 1 |
| `PostSurgeryRollback` | Inchangé ; la réflexion s'exécute avant lui, sans le remplacer |
| Audits quotidiens YOLO | Complétés par la réflexion ; les audits vérifient la conformité, la réflexion vérifie le raisonnement |
| `RetroReview` | Englobé par la critique approfondie du Tier 2 pour la revue au niveau des objectifs |
| Champs `quality_score` / `lesson` | Connectés au magasin de leçons ; disposent enfin d'un lecteur |
| `context_preparation` | Étendu pour injecter les leçons pertinentes |
| `agent-consensus` | Le consensus valide les faits ; la réflexion valide le raisonnement. Complémentaires |
| `memory-and-self.md` | Le magasin de leçons est l'implémentation opérationnelle de la « sédimentation de la mémoire pour le soi » |

## Nommage

Les composants internes du système de réflexion suivent la convention de nommage philosophique grecque existante :

- **OreXis** (ὄρεξις, "desire/yearning") — déjà l'agent questionneur.

Son désir est de savoir si les choses sont *justes*, pas seulement *faites*.

- **Lesson** — cohérent avec les noms de champs `quality_score` / `lesson`

existants dans `TaskState`.

- **`ReflectionResult`** — nommage fonctionnel, en accord avec `ReportCaptureDecision`

et les autres types du pipeline.
