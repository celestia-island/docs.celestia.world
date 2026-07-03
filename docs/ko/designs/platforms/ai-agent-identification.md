# AI 에이전트 식별 및 커밋 공동 저자 전략

## 개요

`evernight`는 두 가지 방식으로 celestia-island 공동 저자 전략에 참여합니다:

1. **커밋 호스트로서**: AI 에이전트가 evernight를 통해 커밋을 조율할 때(호스트 A의 에이전트 → evernight SSH/exec → 호스트 B → `git commit`), 호스트 측 `commit-msg` 훅(`noa`가 설치)이 로컬에서 실행되어 커밋에 출처 메타데이터를 도장찍습니다.
2. **전송 제공자로서**: evernight가 모델 트래픽을 중계할 때, 서빙 플랫폼으로서 저자 이메일에 나타날 수 있어 전송 홉을 감사 가능하게 만듭니다.

본 문서는 evernight의 역할을 명세합니다. 권위 있는 메커니즘은 `noa`의 설계 문서에 정의되어 있으며; 본 문서는 evernight별 통합을 다룹니다.

## 제공자 신원 모델

저자 이메일은 `celestia.world` 신뢰 네임스페이스를 사용합니다:

```
Display Name <provider-or-platform-id@celestia.world>
```

evernight가 모델을 중계할 때, provider id는 중계를 반영합니다:

```
GLM 5 <evernight.celestia.world@celestia.world>   # GLM 5 relayed via evernight
```

1차 제공자는 자체 도메인을 유지하고(`anthropic.com`, `deepseek.com`, `zhipuai.cn`, ...); 서드파티 중계기도 자체 도메인을 유지합니다(`opencode.ai`, `jdcloud.com`, `openrouter.ai`, ...). 이를 통해 "어떤 모델을, 누구를 통해"라는 사슬이 모든 커밋에서 보이게 됩니다.

## 공동 저자 트레일러

- 트레일러 키: `Co-authored-by`(git 인식).
- 사용 순서대로, 구별되는 모델당 하나의 트레일러.
- 완전히 YOLO 순항 제어 하에 실행된 체인 실행은 추가로
  `Co-authored-by: Entelecheia <demiurge@celestia.world>`를 받습니다.

## 내장 토큰 사용량

공동 저자 트레일러 이후에 (빈 줄로 구분하여) 추가됩니다:

```
Co-authored-by: Claude Opus 4.8 (↑ 12.5k ↓ 8.3k ●45.2k) <anthropic.com@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 5.1k ↓ 3.2k) <deepseek.com@celestia.world>
```

- `Upload` = 입력 토큰; `Download` = 출력 토큰.
- `Cache`는 캐시된 입력 토큰이 보고되었고 0보다 클 때만 나타납니다.
- 개수는 천 단위(`k`), 소수점 한 자리, 후행 0 제거.

## evernight 통합 지점

### 호스트 측 훅

`evernight`의 `Command.Exec` JSON-RPC(entelecheia의 수술 파이프라인과 `KaLos:auto_fix` 루프가 사용)를 통해 이루어진 커밋은 시스템 `git`을 호출하므로, `noa hook install`이 설치한 `.git/hooks/commit-msg` 훅이 변경 없이 적용됩니다. 훅이 설치된 호스트에서 이루어진 커밋에는 evernight 코드 변경이 필요 없습니다.

### 전송 제공자 신원

evernight가 LLM 트래픽을 프록시할 때(예: 모델 호출을 원격 호스트의 로컬 추론으로 라우팅), 공동 저자 리졸버에 중계 엔드포인트를 알려 provider id가 `evernight.celestia.world`이 되도록 할 수 있습니다. 이는 `noa co-author resolve`가 읽는 것과 동일한 `aporia.toml` provider 목록을 통해 구성됩니다.

## 전체 커밋 메시지 예시

```
perf(screen): cache X11 connection to avoid per-frame reconnect

X11CaptureBackend previously called x11rb::connect on every capture_frame.
Cache the connection in a Mutex<Option<..>>, reusing it across frames.

Co-authored-by: Entelecheia <demiurge@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 18.2k ↓ 2.1k) <deepseek.com@celestia.world>
```

## 보안 고려사항

- 공동 저자 트레일러는 자체 보고 출처 정보이며, 암호학적 증명이 아닙니다.
- 리졸버는 안전하게 성능 저하합니다: `noa` 누락이나 파싱 오류는 빈 블록을 낳고 커밋은 그대로 진행됩니다.
- 제공자 식별자는 로컬 `aporia.toml`에서 오며, 구성된 제공자를 반영합니다.

## 제공자 식별자 참조 (초기 레지스트리)

| 제공자 id | 브랜드 | 엔드포인트 힌트 |
| --- | --- | --- |
| `zhipuai.cn` | GLM | `open.bigmodel.cn` |
| `deepseek.com` | Deepseek | `api.deepseek.com` |
| `anthropic.com` | Claude | `api.anthropic.com` |
| `openai.com` | GPT / OpenAI | `api.openai.com` |
| `evernight.celestia.world` | (중계기) | evernight proxy |
| `opencode.ai` | (중계기) | `opencode.ai` |
| `jdcloud.com` | (중계기) | `jdcloud.com` |
