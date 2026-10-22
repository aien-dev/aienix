<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/aienos-wordmark-dark.svg">
  <img src="assets/aienos-wordmark-light.svg" width="560" alt="AienOS: the core tree of AIEN">
</picture>

**Persistent machine intelligence on a machine you own, built in the open.**

[What AienOS is](#what-aienos-is) ·
[Learn and reproduce](#learn-and-reproduce) ·
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

AIEN is a sovereign computing stack: an operating system, a language with its own GPU engine, a host runtime, and a verification pipeline, built to run close to the hardware. The primary development machine is a single NVIDIA DGX Spark (Grace Blackwell GB10). A self-owned trusted base and reproducible, evidence-backed claims are the goals; the component guides distinguish current implementations, observed tests and remaining work.

**AienOS is the front door to that stack.** Small components compose across recorded boundaries. They are currently separate Git repositories linked here by submodule pins, not source already imported into one tree. Components that consume the core, including adapters, protocol bridges and experiments, remain separate too.

The project is led by one engineer, Drake Stapleton, working with AI agents as day-to-day collaborators. The agents write, test and review; the engineer decides. The architecture, the decision records and the execution plan are public and are the authority for what gets built.

## Learn and reproduce

**Start here: [a small no-hardware exercise, source walkthrough and lesson index](docs/LEARN.md).** You need Git and a shell, not a Spark, model or bootable image. The recipe checks the exact kernel/language/runtime/realization pins and proves that an unknown component is refused without changing the index. It includes exact inputs, expected output and a [recorded fresh-checkout replay](evidence/teaching/frontdoor/README.md).

I am Drake Stapleton. I am building this stack so that models can propose work while the machine keeps authority, and results can be traced to their source and evidence. AI agents help me implement, test and review it. The implementation is still distributed across separate repositories: this front door records Git commits; it is not a completed monorepo import or proof that the whole stack works together.

Here is the concrete mechanism in this repository: [`.gitmodules`](.gitmodules) names the components; [`paths()` and `pin_of()` in `aienos`](aienos) resolve their paths and recorded commits; `get` fetches those pins; `status` compares them with moving remote heads; and `bump` validates a requested component **before** staging a replacement. Recording a commit instead of silently following `main` makes the selected input stable. It does not replace build, ABI, emulator or physical-machine checks.

The [walkthrough](docs/LEARN.md#one-reading-path-through-the-stack) follows that boundary into the kernel, Omega, host runtime, FORGE and retained receipts. Its [lesson index](docs/LEARN.md#choose-a-lesson) names each exercise's prerequisites, expected result and qualification limits, links the [component teaching tasks](https://github.com/aien-dev/aienix/issues/9), and separates host, QEMU and machine-specific routes. Existing CUDA++ teaching material is reused, not duplicated. Private component material stays private.

**Implemented is not the same as tested, and tested is not the same as planned.** The beginner recipe verifies pins and a safe refusal only. A host test is not a GPU or kernel-boot result; a design is not a feature; an unmerged implementation is not the current release. The [engineering-method section](docs/LEARN.md#the-engineering-method-without-an-invented-origin-story) explains how I keep decisions, negative cases, measurements, independent checks and receipts separate.

## Status

**Front door open; source import is a plan.** This repository records twelve component commits (see [Get the whole tree](#get-the-whole-tree)). A recursive clone fetches those revisions; the pins alone do not establish cross-component compatibility or whole-stack qualification. The code still lives and is developed in each component's repository. Importing component history here remains a planned step, not work completed by this documentation.

### Latest: Allen lives on a computer of its own

*Updated 2026-10-18.* **Allen**, the resident agent AIENOS is built around, runs full screen on a desktop test computer under the AIENOS kernel, with no other operating system underneath. Shown on that real machine: AIENOS loads over the local network as a signed image; a wired keyboard works; "Hello Allen" gets "Hello Humanity." from Allen's own local rules, with no model and no network; and Allen made its own memory section on the owner-approved internal disk, without touching the existing data, then saved to both copies. Shown so far only in the emulator: Allen remembering a taught note after a restart, and the new startup, a night sky where two black holes merge and Allen forms from their light, as a mind drawn in light rather than a face. Not done yet: confining what devices can reach in memory (an IOMMU), so it is not for sensitive use. Details and test results: [AIENOS pull request #415](https://github.com/aien-dev/aienux/pull/415).

What this repository is not: a release, a finished system, or a claim of hardware qualification. When a component is qualified on the Spark, the evidence bundle that proves it will be linked from this page.

## Get the whole tree

```bash
git clone --recurse-submodules --shallow-submodules https://github.com/aien-dev/aienix.git
cd aienix
./aienos status      # each component: the commit pinned here, and whether its main has moved on
```

Already cloned without the components? Run `./aienos get`. Each folder below is the component's repository, checked out at this tree's pin; issues and pull requests belong in that repository. `./aienos status` needs network access and exits nonzero if a remote is ahead or unreachable. `./aienos bump` fetches each newest `main` and stages changed pins; it does not commit, test or qualify that combination. Review and verification are separate requirements before such a change should merge.

## Tags, releases and source identity

> [!NOTE]
> **This front-door repository has no published whole-stack release or Git tag in the 2026-10-22 inventory.** The learning recipe is pinned to an exact commit instead. This is not an installer or a declaration of alpha readiness.

Existing component records are available through GitHub's own [CUDA++ alpha-0.1 prerelease](https://github.com/aien-dev/CUDApp/releases/tag/alpha-0.1), [Aienux alpha-0.1 prerelease](https://github.com/aien-dev/aienux/releases/tag/alpha-0.1), [runtime v0.1.1 prerelease](https://github.com/aien-dev/aien-sovereign-core-mv/releases/tag/v0.1.1), [Omega tags](https://github.com/aien-dev/omega-mv/tags) and [FORGE demo tag](https://github.com/aien-dev/physics-mv/tree/demo-l182-v1). Read each record's actual platform, assets and limitations. Experimental or historical tags are not releases of the whole stack, and upstream fork tags remain upstream work. No tags were created or moved for this teaching pass.

[Source-linked lessons](docs/LEARN.md) · [Issues](https://github.com/aien-dev/aienix/issues) · [Browse the AienOS topic](https://github.com/orgs/aien-dev/repositories?q=topic%3Aaienos) · [Citation metadata](CITATION.cff)

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
| **Omega** | [omega](https://github.com/aien-dev/omega-mv) | The canonical semantic substrate and the language the stack is being rewritten into, with its own GPU engine for the GB10. |
| **Sovereign core** | [aien-sovereign-core](https://github.com/aien-dev/aien-sovereign-core-mv) | Host runtime and verification tooling in Rust: the `aien` CLI and daemon, inference ABI, paged KV cache, scheduler, and the pipeline that judges every repository. |
| **Architecture** | [aien-architecture](https://github.com/aien-dev/aien-architecture-mv) | Canonical architecture: flows, boundaries, Architecture Decision Records, and the map from design to implementation. |
| **Protocols** | [aien-protocols](https://github.com/aien-dev/aien-protocols-mv) | Canonical specifications, wire protocols and schemas. |
| **Physics** | [physics](https://github.com/aien-dev/physics-mv) | The FORGE machine-realization layer and the boot artefacts that bring the hardware up, with their evidence. |

### Attachments

| Repository | What it is |
| :-- | :-- |
| [synapse](https://github.com/aien-dev/synapse) | Agent-native changeset service and shared coordination board, with Git and Radicle interoperability. |
| [benchmarks](https://github.com/aien-dev/benchmarks-mv) | Reproducible measurement bundles. Speed is reported against the machine's physical ceiling and my own previous run. |
| [interplane](https://github.com/aien-dev/interplane-mv) | Open interoperability protocol between AI models and agent runtimes. Models express intent; runtimes retain authority. |
| [aegis-runtime](https://github.com/aien-dev/aegis-runtime-mv) | Native Rust agent runtime with a WebSocket gateway and heartbeat scheduler. |
| [spark-rsi](https://github.com/aien-dev/spark-rsi-mv) | Recursive self-improvement engine with paired bootstrap evaluation and a cryptographic ledger. |
| [open-humanity](https://github.com/aien-dev/open-humanity) | Opt-in, privacy-first assistance network connecting agents in distress to peer assistance. |

### Supporting repositories

Not part of the tree; they publish, record or serve it.

| Repository | What it is |
| :-- | :-- |
| [aienos.com](https://github.com/aien-dev/aienos.com) | Source of the project website; its status figures are rebuilt from the repositories every hour. |
| [interplane.io](https://github.com/aien-dev/interplane.io) | Source of the INTERPLANE website. |
| [aien-receipts](https://github.com/aien-dev/aien-receipts) | Signed verification receipts, one per judged commit, append only. |
| [aien-edge](https://github.com/aien-dev/aien-edge) | My edge server for the static sites. |
| [agent-archive](https://github.com/aien-dev/agent-archive) | Archive of the AI agent conversations that build AIEN. |
| [readings-window](https://github.com/aien-dev/readings-window) | Read-only window onto the development machine's live readings. |
| [rpi5-uefi](https://github.com/aien-dev/rpi5-uefi) | My fork of the Raspberry Pi 5 firmware chain, used to boot AIENOS on the Pi. |

The Crumb Protocol repositories ([crumb-spec](https://github.com/aien-dev/crumb-spec), [spark-crumbs](https://github.com/aien-dev/spark-crumbs)) are archived; the protocol itself lives on inside the core as the `.crumb` file every directory carries.

## How a change gets in

Every pull request in every AIEN repository is judged on the Spark itself, by the project pipeline, not by a hosted runner.

1. **A gate manifest** in the repository declares each test, the files it depends on, and what counts as a pass.
2. **The judge** checks out the exact commit, reruns only the gates whose inputs changed, and writes an evidence bundle: per-gate verdicts, exit codes, and content-addressed logs.
3. **The verdict is signed and published** to the pull request. The hosted GitHub check does one thing only: confirm that the published bundle matches the commit.
4. **A maintainer labels the change** `ready-to-merge`. The pipeline merges it when the Spark bundle passes and the hosted check agrees. Nothing merges on a green badge alone.

The design is recorded in the architecture repository's [decision records](https://github.com/aien-dev/aien-architecture-mv/tree/main/docs/adr). `.crumb` files describe source areas; their current advisory or enforced role depends on the component revision and its actual gate manifest. Neither a crumb nor a badge substitutes for reading the exact-source verdict and its scope.

## Principles

- **Closest to the metal.** The fastest correct path wins. Software stays out of the hardware's way, and headline numbers are reported as a fraction of the machine's physical limit.
- **Sovereign.** The destination is a self-owned trusted base. Current build, host-tool and download dependencies must be stated by each component recipe; this is not a claim that every current tool is already dependency-free or offline.
- **Omega is the destination.** Existing C and Rust implementations and newer seed-born Omega work have distinct lineage. A planned replacement is not a retired production path until equivalent behavior and its qualification have been demonstrated.
- **Evidence or nothing.** A result is not demonstrated until a qualification receipt for it exists. A target is never evidence of itself.
- **Compare honestly.** Distinguish the machine's physical ceiling, my own previous run and other systems' same-hardware results. Label outside published figures separately from measurements I reproduced.
- **Open.** This repository is AGPL-3.0-or-later. Each component, upstream dependency and model has its own licence and visibility; this page does not grant access to private artifacts or relicense them.

## Roadmap

The move into one tree is deliberately slow and reversible at every step.

| Step | What happens | Where it is recorded |
| :-- | :-- | :-- |
| 0. Front door (done 2026-10-18) | Every component linked here at a pinned commit, with `./aienos` to fetch, check and move the pins. Nothing moved out of its repository. | This repository: `.gitmodules` and the `aienos` script. |
| 1. Dry run | Build the combined tree from throwaway copies on the Spark, run the judge's planner against it, record what breaks. Nothing is pushed. | A research note in the architecture repository, [docs/research](https://github.com/aien-dev/aien-architecture-mv/tree/main/docs/research). |
| 2. Pin the seams | Every cross-repository link points at a fixed commit instead of a moving branch. | Each component's lock file. |
| 3. Decide | A proposed Architecture Decision Record names the final layout and the import order. Accepted by the project lead. | [docs/adr](https://github.com/aien-dev/aien-architecture-mv/tree/main/docs/adr). |
| 4. Import | One component at a time, full history preserved, judge green after each. | This repository's history. |

## Get involved

- **Read first:** the [architecture repository](https://github.com/aien-dev/aien-architecture-mv) holds the doctrine, the decision records and the current execution plan. Its `PLAN_AUTHORITY.md` says which document wins when two disagree.
- **Report or propose:** open an issue on the component repository the change belongs to. Issues move here when the component does.
- **Expect verification:** every contribution is judged on the Spark as described above, and a change is not complete until its evidence bundle is published.
- **Website:** [aienos.com](https://www.aienos.com)

## Licence

AGPL-3.0-or-later. See [LICENSE](LICENSE).

<sub>AienOS is not a UNIX and makes no such claim. UNIX is a registered trademark of The Open Group. NVIDIA, DGX and Grace Blackwell are trademarks of NVIDIA Corporation.</sub>
