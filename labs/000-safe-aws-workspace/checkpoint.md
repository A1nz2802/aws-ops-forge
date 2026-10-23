# Lab Checkpoint: 000 - Safe AWS Engineering Workspace

- Status: closed with partial completion; unresolved deliverable explicitly retained
- Last updated: 2026-10-07
- Current stage: local practice and cleanup assessed; harness retrospective completed
- Next safe action: open a new dedicated session to scope the next practical lab; no AWS provisioning is approved
- Learner's current hypothesis/decision: use containerized tooling, temporary non-root credentials where feasible, and explicit effective-target checks; reject mismatches or failed inspection. IAM access provisioning is proposed only and remains outside this lab.
- Verified evidence: learner screenshots show CLI 2.32.7 on Alpine 3.23, profile configuration, region environment precedence, exit codes 0/1/1 for match/mismatch/missing profile, and next-step gating with `&&`. Saved script passed mentor-run `sh -n`; runtime tests were learner-run, not independently repeated.
- Acceptance criteria: partial. Reasoning about costs, identity, approval, and teardown demonstrated in discussion; full pre-flight design and written operating checklist remain pending. Local region guard does not verify AWS identity/account/endpoint/permissions.
- Hints already used: STS identity concept; CLI profile and region selection; shell capture, comparison, explicit failure handling, and exit-code gating
- Open questions and assumptions: no authenticated CLI identity, intended deployment region, or effective permissions verified. CLI `configure list` did not display the global `--region` override in the learner's test; do not treat it as proof of a future service call's destination. Text parsing is a lab simplification.
- AWS/local resources that may still exist: no AWS resources created within the reported lab action scope; active disposable container, local Docker images, and build cache may remain
- Cleanup status and evidence: AWS mutations were not performed; no claim that the entire account is empty. Learner screenshot of `docker ps -a --filter ancestor=aws-ops-forge:lab000` showed no matching containers. Images and build cache remain intentionally; containers from other images were not assessed. Final script is saved in the repository.
- AWS-real validation still required: approved manual console inspection confirmed Free plan and displayed credits and remaining plan duration; authentication and permissions remain unvalidated
- DOP-C02 task statements: 2.2, 6.1, 6.3
- Suggested retrieval questions: What does a billing alert fail to guarantee? How can you prove which AWS identity and account a CLI command will use without exposing a secret? Which pre-flight checks are advisory rather than preventive controls?

## Harness retrospective so far

- Final script uses explicit read-failure handling and POSIX `test`, without dumping configuration. Mentor re-read the saved file and repeated `sh -n`; learner reports match/mismatch/missing-profile tests still return 0/1/1. Runtime tests were not independently repeated.

- Learner prefers doing and troubleshooting over repeated recall and memory-based checklist drafting.
- Keep safety and per-lab scope boundaries; shorten repeated questions and defer concise documentation until after practice.
- No specialist-agent or workflow expansion is needed for this local exercise.
- Closure: learner agrees with the proposed simplifications and reports that CLI use, shell practice, and checking script behavior support understanding. Retrospective complete; do not add more recall loops or tool exercises without a concrete lab need.

## Closure assessment

- Demonstrated in discussion: cost concepts and multiple risk sources; distinction between IAM authorization and operational approval; teardown verification and ownership.
- Partial: temporary non-root access strategy and full pre-flight/approval procedure. No identity was provisioned or authenticated through CLI.
- Demonstrated locally: region profile/environment behavior, failure rejection, and next-step gating, based on learner screenshots and reported reruns; final artifact statically reviewed.
- Pending: English operating checklist; full account/identity/endpoint pre-flight design; effective permissions and real-AWS identity checks. Do not count these as demonstrated.
- Scope evidence: local Docker/package/configuration/script work and approved read-only console billing inspection only; no AWS mutations in the reported lab actions. No account-wide resource inventory claim.
- Public artifact review: Dockerfile and final script contain no credentials or real account identifiers; screenshots and private billing values were not copied into repository artifacts.
