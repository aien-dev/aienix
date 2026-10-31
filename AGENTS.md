# Agents working on AienOS

Read the [shared public rules](https://www.aienos.com/agents/RULES.md), then this file and the README. AienOS is the whole system; Aienux is its kernel. This repository's current address is https://github.com/aien-dev/aienix. Keep that real URL until the repository is renamed; do not point the whole system at the kernel repository.

## Scope and tree

This is a pinned Git-submodule front door, not an imported monorepo or a hardware-qualified release. `.gitmodules` and the gitlinks define the component set and exact revisions. `aienos` is the POSIX-shell entry point. `assets/` holds the wordmarks; `README.md` describes the system and `LICENSE` contains this repository's licence.

Core submodules: `aienux/`, `omega/`, `sovereign-core/`, `architecture/`, `protocols/`, `physics/`. Attachments: `attachments/synapse/`, `attachments/benchmarks/`, `attachments/interplane/`, `attachments/aegis-runtime/`, `attachments/spark-rsi/`, `attachments/open-humanity/`.

Read the relevant component's own instructions before editing it. Component code changes and issues belong in its repository; this repository owns the front door, documentation, submodule declarations and pin changes. Read `.crumb` for directory context, but report stale metadata rather than treating it as implementation evidence. Architecture decisions belong in the architecture component and its accepted ADRs.

## Commands and verification

Prerequisites are POSIX `sh`, Git and ordinary shell utilities. Network access is needed for the component commands.

- `sh -n aienos`: syntax check the front-door script.
- `./aienos help`: non-mutating local usage smoke check.
- `git submodule status`: inspect the recorded component pins without fetching.
- `./aienos get`: initialize components at the pinned commits. This fetches data and updates component worktrees.
- `./aienos status`: query each component's remote `main` and compare it with the pin. Exit 1 means at least one component is behind or unreachable; that is not itself proof of a script defect.
- `./aienos bump path/to/component`: fetch the selected component's current `main`, check it out and stage the gitlink. With no paths it bumps every component. Do not run it merely as a smoke test.

There is no root build manifest, test suite or workflow in the current tree. For script edits, run the syntax and help checks and exercise the changed command in a disposable clone. For a pin update, inspect the exact component commits and their available evidence and run relevant component checks; a remote `main` commit alone does not prove qualification. Report exact commands, outputs and limitations. Host checks do not qualify hardware.

## Contribution and safety

Work on a branch and open a pull request. Push with `git push origin HEAD:refs/heads/your-branch`. Do not merge your own proposal or add an automatic merge label without maintainer authorization. Consult the current maintainer process for merge and qualification policy; this tree has no workflow that establishes it, and historical README prose is not a substitute for current policy.

Keep unrelated submodule pins unchanged. Do not rewrite history, mutate recorded evidence, change trust gates, rename repositories or alter live services as part of onboarding work. Hardware execution requires the owner's explicit scheduling and authorization, not merely possession of a checkout.

Retain Drake Stapleton's public name and attribution. Keep credentials, home-directory paths, private network addresses, internal hostnames and SSH usernames out of tracked files. Use ignored local configuration for machine-specific settings. Never copy local operator configuration into public instructions.
