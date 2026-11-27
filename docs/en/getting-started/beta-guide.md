# Closed Beta Guide

The **internal closed beta** covers the full product loop, from account
registration to industrial control. Participation is by invitation only.

## What the beta covers

1. **Register an account and create an API key** in the Arona cloud API admin
   panel. The panel stays internal during the beta.
2. **Deploy a model** and bind it to a chat backend through the panel.
3. **Chat and run agents** from the shittim-chest desktop app; agent
   orchestration is provided by the agent platform behind it.
4. **Industrial control**: remote operations and protocol brokering run
   through evernight.

## Getting access

- Access is **invite-based**. Public self-registration is closed by default.
- Invitations are issued by the maintainers and bound to a single account.
- For access questions, reach out through the channels listed in
  [Contributing](../meta/CONTRIBUTING.md).

## Reporting bugs

Report issues on GitHub, one issue per bug, using the issue templates. The
bug tracker for each product is the product's repository; if you do not have
access to a repository, send the report through the channels in
[Contributing](../meta/CONTRIBUTING.md) instead.

Always include: environment info (OS, product versions), steps to reproduce,
expected vs. actual behavior, and any relevant logs.

## Known limitations

- The Arona panel is **internal-only** and not exposed publicly during the beta.
- Registration is closed by default; open registration is not yet available.
- Live device telemetry needs a running agent platform; without it the UI falls
  back to simulated demo data.
- Mobile apps and IDE plugins are not part of this beta.
- Some documentation languages are partial translations.

## Where to go deeper

- [Quickstart](./quickstart.md) — the 30-minute path through the loop.
- [Why celestia-island](../philosophy/why.md) — the philosophy behind the beta.
