# Evernight — وسيط البروتوكولات الصناعية

Evernight هو الحافة الصناعية: وسيط متعدد المنصات يتحدّث بروتوكولات الميدان
(Modbus وS7comm وMC Protocol وEtherNet/IP وEtherCAT وCAN وOPC UA وMQTT
و…)، ويستقصي المستشعرات، ويقيّم الإنذارات، ويدفع الأحداث إلى منظومة
celestia-island. كما يدير خوادم النماذج على العقدة (ollama / whisper /
vLLM) للاستدلال على الحافة.

## البنية في لمحة

```text
Field: PLC / MCU / sensors (Modbus, S7comm, MC, EtherCAT, CAN, OPC UA, …)
        ▼
   evernight (edge node)
   ├─ Protocol adapters: poll → decode → typed readings
   ├─ Alarm engine: threshold rules → trigger events
   ├─ Time series: buffered readings with double timestamps
   ├─ Record/replay: ring buffer → segmented storage → replay injection
   ├─ Model server manager: deploy ollama/whisper/vLLM (GPU-first)
   └─ Northbound: Unix-socket JSON-RPC triggers → entelecheia
        │
        ▼
   scepter (agents, industrial workflows, write approval)
```

## 1. بروتوكولات الميدان

تحوّل المحوّلات قراءة/كتابة كل بروتوكول الأصلية إلى قراءات وأوامر
مُنمّطة. طريق الكتابة محروس: تتطلب عمليات الكتابة الصناعية تحققًا من
السياسات وموافقة بشرية في المنصة (OreXis + تدفقات الموافقة).

## 2. الاستشعار والإنذارات

- حلقات استقصاء لكل محطة بفترات قابلة للضبط؛ وتظهر الأعطال أحداثَ صحة.
- يقيّم محرك الإنذارات قواعد العتبات على القراءات ويُصدر أحداثًا موجّهةً
  بالموضوع إلى مصرف المحفزات المتجه صعودًا (northbound).

## 3. الزمن والتسجيل

تحمل القراءات طابعي زمن مزدوجين (ساعة الحائط للعرض/التدقيق، والزمن الرتيب
المتزايد للترتيب/الدمج). يحافظ خط أنابيب التسجيل/إعادة التشغيل على مخزن
حلقي، ويحفظ المقاطع، ويستطيع حقن البيانات المعاد تشغيلها مجددًا في خط
المحفزات — وهو المتطلب المشترك لطبقتي حالة العالم والتعلم.

## 4. تقديم النماذج على الحافة

يدير `model_server` أوقات تشغيل النماذج على العقدة: نشر النماذج على حاويات
(ollama وwhisper.cpp وvLLM) بوضع GPU أولًا مع الرجوع إلى CPU — وهي الوحدة
الأساسية لاستدلال حافة تفاعلي لا يعتمد أبدًا على LLM متصل.

## 5. التكامل الصاعد

تتدفق الأحداث إلى scepter في entelecheia عبر مصرف محفزات JSON-RPC على مقبس
Unix (موجّه بالموضوع)؛ ويسجّل بوابة الجهاز↔السحابة هوية العقدة والقياس عن
بعد. كل ما هو مادي يُوجَّه عبر evernight.

## مرجع متغيرات البيئة (مختصر)

| المتغير | الغرض |
|---|---|
| `EVERNIGHT_SOCK` | مقبس Unix للمحفزات/القياس عن بعد إلى scepter |
| `EVERNIGHT_*` | ضبط الاتصال لكل بروتوكول |
| حاويات/بيئة GPU | نشر خادم النماذج (أوقات تشغيل ollama/vLLM) |
