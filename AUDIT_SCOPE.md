# Audit scope

Written for an outside, independent security audit. Revision described:
`59b32f2` on `main` (2026-10-31; the only change since `292a38cd` on 2026-10-26 is the docs-only
proposal `docs/plans/2026-10-16-single-source-of-truth.md` with its receipts). Everything below is taken from
the repository's own files at that revision; items marked NOT_RUN were not executed while writing
this document.

## What this repository is

The AienOS front door. It links six core components and six attachments as Git submodules pinned at
exact commits, so one clone fetches versions that belong together. It contains one executable, the
69-line POSIX shell script `aienos` (`get`, `status`, `bump`, `help`), plus `README.md`,
`AGENTS.md`, two SVG wordmarks in `assets/`, `.crumb` metadata, a docs-only plan proposal under
`docs/plans/` and `LICENSE` (AGPL-3.0-or-later).
Component code is not here; it is developed in each component's repository. README states it is not
a release, a finished system, or a claim of hardware qualification.

## What an auditor can and cannot check here

- Can check: the `aienos` script, the `.gitmodules` URL list against the gitlinks, and whether
  tracked files carry private data.
- Cannot check here: any component's code, tests or evidence. The pins name revisions; they do not
  certify them. AGENTS.md: "a remote `main` commit alone does not prove qualification."

## What to review, in priority order

1. `aienos` (shell). Reads `.gitmodules` with `git config -f`, calls `git ls-remote`,
   `git submodule update --init --depth 1`, `git fetch` and `git checkout --detach`, and stages the
   gitlink with `git add`. Check:
   - quoting of submodule paths and URLs taken from `.gitmodules`;
   - that `bump` only accepts a path already listed in `.gitmodules` (it checks with
     `paths | grep -qx "$p"`, which treats the argument as a regular expression);
   - that `status` exits non-zero when a component is behind or unreachable, and `bump` exits 2 on
     an unknown path and 1 on an unreachable `main`;
   - that nothing is committed or pushed (the script says it stages only).
2. `.gitmodules` (12 submodules, all `https://github.com/aien-dev/...`) and the gitlinks
   (`git ls-files -s`, mode 160000). Check every URL is the repository the README table names and
   that no gitlink was moved without a matching pull request.
3. `README.md` and `AGENTS.md`. Commands an operator copies (`git clone --recurse-submodules
   --shallow-submodules`, `./aienos status`).
4. `assets/*.svg`. Static wordmarks referenced by README; `.crumb` says they have no external
   assets. Check they contain no script.

There is no `.github/workflows/` directory; AGENTS.md: "There is no root build manifest, test suite
or workflow in the current tree."

## Trust boundaries

- Untrusted at run time: remote replies from `git ls-remote` and `git fetch` for each component URL.
- Trusted: the URLs in `.gitmodules` and the pinned gitlinks as reviewed in pull requests; Git.
- The pins are source revisions only. Any verdict on a component comes from that component's own
  workflow and receipts.

## Threat model summary

- Assets: the mapping from component name to exact source revision that users clone.
- Attackers considered: a pull request that redirects a submodule URL or moves a pin silently; a
  hostile remote or path that abuses the shell script.
- Defended: changes arrive by pull request; `bump` stages, never commits; pins are exact commits.
- Not defended / explicitly out of scope: integrity of component content behind a pin; GitHub
  availability; Git's own submodule handling.

## Build from source at a pin

Nothing to build. Prerequisites per AGENTS.md: POSIX `sh`, Git and ordinary shell utilities;
network access for the component commands.

```sh
git clone --recurse-submodules --shallow-submodules https://github.com/aien-dev/aienix.git
```

## Run every test

There is no test suite. AGENTS.md lists these checks (NOT_RUN while writing this document):

```sh
sh -n aienos            # syntax check
./aienos help           # non-mutating usage output
git submodule status    # recorded pins, no fetch
./aienos get            # network: initialise components at pinned commits
./aienos status         # network: exit 1 if any component is behind or unreachable
```

AGENTS.md says not to run `./aienos bump` merely as a smoke test; exercise it in a disposable
clone.

## Known limitations and NOT_RUN

- `aienos status` exiting 1 means a component is behind or unreachable, not a script defect
  (AGENTS.md).
- No automated check that `.gitmodules` URLs and pins match a reviewed list.
- Component evidence is not linked from this tree at this revision.

## Dependencies and provenance

- No lockfile, no vendored code. `.gitmodules` plus gitlinks act as the pin file.
- Network access to github.com for `get`, `status` and `bump`.
- No GitHub Actions.

## Evidence

No receipts live here. Component receipts are published by each component's verification
workflow; README names `aien-dev/aien-receipts` as the append-only store of signed verification
receipts, one per judged commit.
