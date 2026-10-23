# AWS Ops Forge

**A hands-on journey through AWS delivery automation, infrastructure, observability, and resilience.**

AWS Ops Forge is a problem-driven learning lab for an experienced backend engineer refreshing AWS and building practical DevOps capability. It connects hands-on engineering to the AWS Certified DevOps Engineer - Professional (DOP-C02) blueprint while exploring broader architecture trade-offs.

## How the Lab Works

Each lab presents a realistic business problem, constraints, and observable acceptance criteria. The learner reasons about a design, investigates with the AWS CLI and documentation, explores manually where useful, automates the result with infrastructure as code, and tests failure or changed requirements. The tutor guides with questions and progressive hints rather than giving away the challenge solution.

Labs are independent OpenCode sessions. `learning/PROGRESS.md` is a short index;
compact checkpoints preserve current evidence and next actions. Private Spanish
notes are written locally at closure for fast refresh in Obsidian; `notes/` is
Git-ignored and not published. See [the note policy](docs/LEARNING-NOTES.md).
Close a lab before starting the next one in a new session.

## Learning Principles

- Prefer evidence and explanation over copied recipes.
- Default to local experiments and zero AWS spend; require explicit approval before real AWS mutations or any planned spend.
- Treat local emulators as fast feedback, not proof of AWS fidelity.
- Use AWS CLI, Go, CloudFormation, and Terraform intentionally; use Ansible only where host configuration warrants it.
- Keep theory concise and consult DDIA only when a lab needs a general distributed-systems concept.
- Work in short design/practice/review blocks. Approve specific AWS actions as
  bounded phases; keep checks without repeating consent for each command.
- Keep closure notes practical: selected commands, decisions, troubleshooting,
  cleanup/limits and a small diagram only when useful. Recall prompts are optional.

## Start Here

1. Read `docs/ROADMAP.md` and `docs/SESSION-PROTOCOL.md`.
2. Review `learning/PROGRESS.md`.
3. In a dedicated OpenCode session, run `/lab-start <id>` to start or resume.
4. Use `/lab-checkpoint` before ending an interrupted session and `/lab-close` only when ready to assess the lab.

Lab 000 practiced a local region guard without resource provisioning; its
remaining identity/preflight gaps are recorded, not assumed complete. See the
progress index for subsequent labs rather than restarting Lab 000 by default.

The working contract is [`AGENTS.md`](AGENTS.md); command/approval flow is in
[`docs/SESSION-PROTOCOL.md`](docs/SESSION-PROTOCOL.md). Link notes into an existing
Obsidian vault only after confirming its path; see
[`docs/LEARNING-NOTES.md`](docs/LEARNING-NOTES.md).

## Current Status

For the shared local Go, AWS CLI, and Terraform environment, see
[`tools/README.md`](tools/README.md). Start with `./forge build` and `./forge`.
Starting the tools environment does not authenticate or authorize AWS actions.

See `learning/PROGRESS.md` for the active lab, evidence, and next step. The roadmap is competency-based and has no fixed study schedule.

## Safety

Never commit credentials, access keys, account-specific secrets, local Terraform state/plans, or private study material. Do not deploy to AWS based on a Free Tier label alone. Billing alerts are not hard spending caps. Verify account, profile, region, current plan/credits, expected charges, and teardown before any approved deployment.

## Study References

The DOP-C02 exam guide and DDIA second-edition PDF are optional local references kept outside this repository. See `docs/REFERENCES.md`; the PDFs are not redistributed here.
