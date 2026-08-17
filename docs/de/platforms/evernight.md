# Evernight — Industrieller Protokoll-Broker

Evernight ist die industrielle Edge: ein plattformübergreifender Broker, der
die Feldprotokolle spricht (Modbus, S7comm, MC Protocol, EtherNet/IP,
EtherCAT, CAN, OPC UA, MQTT, …), Sensoren abfragt, Alarme auswertet und
Ereignisse in den celestia-island-Stack pusht. Er verwaltet außerdem
Modell-Server auf dem Knoten (ollama / whisper / vLLM) für die Edge-Inferenz.

## Architektur auf einen Blick

```text
Feld: PLC / MCU / Sensoren (Modbus, S7comm, MC, EtherCAT, CAN, OPC UA, …)
        ▼
   evernight (Edge-Knoten)
   ├─ Protokoll-Adapter: pollen → dekodieren → typisierte Messwerte
   ├─ Alarm-Engine: Schwellwertregeln → Trigger-Ereignisse
   ├─ Zeitreihen: gepufferte Messwerte mit doppelten Zeitstempeln
   ├─ Record/Replay: Ringpuffer → segmentierte Speicherung → Replay-Injektion
   ├─ Modell-Server-Manager: ollama/whisper/vLLM bereitstellen (GPU zuerst)
   └─ Northbound: Unix-Socket-JSON-RPC-Trigger → entelecheia
        │
        ▼
   scepter (Agenten, industrielle Workflows, Schreib-Freigabe)
```

## 1. Feldprotokolle

Adapter wandeln das native Lesen/Schreiben jedes Protokolls in typisierte
Messwerte und Kommandos um. Der Schreibpfad ist gesichert: Industrielle
Schreiboperationen verlangen eine Richtlinienprüfung und menschliche Freigabe
in der Plattform (OreXis + Freigabe-Flows).

## 2. Erfassung und Alarme

- Abfrageschleifen pro Station mit konfigurierbaren Perioden; Fehler
  erscheinen als Health-Ereignisse.
- Die Alarm-Engine wertet Schwellwertregeln über die Messwerte aus und
  emittiert topic-geroutete Ereignisse an die Northbound-Trigger-Senke.

## 3. Zeit und Aufzeichnung

Messwerte tragen doppelte Zeitstempel (Wallclock für Anzeige/Audit, monoton
für Ordnung/Fusion). Eine Record-/Replay-Pipeline hält einen Ringpuffer,
persistiert Segmente und kann wiedergegebene Daten zurück in die
Trigger-Pipeline injizieren — die gemeinsame Voraussetzung für die
Weltzustands- und Lernschichten.

## 4. Edge-Modell-Serving

`model_server` verwaltet die Modell-Runtimes auf dem Knoten:
Modellbereitstellung in Containern (ollama, whisper.cpp, vLLM) mit
GPU-zuerst-/CPU-Fallback-Platzierung — der Baustein für reaktive Edge-Inferenz,
die nie von einem online verfügbaren LLM abhängt.

## 5. Northbound-Integration

Ereignisse fließen über eine Unix-Socket-JSON-RPC-Trigger-Senke
(topic-geroutet) zu entelecheias scepter; das Gerät↔Cloud-Gateway registriert
Knotenidentität und Telemetrie. Alles Physische wird über evernight geroutet.

## Env-Referenz (Auszug)

| Variable | Zweck |
|---|---|
| `EVERNIGHT_SOCK` | Unix-Socket für Trigger/Telemetrie zu scepter |
| `EVERNIGHT_*` | Verbindungskonfiguration je Protokoll |
| container/GPU env | Modell-Server-Bereitstellung (ollama/vLLM-Runtimes) |
