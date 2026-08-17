# Evernight — 工业协议 Broker

Evernight 是工业边缘：一个跨平台 broker，会说现场协议（Modbus、S7comm、MC Protocol、EtherNet/IP、EtherCAT、CAN、OPC UA、MQTT 等），轮询传感器、评估告警，并把事件推入 celestia-island 栈。它还管理节点上的模型服务器（ollama / whisper / vLLM）用于边缘推理。

## 架构一览

```text
现场：PLC / MCU / 传感器（Modbus、S7comm、MC、EtherCAT、CAN、OPC UA、…）
        ▼
   evernight（边缘节点）
   ├─ 协议适配器：轮询 → 解码 → 类型化读数
   ├─ 告警引擎：阈值规则 → 触发事件
   ├─ 时序：双时间戳缓冲读数
   ├─ 录制/回放：环形缓冲 → 分段落盘 → 回放注入
   ├─ 模型服务器管理：部署 ollama/whisper/vLLM（GPU 优先）
   └─ 北向：Unix socket JSON-RPC 触发 → entelecheia
        │
        ▼
   scepter（agent、工业工作流、写入审批）
```

## 1. 现场协议

适配器把各协议的读写转换为类型化读数与命令。写路径有门控：工业写入需要
平台侧的策略校验与人工审批（OreXis + 审批流）。

## 2. 感知与告警

- 每站独立轮询循环、周期可配；失败以上报健康事件呈现。
- 告警引擎对读数评估阈值规则，向触发 sink 发出带 topic 路由的事件。

## 3. 时间与录制

读数携带双时间戳（墙钟用于显示/审计，单调用于排序/融合）。录制/回放管线
维护环形缓冲、分段落盘，可把回放数据重新注入触发管线——是世界状态与
学习层的共同前提。

## 4. 边缘模型服务

`model_server` 管理节点上的模型运行时：容器化部署模型（ollama、whisper.cpp、
vLLM），GPU 优先、CPU 回退——是"反应式边缘推理永远不依赖在线 LLM"的构件。

## 5. 北向集成

事件经 Unix-socket JSON-RPC 触发 sink（topic 路由）流入 entelecheia 的
scepter；设备↔云网关注册节点身份与遥测。一切物理 I/O 都经过 evernight。

## 环境变量参考（节选）

| 变量 | 用途 |
|---|---|
| `EVERNIGHT_SOCK` | 到 scepter 的触发/遥测 Unix socket |
| `EVERNIGHT_*` | 各协议连接配置 |
| 容器/GPU 环境 | 模型服务器部署（ollama/vLLM 运行时） |
