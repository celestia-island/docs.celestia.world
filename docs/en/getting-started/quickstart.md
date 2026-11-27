# Quickstart

Walk the [closed loop](../philosophy/closed-loop.md) in about 30 minutes. The
exact addresses depend on your deployment; ask your administrator for the
panel URL and your invitation.

## 1. Get an account

Registration is invite-gated: the first user of a deployment becomes the admin,
and after that self-registration locks. Contact the maintainers for an
invitation, then register through the panel (`https://dev.celestia.world` in
the public deployment, or your administrator's panel URL).

## 2. Create an API key

In the panel, create an API key for your account. This key is your identity for
everything below — model management, chat backends, and agent operations.

## 3. Deploy a model

From the panel, choose a model runtime, deploy it to a node, and bind it to a
chat backend. The panel shows health and usage; metering and pricing are
handled by the platform layer. See [Arona](../platforms/arona.md) for what
each step does.

## 4. Chat and run agents

Open [shittim-chest](https://dev.celestia.world) (desktop app or webUI),
connect with your API key, and start a conversation. For multi-agent work the
agent platform orchestrates behind the same interface; agent logs and tool
calls are visible in the UI. See [Shittim Chest](../platforms/chest.md) and
[Entelecheia](../platforms/entelecheia.md).

## 5. Control industrial equipment

With [evernight](../platforms/evernight.md) running, connect a protocol bridge
(Modbus, S7comm, OPC UA), subscribe to telemetry, and — after policy validation
and human confirmation — issue writes. During the internal beta this segment
runs against simulated or lab equipment; the safety chain is identical either
way.

## 6. Verify

Check the supervision status ([malkuth](https://github.com/celestia-island/malkuth)-managed
services), inspect usage records, and report issues through the channels in the
[beta guide](./beta-guide.md). If something is broken, the loop is not done —
tell us where.

## What if something fails?

- **A service is down** — supervision should have restarted it; check the
  service status page or logs.
- **The panel does not open** — verify you are on the right host/port.
- **Memory or recall is unavailable** — the API response and UI mark it
  explicitly; chat still works without it.

## Where to go deeper

- [Closed Beta Guide](./beta-guide.md) — what the beta covers and how to report bugs.
- [The Closed Loop](../philosophy/closed-loop.md) — the philosophy behind these steps.
