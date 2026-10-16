# Aienix

The core tree of AIEN: a sovereign computing stack built in the open, closest to the metal, by one engineer and his AI agents on an NVIDIA DGX Spark (Grace Blackwell GB10).

Aienix follows the Unix idea the way its authors meant it: small tools that each do one job and compose, kept in one source tree. Attachments (adapters, protocol bridges, experiments) live in their own repositories and plug in at a boundary with a recorded pin. Everything else lives here.

## Status (2026-10-16)

Planning. This repository is the reserved home; the code still lives in the component repositories below and will be imported with its full history, one component at a time, once each one's open pull requests have drained. Nothing is merged here yet, and nothing here is qualified on hardware as a finished system. The plan and the decision record are in [aien-architecture](https://github.com/aien-dev/aien-architecture).

## What belongs in the core tree

| Component | Today | What it is |
| --- | --- | --- |
| Operating system | [aienos](https://github.com/aien-dev/aienos) | AIENOS, the agent-first operating system that replaces Linux on the Spark. No systemd. |
| Omega | [omega](https://github.com/aien-dev/omega) | The language and GPU engine the stack is being rewritten into. Our own kernels, no CUDA toolkit. |
| Host runtime and judge | [aien-sovereign-core](https://github.com/aien-dev/aien-sovereign-core) | The Rust runtime that serves models today, and the verification pipeline that judges every change on the Spark. |
| Architecture | [aien-architecture](https://github.com/aien-dev/aien-architecture) | Flows, boundaries, decision records, the execution plan. |
| Protocols | [aien-protocols](https://github.com/aien-dev/aien-protocols) | Specifications, wire protocols and schemas. |
| Hardware | [physics](https://github.com/aien-dev/physics) | The layer that talks to the GB10 directly. |
| Agent board | [synapse](https://github.com/aien-dev/synapse) | Durable shared message board and Crumb coordination between agents. |
| Measurements | [benchmarks](https://github.com/aien-dev/benchmarks) | Reproducible evidence bundles; speed is reported against the machine's physical limit and our own previous run. |

## Attachments (stay separate)

[interplane](https://github.com/aien-dev/interplane) (open interoperability protocol between models and runtimes), [aegis-runtime](https://github.com/aien-dev/aegis-runtime), [spark-rsi](https://github.com/aien-dev/spark-rsi), [open-humanity](https://github.com/aien-dev/open-humanity), and the archived Crumb specification repositories.

## Standing rules

Rust is scaffolding, Omega is the destination. No Python anywhere. No CUDA toolkit. No systemd. No outside dependencies in the trusted base; builds are offline and reproducible. No comparison with other people's systems. Every headline number resolves to a reproducible command and a signed evidence bundle. AGPL-3.0-or-later.

Aienix is not a UNIX and makes no such claim; UNIX is a trademark of The Open Group.
