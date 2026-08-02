# Willkommen bei celestia-island

**celestia-island** ist eine Suite von Projekten für industrielle KI-Steuerung:
Multi-Agenten-Kollaboration, Fernoperation und sicherheitskritische
Automatisierung. Diese Seite ist ihr *Warum* — die Philosophie, die
Ökosystem-Karte und der Einstiegspunkt. Das *Wie* lebt in den projekteigenen
Dokumentationsseiten, die von hier aus verlinkt sind.

## Drei Fragen, drei Antworten

| Frage | Wo | Was Sie finden |
| --- | --- | --- |
| **Warum gibt es das?** | [Philosophie](./philosophy/why.md) | Das Problem, das wir lösen, der geschlossene Regelkreis, die Sicherheitsdoktrin und der langfristige Horizont |
| **Was steckt dahinter?** | [Ökosystem](./ecosystem/projects.md) | Jedes Projekt, seine Rolle im Regelkreis und wo seine Dokumentation liegt |
| **Wie fange ich an?** | [Erste Schritte](./getting-started/quickstart.md) | Der 30-Minuten-Weg vom Konto bis zu einem funktionierenden Chat-Agenten und industrieller Steuerung |

## Die Kurzfassung in einem Absatz

celestia-island baut den **geschlossenen Regelkreis** von der Entdeckung bis
zur Verifikation für KI-gesteuerte industrielle Steuerung: entdecken →
installieren → authentifizieren → Modell bereitstellen → chatten und Agenten
ausführen → Industrieanlagen steuern → alles verifizieren. Der Regelkreis wird
aus kleinen, streng geschichteten Bausteinen zusammengesetzt:
Authentifizierungs-Primitive ([kirino](https://github.com/celestia-island/kirino)),
Plattform-Grundlagen ([plana](https://github.com/celestia-island/plana)),
UI-Komponenten ([hikari](https://github.com/celestia-island/hikari)) und
Dienste, die nur Geschäftslogik implementieren
([arona](https://github.com/celestia-island/arona),
[shittim-chest](https://github.com/celestia-island/shittim-chest),
[entelecheia](https://github.com/celestia-island/entelecheia),
[evernight](https://github.com/celestia-island/evernight)). Nichts wird je
doppelt implementiert: generische Fähigkeiten werden einmalig upstream gebaut
und von jedem Dienst downstream konsumiert.

Der Grund dafür ist eine einfache Beobachtung: Auf dem Mond dauert eine
Signal-Rundstrecke 2,6 Sekunden, auf dem Mars 6 bis 44 Minuten. Roboter dort
können nicht auf einen Menschen auf der Erde warten — sie müssen lokal autonom
sein. Die Entscheidungsebene, das Weltmodell und die Sicherheitssperren, die
wir heute für die industrielle Steuerung bauen, haben dieselbe Form, die
Autonomie morgen brauchen wird.

## Wo alles liegt

- **Projekteigene Dokumentation** — `<name>.docs.celestia.world`, aus jedem
  Repository erstellt. Die vollständige Liste finden Sie unter
  [Sites & Verantwortlichkeiten](./ecosystem/sites.md).
- **Präsenz der Organisation** — [celestia-island auf GitHub](https://github.com/celestia-island).
- **Produkt-Panels (WIP während der Beta)** — [arona](https://arona.celestia.world)
  (Cloud-API-Admin), [dev](https://dev.celestia.world) (Entwicklerportal); das
  Live-Panel läuft bis zum Ende der Beta intern unter `arona:8420`.

Verwenden Sie den Sprachumschalter (unten rechts), um diese Seite in einer
anderen Sprache zu lesen. Die Inhalte werden auf Englisch verfasst;
Übersetzungen folgen derselben Struktur.
