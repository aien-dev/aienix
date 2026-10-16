# One source of truth for AIEN, held in Aienix

Status: proposal, not yet reviewed by Drake.

Date: 2026-10-16. Author: Claude (scout lane), from Drake's decision of the same day.

Drake's words: "our entire organization has way too many sources of truth that are out of date and stale... all documentation and references to whatever they're changing must be updated across the entire organization so there is no stale info anywhere... we need one central on the AIENIX for the source of truth." He approved Option 3: first a mandatory receipt for every "exists / does not exist" claim (done today: the `org-check` tool and the `claim-guard` hook), then a planned move to a single source of truth in Aienix, with Alan's truth plug[^1] designed inside it. This document is that plan.

Tags used below: VERIFIED means read on disk today at the quoted path. UNVERIFIED means taken from another document and not re-checked.

## 1. Problem

Truth about AIEN is written in six places today, by different writers, on different schedules. Each copy is correct the day it is written and drifts after that.

| Source | Where (VERIFIED) | Who writes it |
|---|---|---|
| GitHub repositories | 91 repos: 48 under `aien-dev`, 38 under `aien-spark` (old names that redirect), 5 under `drakestapleton` (from `org-check repos`) | Drake and agents, through pull requests |
| Crumb files | one `.crumb` per directory; protocol in `~/aien-architecture/docs/CRUMB_PROTOCOL.md` and `CRUMB_PROTOCOL_RFC_0003.md` | agents, through `~/.local/bin/crumb create`, `seed`, `compile` |
| Cortex | `~/.config/cortex/cortex.db`, served on 127.0.0.1:18080 | `aien-lessons`: agents via `cortex_remember`. `aien-sources`: the Write/Edit hook `~/workspace/cortex-mcp/hook.sh` and `mirror.js` copy files in automatically |
| Mind map | `~/mindmap` (notes, ideas, hubs; `mirror/` rebuilt each build) | Drake and every AI via `~/mindmap/bin/mm`; `build.sh` by cron every 10 minutes |
| Handoff files | `~/handoffs/` (940 `.md` files today) | the orchestrator and workers at the end of a stretch of work |
| Agent memory | `~/.claude/projects/*/memory/MEMORY.md` (11 files) plus `~/.claude/foundation.md` | Claude's auto-memory and the orchestrator |

How they drift: a fact ("kernel X is fused", "no speed receipt exists") is copied by hand into a handoff, a memory note, a mind map note and a crumb purpose line. When the code changes, only the copy nearest the change gets updated, if any. Agents then read whichever copy they find first. No check in the organisation compares the copies with each other, or a sentence with the code it describes (searched: `org:1b26d80bd97f`, `org:8ef76b3bbdee`; the hits are single-repo receipts and site generators, not a cross-source check).

Today's example (from `~/.claude/projects/-home-drakestapleton-aienix/memory/check-every-repo-before-claiming.md`, VERIFIED): twice in one afternoon the orchestrator stated something true in one repository and false in the organisation. It said "no end-to-end speed receipt exists" (one existed in aien-sovereign-core, not omega), and it briefed a worker to merge expert launches that omega main had already fused. Each miss cost a worker run. A third miss was a pull request merged that morning that another lane did not know about.

## 2. Goal state

1. **Facts live once, in Aienix.** A `facts/` folder in this repository holds one small, machine-readable file per fact. Each record carries: id, statement, owner, evidence (repo, commit, path, content hash), `true_from`, `true_until` (empty while current), `recorded_at`, and the receipt that proves it. Records are append-only: changing a fact closes the old record and adds a new one, so the history of what was believed and when is kept. This repository is on GitHub (`origin https://github.com/aien-dev/aienix`, VERIFIED), so the rule "GitHub is canonical" still holds.
2. **Every other surface is a generated view, never hand-edited.** Mind map status notes, Cortex `aien-sources` entries, crumb purpose lines, README tables and the fact sections of handoffs are produced from `facts/` by a generator. Each generated block starts with a marker naming the facts it came from, so a guard can refuse hand edits.
3. **References are pins.** Anywhere a fact is mentioned, it is cited as `fact:<id>@<short digest>`. Changing the fact changes the digest, so every stale mention becomes findable by a plain search.
4. **A staleness gate in the pipeline.** A change that touches a fact, or touches a file a fact points at, is refused until every pin that refers to it has been regenerated. The gate fails closed: if the mirror of the organisation is incomplete, the gate fails instead of passing.
5. **Agents read facts through a plug, not through Markdown.** A read-only MCP server (MCP is the standard way an AI agent calls a tool) named `aienix-facts` answers `get`, `search`, `referrers_of`, `as_of(time)` and `verify`. Every answer carries the fact id and digest, so the agent's sentence can cite it.

The design follows the research in `~/handoffs/2026-10-16-truth-plug-research.md` (VERIFIED present), which found no existing tool that checks "this sentence still matches its source" across many repositories. Outside tools named there (Backstage, Structurizr, Dolt, Graphiti, lychee) are comparison points only; the facts store, generator, gate and plug are built natively in Rust, no Python.

## 3. Alan's claim receipt

One agent proving to another that a claim came from a real run. One object, one verifier.

**Fields** (canonical JSON, then signed):

| Field | Meaning |
|---|---|
| `schema` | `alan/ClaimReceiptV1` |
| `claim` | the sentence being claimed, exactly as said |
| `checker` | which tool decided it, with its version and the digest of its binary or script |
| `inputs` | the pins the checker read: query words, each repo and its head commit, file hashes, mirror state |
| `verdict` | one of `supported`, `contradicted`, `refused`, `unproven` |
| `time` | when the check ran (UTC) |
| `evidence` | digest of the checker's raw output, stored beside the receipt |
| `signer` | key id of the machine or agent that signed |
| `signature` | Ed25519 signature over the canonical bytes of every field above |

**Verifier.** `alan verify <receipt>` checks the signature and the evidence digest, offline. `alan verify <receipt> --rerun` re-runs the named checker on the pinned inputs and compares the verdict. No language model is involved in either step; the research found deterministic checkers far more reliable than model judges (UNVERIFIED secondhand figure, section A6 of the research file).

**Crypto, not invented.** Signing uses a vetted crate already in the tree, never new crypto code. Candidates on disk: `p256` (used by `SignedEvaluationReceipt`, next paragraph) and `ed25519-dalek` 2.1, a dependency of `~/open-humanity/crates/beacon-core` (with `blake3` 1.5) and of `aien-sovereign-core/tools/aien-test` (VERIFIED in both `Cargo.toml` files, the latter on GitHub `main`). Canonical bytes and digest reuse `EvidenceReceiptV1` from `aien-test/src/evidence.rs` ("canonical JSON, sha256 digest", ADR 0028 Decision 4, VERIFIED on GitHub `main`), so test evidence and claims share one canonical form. Which of the two signature crates Alan uses follows the evaluation-protocol spec, so the organisation does not end up with two signing schemes for one kind of receipt. Whether that canonical JSON matches the RFC 8785 standard the research recommends is UNVERIFIED and must be checked before the format is frozen.

**Prior work inside the organisation (found by org-check, read in the organisation mirror).** AIEN already has a signed receipt: `SignedEvaluationReceipt` in `aien-protocols` (`crates/aien-evaluation-protocol/src/lib.rs`, fields `receipt`, `signature`, `cryptographic_tier`, `key_fingerprint`; signs with the `p256` crate and digests with `sha2`; mirror commit 4b76f7f, 2026-10-16). Alan does not add a third receipt family. Its first build step is to read `aien-protocols/specs/evaluation/SPEC.md` and `specs/evidence/ADAPTIVE_EVIDENCE_INTERFACE.md` and express the claim receipt as a kind of evaluation receipt inside that envelope, or record in an ADR why it cannot. Related precedents for generated views: `aienos.com` PR 32 (merged, "facts from the public GitHub record") and `interplane.io` PR 4 (merged, "Rust generator reads the protocol repository and renders the page"). Receipt: `org:59d0ebec3f62`, `org:1b26d80bd97f`.

**How today's receipts become Alan receipts.** The four existing receipt tools already do the hard part; each gets a small adapter that wraps its record in the fields above and signs it.

| Tool | Evidence it exists today (VERIFIED line) | Becomes |
|---|---|---|
| aien-calc | `~/.claude/hooks/calc-guard.sh`: `id_re='calc:[0-9a-f]{12,}'` | checker `aien-calc`, inputs = the expression, verdict = the exact result; the existing `verify` tool of the aien-calc server is the rerun |
| docs-read | `~/.local/bin/docs-read`: `# docs-read REPO "SOURCE" "QUOTED LINE or DOCS SILENT on X"`, records in `~/.claude/state/docs-read/`; enforced by `~/.claude/hooks/manual-guard.sh`: "BLOCKED unless a fresh docs-read record exists for this repo" | checker `docs-read`, inputs = source and hash of the quoted file, verdict = `supported` (quote found) or `unproven` (docs silent) |
| org-check | `~/.local/bin/org-check` writes `receipt: org:$id`, query, time, mirror state, repos searched and hits to `~/org-mirror/receipts/` | checker `org-check`, inputs = query plus every repo head; today's receipt records only mirror counts (`repos_listed=91`, `repos_mirrored=91` in `~/org-mirror/STATE`), so it must start recording each repo's head commit |
| claim-guard | `~/.claude/hooks/claim-guard.sh`: "cites no org-check receipt (org:<12 hex>), the stop is blocked" | stays the enforcer; learns to accept a signed Alan receipt id as well as `org:` |

First demonstration: one agent says "nothing like X exists in the organisation"; a second agent asks Alan, receives a signed `org-check` receipt listing all 91 repo heads, and verifies it against its own mirror.

## 4. Migration order

Nothing is switched off until the facts store, the generator and the gate exist and pass on the first batch of facts. The first facts are the kinds that caused today's misses: what exists where, what is merged, what has been measured.

1. **Cortex `aien-sources` retires first as a place truth is written.** It is already a machine-made copy (the Write/Edit hook mirrors files into it), so only its input changes: it mirrors `facts/` and generated views. Lowest risk, immediate benefit to every agent that recalls from it.
2. **Crumb purpose lines next.** `crumb compile` already regenerates the structural part of every `.crumb` and `crumb verify` already refuses drift; the purpose line becomes generated from a fact in the same way.
3. **Mind map status notes and hub pages.** `mirror/` is already rebuilt every build; status notes move to the same treatment.
4. **Handoffs.** A handoff keeps plan, done and next, and cites facts by pin instead of restating them.
5. **Agent memory and `foundation.md`.** They keep behaviour rules (how to work with Drake, which tool to run); any project state in them is replaced by a pin.

What stays as it is: GitHub stays canonical for code, merged history and accepted decision records (ADRs). Cortex `aien-lessons` stay hand-written, because they are mistake stories, not state. Mind map ideas stay hand-written unless Drake decides otherwise (question 1 below).

## 5. Enforcement

Rules that live only as advice get skipped, so every step below is a hook or a script, modelled on `manual-guard` and `claim-guard`.

| Guard | Kind | What it refuses |
|---|---|---|
| `claim-guard` (exists) | Stop hook | a final message with an absence claim and no `org:` or Alan receipt id |
| `view-guard` (new) | PreToolUse hook, same shape as `manual-guard` | a hand edit to any file or block carrying the "generated from facts" marker |
| `facts verify` (new) | native binary, run as a pipeline check, same shape as `crumb verify` | a change where any pin is stale, any fact's evidence hash no longer matches its file, any reference uses a redirecting `aien-spark` name, or the mirror is incomplete |
| `alan verify` (new) | native binary | a receipt whose signature, evidence digest or rerun verdict does not match |
| brief guard (extend) | the worker-brief writer | a worker brief that states an absence without a receipt id |

Inside Aienix, a fact change and every regenerated view land in one commit, so the gate is one check. For the other repositories, until they are imported, the gate lists the referrers from the organisation mirror and a nightly run reports drift; landing one change atomically across several GitHub repositories is UNVERIFIED as possible (research, section C5) and is not designed around.

## 6. Open decisions for Drake

**Question 1. Do your mind map ideas stay hand-written?**
- Option A, keep ideas hand-written (recommended): the `ideas/` folder stays your free notebook; only status and facts become generated. You keep a place to think out loud. The cost is that an idea can mention a fact that later goes stale; the gate will flag the pin but not rewrite your words.
- Option B, generate everything: ideas become records in `facts/` too. Nothing in the map can go stale, but adding an idea becomes a formal record, which is slower and stiffer for brainstorming.

**Question 2. Is "Alan" the public name?**
- Option A, Alan publicly: matches the Joan and Alan phone-app faces. Before it appears on a public page, run `org-check "Alan"` and a public name search, and keep the footnote below wherever ALLEN (ADR 0035) could be confused with it.
- Option B, Alan as the inside name only: a different public name is picked later; no confusion with ALLEN in public material, at the cost of a second name to keep in step.

**Question 3. Should other people's agents be able to check Alan receipts from the start?**
- Option A, inside the Spark first (recommended): receipts are signed and checked only by our own agents until the format is frozen. Lower exposure while the format can still change.
- Option B, public from the start: the verifier and the public key are published with the first release so anyone can check a receipt. Shows the idea working sooner; any format change after that breaks other people's copies.

## 7. Not in scope, not decided

- No code is written by this document; it is a plan.
- The exact file format inside `facts/` (field names beyond those listed, one file per fact versus one line per fact) is decided when the first batch is built.
- Key storage, key rotation and revocation for Alan signing keys are not decided.
- Hardware attestation (the GB10 vouching for a run) is out of scope until the NVIDIA documentation has been read, per the `spark-hardware-manual` rule.
- Cross-repository atomic merges are not designed (see section 5).
- Importing the component repositories into Aienix follows its own plan (the Aienix `.crumb` purpose line); this document does not schedule it.
- No time or effort figures are given: none have been measured.

## Receipts for claims in this document

Every "exists / does not exist" sentence above rests on these `org-check` runs (receipts in `~/org-mirror/receipts/`). org-check does not see unmerged local work.

- `CHECKED org:8ef76b3bbdee: "single source of truth" in 90 repos (default branch, branches active in 60 days, all commit messages, issues, PRs) at 2026-10-16T18:16:35Z: 93 hit(s).`
- `CHECKED org:59d0ebec3f62: "claim receipt" in 91 repos (default branch, newest 12 branches active in 60 days, all commit messages, issues, PRs) at 2026-10-16T18:16:48Z: 27 hit(s).`
- `CHECKED org:1b26d80bd97f: "facts verify" in 91 repos (default branch, newest 12 branches active in 60 days, all commit messages, issues, PRs) at 2026-10-16T18:17:01Z: 15 hit(s).`

[^1]: **Alan, not ALLEN.** "Alan" here is the trusted agent plug: one agent proving to another that a claim came from a real run. The spelling follows the mind map note `phone-agent-joan-and-alan` and the file name of the idea note `~/mindmap/ideas/2026-10-16-alan-the-trusted-agent-plug-and-one-source-of-trut.md`; that note's title and body spell it "Allen", which should be corrected to match. It is unrelated to ALLEN, ADR 0035 "Persistent Cognitive Entity Boundary (ALLEN)" in `aien-architecture/docs/adr/0035-persistent-cognitive-entity-boundary-allen.md`, accepted 2026-10-06.
