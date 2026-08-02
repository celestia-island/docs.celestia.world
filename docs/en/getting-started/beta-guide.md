# Closed Beta Guide

The **internal closed beta** covers the full product loop, from account
registration to industrial control. Participation is by invitation only.

## What the beta covers

1. **Register an account and create an API key** in the
   [Arona](https://github.com/celestia-island/arona) cloud API admin panel.
   The panel is internal-only during the beta (`arona:8420` on the deployment
   host).
2. **Deploy a model** and bind it to a chat backend through the panel.
3. **Chat and run agents** from the
   [shittim-chest](https://github.com/celestia-island/shittim-chest) desktop
   app; agent orchestration is provided by entelecheia's **scepter** runtime.
4. **Industrial control**: remote operations and protocol brokering run
   through [evernight](https://github.com/celestia-island/evernight).

## Getting access

- Access is **invite-based**. Public self-registration is closed by default.
- Invitations are issued by the maintainers and bound to a single account.
- For access questions, reach out through the channels listed in
  [Contributing](../meta/CONTRIBUTING.md).

## Reporting bugs

Report issues on GitHub, one issue per bug, using the issue templates:

| Product | Repository |
| --- | --- |
| Chat desktop/web — shittim-chest | [celestia-island/shittim-chest](https://github.com/celestia-island/shittim-chest/issues) |
| Agent orchestration — entelecheia/scepter | [celestia-island/entelecheia](https://github.com/celestia-island/entelecheia/issues) |
| Industrial control — evernight | [celestia-island/evernight](https://github.com/celestia-island/evernight/issues) |
| Admin panel & platform — arona/plana | [celestia-island/arona](https://github.com/celestia-island/arona/issues) |

Always include: environment info (OS, product versions), steps to reproduce,
expected vs. actual behavior, and any relevant logs.

## Known limitations

- The Arona panel is **internal-only** and not exposed publicly during the beta.
- Registration is closed by default; open registration is not yet available.
- WebRTC device relay and live SCADA telemetry require a running scepter
  instance; without it the UI falls back to simulated demo data.
- Mobile apps and IDE plugins are not part of this beta.
- Some documentation languages are partial translations.

## Where to go deeper

- [Quickstart](./quickstart.md) — the 30-minute path through the loop.
- [Why celestia-island](../philosophy/why.md) — the philosophy behind the beta.
