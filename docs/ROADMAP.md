# Competency Roadmap

Progress is based on demonstrated capability, not weeks or a target date. The
sequence is provisional; use `learning/PROGRESS.md` for actual completed scope.

| Stage | Challenge themes | Evidence of capability |
|---|---|---|
| 0. Safe workspace | Identity, account context, CLI profiles, cost awareness, repository hygiene | Can establish which identity/account/region a command targets and explain safe operating boundaries without deploying resources |
| 1. Refresh and ship a service | API, persistence, IAM roles, events, retries, idempotency, tests | Can build and explain a small Go service and reproduce its environment |
| 2. Delivery automation | CI, artifact handling, deployment strategies, rollback, secrets | Can promote a tested immutable artifact and diagnose a failed deployment |
| 3. Operate and observe | Logs, metrics, traces, alarms, SLOs, event response | Can find a fault from evidence, identify impact, and improve detection |
| 4. Resilience and recovery | Queues, scaling, backups, restore tests, RTO/RPO, failure injection | Can measure recovery behavior and explain remaining failure modes |
| 5. Infrastructure and governance | CloudFormation, Terraform, drift, multi-Region/account design, security controls | Can make a safe change reproducibly and justify scope, ownership, and blast radius |
| 6. Agent-assisted operations | AWS Agent Toolkit, MCP/skills, scoped identity, audit, human approval | Can use agent capabilities for a real task while constraining access and independently verifying actions |
| 7. Integrated operations exercise | Changing requirements, incident response, cost and architecture trade-offs | Can solve a novel scenario, present evidence, and identify what remains unvalidated |
| 8. Exam consolidation | DOP-C02 task review, question practice, gap-driven revision | Can explain service choices and resolve weak areas across every exam domain |

## Scenario Thread

ParcelFlow is a fictional shipment-event SaaS. Customers submit events; the service validates and records them, processes asynchronous work, and delivers notifications. Requirements evolve to introduce duplicate delivery, bursts, provider failures, deployment regressions, audit needs, recovery objectives, and organizational constraints. Not every service is deployed in every stage; alternatives should be compared before adding complexity.

## IaC and Runtime Choices

- Begin with bounded CLI exploration, then make one IaC tool the owner of each resource set.
- Terraform was selected by the learner for Lab 002. Continue with one IaC owner
  per resource set; introduce CloudFormation deliberately for a relevant DOP-C02
  comparison, not as a second owner of existing resources.
- Never have CloudFormation and Terraform co-manage the same resources.
- Introduce Ansible only for a lab where configuring a host is itself a learning objective; compare it with image baking, cloud-init, or Systems Manager.
- Use Go for the evolving application unless the learner elects to change that choice.
- Prefer Floci for rapid local application/API feedback where operations are supported. Record the emulation boundary and validate important service-specific behavior in AWS only with approval.

## Dedicated Toolkit Lab

The Agent Toolkit for AWS lab follows foundational IAM and operations practice. It compares documentation/skills with authenticated runtime tools, designs a dedicated least-privilege agent identity, tests read-only investigation before any write capability, evaluates CloudTrail/CloudWatch audit evidence, and compares learner-only versus agent-assisted incident work. No agent receives permission to deploy or destroy resources by default.
