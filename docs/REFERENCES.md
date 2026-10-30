# References and Reading Guide

Use this page as an index, not required reading. A source being listed does not
mean it was studied. Lab briefs link only relevant sources; checkpoints hold
evidence, not a bibliography duplicated on every step.

## Sources consulted in Labs 002–003

| Source | Used for |
|---|---|
| [GitHub OIDC reference](https://docs.github.com/en/actions/reference/security/oidc#immutable-subject-claims) | Diagnose the real immutable-subject mismatch; verify repository metadata before exact IAM matching |
| [ECR push IAM permissions](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-push-iam.html) | Publisher actions and repository scope |
| [ECR lifecycle](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html) | Priorities, age/count retention and limits |
| [ACT installation/runners](https://nektosact.com/usage/runners.html) | Local runner selection and differences from hosted GitHub |
| [ACT 0.2.89 artifact server source](https://github.com/nektos/act/blob/v0.2.89/pkg/artifacts/server.go) | Listener placement during controller-container migration |
| [Floci 2.3.0 ECR](https://github.com/floci-io/floci/blob/2.3.0/docs/services/ecr.md) | Registry lifecycle, immutable tags and unimplemented features |

Prices were checked when scoping real runs using [ECR pricing](https://aws.amazon.com/ecr/pricing/)
and [GitHub Actions billing](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions).
These are changing contracts, not permanent price guarantees.

## Optional tool refreshers

- [GitHub workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax)
  and [workflow artifacts](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/store-and-share-data).
- [ACT limitations](https://nektosact.com/not_supported.html) and
  [Compose networking](https://docs.docker.com/compose/how-tos/networking/).
- [Terraform dependency lockfile](https://developer.hashicorp.com/terraform/language/files/dependency-lock):
  commit provider selections/hashes; do not confuse it with private state or plans.

## Local study PDFs

The learner keeps the PDFs locally in the working-tree root. Root PDFs are
Git-ignored and must never be staged, copied into documentation or published.

| Reference | Expected local file | Use |
|---|---|---|
| AWS Certified DevOps Engineer - Professional Exam Guide (DOP-C02) | `dop_c02.pdf` | Map labs and revision to task statements and in-scope services; check for a newer guide before exam booking |
| Designing Data-Intensive Applications, 2nd edition | `ddia_2nd.pdf` | Consult targeted sections for general data-system and distributed-systems concepts when a lab needs them |

If a file is unavailable at that path, ask the learner for its location. Do not
search neighboring folders for credentials or add local PDFs to versioned content.

## DDIA Pointers

DDIA was **not assigned or consulted in Lab 003**. That lab focused on delivery
tooling and identity; no reading should be retroactively claimed. For a future
partial-failure discussion, Chapter 9 may help; it is optional, not a CI manual.
The chapter map below was checked against the supplied second-edition contents.
It is a lookup guide, **not a required syllabus or a scope exclusion**. Select a
section when a concrete lab decision needs it; no chapter is ruled out in advance.

| Lab concept | Suggested section |
|---|---|
| Choosing cloud/self-hosted or distributed/single-node architecture | Chapter 1, *Trade-Offs in Data Systems Architecture* |
| Reliability, scalability, operability, latency percentiles | Chapter 2, *Defining Nonfunctional Requirements* |
| Data models and access patterns | Chapter 3, *Data Models and Query Languages* |
| Indexes, storage engines and read/write tradeoffs | Chapter 4, *Storage and Retrieval* |
| Encoding, compatibility, event-driven dataflow | Chapter 5, *Encoding and Evolution* |
| Replication, lag, multi-Region trade-offs | Chapter 6, *Replication* |
| Partitioning and hot keys | Chapter 7, *Sharding* |
| Transactions and delivery semantics | Chapter 8, *Transactions* |
| Partial failure, timeouts, unreliable networks | Chapter 9, *The Trouble with Distributed Systems* |
| Consistency and coordination | Chapter 10, *Consistency and Consensus* |
| ETL, bulk work and data-processing jobs | Chapter 11, *Batch Processing* |
| Messaging, event time, stream fault tolerance | Chapter 12, *Stream Processing* |
| Integrating dataflows, derived state and end-to-end correctness | Chapter 13, *A Philosophy of Streaming Systems* |
| Privacy, accountability, consent and consequences of data use | Chapter 14, *Doing the Right Thing* |

Use only the relevant subsection. Notes in this project must be original summaries, not transcriptions of the book.
