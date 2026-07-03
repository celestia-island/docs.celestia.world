# Conception du Serveur Benchmark & Mock LLM

> Thèse centrale : **Avec n'importe quel modèle + le système d'outils Entelecheia, combien de tâches peut-on accomplir ?**
>
> Aucune classification « faible/fort » prédéfinie. La clé de provider transmise via les variables d'environnement détermine pour quel modèle créer une configuration de forfait de codage et le tester. S'il n'y a aucune clé → erreur immédiate et arrêt.

## 0. Découverte clé : réutiliser le registre de providers existant

Entelecheia **dispose déjà** d'un système complet de découverte de providers piloté par les variables d'environnement :

- Dépôt `provider-registry` : 926 fichiers TOML, couvrant tous les principaux providers (OpenAI / Anthropic / DeepSeek / GLM / Qwen / Kimi / MiniMax, etc.)
- `derive_config_from_env()` : parcourt tous les TOML d'entrypoint ; tout provider dont la `env_var` est définie est automatiquement activé
- `ModelTier` (Deep / Normal / Basic) sur trois niveaux + chaîne de repli (fallback chain)
- `_shared_llm_provider::ProviderRegistry` : registre global, 5 protocoles (OpenAI Chat / Responses / Anthropic v1/v2 / Gemini)

**Pas besoin de créer un nouveau registre de providers** — le runner de benchmark réutilise directement `_shared_config` + `_shared_llm_provider`.

## 1. Concept de forfait de codage (Coding Plan)

Chaque modèle disponible génère automatiquement un profil de benchmark :

| Champ | Source | Description |
|------|------|------|
| provider_id | TOML d'entrypoint | ex. `deepseek` / `zhipu_glm` |
| model_id | valeurs par défaut de l'entrypoint | ex. `deepseek-coder` / `glm-4-plus` |
| tier | ModelTier::Deep | les tâches de codage utilisent le tier Deep |
| base_url | entrypoint api.base_url | véritable API distante |
| api_key | variable d'environnement (entrypoint api.env_var) | lu à l'exécution |
| protocol | entrypoint api.protocol | valeur de l'énumération GenProtocol |
| context_window | model card | lu depuis `models/<provider>/<model>.toml` |
| max_output_tokens | model card | idem |
| supports_function_calling | model card | détermine le mode d'appel d'outils |

Le profil est construit dynamiquement à l'exécution depuis les variables d'environnement, sans fichier de configuration préstocké.

## 2. Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Benchmark Runner                      │
│  (遍历数据集实例，收集结果，输出 JSONL)                     │
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
       │  (SkoPeo 编排 → HubRis 规划 → 技能链)    │
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
       │ (任务实例环境)    │
       │ - 代码仓库       │
       │ - 工具链         │
       │ - 测试套件       │
       └─────────────────┘
```

## 3. Serveur Mock LLM

### 3.1 Protocole Record/Replay

Le serveur Mock est compatible avec l'API OpenAI Chat Completions (`/v1/chat/completions`) et prend en charge deux modes de fonctionnement :

**Mode enregistrement (lors de la première exécution avec un modèle réel)** :
```
Client → Mock Server → Real API → Mock Server (录制响应) → Client
```

**Mode relecture (en CI / hors ligne)** :
```
Client → Mock Server (匹配请求 → 返回录制的响应) → Client
```

### 3.2 Stratégie de correspondance des requêtes

Les requêtes sont mises en correspondance via le hachage des champs suivants :
- `model` (nom du modèle)
- hachage du contenu de `messages` (après normalisation)
- hachage de la structure de `tools` (le cas échéant)
- paramètres tels que `temperature`, `max_tokens`, etc.

**Mode Strict** (activé par défaut en CI) : toute requête non correspondante déclenche immédiatement une erreur, sans repli vers la véritable API. Garantit l'intégrité des fixtures.

**Mode Lenient** (pour le développement) : en cas de non-correspondance, repli vers la véritable API et enregistrement.

### 3.3 Stockage des fixtures

```
tests/fixtures/llm/
├── swe-bench-verified/
│   ├── gpt-4o/
│   │   ├── <request_hash>.json      # 录制的响应
│   │   └── index.toml                # 请求摘要索引
│   ├── claude-sonnet/
│   └── llama-8b/
└── aider-polyglot/
    └── ...
```

### 3.4 Choix d'implémentation

| Option | Avantages | Inconvénients |
|------|------|------|
| **AIMock** (CopilotKit) | mature, prend en charge streaming/tool-calls/MCP, image Docker | dépendance externe |
| **Serveur simple maison** | contrôle total, zéro dépendance externe | nécessite de gérer soi-même streaming/edge cases |
| **VCR.py / wiremock** | écosystème linguistique mature | non spécifique aux LLM, adaptation nécessaire |

**Recommandation** : commencer par un serveur simple maison (un routeur axum/actix, correspondance + renvoi de JSON), puis migrer vers AIMock si le streaming devient nécessaire.

## 4. Adaptateur SWE-bench

### 4.1 Flux d'exécution des tâches

```
for instance in dataset:
    1. 拉取 SWE-bench Docker 镜像 (base + env + instance 三层)
    2. 启动容器，挂载代码仓库
    3. 注入 issue 文本作为任务描述
    4. 启动 Entelecheia Agent Runtime（连接到容器内的 bash/文件系统）
    5. Agent 执行直到完成或超时（step cap: 50, wall-clock: 15min）
    6. 容器内执行 git diff → 提取 patch
    7. 输出 JSONL: {instance_id, model_name_or_path, model_patch}
    8. 销毁容器
```

### 4.2 Injection du runtime de l'Agent

Lorsqu'Entelecheia s'exécute dans un conteneur SWE-bench, il a besoin de :
- outils de manipulation de fichiers → mappés au système de fichiers du conteneur
- outils d'exécution de commandes → mappés au bash du conteneur
- outils de recherche → `rg`/`grep` (préinstallés dans le conteneur)
- **Désactiver** les agents non liés à cette tâche (PoleMos/protocoles industriels, etc.) afin de réduire le bruit contextuel

### 4.3 Évaluation

Utiliser directement le harness natif de SWE-bench :
```bash
python -m swebench.harness.run_evaluation \
    --dataset_name princeton-nlp/SWE-bench_Verified \
    --predictions_path entelecheia_predictions.jsonl \
    --max_workers 8 --run_id entelecheia-eval
```

Sortie : chaque instance resolved/unresolved, agrégation en taux de résolution (resolution rate).

## 5. Matrice d'expérimentation

### 5.1 Comparaison centrale

Jeu de données fixé (SWE-bench Verified), variation selon deux dimensions :

|  | Baseline (mini-SWE-agent) | Entelecheia |
|--|---------------------------|-------------|
| **GPT-4o** | A₁ | B₁ |
| **Claude Sonnet** | A₂ | B₂ |
| **Llama 3.1 8B** | A₃ | B₃ |
| **Qwen 2.5 7B** | A₄ | B₄ |

- Bᵢ/Aᵢ = coefficient d'amplification du modèle i
- Comparaison entre lignes : l'AF des modèles faibles (Llama/Qwen) est-il supérieur à celui des modèles forts (GPT-4o) ?

### 5.2 Expériences d'ablation

| Configuration | Objectif |
|------|------|
| Entelecheia complet (12 agents + toutes les skills) | référence pleine puissance |
| HubRis + KaLos + SkeMma seuls (planification + fichiers + exécution) | mesurer l'apport de l'orchestration multi-agents |
| KaLos + bash seuls (agent unique + outils fichiers) | proche de la baseline, mesurer l'apport de la skill chain |
| Sans identité soul (retrait des prompts d'identité/métaphore) | mesurer l'effet des prompts de persona |

## 6. Feuille de route d'implémentation

### Phase 1 : Serveur Mock LLM (1-2 jours)
- [ ] Implémenter un serveur record/replay compatible OpenAI
- [ ] Correspondance par hachage de requêtes + modes strict/lenient
- [ ] Structure de stockage des fixtures
- [ ] Bascule via la variable d'environnement `ENTELECHEIA_LLM_BASE_URL`

### Phase 2 : Adaptateur SWE-bench (2-3 jours)
- [ ] Chargeur de tâches JSONL
- [ ] Orchestration de conteneurs Docker (réutilisation des images SWE-bench)
- [ ] Injection du runtime de l'Agent dans le conteneur
- [ ] Extraction des patches + sortie JSONL
- [ ] Intégration au harness natif pour l'évaluation

### Phase 3 : Première évaluation (1 jour)
- [ ] Exécuter la baseline + entelecheia avec GPT-4o sur SWE-bench Lite (300 problèmes)
- [ ] Enregistrer les fixtures (pour un usage ultérieur en CI)
- [ ] Calculer l'AF et produire le premier rapport comparatif

### Phase 4 : Comparaison multi-modèles (2-3 jours)
- [ ] Intégrer Claude / Llama / Qwen
- [ ] Exécuter la matrice d'expérimentation complète
- [ ] Expériences d'ablation
- [ ] Produire le rapport final

## 7. Points d'intégration avec l'architecture existante d'Entelecheia

| Composant | Mode d'intégration |
|------|---------|
| `ApoRia::llm_chat` | basculer la base_url vers l'API mock ou réelle |
| Orchestration `SkoPeo` | ajout d'un mode d'exécution `benchmark`, contournement des confirmations interactives |
| Planification `HubRis` | accepte la description de tâche benchmark en entrée |
| Conteneurs `NeiKos` | gère le cycle de vie des conteneurs Docker SWE-bench |
| Fichiers `KaLos` | mappés au système de fichiers du conteneur |
| Sécurité `OreXis` | assouplit les politiques de sécurité en mode benchmark (autorise l'exécution arbitraire de code) |

## 8. Points d'attention

- **Contrôle des coûts** : SWE-bench Verified en totalité représente 500 problèmes × 4 modèles × 2 configurations = 4000 exécutions. En estimant une moyenne de 50 étapes/problème et ~2K tokens/étape, cela représente environ 400M tokens. Il convient de définir une limite `--max_cost`.
- **Ressources des conteneurs** : chaque instance SWE-bench nécessite un conteneur Docker dédié ; il est recommandé de disposer d'≥120 Go de disque et d'≥32 Go de RAM.
- **Déterminisme** : le mode Mock garantit la reproductibilité en CI ; le mode Real fixe `temperature=0` + enregistre les hachages de requêtes afin de détecter la dérive (drift).
- **Détection de contamination** : SWE-bench présente un problème de fuite de mémoire (arXiv:2506.12286) ; il est recommandé de conserver une part de tâches auto-synthétisées en tant que holdout.
