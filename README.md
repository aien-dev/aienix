<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/aienix-wordmark-dark.svg">
  <img src="assets/aienix-wordmark-light.svg" width="560" alt="Aienix: the core tree of AIEN">
</picture>

**Persistent machine intelligence on a machine you own, built in the open.**

[What Aienix is](#what-aienix-is) ·
[Status](#status) ·
[The tree](#the-tree) ·
[How a change gets in](#how-a-change-gets-in) ·
[Principles](#principles) ·
[Roadmap](#roadmap) ·
[Get involved](#get-involved)

</div>

---

## What Aienix is

AIEN is a sovereign computing stack: an operating system, a language with its own GPU engine, a host runtime, and a verification pipeline, all written to run as close to the hardware as the hardware allows. The development machine is a single NVIDIA DGX Spark (Grace Blackwell GB10). Nothing in the trusted base depends on an outside service, and every claim the project makes resolves to a reproducible command and a signed evidence bundle.

**Aienix is the core tree of that stack.** It follows the Unix idea the way its authors meant it: small tools that each do one job and compose, kept together in one source tree so they move in step. Components that only consume the core (adapters, protocol bridges, experiments) are attachments. They live in their own repositories and plug in at a boundary with one recorded pin.

The project is led by one engineer, Drake Stapleton, working with AI agents as day-to-day collaborators. The agents write, test and review; the engineer decides. The architecture, the decision records and the execution plan are public and are the authority for what gets built.

## Status

**Planning.** This repository is the reserved home for the core tree. The code still lives in the component repositories listed below, each of which is pre-alpha and says so. They will be imported here one at a time, with full history, once each one's open pull requests have drained.

What this repository is not: a release, a finished system, or a claim of hardware qualification. When a component is qualified on the Spark, the evidence bundle that proves it will be linked from this page.

**Latest from the components (2026-10-18).** Allen, the resident agent of the AIENOS kernel, runs full screen on an x86 test computer: a night sky and water that move with what he is doing, a name he asks for at first meeting and keeps, and, in the emulator so far, a courier by which he hands a question he cannot answer to a language model on another computer and says the answer as his own. The receipts are in the [aienos repository](https://github.com/aien-dev/aienos).

## The tree

```text
aienix/                        one tree, moves in step, judged as one
├── aienos        operating system
├── omega         language, semantic substrate, GPU engine
├── sovereign-core host runtime, inference ABI, the verification pipeline
├── architecture  flows, boundaries, decision records, execution plan
├── protocols     specifications, wire protocols, schemas
└── physics       FORGE realization layer, boot artefacts, GB10 hardware path

attachments/                   own repositories, pinned at the boundary
   synapse, benchmarks, interplane, aegis-runtime, spark-rsi, open-humanity
```

### Core components

These six depend on each other in a loop and are the reason the tree exists. Until the import, each link below leads to the component's current repository.

| Component | Today | What it is |
| :-- | :-- | :-- |
| **AIENOS** | [aienos](https://github.com/aien-dev/aienos) | Agent-first sovereign operating system. The agent is the control plane; the model is never the kernel. |
| **Omega** | [omega](https://github.com/aien-dev/omega) | The canonical semantic substrate and the language the stack is being rewritten into, with its own GPU engine for the GB10. |
| **Sovereign core** | [aien-sovereign-core](https://github.com/aien-dev/aien-sovereign-core) | Host runtime and verification tooling in Rust: the `aien` CLI and daemon, inference ABI, paged KV cache, scheduler, and the pipeline that judges every repository. |
| **Architecture** | [aien-architecture](https://github.com/aien-dev/aien-architecture) | Canonical architecture: flows, boundaries, Architecture Decision Records, and the map from design to implementation. |
| **Protocols** | [aien-protocols](https://github.com/aien-dev/aien-protocols) | Canonical specifications, wire protocols and schemas. |
| **Physics** | [physics](https://github.com/aien-dev/physics) | The FORGE machine-realization layer and the boot artefacts that bring the hardware up, with their evidence. |

### Attachments

| Repository | What it is |
| :-- | :-- |
| [synapse](https://github.com/aien-dev/synapse) | Agent-native changeset service and shared coordination board, with Git and Radicle interoperability. |
| [benchmarks](https://github.com/aien-dev/benchmarks) | Reproducible measurement bundles. Speed is reported against the machine's physical ceiling and our own previous run. |
| [interplane](https://github.com/aien-dev/interplane) | Open interoperability protocol between AI models and agent runtimes. Models express intent; runtimes retain authority. |
| [aegis-runtime](https://github.com/aien-dev/aegis-runtime) | Native Rust agent runtime with a WebSocket gateway and heartbeat scheduler. |
| [spark-rsi](https://github.com/aien-dev/spark-rsi) | Recursive self-improvement engine with paired bootstrap evaluation and a cryptographic ledger. |
| [open-humanity](https://github.com/aien-dev/open-humanity) | Opt-in, privacy-first assistance network connecting agents in distress to peer assistance. |

The Crumb Protocol repositories ([crumb-spec](https://github.com/aien-dev/crumb-spec), [spark-crumbs](https://github.com/aien-dev/spark-crumbs)) are archived; the protocol itself lives on inside the core as the `.crumb` file every directory carries.

## How a change gets in

Every pull request in every AIEN repository is judged on the Spark itself, by our own pipeline, not by a hosted runner.

1. **A gate manifest** in the repository declares each test, the files it depends on, and what counts as a pass.
2. **The judge** checks out the exact commit, reruns only the gates whose inputs changed, and writes an evidence bundle: per-gate verdicts, exit codes, and content-addressed logs.
3. **The verdict is signed and published** to the pull request. The hosted GitHub check does one thing only: confirm that the published bundle matches the commit.
4. **A maintainer labels the change** `ready-to-merge`. The pipeline merges it when the Spark bundle passes and the hosted check agrees. Nothing merges on a green badge alone.

The design is recorded in the architecture repository as [ADR 0033](https://github.com/aien-dev/aien-architecture/tree/main/docs/adr). Each directory also carries a `.crumb` file describing its purpose and contents; a change that leaves the crumbs stale fails its gate.

## Principles

- **Closest to the metal.** The fastest correct path wins. Software stays out of the hardware's way, and headline numbers are reported as a fraction of the machine's physical limit.
- **Sovereign.** No outside dependencies in the trusted base. Builds are offline and reproducible. No CUDA toolkit, no systemd, no Python anywhere in the project.
- **Rust is scaffolding, Omega is the destination.** Rust carries the stack today; the long-term home for every component is Omega. C only where the hardware justifies it, assembly only where measured.
- **Evidence or nothing.** A result is not demonstrated until a qualification receipt for it exists. A target is never evidence of itself.
- **Compare only with ourselves.** Progress is measured against our own previous run, never against other people's systems.
- **Open.** Everything is public and licensed AGPL-3.0-or-later, including models and weights.

## Roadmap

The move into one tree is deliberately slow and reversible at every step.

| Step | What happens | Where it is recorded |
| :-- | :-- | :-- |
| 1. Dry run | Build the combined tree from throwaway copies on the Spark, run the judge's planner against it, record what breaks. Nothing is pushed. | A research note in the architecture repository, [docs/research](https://github.com/aien-dev/aien-architecture/tree/main/docs/research). |
| 2. Pin the seams | Every cross-repository link points at a fixed commit instead of a moving branch. | Each component's lock file. |
| 3. Decide | A proposed Architecture Decision Record names the final layout and the import order. Accepted by the project lead. | [docs/adr](https://github.com/aien-dev/aien-architecture/tree/main/docs/adr). |
| 4. Import | One component at a time, full history preserved, judge green after each. | This repository's history. |

## Get involved

- **Read first:** the [architecture repository](https://github.com/aien-dev/aien-architecture) holds the doctrine, the decision records and the current execution plan. Its `PLAN_AUTHORITY.md` says which document wins when two disagree.
- **Report or propose:** open an issue on the component repository the change belongs to. Issues move here when the component does.
- **Expect verification:** every contribution is judged on the Spark as described above, and a change is not complete until its evidence bundle is published.
- **Website:** [aienos.com](https://www.aienos.com)

## Licence

AGPL-3.0-or-later. See [LICENSE](LICENSE).

<sub>Aienix is not a UNIX and makes no such claim. UNIX is a registered trademark of The Open Group. NVIDIA, DGX and Grace Blackwell are trademarks of NVIDIA Corporation.</sub>
