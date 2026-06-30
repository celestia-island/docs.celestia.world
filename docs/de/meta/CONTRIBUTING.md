# Mitwirken bei Arona
> Dies ist eine gemeinschaftliche Referenzübersetzung. Bei Unstimmigkeiten ist die englische Originaldatei [`CONTRIBUTING.md`](../../en/meta/CONTRIBUTING.md) im Stammverzeichnis des Repositorys maßgeblich.

Vielen Dank für Ihr Interesse an der Mitarbeit! Dieser Leitfaden deckt alles ab, was Sie für den Einstieg benötigen.

## Beitragsrichtlinie (zuerst lesen)

Arona definiert die gemeinsamen JSON-RPC 2.0-Protokolltypen, die auf der gesamten Entelecheia-Plattform verwendet werden. Daher wiegen **Korrektheit, Abwärtskompatibilität und Stabilität schwerer als der Beitragsdurchsatz**. Bitte lesen Sie dies, bevor Sie einen Pull Request eröffnen.

- **Hohe Merge-Hürde, keine öffentliche Roadmap.** Das Eröffnen eines PR bedeutet nicht, dass er zusammengeführt wird. Wir akzeptieren bewusst nur eine geringe Anzahl von Änderungen, und nur dann, wenn sie zur Architektur passen und das Review bestehen. Das ist beabsichtigt, nicht unhöflich.

- **Was wir begrüßen:** Fehlerberichte, gezielte Korrekturen, additive (nicht-breaking) Protokollfelder, verbesserte Dokumentation und vorherige Design-Diskussionen vor dem Code.

- **Was wir im Allgemeinen nicht mergen:** große unaufgeforderte Umschreibungen, Breaking Changes der Protokolltyp-Oberfläche, Architekturänderungen ohne vorherige Design-Diskussion, massenhafte „Vibe-Coded"-PRs und alles, was die Kompatibilitätsbarriere des Typvertrags senkt.

- **Kern vs. Peripherie.** Die Protokolltyp-Definitionen und ihre Serialisierungsschnittstelle unterliegen der strengsten Prüfung und werden vom Kernteam gewartet.

- **CLA erforderlich.** Jeder akzeptierte Beitrag erfordert eine unterzeichnete Contributor License Agreement. Siehe [`CLA.md`](cla.md). Commits müssen eine `Signed-off-by`-Zeile enthalten (`git commit -s`).

> **Die Lizenz mag sich öffnen; die Merge-Hürde nicht.** Am **2030-01-01** wechselt dieses Projekt von BUSL-1.1 zu Apache-2.0 oder MIT (nach Wahl des Empfängers) — siehe [`LICENSE`](../../../LICENSE). Das erweitert, *was Sie mit dem Code tun dürfen*; es senkt **nicht** die Review-Hürde, entfernt nicht die CLA und bedeutet nicht, dass wir mehr PRs akzeptieren. Die Beitragsrichtlinie bleibt vor und nach dem Änderungsdatum unverändert.

## Sicherheit

Eröffnen Sie **keine** öffentlichen Issues für Sicherheitslücken. Melden Sie diese vertraulich über [GitHub Security Advisories](https://github.com/celestia-island/arona/security/advisories/new). Siehe [`SECURITY.md`](security.md).

## Verhaltenskodex

Seien Sie respektvoll, konstruktiv und inklusiv. Wir befolgen den [Contributor Covenant Verhaltenskodex](code-of-conduct.md).

## Entwicklung

Arona ist eine kleine Rust-Crate. Schnellstart:

```bash
git clone https://github.com/celestia-island/arona.git
cd arona
cargo build
cargo test
cargo clippy -- -D warnings
```

- Rust 1.85+.
- Typen leiten `ts-rs` ab (`#[derive(TS)]`), um TypeScript-Bindings zu generieren — halten Sie `serde`-Attribute und `ts-rs`-Annotationen konsistent.

- Führen Sie keine Breaking Changes an bestehenden Protokolltypen ein; bevorzugen Sie additive Felder mit `#[serde(default)]`.

## Pull-Request-Prozess

1. Forken und von `main` abzweigen.
2. Diskutieren Sie große oder protokollrelevante Änderungen zuerst in einem Issue.
3. Erstellen Sie atomare Commits gemäß [Conventional Commits](https://www.conventionalcommits.org/).
4. Stellen Sie sicher, dass `cargo fmt`, `cargo clippy -D warnings` und `cargo test` erfolgreich sind.
5. Unterzeichnen Sie die CLA und fügen Sie jedem Commit `Signed-off-by` hinzu.
6. Berücksichtigen Sie Review-Feedback; beschränken Sie Force-Pushes auf Rebase-Vorgänge.

## Lizenz & CLA

Arona ist unter der **Business Source License 1.1 (BUSL-1.1)** mit einem **Änderungsdatum vom 2030-01-01** lizenziert, an dem es nach Wahl des Empfängers in **Apache-2.0 oder MIT** übergeht. Für alle interne, akademische, staatliche, bildungsspezifische und nicht-kommerzielle Nutzung ist es bereits heute gleichwertig mit Apache-2.0 oder MIT (siehe Additional Use Grant in [`LICENSE`](../../../LICENSE)). Eingeschränkte kommerzielle Nutzungen (Hosting, Weiterverkauf oder Rebranding als Dienst) erfordern bis zum Änderungsdatum eine separate kommerzielle Lizenz.

Durch Ihre Mitwirkung erklären Sie sich damit einverstanden, dass Ihre Beiträge unter der Projektlizenz lizenziert werden und dass Sie die CLA unterzeichnen ([`CLA.md`](cla.md)). Die CLA gewährt dem Projekt eine freizügige Lizenz **einschließlich des Rechts zur Relizenzierung**, damit das Projekt seinen BUSL→Apache/MIT-Pfad beibehalten und seine Lizenzierung in Zukunft anpassen kann.
