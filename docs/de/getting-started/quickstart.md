# Schnellstart

Durchlaufen Sie den [geschlossenen Regelkreis](../philosophy/closed-loop.md) in
etwa 30 Minuten. Die genauen Adressen hängen von Ihrer Bereitstellung ab; fragen
Sie Ihren Administrator nach der Panel-URL und Ihrer Einladung.

## 1. Konto anlegen

Die Registrierung ist einladungsbasiert: Der erste Nutzer einer Bereitstellung
wird zum Admin, danach sperrt sich die Selbstregistrierung. Kontaktieren Sie
die Maintainer für eine Einladung und registrieren Sie sich dann über das
Arona-Panel (`https://arona.celestia.world` in einer öffentlichen
Bereitstellung oder `http://<host>:8420` intern).

## 2. API key erstellen

Erstellen Sie im Arona-Panel einen API key für Ihr Konto. Dieser Key ist Ihre
Identität für alles Folgende — Modellverwaltung, Chat-Backends und
Agentenoperationen.

## 3. Ein Modell bereitstellen

Wählen Sie im Panel eine Modell-Runtime (zum Beispiel ein Ollama-gestütztes
Modell), stellen Sie es auf einem Knoten bereit und binden Sie es an ein
Chat-Backend. Das Panel zeigt Health und Nutzung; Messung und Preisgestaltung
übernimmt die Plattformschicht.

## 4. Chatten und Agenten ausführen

Öffnen Sie [shittim-chest](https://shittim-chest.docs.celestia.world)
(Desktop-App oder WebUI), verbinden Sie sich mit Ihrem API key und starten Sie
eine Unterhaltung. Für Multi-Agenten-Arbeit orchestriert entelecheias
scepter-Runtime die Agenten hinter derselben Oberfläche; Agentenprotokolle und
Tool-Aufrufe sind in der UI sichtbar.

## 5. Industrieanlagen steuern

Verbinden Sie bei laufendem [evernight](https://evernight.docs.celestia.world)
eine Protokoll-Bridge (Modbus, S7comm, OPC UA), abonnieren Sie Telemetrie und
führen Sie — nach Richtlinienprüfung und menschlicher Bestätigung —
Schreiboperationen aus. Während der internen Beta läuft dieses Segment gegen
simulierte oder Laboranlagen; die Sicherheitskette ist in beiden Fällen
identisch.

## 6. Verifizieren

Prüfen Sie den Überwachungsstatus (von malkuth verwaltete Dienste), sehen Sie
sich die Nutzungsprotokolle an und melden Sie Probleme über die Kanäle im
[Beta-Leitfaden](./beta-guide.md). Wenn etwas kaputt ist, ist der Regelkreis
nicht fertig — sagen Sie uns, wo.

## Was, wenn etwas fehlschlägt?

- **Ein Dienst ist ausgefallen** — malkuth sollte ihn neu gestartet haben;
  prüfen Sie die Dienststatusseite oder die Logs.
- **Das Panel öffnet sich nicht** — prüfen Sie, ob Sie den richtigen Host/Port
  verwenden und ob der Deployer die eingebettete WebUI aktiviert hat.
- **Speicher oder Recall ist nicht verfügbar** — die API-Antwort und die UI
  kennzeichnen das explizit (`memory: "offline"`); Chat funktioniert auch ohne.

## Weiterführendes

- [Leitfaden zur geschlossenen Beta](./beta-guide.md) — was die Beta abdeckt und wie Sie Bugs melden.
- [Der Geschlossene Regelkreis](../philosophy/closed-loop.md) — die Philosophie hinter diesen Schritten.
