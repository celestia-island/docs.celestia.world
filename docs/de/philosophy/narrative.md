# Erzählung & Horizont

## Die Form des Problems

Wir bauen weder einen Chatbot mit angeflanschtem Bedienpult noch ein
Steuerungssystem mit angeflanschtem Sprachmodell. Die beiden Hälften müssen
ein System sein, denn in dem Moment, in dem ein Modell physische Anlagen
bewegen kann, wird jedes Nice-to-have eines Chat-Produkts zur Randbedingung
eines Steuerungssystems: deterministisches Verhalten, begrenzte Latenz, ein
Prüfprotokoll und eine Möglichkeit, Nein zu sagen.

Das vollständige Argument steht unter [Warum celestia-island](./why.md). Diese
Seite ist der Verlauf, der daraus folgt.

## Wohin es geht

**Näher an die Maschine.** Heute läuft der Regelkreis von Webbrowser eines
Bedienern über einen Protokoll-Broker bis zu einem Controller. Jeder Schritt
näher an der Hardware enthält weniger Modell und weniger Netzwerk und endet bei
einem Regelkreis, der lokal läuft und nicht auf eine Rundstrecke wartet. Diese
Reihenfolge ist der Punkt: Die Teile, die nicht ausfallen dürfen, sind die
Teile, die nie hinausrufen.

**Lokale Autonomie als Ausblick.** Dieselbe Reihenfolge verallgemeinert sich
überall dort, wo eine Rundstrecke teuer ist — ein abgelegener Standort, eine
unbeständige Verbindung, ein Werk, dessen Bediener nicht in der Halle ist.
Maschinen, die nicht auf einen Menschen warten können, müssen lokal, sicher und
vorhersehbar entscheiden: mit der Befugnis zu handeln und der Disziplin,
abzulehnen. Das ist eine langfristige Richtung, kein datierter Plan, und der
Grund, warum die Entscheidungsebene, das Weltmodell und die Sicherheitssperre
als getrennte Dinge gebaut werden statt als ein Monolith.

**Wiederverwendbar durch Konstruktion.** Wie auch immer die nächste
Bereitstellung aussieht: Sie sollte aus der gleichen Asset-Basis zusammengesetzt
werden statt neu gebaut — das Wire-Protokoll, der Weltzustand, die
Sicherheitssperren und die Aufzeichnungspipeline sind gemeinsame Assets. Alles,
was ein neues startet, muss eine Architekturprüfung durchlaufen. Und
keine Produktlinie hängt je von einem nicht veröffentlichten Kern ab — rutscht
der Kern, rutscht nicht der Umsatz.

## Was fest bleibt

Wie der Horizont auch aussieht, drei Dinge bewegen sich nicht:

- **Sicherheit vor Autonomie.** Ein autonomes System, das nicht ablehnen kann,
  ist nicht autonom, sondern unbewacht. Siehe
  [Sicherheitsprinzipien](./safety.md).
- **Der Regelkreis bleibt ganz.** Jede Fähigkeit ist nur so real wie der
  geschlossene Regelkreis, zu dem sie gehört — siehe
  [Der Geschlossene Regelkreis](./closed-loop.md).
- **Struktur kommt zuerst.** Ordnung über Dutzende von Repositories kommt aus
  Schichtung, nicht aus Disziplin im Moment — siehe
  [Geschichtete Architektur](./layered-architecture.md).

## Weiterführendes

- [Warum celestia-island](./why.md) — die Problemstellung hinter dem Horizont.
- [Sicherheitsprinzipien](./safety.md) — die Echtzeit-Semantik, auf der die Erzählung aufbaut.
- [Projektübersicht](../ecosystem/projects.md) — wo die Arbeit heute lebt.
