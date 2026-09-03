# Mitwirken bei Celestia Island

Vielen Dank für Ihr Interesse an einem Beitrag! Celestia Island ist eine Familie von Projekten, die die gesamte Plattform umspannen — kirino (Authentifizierung), plana (Plattform), hikari (UI), die Dienste-Schicht sowie die WebUIs und Websites rundherum. Dieser Leitfaden beschreibt die Beitragspolitik, die für die gesamte Projektgruppe gilt; Bau- und Entwicklungsanleitungen für ein einzelnes Projekt finden Sie in dessen eigenem Repository und auf dessen Dokumentationsseite.

## Beitragspolitik (zuerst lesen)

Die Gruppe ist als Schichten gemischter Kritikalität aufgebaut — Schicht 0 (kirino, Authentifizierung), Schicht 1 (plana, Plattform), Schicht 2 (hikari, UI) und die Dienste der Schicht 3 darüber — daher wiegen **Korrektheit, Abwärtskompatibilität und Stabilität schwerer als der Beitragsdurchsatz**. Bitte lesen Sie diesen Abschnitt, bevor Sie einen Pull Request öffnen.

- **Hohe Merge-Hürde, keine öffentliche Roadmap.** Das Öffnen eines Pull Requests impliziert nicht, dass er zusammengeführt wird. Wir nehmen bewusst nur eine kleine Zahl von Änderungen an — und auch nur dann, wenn sie zur Architektur passen und die Review bestehen. Das ist Absicht, keine Unhöflichkeit.
- **Was wir willkommen heißen:** Fehlerberichte, fokussierte Fixes, additive (nicht brechende) Features und Protokollfelder, verbesserte Dokumentation sowie Design-Diskussionen vor dem Code.
- **Was wir in der Regel nicht zusammenführen:** große unaufgeforderte Neuschreibungen, brechende Änderungen an gemeinsamen Verträgen und Protokollflächen (zum Beispiel die JSON-RPC-2.0-Protokolltypen, die in der gesamten Entelecheia-Plattform geteilt werden), architektonische Änderungen ohne vorherige Design-Diskussion, massenhafte „vibe-coded“ Pull Requests sowie alles, was die Kompatibilitäts-, Zuverlässigkeits- oder Sicherheitsanforderungen einer niedrigeren Schicht senkt.
- **Kern versus Peripherie.** Der Zero-Trust-Authentifizierungskern, die gemeinsamen Plattformtypen und die gemeinsame UI-Komponentenbibliothek unterliegen dem strengsten Maßstab und werden vom Kernteam gepflegt; vorgeschlagene Änderungen dort sollten als Design-Diskussion beginnen.
- **CLA erforderlich.** Jeder angenommene Beitrag erfordert eine unterzeichnete CLA (Contributor License Agreement). Siehe [`CLA.md`](cla.md). Commits müssen eine `Signed-off-by`-Zeile tragen (`git commit -s`).

> **Die Lizenz mag sich öffnen; die Merge-Hürde tut es nicht.** Am **2030-01-01** gehen die Projekte der Gruppe von BUSL-1.1 zu der in der [`LICENSE`](../../../LICENSE) jedes Repositorys genannten Change License über — heute SySL-1.0 für die meisten Projekte. Das erweitert, *was Sie mit dem Code tun dürfen*; es senkt **nicht** die Review-Hürde, schafft die CLA nicht ab und bedeutet nicht, dass wir mehr Pull Requests annehmen. Die Beitragspolitik bleibt vor und nach dem Änderungsdatum unverändert.

## Sicherheit

Öffnen Sie **keine** öffentlichen Issues für Sicherheitslücken. Melden Sie sie privat über GitHub Security Advisories im betroffenen Repository oder per E-Mail an <security@celestia.world>. Siehe [`SECURITY.md`](security.md).

## Verhaltenskodex

Behandeln Sie einander respektvoll, konstruktiv und inklusiv. Wir folgen dem [Contributor Covenant Code of Conduct](code-of-conduct.md).

## Erste Schritte

Wählen Sie das Repository aus, an dem Sie arbeiten möchten, und folgen Sie dessen README und Dokumentationsseite. Rust-Projekte verifizieren mit `cargo fmt`, `cargo clippy -D warnings` und `cargo test`; Web-Projekte mit `pnpm lint`, `pnpm build` und `pnpm test`. Die [Ökosystemkarte](../ecosystem/sites.md) listet jedes Projekt auf und zeigt, wo seine Dokumentation zu finden ist.

## Pull-Request-Prozess

1. Forken Sie das Repository und verzweigen Sie von dessen Standard-Branch.
1. Diskutieren Sie große Änderungen oder solche an gemeinsamen Verträgen zuerst in einem Issue.
1. Erstellen Sie atomare Commits: Jede Betreffzeile besteht aus einem einzelnen Gitmoji, gefolgt von einem englischen Satz, der großgeschrieben beginnt und mit einem Punkt endet; Details gehören in den Commit-Body.
1. Stellen Sie sicher, dass die Checks des Projekts bestehen, bevor Sie pushen.
1. Unterschreiben Sie die CLA und fügen Sie jedem Commit eine `Signed-off-by`-Zeile hinzu.
1. Arbeiten Sie Review-Feedback ein; beschränken Sie Force-Pushes auf Rebases.

## Lizenz & CLA

Die Projekte dieser Gruppe sind unter der **Business Source License 1.1 (BUSL-1.1)** mit einem **Änderungsdatum (Change Date) vom 2030-01-01** lizenziert, zu dem jedes in die in seiner LICENSE genannte Change License übergeht — heute **SySL-1.0** für die meisten Projekte. Für interne, akademische, staatliche, bildungsbezogene und nicht-kommerzielle Nutzung sind sie heute bereits gleichwertig zu Apache-2.0 oder MIT (siehe den Additional Use Grant in der [`LICENSE`](../../../LICENSE) jedes Repositorys). Eingeschränkte kommerzielle Nutzungen (Hosting, Weiterverkauf oder Rebranding als Dienst) erfordern bis zum Änderungsdatum eine separate kommerzielle Lizenz.

Mit Ihrem Beitrag stimmen Sie zu, dass Ihre Beiträge unter der Lizenz des Projekts lizenziert werden und dass Sie die CLA unterzeichnen ([`CLA.md`](cla.md)). Die CLA räumt dem Projekt eine permissive Lizenz **einschließlich des Rechts zur erneuten Lizenzierung** ein, damit die Projekte ihren geplanten Lizenzierungspfad beibehalten und ihre Lizenzierung in Zukunft anpassen können.

## Weiterführendes

- [CLA](cla.md) — das Contributor License Agreement (CLA), das Sie unterzeichnen.
- [Sicherheitsrichtlinie](security.md) — wie Sie Schwachstellen privat melden.
- [Verhaltenskodex](code-of-conduct.md) — der Umgang, den wir voneinander erwarten.
- [Ökosystemkarte](../ecosystem/sites.md) — jedes Projekt, jede Website und wo ihre Dokumentation zu finden ist.
