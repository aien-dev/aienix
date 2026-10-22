# Learn and reproduce AienOS

I am Drake Stapleton. I am building a stack in which a model can propose work without becoming the authority that permits it, and a result can be traced to the source and checks that produced it. AI agents help me write, test and review code; that collaboration is not an independent hardware qualification. This guide explains the implementation boundaries and gives you a small result you can check without a Spark, a model, root access or a bootable image.

Start with the **pin-and-refusal exercise** below. Then choose a component lesson. This repository is an entry point containing Git submodule pins, not a completed source import, an installer or one end-to-end qualification of the entire stack.

## First exercise: prove which code a checkout names

**You learn:** the difference between a repository URL, a moving branch and a Git commit; how the front door resolves a component; and why an unknown component is refused before the index changes.

**Prerequisites:** macOS or Linux, Git, a POSIX shell, `mktemp`, `wc`, `tr` and `cat`; HTTPS access to GitHub for the initial clone. No compiler, model, specialist hardware or privileges. Use a writable scratch directory for `TMPDIR` if your shell does not set it. After the clone, the inspection and refusal commands are offline. The temporary checkout is left in place for inspection; none of the commands deletes it or changes an existing checkout.

**Frozen input:** front-door source `d575aab28b2a635dd08b452f5995b2156c6b9213`. This pin intentionally predates this guide. It makes the command and output independent of later documentation or component updates. The current documentation branch repairs renamed repository URLs in `.gitmodules` without moving any gitlink pin; the frozen exercise and its recorded source-file hashes still refer to the older input revision.

```sh
set -eu
: "${TMPDIR:?set TMPDIR to a writable scratch directory}"
work=$(mktemp -d "$TMPDIR/aienos-lesson.XXXXXX")
git clone --quiet --no-recurse-submodules https://github.com/aien-dev/aienix.git "$work/tree"
cd "$work/tree"
git checkout --quiet --detach d575aab28b2a635dd08b452f5995b2156c6b9213
printf 'source: '; git rev-parse HEAD
printf 'component count: '
git config -f .gitmodules --get-regexp '^submodule\..*\.path$' | wc -l | tr -d ' '
printf 'kernel pin: '; git ls-tree HEAD -- aienux
printf 'language pin: '; git ls-tree HEAD -- omega
printf 'runtime pin: '; git ls-tree HEAD -- sovereign-core
printf 'realization pin: '; git ls-tree HEAD -- physics
before=$(git write-tree)
set +e
./aienos bump not-a-component >refusal.txt 2>&1
rc=$?
set -e
cat refusal.txt
test "$rc" -eq 2
test "$(git write-tree)" = "$before"
printf 'refusal exit: %s; index unchanged\n' "$rc"
printf 'scope: git pins and path refusal only; no component build or hardware test\n'
```

Expected output, with a tab before each Git tree path:

```text
source: d575aab28b2a635dd08b452f5995b2156c6b9213
component count: 12
kernel pin: 160000 commit 17ad0167eac91edc280472020679a11969a78609 aienux
language pin: 160000 commit f4a9849fb127f8d2d664dfc56890752ad180c507 omega
runtime pin: 160000 commit 12e71aad80fda23a428317d11b0dac02d1c777f1 sovereign-core
realization pin: 160000 commit 2043924224b9ecffd79de2c37b2fe7a3a5396e0c physics
aienos: no component at not-a-component
refusal exit: 2; index unchanged
scope: git pins and path refusal only; no component build or hardware test
```

The whole recipe must exit **0**. The deliberately invalid `bump` must exit **2**. The second `test` checks the index tree is unchanged, not merely that an error message was printed. `refusal.txt` is an untracked observation file inside the disposable clone; it is not a component or an evidence signature. [Recorded execution and environment](../evidence/teaching/frontdoor/README.md).

### Follow the exact source

1. Git stores a submodule as a mode `160000` tree entry containing a commit ID, rather than copying all the component's source into the parent. [`git ls-tree` output](../evidence/teaching/frontdoor/output.txt) shows the four core pins used here. [`.gitmodules`](../.gitmodules) supplies the URLs, not proof that a component has passed tests.
2. In [`aienos`](../aienos), `paths()` reads the configured component paths; `pin_of()` reads their staged IDs. `main_of()` asks a remote for its moving `main`. These are different questions: a newer remote branch does not silently replace a pin.
3. `get` initializes submodules at those pins. It downloads code, but does not build, boot or qualify it. `status` compares pins to current remote heads, uses the network and exits nonzero if any is behind or unreachable. It is deliberately not part of this frozen exercise: its output changes as development advances.
4. `bump` validates its requested path with `paths | grep -qx` **before** fetching and staging a replacement. The negative case takes that refusal branch. A valid `bump` does modify a checkout and stage new pins; do not substitute a valid path into this exercise on your working tree.

That separation is the design choice: a recorded source identity should not drift when a remote branch advances. It does **not** follow that all the recorded component revisions work together. Build, ABI and hardware checks still have to establish that.

## One reading path through the stack

Use the exercise's recorded identities to distinguish **what is selected** from **what executes**:

| Stage | Concrete source boundary | What to follow next | What this lesson does not claim |
| --- | --- | --- | --- |
| Front door | [`paths`, `pin_of`, `get`, `bump`](../aienos) and [`.gitmodules`](../.gitmodules) | Resolve a component pin, then read that component at the recorded revision. | Pin consistency is not runtime compatibility. |
| Kernel | [Aienux at the recorded kernel pin](https://github.com/aien-dev/aienux/tree/17ad0167eac91edc280472020679a11969a78609) | Follow its boot, scheduling, IPC and capability walkthrough linked from the [current teaching issue](https://github.com/aien-dev/aienux/issues/442). | A host unit test is not QEMU or a physical boot. |
| Language | [Omega at the recorded language pin](https://github.com/aien-dev/omega-mv/tree/f4a9849fb127f8d2d664dfc56890752ad180c507) | Follow parse/check, canonical identity, realization and result through [Omega's lesson](https://github.com/aien-dev/omega-mv/issues/619). | This historical tree pin is not the newly seeded compiler or an automatic migration to it. |
| Host runtime | [Sovereign core at the recorded runtime pin](https://github.com/aien-dev/aien-sovereign-core-mv/tree/12e71aad80fda23a428317d11b0dac02d1c777f1) | Follow request admission, KV ownership and inference boundaries in [its lesson](https://github.com/aien-dev/aien-sovereign-core-mv/issues/704). | A model-free fixture does not produce or qualify model text. |
| Realization | [FORGE at the recorded realization pin](https://github.com/aien-dev/physics-mv/tree/2043924224b9ecffd79de2c37b2fe7a3a5396e0c) | Follow a request and the verifier that binds its result in [its lesson](https://github.com/aien-dev/physics-mv/issues/74). | A host provider or simulator is not a GPU driver measurement. |
| Retained result | [Receipt shelf](https://github.com/aien-dev/aien-receipts) | Resolve a judged source commit to a bundle, its verdict and content-addressed logs in [the receipt lesson](https://github.com/aien-dev/aien-receipts/issues/3). | A receipt's presence is not PASS; its scope, signature and exact inputs matter. |

These are separate repositories. A component tutorial can intentionally use a newer, separately stated pin than this front door. Do not mix such recipes and call the combination a tested stack. The tutorial must name its own source and dependency revisions.

### Inspect the actual functions

The component exercises use these independently stated source revisions, not a claim that they form one tested executable:

- **Kernel boot and authority:** [`ck_el1_main` in kmain.c](https://github.com/aien-dev/aienux/blob/18e276590424593647cd7c39c6d16c2f9f8d6027/native/kernel/core/kmain.c) reaches memory/interrupt setup and M3 tasks; [`ck_ipc_send` in ipc.c](https://github.com/aien-dev/aienux/blob/18e276590424593647cd7c39c6d16c2f9f8d6027/native/kernel/core/ipc.c) checks handle rights and generations. The host message fixture covers refusal independently of a physical boot.
- **Meaning versus code:** [the program-realization fixture](https://github.com/aien-dev/omega-mv/blob/a8ffd2b912c84197d08f963b05f9c7d8b30a3f8a/tests/realize/test_program_realize.c) constructs a semantic program, realizes and evaluates it. OSC compilation and this semantic-ID path are not a single joined source-to-receipt implementation on this main revision.
- **Request-bound result:** [`forge_realize` and `aegis_verify_realization`](https://github.com/aien-dev/physics-mv/blob/14273c5ce7d13fbc6e410c4fed9aa36837918177/forge/forge_realize.c) construct and verify the host seam. Its [test fixture](https://github.com/aien-dev/physics-mv/blob/14273c5ce7d13fbc6e410c4fed9aa36837918177/tests/test_forge_aegis_host.c) refuses a result replayed for another program. The seam is simulated lowering, not GPU code generation.
- **A hosted request:** [`generate_text`](https://github.com/aien-dev/aien-sovereign-core-mv/blob/754c07b118f41ad899607b60329bd851b1ccb13e/crates/aien-runtime/src/server.rs) is the server entry; [generation.rs](https://github.com/aien-dev/aien-sovereign-core-mv/blob/754c07b118f41ad899607b60329bd851b1ccb13e/crates/aien-inference-abi/src/generation.rs) controls token progression. The lesson's deterministic test does not qualify the server, scheduler, tokenizer, Omega and a real model together.

## Choose a lesson

The issue links below are acceptance records, not claims that a tutorial has already merged. Read the linked front page for the current recipe and its receipt. A limitation or a recorded failed historical replay is useful teaching material, but is not a successful reproduction.

| Component and task | What you learn | Prerequisites and bounded exercise | Expected outcome / qualification boundary |
| --- | --- | --- | --- |
| [Front door](#first-exercise-prove-which-code-a-checkout-names) · [#9](https://github.com/aien-dev/aienix/issues/9) | Immutable pins and safe refusal | Git + shell; inspect 12 pins and refuse an invalid component | Recipe exit 0, invalid path exit 2, index unchanged; **host-only replay recorded** |
| [Aienux](https://github.com/aien-dev/aienux) · [#442](https://github.com/aien-dev/aienux/issues/442) | Boot, scheduling, IPC and isolation | C toolchain; existing host fixture first, QEMU route separately | Host assertions or annotated QEMU logs; no physical boot inferred |
| [Omega](https://github.com/aien-dev/omega-mv) · [#619](https://github.com/aien-dev/omega-mv/issues/619) | Source, semantic identity and realization | Pinned compiler/toolchain; one valid program, equivalent form and invalid input | Actual identity/result plus refusal; CPU and GB10 routes separated |
| [FORGE](https://github.com/aien-dev/physics-mv) · [#74](https://github.com/aien-dev/physics-mv/issues/74) | Request binding and result verification | C toolchain; existing host/simulated request fixture | Matching request accepted, mismatched result refused; no chip claim |
| [Sovereign core](https://github.com/aien-dev/aien-sovereign-core-mv) · [#704](https://github.com/aien-dev/aien-sovereign-core-mv/issues/704) | Admission, batching and KV ownership | Model-free fixture first; pinned model/Spark setup separately | Observed fixture output; generation is a separate qualified route |
| [Synapse](https://github.com/aien-dev/synapse) · [#122](https://github.com/aien-dev/synapse/issues/122) | Changesets and coordination boundaries | Its pinned host tools and existing local fixture | Local checks only; remote collaboration is not implied |
| [Receipts](https://github.com/aien-dev/aien-receipts) · [#3](https://github.com/aien-dev/aien-receipts/issues/3) | Claim → source → bundle → log | Git and the documented verifier; inspect one existing bundle | Digest/verdict interpretation; do not rewrite old evidence |
| [Spark connector](https://github.com/aien-dev/spark-connector) · [#2](https://github.com/aien-dev/spark-connector/issues/2) | Adapter and authority boundary | Existing local/synthetic connector fixture | Local fixture result; no live-account permissions or service deployment |
| [Rig](https://github.com/aien-dev/aien-rig) · [#1](https://github.com/aien-dev/aien-rig/issues/1) | Implementation versus platform plans | Actual crate/toolchain and synthetic fixture where present | Host or platform-specific result explicitly labelled |
| [Training](https://github.com/aien-dev/aien-train) · [#2](https://github.com/aien-dev/aien-train/issues/2) | Training design and measured versus estimated limits | Smallest existing public runnable check, or documented missing pieces | No fictional training command or trained-model claim |
| [Personal site](https://github.com/drakestapleton/drakestapleton.com) · [#31](https://github.com/drakestapleton/drakestapleton.com/issues/31) | Content → pages → deployment | This checkout's actual toolchain, not another site's commands | Local output, historical status and hosting boundaries stated separately |
| [CUDA++](https://github.com/aien-dev/CUDApp) | Kernel encoding, driver objects and launch path | Follow its existing first-kernel guide and hardware requirements | Reuse the existing teaching material; not requalified by this index |

Additional component work is tracked privately. This public index deliberately does not name private repositories, expose their source or copy their artifacts.

### Replayed documentation candidates, not yet a main-branch certification

These exact teaching branches were pushed and their remote heads checked on 2026-10-22. The linked lesson and author receipt remain readable before integration. Parent follow-up replays are linked separately from initial author receipts. Fresh-context source review and protected-branch admission are separate gates. An absence/status inspection below is **not** execution of an unavailable product. The website's failed check is retained rather than changed to PASS.

| Public lesson | Documentation head | Observed bounded replay scope | Evidence |
| --- | --- | --- | --- |
| [aien-dev/aienux](https://github.com/aien-dev/aienux/blob/d77464e9699b026eda6391518074185743c1a5ba/TEACHING.md) | [`d77464e9`](https://github.com/aien-dev/aienux/commit/d77464e9699b026eda6391518074185743c1a5ba) | QEMU M1/M3 and host IPC fixture passed; no physical qualification | [Initial receipt](https://github.com/aien-dev/aienux/blob/d77464e9699b026eda6391518074185743c1a5ba/TEACHING-REPLAY.txt) · [Parent replay](https://github.com/aien-dev/aienux/blob/d77464e9699b026eda6391518074185743c1a5ba/docs/parent-replay-2026-10-22.txt) |
| [aien-dev/omega-mv](https://github.com/aien-dev/omega-mv/blob/c5549362554d5d6ffe06719ac80678f7a6a5791e/TEACHING.md) | [`c5549362`](https://github.com/aien-dev/omega-mv/commit/c5549362554d5d6ffe06719ac80678f7a6a5791e) | AArch64 host program realization fixture passed; OSC source-to-semantic ID and unified receipt remain unverified | [Initial receipt](https://github.com/aien-dev/omega-mv/blob/c5549362554d5d6ffe06719ac80678f7a6a5791e/TEACHING-REPLAY.txt) · [Parent replay](https://github.com/aien-dev/omega-mv/blob/c5549362554d5d6ffe06719ac80678f7a6a5791e/docs/parent-replay-2026-10-22.txt) |
| [aien-dev/physics-mv](https://github.com/aien-dev/physics-mv/blob/efdeb2ad41831987116edcde3c744cd91422f742/TEACHING.md) | [`efdeb2ad`](https://github.com/aien-dev/physics-mv/commit/efdeb2ad41831987116edcde3c744cd91422f742) | Host FORGE/AEGIS seam passed 13/13; no GPU qualification | [Initial receipt](https://github.com/aien-dev/physics-mv/blob/efdeb2ad41831987116edcde3c744cd91422f742/TEACHING-REPLAY.txt) · [Parent replay](https://github.com/aien-dev/physics-mv/blob/efdeb2ad41831987116edcde3c744cd91422f742/docs/parent-replay-2026-10-22.txt) |
| [aien-dev/aien-sovereign-core-mv](https://github.com/aien-dev/aien-sovereign-core-mv/blob/f12c7991542b39ac3cc81a18ab59f54904c30f8e/TEACHING.md) | [`f12c7991`](https://github.com/aien-dev/aien-sovereign-core-mv/commit/f12c7991542b39ac3cc81a18ab59f54904c30f8e) | Synthetic model-free generation-controller test passed; live model request not run | [Initial receipt](https://github.com/aien-dev/aien-sovereign-core-mv/blob/f12c7991542b39ac3cc81a18ab59f54904c30f8e/TEACHING-REPLAY.txt) · [Parent replay](https://github.com/aien-dev/aien-sovereign-core-mv/blob/f12c7991542b39ac3cc81a18ab59f54904c30f8e/docs/parent-replay-2026-10-22.txt) |
| [aien-dev/synapse](https://github.com/aien-dev/synapse/blob/0050738a9efbf4dc1b2a95775165b0be064e469d/TEACHING.md) | [`0050738a`](https://github.com/aien-dev/synapse/commit/0050738a9efbf4dc1b2a95775165b0be064e469d) | Host Git conformance fixture passed 7 cases; no live Radicle promotion | [Initial receipt](https://github.com/aien-dev/synapse/blob/0050738a9efbf4dc1b2a95775165b0be064e469d/TEACHING-REPLAY.txt) · [Parent replay](https://github.com/aien-dev/synapse/blob/0050738a9efbf4dc1b2a95775165b0be064e469d/docs/parent-replay-2026-10-22.txt) |
| [aien-dev/aien-receipts](https://github.com/aien-dev/aien-receipts/blob/ee9b1868bbc2b8f533bd400c5992dbd561f7e34c/docs/TEACHING.md) | [`ee9b1868`](https://github.com/aien-dev/aien-receipts/commit/ee9b1868bbc2b8f533bd400c5992dbd561f7e34c) | signature and tamper control reproduced; underlying Spark gate execution unverified | [Initial receipt](https://github.com/aien-dev/aien-receipts/blob/ee9b1868bbc2b8f533bd400c5992dbd561f7e34c/docs/teaching-replay-2026-10-22.txt) · [Parent replay](https://github.com/aien-dev/aien-receipts/blob/ee9b1868bbc2b8f533bd400c5992dbd561f7e34c/docs/parent-replay-2026-10-22.txt) |
| [aien-dev/aien-rig](https://github.com/aien-dev/aien-rig/blob/8292e249992daaa32fd012479d430786ebd052f4/docs/TEACHING.md) | [`8292e249`](https://github.com/aien-dev/aien-rig/commit/8292e249992daaa32fd012479d430786ebd052f4) | five component placeholders reproduced; RTX result blocked on main | [Initial receipt](https://github.com/aien-dev/aien-rig/blob/8292e249992daaa32fd012479d430786ebd052f4/docs/teaching-replay-2026-10-22.txt) · [Parent replay](https://github.com/aien-dev/aien-rig/blob/8292e249992daaa32fd012479d430786ebd052f4/docs/parent-replay-2026-10-22.txt) |
| [aien-dev/aien-train](https://github.com/aien-dev/aien-train/blob/21e061b42c4c8df102e24666f84e64348f7a2329/docs/TEACHING.md) | [`21e061b4`](https://github.com/aien-dev/aien-train/commit/21e061b42c4c8df102e24666f84e64348f7a2329) | budget arithmetic and missing trainer reproduced; training blocked on main | [Initial receipt](https://github.com/aien-dev/aien-train/blob/21e061b42c4c8df102e24666f84e64348f7a2329/docs/teaching-replay-2026-10-22.txt) · [Parent replay](https://github.com/aien-dev/aien-train/blob/21e061b42c4c8df102e24666f84e64348f7a2329/docs/parent-replay-2026-10-22.txt) |
| [aien-dev/spark-connector](https://github.com/aien-dev/spark-connector/blob/afc836531ddf61764d77f8bae507eac854054a5a/docs/TEACHING.md) | [`afc83653`](https://github.com/aien-dev/spark-connector/commit/afc836531ddf61764d77f8bae507eac854054a5a) | design/absence reproduced; connector implementation blocked on main | [Initial receipt](https://github.com/aien-dev/spark-connector/blob/afc836531ddf61764d77f8bae507eac854054a5a/docs/teaching-replay-2026-10-22.txt) · [Parent replay](https://github.com/aien-dev/spark-connector/blob/afc836531ddf61764d77f8bae507eac854054a5a/docs/parent-replay-2026-10-22.txt) |
| [aien-dev/translate](https://github.com/aien-dev/translate/blob/e4ce3d3c71ee4cf61610a84c620c6140ba0edd97/docs/TEACHING.md) | [`e4ce3d3c`](https://github.com/aien-dev/translate/commit/e4ce3d3c71ee4cf61610a84c620c6140ba0edd97) | Local browser extraction and ignore/code boundaries pass; protection-removal control caught; no external requests; translation NOT_RUN | [Initial receipt](https://github.com/aien-dev/translate/blob/e4ce3d3c71ee4cf61610a84c620c6140ba0edd97/docs/teaching-replay-2026-10-22.txt) · [Parent replay](https://github.com/aien-dev/translate/blob/e4ce3d3c71ee4cf61610a84c620c6140ba0edd97/docs/parent-replay-2026-10-22.txt) · [Additional check](https://github.com/aien-dev/translate/blob/e4ce3d3c71ee4cf61610a84c620c6140ba0edd97/docs/local-boundary-replay.txt) |
| [drakestapleton/aien-architecture](https://github.com/drakestapleton/aien-architecture/blob/53c617244511c821d0991dac406eeef92c934b99/docs/TEACHING.md) | [`53c61724`](https://github.com/drakestapleton/aien-architecture/commit/53c617244511c821d0991dac406eeef92c934b99) | historical ADR/status relation reproduced; enforcement not replayed | [Initial receipt](https://github.com/drakestapleton/aien-architecture/blob/53c617244511c821d0991dac406eeef92c934b99/docs/teaching-replay-2026-10-22.txt) · [Parent replay](https://github.com/drakestapleton/aien-architecture/blob/53c617244511c821d0991dac406eeef92c934b99/docs/parent-replay-2026-10-22.txt) |
| [drakestapleton/aien-sovereign-core](https://github.com/drakestapleton/aien-sovereign-core/blob/c95033446812f88d23a3a7091b3250751995078c/docs/TEACHING.md) | [`c9503344`](https://github.com/drakestapleton/aien-sovereign-core/commit/c95033446812f88d23a3a7091b3250751995078c) | MAX/fallback source inspected; model execution not replayed | [Initial receipt](https://github.com/drakestapleton/aien-sovereign-core/blob/c95033446812f88d23a3a7091b3250751995078c/docs/teaching-replay-2026-10-22.txt) · [Parent replay](https://github.com/drakestapleton/aien-sovereign-core/blob/c95033446812f88d23a3a7091b3250751995078c/docs/parent-replay-2026-10-22.txt) |
| [drakestapleton/aienos](https://github.com/drakestapleton/aienos/blob/2a8864281277c046b67195727ee97a4911d314fa/docs/TEACHING.md) | [`2a886428`](https://github.com/drakestapleton/aienos/commit/2a8864281277c046b67195727ee97a4911d314fa) | guard source inspected; QEMU and hardware not replayed | [Initial receipt](https://github.com/drakestapleton/aienos/blob/2a8864281277c046b67195727ee97a4911d314fa/docs/teaching-replay-2026-10-22.txt) · [Parent replay](https://github.com/drakestapleton/aienos/blob/2a8864281277c046b67195727ee97a4911d314fa/docs/parent-replay-2026-10-22.txt) |
| [drakestapleton/drakestapleton.com](https://github.com/drakestapleton/drakestapleton.com/blob/97b720c341dab1536e1fc6d2f6adeb9bacf1957c/docs/TEACHING.md) | [`97b720c3`](https://github.com/drakestapleton/drakestapleton.com/commit/97b720c341dab1536e1fc6d2f6adeb9bacf1957c) | syntax checks pass; existing copy guard fails at nine lines; full build pending iMac runner | [Initial receipt](https://github.com/drakestapleton/drakestapleton.com/blob/97b720c341dab1536e1fc6d2f6adeb9bacf1957c/docs/teaching-replay-2026-10-22.txt) · [Parent replay](https://github.com/drakestapleton/drakestapleton.com/blob/97b720c341dab1536e1fc6d2f6adeb9bacf1957c/docs/parent-replay-2026-10-22.txt) |

A fresh reader must use the lesson's stated **executable source pin**, not assume its documentation commit and executable input are the same. Component source pins differ from the front-door exercise's frozen pins by design. No combined-stack claim follows from this table.

### Historical and fork reading routes

These repositories have issues disabled. Their documentation work remains in [the tracker](https://github.com/aien-dev/aienix/issues/9), without changing their settings:

- [translate fork](https://github.com/aien-dev/translate): establish the upstream attribution and actual local delta; read the browser extraction/request boundary before trying any upstream network service. This is not evidence that AIEN authored translate.js.
- [Historical AienOS checkout](https://github.com/drakestapleton/aienos): distinguish that implementation from the current C kernel in [Aienux](https://github.com/aien-dev/aienux). Replaying a historical Rust build does not qualify the current kernel.
- [Historical sovereign core](https://github.com/drakestapleton/aien-sovereign-core): keep MAX/Mojo-era dependencies and claims with their historical revision; use the [current runtime](https://github.com/aien-dev/aien-sovereign-core-mv) for the active teaching path.
- [Historical architecture](https://github.com/drakestapleton/aien-architecture): establish revision/status first, then use [current architecture](https://github.com/aien-dev/aien-architecture-mv) and this front door. A design document is not a delivered feature.

## Machine-specific routes

- **Ordinary Mac/Linux machine:** begin with the Git exercise. Choose a documented host fixture next. Downloads and compiler/dependency requirements belong to that component recipe; neither this index nor an uninitialized submodule supplies them.
- **QEMU:** use the Aienux tutorial's exact emulator version, architecture, image and script. Its expected serial log is emulator evidence only. No physical display, disk or network behavior follows from a QEMU PASS.
- **DGX Spark / GB10:** use the component's exact pinned toolchain, driver/client, model identity where needed, hardware prerequisites and retained receipt. CUDA++ explains the driver/kernel boundary. Do not treat host or simulation output as silicon evidence, or run a tutorial against a production model service without its operator's authorization.
- **Pi / native iMac:** follow the kernel's specific platform instructions and recovery requirements, not the generic host recipe. This guide does not flash, install or qualify an image on either machine.

## The engineering method, without an invented origin story

1. **State a decision and its reason.** Link the actual source, contract or ADR. Here the executable and Git representation show why branch names are not substituted for pins. Architectural intent lives in [current ADRs](https://github.com/aien-dev/aien-architecture-mv/tree/main/docs/adr), not an attributed anecdote invented for a tutorial.
2. **Choose a small implementation you can inspect.** The front-door wrapper is a bounded example; a complete stack rewrite is not required to understand it. Existing runtime implementations and seed-born replacements have different lineage and must be named honestly.
3. **Exercise failure as well as success.** A positive-looking output is insufficient if the invalid path also mutates the index. Keep the refusal and its observed exit code.
4. **Measure only what the command measures.** This lesson observes pins, exit status and index identity. It publishes no timing or hardware measurement. Component performance lessons must retain their environment, raw results and physical scope.
5. **Check independently.** A reviewer starts from a fresh checkout, executes the printed commands and compares the observations, rather than trusting a normal test-suite badge or the author's report. Author replay and independent replay must be labelled separately.
6. **Retain the receipt and its limits.** Record revision, environment, command, stdout/stderr, exit status and unresolved prerequisites. Keep failures and NOT_RUN states. A docs branch, a merged PR and a physical-machine qualification are three different facts.

The front-door receipt documents its actual replay. The [tracker](https://github.com/aien-dev/aienix/issues/9) remains open until its component acceptance criteria and review requirements are met; links in this index are not a blanket certification.
