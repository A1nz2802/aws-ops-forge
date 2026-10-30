# Private Learning Notes

## Purpose: a practical refresher, not another checkpoint

`notes/` is private Spanish study material, ignored by Git. Public lab briefs and
documentation are English and authored separately. Never stage/force-add notes.
If notes are already tracked, report that before changing the index/history.

Write the closure note from actual practice, but optimize it for a later reader:
**What problem did I solve? How do the pieces work? What can I reuse elsewhere?**

| Keep in study notes | Keep in the checkpoint / archive |
|---|---|
| Mental model, small diagram, tool vocabulary | Exact run/commit/image hashes and timestamps |
| Why a design was chosen and its tradeoff | Approval timeline and detailed acceptance ledger |
| Commands with purpose, inputs and expected behavior | Screenshots/log provenance and who verified each deletion |
| A reusable troubleshooting lesson | Machine-specific escalation tools or incidental shell history |
| Short practice scope and unvalidated boundary | Full retained-resource/access inventory |

The note must not invent studied theory or successful commands. A short scope
sentence and checkpoint link suffice; do not repeat evidence caveats everywhere.
Never store credentials, real account IDs, raw tokens/state/plans or copied PDFs.

## Authoring at closure

- Write/update `notes/labs/lab-<id>-<topic>.md`, including partial closures, and link
  it from `notes/START-HERE.md`. Use `notes/plantillas/LAB-NOTE-TEMPLATE.md` when present.
- Keep reusable tool explanations under `notes/fundamentos/<tool>/`; labs apply
  the tools and link fundamentals instead of copying the same theory everywhere.
- Explain newly used tool concepts briefly or link one reusable concept note.
  Existing experience does not imply familiarity with every CI tool.
- Show native `aws`, `terraform`, `docker` or `gh` commands first, with placeholders
  and a clear execution context. Explain `./forge`/CI wrappers once as this
  project's invocation, not as portable tools or the concept itself.
- Select representative commands; explain useful flags and expected results.
  Separate optional reference helpers from what was practiced, without a transcript.
- Prefer concise prose, small tables and code blocks; avoid giant command tables,
  long digests, ceremony or infrastructure-specific trivia that obscures learning.
- Include one genuine lesson and a short cleanup/limits summary; detailed evidence
  stays in the checkpoint. Suggested length is not a gate: cut redundancy first.
- Keep one engineering section when requested. Add reusable notes only for a real
  recurring need, not one atomic note per term. Recall prompts are optional.
- Fresh clones may lack notes: initialize Spanish notes/index/template locally at
  closure. No Obsidian/community plugin is required and absence never blocks closure.

## Vault integration

The ignored project directory is the source of truth. Link it into an existing
vault only after the learner supplies the **exact** vault path. Never search
personal vaults or inspect unrelated notes. Do not overwrite any destination,
including dangling symlinks, or commit a personal absolute path/external symlink.

```sh
VAULT="<exact-existing-vault-path>"
test -d "$VAULT" &&
  test ! -e "$VAULT/AWS Ops Forge" &&
  test ! -L "$VAULT/AWS Ops Forge" &&
  ln -s -- "$PWD/notes" "$VAULT/AWS Ops Forge"
```

Use native properties, local wikilinks/headings and no nested `.obsidian/` here.
Paths outside notes are project references, not vault wikilinks. Check navigation
in Obsidian after setup; filesystem link verification does not prove indexing.
Moving the project needs a link update; remove only the vault entry to unlink it.
