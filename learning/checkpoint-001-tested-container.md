# Checkpoint: Lab 001 — A Tested Container Before AWS Access

- Status: **CLOSED**; test/build scope demonstrated with security limitations.
- Ownership: mentor supplied Go/tests/Docker packaging; learner authored Actions
  YAML, pinned actions, debugged the runtime assertion and demonstrated gates.
- Next: historical closure only; Lab 002 later completed in its own session.

## Evidence and gaps

| Criterion / task | Outcome | Evidence source and limits |
|---|---|---|
| Tests gate image build, task 1.1 | Demonstrated slice; partial task coverage | Failed hosted run: tests failed, build skipped, cleanup succeeded; restored success |
| Image HTTP health | Demonstrated | Local screenshot and successful hosted runs: 200, exact body |
| Non-root process | Demonstrated | Runtime UID/GID 65532; corrected hosted assertion passed |
| Manual/PR/push triggers | Demonstrated | Hosted manual, PR-to-main and push-to-main runs verified |
| Secret review | Partial | Source/context/metadata and visible history only; not exhaustive layers |
| Cleanup | Demonstrated within scope | Named local container absent; hosted cleanup steps passed |

## Decisions / incidents

- Multi-stage image with allowlisted context; tests separate from build.
- Runner `docker top -eo uid=` failed because PID field was absent; corrected
  to PID-preserving output. Failure was tooling, not proof of root execution.
- Deliberate test assertion inversion blocked build; restored assertion passed.
- Action runtime updates and triggers tested, reviewed and merged.

## Retention / approval / limits

- Retained: local image/build cache, private repository, source and three merged
  work branches; branch deletion was not approved. No AWS operations in this lab.
- Final recorded main revision at closure: `24fe193`; not a current-HEAD claim.
- Hosted run approval gap: one early learner-initiated run preceded its separate
  confirmation. Do not retrospectively label it explicitly approved.
- GitHub quota/spend controls reviewed; final billed usage not checked.
- Not demonstrated: artifact publication, deployment, branch protection,
  byte-reproducibility, dependency readiness or exhaustive image scan.
- No remaining Lab 001 approval authorizes new publication or hosted runs.
- Practical note: `notes/lab-001-tested-container.md` (reconstructed from evidence).
- Detailed run IDs, reviews and approval history: [archive](archive/lab-001-evidence-history.md).
