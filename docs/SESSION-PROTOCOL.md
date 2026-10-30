# Lab Workflow

`AGENTS.md` is the contract. This file explains how to use it, not a second
set of agent permissions. One lab per session; harness maintenance may continue
after closure without starting another lab.

## Start or resume: `/lab-start <id>`

Load only progress, the requested brief/checkpoint and directly relevant files.
A checkpoint means resume: summarize the current state and continue, not another
quiz. A fresh lab starts with business context, constraints, acceptance criteria,
scaffold/learner ownership, and one design or prediction.

Then work in short blocks:

```text
Design/prediction -> hands-on block -> evidence/troubleshooting -> next decision
```

Ask only questions that change a decision or reveal a useful misconception.
Do not make the learner repeatedly reconstruct an already demonstrated answer.
Batch related mechanical edits/commands into one practice block and review its
evidence together, rather than requiring a separate "saved/done" exchange per step.
`/lab-resume` is retired; `/lab-start <id>` handles both paths.

## AWS phase approval

Before a real-AWS phase, verify context and describe a bounded scope. Example
shape, not authorization for any current lab:

| Field | Agree before work |
|---|---|
| Goal and target | Account verified privately, identity/profile, region; current Free plan/credits checked for freshness |
| Specific actions | Login/STS, named reads, plan, create/update/delete of named resources; list exactly which are included |
| Limits | Cost estimate/budget, duration/size, permissions, excluded features |
| Evidence | Plan review, service readback, expected failures and cleanup checks |
| Cleanup | Exact resources to remove and artifacts/access to retain |
| Stop conditions | Unexpected target, plan, resource/data, cost or privilege change |

One explicit learner approval can cover this listed set, including specifically
described creation and teardown. If only a read phase was approved, mutations
are not included. Root/IAM changes need their own explicit scope unless already
named and approved. The learner executes mutations; agents do not.

Continue approved steps without asking permission again for every command.
Still inspect results and stop on deviations. A session/day change calls for a
context freshness check, not automatic cancellation of every valid approval;
do not carry approval into a different lab or assume expired approval persists.
Record the scope and its validity in the checkpoint when resuming is possible.

Local-only work and documentation do not need extra conversational consent.
OpenCode's shell/external-directory prompts are separate technical controls;
do not globally allow shell to eliminate those prompts.

## Pause: `/lab-checkpoint`

Replace the current checkpoint using `learning/LAB-CHECKPOINT-TEMPLATE.md`.
Record current evidence, approval validity, retained resources and next action;
do not append the chat. `PROGRESS.md` only indexes current state and coverage.
Archive long historical evidence only when needed to preserve provenance.

## Close: `/lab-close`

1. Assess criteria: demonstrated / partial / not demonstrated / not applicable.
2. Complete approved cleanup and verify it; identify intentional retention and
   unverified concerns. Do not infer absence from `destroy` alone.
3. **Write the private Spanish lab note now**, while commands, decisions and
   incidents are fresh. Follow `docs/LEARNING-NOTES.md` and any local template;
   update the private Obsidian index. Use real evidence, not an idealized solution
   or copied logs. The whole `notes/` directory is ignored, never a commit candidate.
4. Replace the checkpoint with a compact closure assessment and link any history;
   update the progress index. Public summaries stay in English, separate from
   private Spanish notes. Before any requested final Git delivery, inspect CI
   triggers against the post-cleanup state: documentation/source publication is
   not authorization for a new deployment. Agree a non-running delivery where
   appropriate; do not silently disable security controls or rewrite pushed commits.
5. Explicitly tell the learner in Spanish to open a new session for the next lab.

A partial closure still gets an honest note. Obsidian installation or a missing
vault symlink is not a gate: notes are usable private, Git-ignored Markdown.
