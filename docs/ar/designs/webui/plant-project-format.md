# صيغة ملف مشروع المنشأة (`.plant.json`)

> تصميم صيغة ملف المشروع — مشابه لملفات مشروع Siemens TIA Portal، يوحّد طوبولوجيا العقد الصناعية، اللوحات ثنائية الأبعاد، والمشاهد ثلاثية الأبعاد.

## أهداف التصميم

1. **مصدر وحيد للحقيقة** — ملف واحد يصف المنشأة/المشروع بأكمله: عقد الأجهزة، الطوبولوجيا ثنائية الأبعاد، المشهد ثلاثي الأبعاد، الشبكات الصناعية
1. **توافق ثلاثي الأطراف** — `mock_scepter` (fixtures)، webui الخاص بـ shittim-chest (عرض ثلاثي الأبعاد)، وكيل entelecheia PoleMos (إدارة الأجهزة) جميعًا يقرؤون نفس الملف
1. **متمركز حول العقدة** — جميع بيانات الطوبولوجيا والمشهد والمستشعرات مرتبطة بالعقد؛ العقدة هي الكيان الأساسي
1. **قابل للإصدار** — حقل `format_version` + JSON Schema للتطور المتوافق مع الإصدارات السابقة
1. **قابل للتوسعة** — يمكن إلحاق بيانات وصفية مخصصة دون كسر المحللات الموجودة

## اصطلاحات الملف

- الامتداد: `.plant.json`
- الترميز: UTF-8
- الصيغة: JSON (مدعومة أصليًا من قبل جميع الأطراف الثلاثة)
- ملف واحد = مشروع واحد = منشأة/خط إنتاج واحد

## البنية عالية المستوى

```json
{
  "$schema": "https://shittim-chest.ai/schemas/plant-v1.json",
  "format_version": 1,

  "metadata": { ... },
  "nodes": { ... },
  "topology": { ... },
  "scene": { ... }
}
```

---

## القسم 1: `metadata`

البيانات الوصفية للمشروع.

```json
{
  "metadata": {
    "name": "Green Hydrogen Corridor",
    "description": "Green hydrogen corridor demonstration project",
    "author": "engineering-team",
    "created_at": "2026-06-13T00:00:00Z",
    "updated_at": "2026-06-13T00:00:00Z",
    "tags": ["hydrogen", "green-energy", "demo"]
  }
}
```

أوصاف الحقول:

| الحقل | النوع | مطلوب | الوصف |
| --- | --- | --- | --- |
| name | string | نعم | اسم المشروع |
| description | string | لا | الوصف |
| author | string | لا | المنشئ |
| created_at | ISO8601 | لا | وقت الإنشاء |
| updated_at | ISO8601 | لا | وقت آخر تعديل |
| tags | string[] | لا | الوسوم |

---

## القسم 2: `nodes`

**الكيان الأساسي**. تمثل كل عقدة جهازًا ماديًا أو وحدة منطقية. الأقسام الأخرى (الطوبولوجيا، المشهد) تشير إلى العقد بالمعرّف.

```json
{
  "nodes": {
    "rsoc-enc": {
      "label": "RSOC Enclosure",
      "label_i18n": { "zhs": "RSOC 系统外壳" },
      "type": "rsoc",
      "box": "box-1",
      "polemos_node_id": "node-rsoc-enc",
      "manufacturer": "Example Corp",
      "model": "RSOC-2024-ENC",
      "serial": "SN-RSOCENC-012345",
      "rated": {
        "rated_power": "150 kW",
        "operating_temperature": "600 ~ 850 °C",
        "fuel": "H₂ / CH₄",
        "generation_efficiency": "≥ 60%"
      },
      "sensors": [
        {
          "id": "tt-101",
          "type": "temperature",
          "label": "TT-101",
          "address": "Modbus:HR101",
          "unit": "°C",
          "range": [0, 1000]
        },
        {
          "id": "pt-101",
          "type": "pressure",
          "label": "PT-101",
          "address": "Modbus:HR102",
          "unit": "MPa",
          "range": [0, 5]
        }
      ],
      "status": "online",
      "metadata": {}
    },

    "rsoc-stack": {
      "label": "RSOC Stack",
      "type": "rsoc-stack",
      "box": "box-1",
      "polemos_node_id": "node-rsoc-stack",
      "rated": {},
      "sensors": [],
      "status": "online"
    }
  }
}
```

أوصاف الحقول:

| الحقل | النوع | مطلوب | الوصف |
| --- | --- | --- | --- |
| label | string | نعم | اسم العرض |
| label_i18n | {lang: string} | لا | أسماء متعددة اللغات |
| type | string | نعم | معرّف نوع الجهاز (rsoc / pem / tank / compressor / fuelcell / synthesis / chp / structure / ...) |
| box | string | نعم | معرّف الحاوية، يطابق topology.boxes[].id |
| polemos_node_id | string | لا | معرّف عقدة وكيل PoleMos الخاص بـ entelecheia لتعاون السحابة-الطرف |
| manufacturer | string | لا | المُصنّع |
| model | string | لا | الموديل |
| serial | string | لا | الرقم التسلسلي |
| rated | {key: string} | لا | معاملات لوحة الاسم |
| sensors | Sensor[] | لا | المستشعرات المرتبطة |
| status | string | لا | الحالة الافتراضية (online / offline / maintenance) |
| metadata | object | لا | حقول التمديد |

بنية المستشعر:

| الحقل | النوع | الوصف |
| --- | --- | --- |
| id | string | معرّف المستشعر (مثل tt-101) |
| type | string | temperature / pressure / flow / level / gas / current |
| label | string | تسمية العرض |
| address | string | عنوان البروتوكول الصناعي (Modbus:HR101 / OPC-UA:ns=2;s=Temperature) |
| unit | string | الوحدة |
| range | [min, max] | نطاق القياس |

---

## القسم 3: `topology`

طوبولوجيا اللوحات ثنائية الأبعاد — تُستخدم لعر views لوحات بنمط SCADA ومخططات خطوط الأنابيب ثنائية الأبعاد.

```json
{
  "topology": {
    "boxes": [
      {
        "id": "box-1",
        "label": "#1 RSOC System",
        "label_i18n": { "zhs": "#1 RSOC 系统", "en": "#1 RSOC System" },
        "color": "#8b5cf6",
        "nodes": ["rsoc-enc", "rsoc-stack"]
      },
      {
        "id": "box-2",
        "label": "#2 Electrolyzer Area",
        "label_i18n": { "zhs": "#2 电解槽区", "en": "#2 Electrolyzer Area" },
        "color": "#3b82f6",
        "nodes": ["alk2", "alk3", "bop", "pem", "pem-cluster"]
      }
    ],

    "plcs": [
      { "id": "plc-central", "label": "PLC-Central", "ip": "192.168.10.40", "protocol": "Modbus TCP" }
    ],

    "connections": {
      "signal_wires": [
        {
          "id": "sw-rsoc-1",
          "from": "tt-101",
          "to": "plc-central",
          "protocol": "Modbus",
          "points": [[260,130],[150,130],[150,500],[60,500]]
        }
      ],
      "power_cables": [
        {
          "id": "pc-rsoc-1",
          "from": "mcc-panel",
          "to": "rsoc-enc",
          "voltage": "380V",
          "points": [[500,50],[300,200]]
        }
      ],
      "water_pipes": [
        {
          "id": "wp-rsoc-1",
          "from": "cooling-tower",
          "to": "rsoc-enc",
          "medium": "circulating cooling water",
          "points": [[50,400],[300,300]],
          "flow_rate": 120,
          "temperature": 28
        }
      ],
      "gas_pipes": [
        {
          "id": "gp-rsoc-1",
          "from": "rsoc-enc",
          "to": "h2-manifold",
          "gas": "H2",
          "points": [[390,250],[600,250]]
        }
      ]
    },

    "layout": {
      "rsoc-enc": { "pos": [300, 200], "size": [180, 100] },
      "tt-101":   { "pos": [260, 130] },
      "pt-101":   { "pos": [340, 130] },
      "plc-central": { "pos": [60, 500] }
    }
  }
}
```

أوصاف حقول الطوبولوجيا:

| الحقل | النوع | الوصف |
| --- | --- | --- |
| boxes | Box[] | تجميعات الحاويات؛ كل صندوق يحتوي عدة عقد |
| plcs | PLC[] | قائمة أجهزة PLC |
| connections | Connections | أربعة أنواع اتصال: أسلاك الإشارة، كابلات الطاقة، أنابيب المياه، أنابيب الغاز |
| layout | {id: LayoutItem} | إحداثيات اللوحة ثنائية الأبعاد (الموضع ثنائي الأبعاد لكل عقدة / مستشعر / plc) |

بنية الصندوق:

| الحقل | النوع | الوصف |
| --- | --- | --- |
| id | string | معرّف الحاوية |
| label | string | تسمية العرض |
| label_i18n | {lang: string} | متعدد اللغات |
| color | string | لون السمة |
| nodes | string[] | قائمة معرّفات العقد المضمنة |

بنية الاتصال (مشترك):

| الحقل | النوع | الوصف |
| --- | --- | --- |
| id | string | معرّف الاتصال |
| from | string | معرّف الكيان المصدر (عقدة / مستشعر / plc / منفعة) |
| to | string | معرّف الكيان الوجهة |
| points | [x,y][] | إحداثيات مسار الخط المتعدد |
| protocol | string | بروتوكول سلك الإشارة (Modbus / 4-20mA / Profibus / HART / OPC-UA) |
| voltage | string | جهد كابل الطاقة |
| medium | string | وسيط أنبوب المياه |
| gas | string | نوع أنبوب الغاز |
| flow_rate | number | معدل التدفق |
| temperature | number | درجة الحرارة |

---

## القسم 4: `scene`

تكوين المشهد المجسم ثلاثي الأبعاد — يُستخدم بواسطة عرض Three.js الخاص بـ `PhysicalPreview` في webui.

```json
{
  "scene": {
    "background_color": "#0a0a1a",
    "environment_url": null,

    "camera": {
      "overview": {
        "position": [10, 15, 50],
        "target": [10, 2, 20],
        "fov": 45
      },
      "bookmarks": {
        "box-1": { "position": [28, 6, 32], "target": [27, 2, 24] },
        "box-2": { "position": [23, 6, 35], "target": [18, 1, 27] },
        "box-3": { "position": [10, 6, 37], "target": [6, 2, 27] },
        "box-4": { "position": [2, 6, 35], "target": [-1, 2, 26] },
        "box-5": { "position": [-2, 6, 29], "target": [-5, 2, 21] },
        "box-6": { "position": [-5, 6, 16], "target": [-8, 2, 8] },
        "box-7": { "position": [14, 6, 16], "target": [15, 2, 7] }
      }
    },

    "lighting": {
      "ambient": {
        "color": [0.70, 0.75, 0.82],
        "intensity": 500
      },
      "directional": {
        "color": [0.90, 0.92, 0.95],
        "intensity": 6000,
        "position": [15, 80, 30]
      }
    },

    "ground": {
      "enabled": false
    },

    "bloom": {
      "strength": 0.5,
      "radius": 0.4,
      "threshold": 0.85
    },

    "models": [
      {
        "node": "rsoc-enc",
        "glb": "box1_rsoc_enclosure.glb",
        "position": [27.11, 1.76, 24.86],
        "rotation": [0, 0, 0],
        "scale": 1.0,
        "material": "auto",
        "is_background": false
      },
      {
        "node": "rsoc-stack",
        "glb": "box1_rsoc_stack.glb",
        "position": [28.39, 1.62, 23.05],
        "rotation": [0, 0, 0],
        "scale": 1.0,
        "material": "auto",
        "is_background": false
      }
    ]
  }
}
```

أوصاف حقول المشهد:

| الحقل | النوع | الوصف |
| --- | --- | --- |
| background_color | string | لون خلفية المشهد ثلاثي الأبعاد |
| environment_url | string? | URL لخريطة بيئة HDR |
| camera.overview | CameraView | زاوية الكاميرا المبدئية (نظرة عامة على جميع النماذج) |
| camera.bookmarks | {boxId: CameraView} | زاوية الهدف للطيران لكل حاوية |
| lighting.ambient | {color, intensity} | الضوء المحيطي |
| lighting.directional | {color, intensity, position} | الضوء الاتجاهي |
| ground | {enabled, ...} | تكوين الأرضية |
| bloom | {strength, radius, threshold} | معالجة لاحقة للتوهج (Bloom) |
| models | Model3D[] | قائمة وضع النماذج ثلاثية الأبعاد |

بنية CameraView:

| الحقل | النوع | الوصف |
| --- | --- | --- |
| position | [x, y, z] | موضع الكاميرا |
| target | [x, y, z] | نقطة النظر إليها |
| fov | number | مجال الرؤية (درجات) |

بنية Model3D:

| الحقل | النوع | الوصف |
| --- | --- | --- |
| node | string | معرّف العقدة المرتبط |
| glb | string | اسم ملف GLB (نسبًا إلى دليل models/) |
| position | [x, y, z] | إحداثيات العالم ثلاثية الأبعاد |
| rotation | [x, y, z] | دوران زاوية أويلر |
| scale | number | عامل القياس |
| material | "auto" \| "holographic" \| "native" | تجاوز المادة |
| is_background | boolean | ما إذا كان هذا زخرفة خلفية |

---

## التكامل ثلاثي الأطراف

### 1. mock_scepter (Rust fixture)

مسار التحميل: `fixtures/{project}.plant.json`

```text
fixtures/
├── agents.json
├── devices.json
├── hydrogen_corridor.plant.json   ← new
└── models/
    ├── box1_rsoc_enclosure.glb
    ├── box2_alk2.glb
    └── ...
```

عند بدء تشغيل `mock_scepter`:

- يحصل `fixtures::load_all()` على استدعاء `load_plant()` جديد
- يحلل `.plant.json` ← يقسم إلى `DeviceModelResponse[]` + `SceneConfigItem`
- يعيد `get_scene_config` من بيانات المنشأة بدلاً من القيم المُشفر ثابتًا
- يعيد `list_device_models` من بيانات المنشأة
- مشتق `box_detail()` / `equipment_detail()` الخاص بـ `topology.rs` من بيانات المنشأة

### 2. shittim-chest webui

تبقى عقود API الموجودة دون تغيير (`/projects/{pid}/device-models` + `/projects/{pid}/device-models/scene-config`).

إضافات جديدة:

- يقرأ `BOX_CAMERA_TARGETS` الخاص بـ `PhysicalPreview.tsx` من `scene.camera.bookmarks` بدلاً من كونه مُشفر ثابتًا
- تقرأ تسميات تراكب CSS2D للنموذج ثلاثي الأبعاد من `nodes[nodeId].label`

### 3. وكيل entelecheia PoleMos

يقرأ PoleMos ملف المنشأة عبر أدوات MCP:

- `node_discover` ← يجتاز `nodes` + `topology.plcs`
- `device_self_test` ← يقرأ `nodes[id].sensors` + `nodes[id].rated`
- عمليات إدارة الأجهزة ← يكتب `nodes[id].status`

امتدادات مستقبلية:

- يولّد وكيل PoleMos layer2 ملف `.plant.json` (يقرأ الذكاء الاصطناعي وثائق الأجهزة لبناء الطوبولوجيا تلقائيًا)
- المستخدمون يسحبون ويفلتون التخطيط ثلاثي الأبعاد في webui ← يكتبون `.plant.json`
- خط أنابيب CI/CD يتحقق من سلامة مخطط `.plant.json`

---

## ملف مثال

راجع `scripts/mock/fixtures/hydrogen_corridor.plant.json` لمثال كامل (سيُنشأ).

---

## العلاقة بالبيانات الموجودة

| مصدر البيانات الموجود | الجزء المُهاجَر إلى .plant.json |
| --- | --- |
| 20 DeviceModelResponses مُشفر ثابتًا في `http_server.rs` | → `scene.models[]` + `nodes{}` |
| SceneConfigItem مُشفر ثابتًا في `http_server.rs` | → `scene{}` (camera, lighting, ground, bloom) |
| overview() / box_detail() في `mock_data/topology.rs` | → `topology{}` (boxes, connections, layout) |
| equipment_detail() في `mock_data/topology.rs` | → `nodes{}.rated` + `nodes{}.sensors` |
| BOX_CAMERA_TARGETS في `PhysicalPreview.tsx` | → `scene.camera.bookmarks` |
| fixture `devices.json` (entelecheia PoleMos) | → `nodes{}.polemos_node_id` |

## التحقق من المخطط

يعيش ملف JSON Schema في `schemas/plant-v1.json` ويُشارك من قبل جميع الأطراف الثلاثة.
يتحقق `mock_scepter` عبر إزالة تسلسل `serde_json` + التحقق من المخطط وقت التحميل.
يمكن لـ webui التحقق باستخدام `ajv` وقت البناء.
يمكن لـ entelecheia التحقق باستخدام كرات `jsonschema`.
