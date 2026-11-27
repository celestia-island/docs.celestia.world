# Leitfaden zur geschlossenen Beta

Die **interne geschlossene Beta** deckt den gesamten Produkt-Regelkreis ab, von
der Kontoregistrierung bis zur industriellen Steuerung. Die Teilnahme erfolgt
nur auf Einladung.

## Was die Beta abdeckt

1. **Ein Konto registrieren und einen API key erstellen** im Arona
   Cloud-API-Admin-Panel. Das Panel bleibt während der Beta intern.
2. **Ein Modell bereitstellen** und es über das Panel an ein Chat-Backend
   binden.
3. **Chatten und Agenten ausführen** über die shittim-chest Desktop-App; die
   Agenten-Orchestrierung übernimmt die Agenten-Plattform dahinter.
4. **Industrielle Steuerung**: Fernoperation und Protokoll-Vermittlung laufen
   über evernight.

## Zugang erhalten

- Der Zugang ist **einladungsbasiert**. Öffentliche Selbstregistrierung ist
  standardmäßig geschlossen.
- Einladungen werden von den Maintainern ausgestellt und an ein einzelnes
  Konto gebunden.
- Bei Zugangsfragen wenden Sie sich über die Kanäle in
  [Mitwirken](../meta/CONTRIBUTING.md) an uns.

## Bugs melden

Melden Sie Probleme auf GitHub, ein Issue pro Bug, mit den Issue-Vorlagen. Der
Bugtracker für jedes Produkt ist das Repository des Produkts; wenn Sie keinen
Zugang zu einem Repository haben, senden Sie den Bericht stattdessen über die
Kanäle in [Mitwirken](../meta/CONTRIBUTING.md).

Geben Sie immer an: Umgebungsinformationen (OS, Produktversionen), Schritte zur
Reproduktion, erwartetes vs. tatsächliches Verhalten sowie relevante Logs.

## Bekannte Einschränkungen

- Das Arona-Panel ist **nur intern** und während der Beta nicht öffentlich
  erreichbar.
- Die Registrierung ist standardmäßig geschlossen; offene Registrierung ist
  noch nicht verfügbar.
- Live-Gerätetelemetrie braucht eine laufende Agenten-Plattform; ohne sie fällt
  die UI auf simulierte Demo-Daten zurück.
- Mobile Apps und IDE-Plugins sind nicht Teil dieser Beta.
- Einige Dokumentationssprachen sind Teilübersetzungen.

## Weiterführendes

- [Schnellstart](./quickstart.md) — der 30-Minuten-Weg durch den Regelkreis.
- [Warum celestia-island](../philosophy/why.md) — die Philosophie hinter der Beta.
