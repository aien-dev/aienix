# Security policy

## Reporting a vulnerability

Report privately. Do not open a public issue, pull request or discussion about it.

1. GitHub: open this repository's Security tab and choose "Report a vulnerability". This
   creates a private advisory that only the maintainers can see. If that option is not shown,
   private vulnerability reporting has not been enabled for this repository yet; use email.
2. Email: drake@aienos.com with the subject `[aienix] security report`.

Include the commit or release you tested, the component (path), steps to reproduce, and what an
attacker gains. If the report involves a secret, say where it was exposed and do not send the
secret itself. Encrypted mail is not required; do not post proof-of-concept payloads publicly.

## Response targets

This project has one maintainer; the targets below are best effort and stated honestly.

- Acknowledgement: within 3 working days.
- Triage and severity: within 7 days of acknowledgement.
- Fix or mitigation for confirmed issues: aim for 30 days for high and critical, 90 days
  otherwise, with a status update at least every 14 days until closed.
- Disclosure: coordinated. An advisory is published with credit (unless you ask otherwise)
  once the fix is on the default branch. Default embargo 90 days, negotiable.

## Scope

This repository is a front door: `.gitmodules`, pinned gitlinks, the POSIX shell script `aienos`,
two wordmark SVGs and documentation. Component code lives in each component's own repository.

In scope:

- The `aienos` script: a way for a crafted `.gitmodules` entry, submodule path or remote reply
  to make `get`, `status` or `bump` run commands, write outside the clone, or stage something
  other than the named component's `main` commit.
- A `.gitmodules` URL or gitlink that points somewhere other than the component the README
  names.
- Credentials, home paths, private addresses, internal hostnames or SSH usernames in a tracked file
  (AGENTS.md forbids them).

Out of scope:

- Vulnerabilities inside a component (`aienux/`, `omega/`, `sovereign-core/`, `architecture/`,
  `protocols/`, `physics/`, `attachments/*`). Report those in the component's own repository.
- Git itself and the host operating system.

## Supported versions

Only the default branch `main`; there is no release. README: "What this repository is not: a
release, a finished system, or a claim of hardware qualification." Reports against older commits
are welcome but fixes land on the default branch only.

## Status

AGENTS.md: a pinned Git-submodule front door, not an imported monorepo or a hardware-qualified
release. This repository has no verification workflow; its pins select source revisions, not
verdicts (README). No certification, no bug bounty. See AUDIT_SCOPE.md for what to review.
