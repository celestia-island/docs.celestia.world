# Evernight — Broker de Protocolos Industriais

O Evernight é a borda industrial: um broker multiplataforma que fala os
protocolos de campo (Modbus, S7comm, MC Protocol, EtherNet/IP, EtherCAT,
CAN, OPC UA, MQTT, …), faz polling de sensores, avalia alarmes e faz push de
eventos para a stack celestia-island. Ele também gerencia servidores de
modelo no nó (ollama / whisper / vLLM) para inferência na borda.

## Arquitetura num relance

```text
Campo: PLC / MCU / sensores (Modbus, S7comm, MC, EtherCAT, CAN, OPC UA, …)
        ▼
   evernight (nó de borda)
   ├─ Adaptadores de protocolo: polling → decodificação → leituras tipadas
   ├─ Motor de alarmes: regras de limiar → eventos de gatilho
   ├─ Séries temporais: leituras em buffer com timestamps duplos
   ├─ Gravação/replay: ring buffer → armazenamento segmentado → injeção de replay
   ├─ Gerenciador de servidores de modelo: implanta ollama/whisper/vLLM (GPU primeiro)
   └─ Northbound: gatilhos JSON-RPC por Unix-socket → entelecheia
        │
        ▼
   scepter (agentes, fluxos de trabalho industriais, aprovação de escrita)
```

## 1. Protocolos de campo

Adaptadores convertem a leitura/escrita nativa de cada protocolo em leituras
e comandos tipados. O caminho de escrita é protegido por portões: escritas
industriais exigem validação de política e aprovação humana na plataforma
(OreXis + fluxos de aprovação).

## 2. Sensoriamento e alarmes

- Laços de polling por estação com períodos configuráveis; falhas aparecem
  como eventos de saúde.
- O motor de alarmes avalia regras de limiar sobre as leituras e emite
  eventos roteados por tópico para o coletor de gatilhos northbound.

## 3. Tempo e gravação

Leituras carregam timestamps duplos (relógio de parede para
exibição/auditoria, monótono para ordenação/fusão). Um pipeline de
gravação/replay mantém um ring buffer, persiste segmentos e pode injetar
dados reproduzidos de volta no pipeline de gatilhos — o pré-requisito
compartilhado para as camadas de estado do mundo e de aprendizado.

## 4. Servir modelos na borda

O `model_server` gerencia runtimes de modelo no nó: implantação de modelos
em contêineres (ollama, whisper.cpp, vLLM) com alocação GPU primeiro, CPU
como fallback — o bloco de construção para inferência reativa na borda que
nunca depende de um LLM online.

## 5. Integração northbound

Eventos fluem para o scepter do entelecheia via um coletor de gatilhos
JSON-RPC por Unix-socket (roteado por tópico); o gateway
dispositivo↔nuvem registra identidade e telemetria do nó. Tudo o que é
físico passa pelo evernight.

## Referência de env (subconjunto)

| Variável | Finalidade |
|---|---|
| `EVERNIGHT_SOCK` | Socket Unix para gatilhos/telemetria para o scepter |
| `EVERNIGHT_*` | Configuração de conexão por protocolo |
| env de contêiner/GPU | Implantação de servidores de modelo (runtimes ollama/vLLM) |
