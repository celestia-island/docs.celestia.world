# Leitfaden zur geschlossenen Beta

Die **interne geschlossene Beta** deckt den gesamten Produkt-Regelkreis ab, von
der Kontoregistrierung bis zur industriellen Steuerung. Die Teilnahme erfolgt
nur auf Einladung.

## Was die Beta abdeckt

1. **Ein Konto registrieren und einen API key erstellen** im
   [Arona](https://github.com/celestia-island/arona) Cloud-API-Admin-Panel.
   Das Panel ist während der Beta nur intern erreichbar (`arona:8420` auf dem
   Bereitstellungs-Host).
2. **Ein Modell bereitstellen** und es über das Panel an ein Chat-Backend
   binden.
3. **Chatten und Agenten ausführen** über die
   [shittim-chest](https://github.com/celestia-island/shittim-chest)
   Desktop-App; die Agenten-Orchestrierung übernimmt entelecheias **scepter**-
   Runtime.
4. **Industrielle Steuerung**: Fernoperation und Protokoll-Vermittlung laufen
   über [evernight](https://github.com/celestia-island/evernight).

## Zugang erhalten

- Der Zugang ist **einladungsbasiert**. Öffentliche Selbstregistrierung ist
  standardmäßig geschlossen.
- Einladungen werden von den Maintainern ausgestellt und an ein einzelnes
  Konto gebunden.
- Bei Zugangsfragen wenden Sie sich über die Kanäle in
  [Mitwirken](../meta/CONTRIBUTING.md) an uns.

## Bugs melden

Melden Sie Probleme auf GitHub, ein Issue pro Bug, mit den Issue-Vorlagen:

| Produkt | Repository |
| --- | --- |
| Chat-Desktop/Web — shittim-chest | [celestia-island/shittim-chest](https://github.com/celestia-island/shittim-chest/issues) |
| Agenten-Orchestrierung — entelecheia/scepter | [celestia-island/entelecheia](https://github.com/celestia-island/entelecheia/issues) |
| Industrielle Steuerung — evernight | [celestia-island/evernight](https://github.com/celestia-island/evernight/issues) |
| Admin-Panel & Plattform — arona/plana | [celestia-island/arona](https://github.com/celestia-island/arona/issues) |

Geben Sie immer an: Umgebungsinformationen (OS, Produktversionen), Schritte zur
Reproduktion, erwartetes vs. tatsächliches Verhalten sowie relevante Logs.

## Bekannte Einschränkungen

- Das Arona-Panel ist **nur intern** und während der Beta nicht öffentlich
  erreichbar.
- Die Registrierung ist standardmäßig geschlossen; offene Registrierung ist
  noch nicht verfügbar.
- WebRTC-Geräte-Relay und Live-SCADA-Telemetrie erfordern eine laufende
  scepter-Instanz; ohne sie fällt die UI auf simulierte Demo-Daten zurück.
- Mobile Apps und IDE-Plugins sind nicht Teil dieser Beta.
- Einige Dokumentationssprachen sind Teilübersetzungen.

## Weiterführendes

- [Schnellstart](./quickstart.md) — der 30-Minuten-Weg durch den Regelkreis.
- [Warum celestia-island](../philosophy/why.md) — die Philosophie hinter der Beta.
