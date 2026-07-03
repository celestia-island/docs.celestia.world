# Identification des Agents IA & Stratégie de Co-auteur de Commit

## Aperçu

`evernight` participe à la stratégie de co-auteur celestia-island de deux manières :

1. **En tant qu'hôte de commit** : lorsqu'un agent IA orchestre un commit via evernight
   (agent sur l'hôte A → SSH/exec evernight → hôte B → `git commit`), le hook côté hôte
   `commit-msg` (installé par `noa`) se déclenche localement et horodate le commit avec
   des métadonnées de provenance.
2. **En tant que provider de transit** : lorsqu'evernight relaie le trafic d'un modèle, il peut apparaître dans
   l'email de l'auteur en tant que plateforme desservie, rendant le saut de transport auditable.

Ce document spécifie le rôle d'evernight. Le mécanisme de référence est défini dans
le document de conception de `noa` ; la présente couvre l'intégration spécifique à evernight.

## Modèle d'Identité des Providers

L'email de l'auteur utilise l'espace de noms de confiance `celestia.world` :

```
Display Name <provider-or-platform-id@celestia.world>
```

Lorsqu'evernight relaie un modèle, l'identifiant du provider reflète ce relais :

```
GLM 5 <evernight.celestia.world@celestia.world>   # GLM 5 relayé via evernight
```

Les providers de première partie conservent leur propre domaine (`anthropic.com`, `deepseek.com`,
`zhipuai.cn`, ...) ; les relais tiers conservent le leur (`opencode.ai`, `jdcloud.com`,
`openrouter.ai`, ...). Cela rend la chaîne « quel modèle, par qui » visible sur
chaque commit.

## Trailer de Co-auteur

- Clé du trailer : `Co-authored-by` (reconnu par git).
- Un trailer par modèle distinct, dans l'ordre d'utilisation.
- Une exécution de chaîne entièrement sous contrôle de croisière YOLO reçoit en plus :
  `Co-authored-by: Entelecheia <demiurge@celestia.world>`.

## Utilisation des Tokens Intégrée

Ajouté après les trailers de co-auteur (séparé par une ligne vide) :

```
Co-authored-by: Claude Opus 4.8 (↑ 12.5k ↓ 8.3k ●45.2k) <anthropic.com@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 5.1k ↓ 3.2k) <deepseek.com@celestia.world>
```

- `Upload` = tokens d'entrée ; `Download` = tokens de sortie.
- `Cache` n'apparaît que lorsque des tokens d'entrée mis en cache ont été signalés et sont > 0.
- Comptes en milliers (`k`), une décimale, zéros de fin supprimés.

## Points d'Intégration d'evernight

### Hook côté hôte

Les commits réalisés via le JSON-RPC `Command.Exec` d'`evernight` (utilisés par le pipeline de
chirurgie d'entelecheia et la boucle `KaLos:auto_fix`) invoquent le `git` système, de sorte que le
hook `.git/hooks/commit-msg` installé par `noa hook install` s'applique tel quel. Aucune
modification du code d'evernight n'est requise pour les commits effectués sur un hôte où le hook est
installé.

### Identité du provider de transit

Lorsqu'evernight agit comme proxy pour le trafic LLM (par ex. en routant un appel de modèle vers l'inférence
locale d'un hôte distant), le résolveur de co-auteur peut être informé du point de terminaison de relais afin que
l'identifiant du provider devienne `evernight.celestia.world`. Ceci est configuré via la même
liste de providers `aporia.toml` que lit `noa co-author resolve`.

## Exemple de Message de Commit Complet

```
perf(screen): cache X11 connection to avoid per-frame reconnect

X11CaptureBackend previously called x11rb::connect on every capture_frame.
Cache the connection in a Mutex<Option<..>>, reusing it across frames.

Co-authored-by: Entelecheia <demiurge@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 18.2k ↓ 2.1k) <deepseek.com@celestia.world>
```

## Considérations de Sécurité

- Les trailers de co-auteur sont une provenance auto-déclarée, pas une preuve cryptographique.
- Le résolveur se dégrade de manière sûre : un `noa` manquant ou une erreur d'analyse produit un bloc vide
  et le commit se poursuit sans modification.
- Les identifiants de provider proviennent du `aporia.toml` local, reflétant les providers
  configurés.

## Référence des Identifiants de Provider (registre initial)

| Identifiant de provider | Marque | Indice d'endpoint |
| --- | --- | --- |
| `zhipuai.cn` | GLM | `open.bigmodel.cn` |
| `deepseek.com` | Deepseek | `api.deepseek.com` |
| `anthropic.com` | Claude | `api.anthropic.com` |
| `openai.com` | GPT / OpenAI | `api.openai.com` |
| `evernight.celestia.world` | (relais) | proxy evernight |
| `opencode.ai` | (relais) | `opencode.ai` |
| `jdcloud.com` | (relais) | `jdcloud.com` |
