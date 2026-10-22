# Front-door lesson execution

Date: 2026-10-22. Executed by the documentation authoring agent on an ordinary Mac, twice in separate fresh GitHub clones. This is author replay, not independent review or physical-stack qualification.

- Source: `aien-dev/aienix@d575aab28b2a635dd08b452f5995b2156c6b9213`.
- Environment: macOS 26.6.2 (25G83), arm64; Git 2.50.1 (Apple Git-155); POSIX `sh` supplied by GNU Bash 3.2.57(1)-release.
- Command: the complete first `sh` block in [docs/LEARN.md](../../../docs/LEARN.md), copied verbatim to a scratch script and executed with `sh`; initial HTTPS clone from GitHub, no recursive submodule fetch. `TMPDIR` was an existing writable scratch directory.
- Input fixtures: the source revision's `.gitmodules`, recorded Git tree and the literal invalid path `not-a-component`.
- Observed recipe exit status: **0** on both fresh-clone executions.
- Observed invalid-path exit status: **2**; index tree before/after identical. Four displayed pins matched the documented values; component count **12**.
- Raw observed stdout/stderr: [output.txt](output.txt). No timing measurement is claimed.
- Source SHA-256: `aienos` = `9fb80b0d3314fa64f13139c3f9d8fb4661ba9b33a8417d144fff143edc09fce0`; `.gitmodules` = `7f711f92f7bd5fe2597c327f195a710b614d33d51e81b0be24648c00b11fee9f`.

This establishes only Git pin inspection and the existing wrapper's unknown-path refusal. Component builds, ABI compatibility, QEMU, physical hardware, models, performance, signatures and whole-stack behavior were **NOT_RUN**. No runtime, submodule pin, gate or historical receipt was changed. Network-dependent `status`, successful `bump` and component download `get` were intentionally outside this safe recipe and are not called reproduced.

The expected tree-output columns in the guide are space-separated for readability; the retained raw log has Git's literal tabs. The refusal file is an untracked scratch observation, not a signed verification bundle.
