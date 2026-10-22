<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/aienos-wordmark-dark.svg">
  <img src="assets/aienos-wordmark-light.svg" width="560" alt="AienOS: the core tree of AIEN">
</picture>

**Persistent machine intelligence on a machine you own, built in the open.**

[What AienOS is](#what-aienos-is) ·
[Status](#status) ·
[Get the whole tree](#get-the-whole-tree) ·
[The tree](#the-tree) ·
[How a change gets in](#how-a-change-gets-in) ·
[Principles](#principles) ·
[Roadmap](#roadmap) ·
[Get involved](#get-involved)

</div>

---

## What AienOS is

AIEN is a sovereign computing stack: an operating system, a language with its own GPU engine, a host runtime, and a verification pipeline, all written to run as close to the hardware as the hardware allows. The development machine is a single NVIDIA DGX Spark (Grace Blackwell GB10). Nothing in the trusted base depends on an outside service, and every claim the project makes resolves to a reproducible command and a signed evidence bundle.

**AienOS is the core tree of that stack.** It follows the Unix idea the way its authors meant it: small tools that each do one job and compose, kept together in one source tree so they move in step. Components that only consume the core (adapters, protocol bridges, experiments) are attachments. They live in their own repositories and plug in at a boundary with one recorded pin.

The project is led by one engineer, Drake Stapleton, working with AI agents as day-to-day collaborators. The agents write, test and review; the engineer decides. The architecture, the decision records and the execution plan are public and are the authority for what gets built.

## Status

**Front door open; one tree later.** As of 2026-10-18 this repository is the entry point to AIEN: every core component and attachment is linked in at a pinned commit, so one clone fetches the whole system at versions that belong together (see [Get the whole tree](#get-the-whole-tree)). The code itself still lives and is developed in each component's own repository, and each one is pre-alpha and says so. The components will be imported here one at a time, with full history, once each one's open pull requests have drained.

### Latest: Allen lives on a computer of its own

*Updated 2026-10-18.* **Allen**, the resident agent AIENOS is built around, runs full screen on a desktop test computer under the AIENOS kernel, with no other operating system underneath. Shown on that real machine: AIENOS loads over the local network as a signed image; a wired keyboard works; "Hello Allen" gets "Hello Humanity." from Allen's own local rules, with no model and no network; and Allen made its own memory section on the owner-approved internal disk, without touching the existing data, then saved to both copies. Shown so far only in the emulator: Allen remembering a taught note after a restart, and the new startup, a night sky where two black holes merge and Allen forms from their light, as a mind drawn in light rather than a face. Not done yet: confining what devices can reach in memory (an IOMMU), so it is not for sensitive use. Details and test results: [AIENOS pull request #415](https://github.com/aien-dev/aienos-mv/pull/415).

What this repository is not: a release, a finished system, or a claim of hardware qualification. When a component is qualified on the Spark, the evidence bundle that proves it will be linked from this page.

## Get the whole tree

```bash
git clone --recurse-submodules --shallow-submodules https://github.com/aien-dev/aienix.git
cd aienix
./aienos status      # each component: the commit pinned here, and whether its main has moved on
```

Already cloned without the components? Run `./aienos get`. Each folder below is the component's own repository, checked out at the commit this tree pins; issues and pull requests belong in that repository. `./aienos bump` moves the pins forward to each component's newest main, and that change comes in through a pull request like any other, so the pins only ever point at merged, judged work.

## The tree

```text
aienos/                        the front door: every folder is a component, pinned
├── aienux        kernel
├── omega         language, semantic substrate, GPU engine
├── sovereign-core host runtime, inference ABI, the verification pipeline
├── architecture  flows, boundaries, decision records, execution plan
├── protocols     specifications, wire protocols, schemas
└── physics       FORGE realization layer, boot artefacts, GB10 hardware path

attachments/                   plug into the core at a boundary
├── synapse        changeset service, coordination board
├── benchmarks     reproducible measurement bundles
├── interplane     model and runtime interoperability protocol
├── aegis-runtime  agent runtime
├── spark-rsi      self-improvement engine with a ledger
└── open-humanity  opt-in assistance network
```

### Core components

These six depend on each other in a loop and are the reason the tree exists. Each is linked in as a folder of this tree; the link below leads to its own repository, where the work happens.

| Component | Repository | What it is |
| :-- | :-- | :-- |
| **Aienux** | [aienux](https://github.com/aien-dev/aienux) | Agent-first sovereign kernel. The agent is the control plane; the model is never the kernel. |
| **Omega** | [omega](https://github.com/aien-dev/omega) | The canonical semantic substrate and the language the stack is being rewritten into, with its own GPU engine for the GB10. |
| **Sovereign core** | [aien-sovereign-core](https://github.com/aien-dev/aien-sovereign-core) | Host runtime and verification tooling in Rust: the `aien` CLI and daemon, inference ABI, paged KV cache, scheduler, and the pipeline that judges every repository. |
| **Architecture** | [aien-architecture](https://github.com/aien-dev/aien-architecture) | Canonical architecture: flows, boundaries, Architecture Decision Records, and the map from design to implementation. |
| **Protocols** | [aien-protocols](https://github.com/aien-dev/aien-protocols) | Canonical specifications, wire protocols and schemas. |
| **Physics** | [physics](https://github.com/aien-dev/physics) | The FORGE machine-realization layer and the boot artefacts that bring the hardware up, with their evidence. |

### Attachments

| Repository | What it is |
| :-- | :-- |
| [synapse](https://github.com/aien-dev/synapse) | Agent-native changeset service and shared coordination board, with Git and Radicle interoperability. |
| [benchmarks](https://github.com/aien-dev/benchmarks) | Reproducible measurement bundles. Speed is reported against the machine's physical ceiling and my own previous run. |
| [interplane](https://github.com/aien-dev/interplane) | Open interoperability protocol between AI models and agent runtimes. Models express intent; runtimes retain authority. |
| [aegis-runtime](https://github.com/aien-dev/aegis-runtime) | Native Rust agent runtime with a WebSocket gateway and heartbeat scheduler. |
| [spark-rsi](https://github.com/aien-dev/spark-rsi) | Recursive self-improvement engine with paired bootstrap evaluation and a cryptographic ledger. |
| [open-humanity](https://github.com/aien-dev/open-humanity) | Opt-in, privacy-first assistance network connecting agents in distress to peer assistance. |

### Supporting repositories

Not part of the tree; they publish, record or serve it.

| Repository | What it is |
| :-- | :-- |
| [aienos.com](https://github.com/aien-dev/aienos.com) | Source of the project website; its status figures are rebuilt from the repositories every hour. |
| [interplane.io](https://github.com/aien-dev/interplane.io) | Source of the INTERPLANE website. |
| [aien-receipts](https://github.com/aien-dev/aien-receipts) | Signed verification receipts, one per judged commit, append only. |
| [aien-edge](https://github.com/aien-dev/aien-edge) | My own edge server for the static sites. |
| [agent-archive](https://github.com/aien-dev/agent-archive) | Archive of the AI agent conversations that build AIEN. |
| [readings-window](https://github.com/aien-dev/readings-window) | Read-only window onto the development machine's live readings. |
| [rpi5-uefi](https://github.com/aien-dev/rpi5-uefi) | My fork of the Raspberry Pi 5 firmware chain, used to boot AIENOS on the Pi. |

The Crumb Protocol repositories ([crumb-spec](https://github.com/aien-dev/crumb-spec), [spark-crumbs](https://github.com/aien-dev/spark-crumbs)) are archived; the protocol itself lives on inside the core as the `.crumb` file every directory carries.

## How a change gets in

Every pull request in every AIEN repository is judged on the Spark itself, by my own pipeline, not by a hosted runner.

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
- **Compare only with myself.** Progress is measured against my own previous run, never against other people's systems.
- **Open.** Everything is public and licensed AGPL-3.0-or-later, including models and weights.

## Roadmap

The move into one tree is deliberately slow and reversible at every step.

| Step | What happens | Where it is recorded |
| :-- | :-- | :-- |
| 0. Front door (done 2026-10-18) | Every component linked here at a pinned commit, with `./aienos` to fetch, check and move the pins. Nothing moved out of its repository. | This repository: `.gitmodules` and the `aienix` script. |
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

<sub>AienOS is not a UNIX and makes no such claim. UNIX is a registered trademark of The Open Group. NVIDIA, DGX and Grace Blackwell are trademarks of NVIDIA Corporation.</sub>
