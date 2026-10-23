# Lab 000: Establish a Safe AWS Engineering Workspace

## Scenario

You are joining ParcelFlow as its first platform-minded backend engineer. The team has approved an AWS Free plan account for learning and prototyping, but has no written operating procedure. A command run under the wrong profile or region could expose data, consume credits, or create an unexpected bill. Before building the service, you must establish how you will know which identity and account a tool is targeting and how you will decide whether an action is safe.

This is a planning and verification lab. **Do not create, modify, or delete AWS resources in this lab.** Do not upgrade or otherwise change the account plan. The account has not yet been inspected by this project.

## Business Requirements

- Avoid AWS charges during this lab.
- Keep existing credentials private and do not copy them into this repository.
- Make accidental use of the wrong account/profile/region detectable before a future write operation.
- Determine what must be checked before a future AWS deployment and how resources will be tracked and cleaned up.
- Produce a short, reusable operating checklist suitable for a public portfolio without account-specific secrets or identifiers.

## Acceptance Criteria

- [ ] Explain the difference between a Free plan, credits, free usage allowances, and a hard spending limit; identify which account facts remain unknown.
- [ ] Propose a credential and profile approach that avoids long-lived access keys where feasible and never exposes secret values.
- [ ] Design a pre-flight check that confirms the intended identity, account, region, and endpoint before any future mutation.
- [ ] Propose a safe approval, cost-estimation, tagging/naming, and teardown procedure for later labs.
- [ ] Identify at least three ways a lab can still create cost or risk even when described as free-tier or temporary.
- [ ] Publish no account IDs, credentials, private PDFs, or personal filesystem paths in the lab artifact.
- [ ] No AWS resource was created or changed; support this claim with the scope of actions taken, not an unsupported assertion about the account.

## Investigation Boundaries

- You may reason from official AWS documentation and inspect local tool configuration without revealing any credential content.
- Before suggesting any command that could access authenticated account data, explain what it reads and ask the learner to approve that inspection.
- Do not run `aws configure`, print environment variables containing credentials, list local credential files, or run mutating AWS commands.
- This lab does not configure the AWS Agent Toolkit or its authenticated MCP server.

## Deliverable

Create `labs/000-safe-aws-workspace/operating-checklist.md` in English. Keep it concise and general: pre-flight, cost review, approval, execution boundary, evidence, cleanup, and incident response if the wrong target is detected. Do not include real account-specific values.

## Reflection

Be ready to explain which checks are advisory rather than preventive controls, what account plan and credit questions still require console verification, and what evidence would be sufficient to approve the first resource-creating lab.

## DOP-C02 Mapping

- Task 2.2: account structures and secure account onboarding (conceptual preparation only)
- Task 6.1: human and machine identity choices (design only)
- Task 6.3: security auditing and common credential threats (design only)
- Cost optimization: operational concept (no cost optimization service configured)

## DDIA

No reading is required. If reasoning about operational risk and human error becomes relevant, consult Chapter 2, *Defining Nonfunctional Requirements*, especially *Humans and Reliability* and *Operability: Making Life Easy for Operations*.
