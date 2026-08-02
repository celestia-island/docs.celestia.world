# Quickstart

Walk the [closed loop](../philosophy/closed-loop.md) in about 30 minutes. The
exact addresses depend on your deployment; ask your administrator for the
panel URL and your invitation.

## 1. Get an account

Registration is invite-gated: the first user of a deployment becomes the
admin, and after that self-registration locks. Contact the maintainers for an
invitation, then register through the Arona panel (`https://arona.celestia.world`
in a public deployment, or `http://<host>:8420` internally).

## 2. Create an API key

In the Arona panel, create an API key for your account. This key is your
identity for everything below — model management, chat backends, and agent
operations.

## 3. Deploy a model

From the panel, choose a model runtime (for example an Ollama-backed model),
deploy it to a node, and bind it to a chat backend. The panel shows health and
usage; metering and pricing are handled by the platform layer.

## 4. Chat and run agents

Open [shittim-chest](https://shittim-chest.docs.celestia.world) (desktop app
or webUI), connect with your API key, and start a conversation. For multi-agent
work, entelecheia's scepter runtime orchestrates agents behind the same
interface; agent logs and tool calls are visible in the UI.

## 5. Control industrial equipment

With [evernight](https://evernight.docs.celestia.world) running, connect a
protocol bridge (Modbus, S7comm, OPC UA), subscribe to telemetry, and — after
policy validation and human confirmation — issue writes. During the internal
beta this segment runs against simulated or lab equipment; the safety chain is
identical either way.

## 6. Verify

Check the supervision status (malkuth-managed services), inspect usage
records, and report issues through the channels in the
[beta guide](./beta-guide.md). If something is broken, the loop is not done —
tell us where.

## What if something fails?

- **A service is down** — malkuth should have restarted it; check the service
  status page or logs.
- **The panel does not open** — verify you are on the right host/port and that
  the deployer enabled the embedded webUI.
- **Memory or recall is unavailable** — the API response and UI mark it
  explicitly (`memory: "offline"`); chat still works without it.

## Where to go deeper

- [Closed Beta Guide](./beta-guide.md) — what the beta covers and how to report bugs.
- [The Closed Loop](../philosophy/closed-loop.md) — the philosophy behind these steps.
