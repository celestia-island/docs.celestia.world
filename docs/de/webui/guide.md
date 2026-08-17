# Web UI — die Reise beginnend mit deinem ersten Satz

Zwei Oberflächen, ein Fluss: **arona** ist die Headless-Steuerungsebene (Modelle, Schlüssel,
Ledger, Memory); **shittim-chest** ist die Werkbank, die du tatsächlich vor Augen hast (Chat,
Panels, Weltblick). Jeder Bildschirm unten ist eine chest-Ansicht — chest spricht mit arona
über dessen RPC-Fläche; arona selbst bringt kein UI mit.

![Chest-Backend-Konsole](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## Modelle: von der Quelle bis zum Aufruf

Ein Modell durchläuft vier Stufen von „vorhanden“ bis „chatbereit“: **Quelle** (der
Providers-Katalog — Metadaten, keine Inferenz) → **Registrierung** (ein `ollama`-Backend oder
ein OpenAI-kompatibles `external`-Backend, persistent über Neustarts hinweg) → **Deployment**
(die Agents-Seite übergibt eine Modell-ID an einen `arona-agent`-Knoten; ein leerer Modellname
wählt automatisch den am wenigsten ausgelasteten Knoten) → **Routing** (die Models-Seite;
Lastverteilung nach wenigsten In-Flight-Anfragen mit Sitzungsaffinität). Externe Backends
sind fail-closed, bis die erste Probe erfolgreich ist. Die exakte API für jeden Schritt
liegt in den [arona docs](https://arona.docs.celestia.world).

## Identität und Verbrauchsmessung

![Chest-API-Schlüssel](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Chest-Abrechnung](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**API-Schlüssel** sind deine Identität — das Gateway authentifiziert `/v1/*` mit
Bearer-Tokens, und sowohl `curl` als auch chest zeigen an der Tür einen vor. **Usage** ist
ein Ledger pro Aufruf und Schlüssel: Tokens, Modell, Backend, Kosten. **Billing**-Stufen
setzen Kontingente (USD / Tokens / Rate-Limits); wer eines erreicht, erhält eine harte
Ablehnung, keine Verlangsamung.

## Chat und Memory

![Chest-Chat](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

Jede Chat-Runde läuft durch den Memory-Dienst — das Badge an jeder Runde verrät dir, ob das
geschah. `Memory on` bedeutet, dass relevante Langzeit-Erinnerungen vor dem Routing injiziert
wurden; `Memory offline` bedeutet, dass der Memory-Dienst nicht erreichbar ist (ein
Ehrlichkeitssignal, kein Bug); `disabled` bedeutet, dass nichts Relevantes gefunden wurde.
Abgeschlossene Runden werden zu Episoden extrahiert und persistent gespeichert, sodass
Memory Neustarts überlebt — und Write-Back-Einträge lassen sich direkt auf der Memory-Seite
löschen.

## Panels und industrielle Steuerung

![Chest-Agents](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

Ein Prompt erzeugt ein Panel; die Engine generiert das Layout und speichert es persistent im
Workspace-Speicher von scepter. Die Bearbeitung ist strukturell — Datenquellen-Bindungen,
Komponentenlisten, Verbindungszustände — keine Black Box. Topology und Holographic sind zwei
Ansichten derselben Flotte; Reports ergänzt eine semantische Suche über die Historie.
Industrielle Schreibvorgänge durchlaufen Richtlinienvalidierung und **menschliche Freigabe**,
bevor sich etwas bewegt: das Ende des geschlossenen Regelkreises — und zugleich dessen
schwerster Schritt.

![Chest-Login](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## Weiter vertiefen

- Die vollständige Referenz der arona-Plattform — [arona docs](https://arona.docs.celestia.world)
- Die chest-Werkbank und ihre Panels — [shittim-chest docs](https://shittim-chest.docs.celestia.world)
- Agents, Workspaces und das industrielle Schreib-Gate — [entelecheia docs](https://entelecheia.docs.celestia.world)
