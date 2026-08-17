# Evernight — Broker de protocolos industriales

Evernight es el borde industrial: un broker multiplataforma que habla los
protocolos de campo (Modbus, S7comm, MC Protocol, EtherNet/IP, EtherCAT,
CAN, OPC UA, MQTT, …), sondea sensores, evalúa alarmas y empuja eventos
hacia la pila de celestia-island. También gestiona servidores de modelos
en el nodo (ollama / whisper / vLLM) para la inferencia en el borde.

## Arquitectura de un vistazo

```text
Campo: PLC / MCU / sensores (Modbus, S7comm, MC, EtherCAT, CAN, OPC UA, …)
        ▼
   evernight (nodo de borde)
   ├─ Adaptadores de protocolo: sondear → decodificar → lecturas tipadas
   ├─ Motor de alarmas: reglas de umbral → eventos de disparo
   ├─ Series temporales: lecturas en búfer con doble marca de tiempo
   ├─ Grabación/reproducción: búfer circular → almacenamiento segmentado → inyección de reproducción
   ├─ Gestor de servidores de modelos: desplegar ollama/whisper/vLLM (GPU primero)
   └─ Northbound: disparadores JSON-RPC por socket Unix → entelecheia
        │
        ▼
   scepter (agentes, flujos de trabajo industriales, aprobación de escritura)
```

## 1. Protocolos de campo

Los adaptadores convierten la lectura/escritura nativa de cada protocolo
en lecturas y comandos tipados. La ruta de escritura está bajo compuerta:
las escrituras industriales requieren validación de políticas y
aprobación humana en la plataforma (OreXis + flujos de aprobación).

## 2. Detección y alarmas

- Bucles de sondeo por estación con periodos configurables; los fallos
  afloran como eventos de salud.
- El motor de alarmas evalúa reglas de umbral sobre las lecturas y emite
  eventos enrutados por tema al sumidero de disparadores northbound.

## 3. Tiempo y grabación

Las lecturas llevan marcas de tiempo duales (reloj de pared para
visualización/auditoría, monótono para ordenación/fusión). Una
canalización de grabación/reproducción mantiene un búfer circular,
persiste segmentos y puede inyectar datos reproducidos de nuevo en la
canalización de disparadores — el prerrequisito compartido para las capas
de estado del mundo y de aprendizaje.

## 4. Servicio de modelos en el borde

`model_server` gestiona los runtimes de modelos en el nodo: despliegue de
modelos en contenedores (ollama, whisper.cpp, vLLM) con preferencia de
GPU y respaldo de CPU — el bloque de construcción para la inferencia
reactiva en el borde que nunca depende de un LLM en línea.

## 5. Integración northbound

Los eventos fluyen hacia el scepter de entelecheia a través de un
sumidero de disparadores JSON-RPC por socket Unix (enrutado por tema); la
pasarela dispositivo↔nube registra la identidad del nodo y la telemetría.
Todo lo físico se enruta a través de evernight.

## Referencia de variables de entorno (subconjunto)

| Variable | Propósito |
|---|---|
| `EVERNIGHT_SOCK` | Socket Unix para disparadores/telemetría hacia scepter |
| `EVERNIGHT_*` | Configuración de conexión por protocolo |
| env de contenedor/GPU | Despliegue del servidor de modelos (runtimes ollama/vLLM) |
