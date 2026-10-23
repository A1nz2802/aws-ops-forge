# Private Learning Notes

## Language and publication boundary

- `notes/` contains **private Spanish learning notes**, not public portfolio
  artifacts. `/notes/` in `.gitignore` excludes the entire directory.
- Public documentation, briefs, evidence summaries and examples remain in English.
  This English policy is public-safe; the notes and their local templates are not.
- Never stage, force-add, commit or publish notes. Before a commit, check both
  tracked files and staged paths: ignore rules do not untrack existing files.
- Private does not mean a place to copy credentials, tokens, raw state/plans,
  personal vault paths or private PDFs. Do not reproduce copyrighted passages.

## Closure workflow

The mentor writes/updates one concise note **in Spanish at each lab closure**,
including partial closures, using the actual session evidence. Reconstructed
historical notes must say so. Do not invent successful steps or a complete CLI
history when only service actions/results were recorded.

Create `notes/lab-<id>-<topic>.md` and link it from the private `START-HERE.md`.
Use the local `LAB-NOTE-TEMPLATE.md` if available. On a fresh checkout these
ignored files may be absent: initialize the index, short Spanish README and
template from this policy, without adding them to Git.

Aim for a fast refresher, usually 40–90 lines:

1. Native Obsidian properties: note type, lab, outcome/status and a few tags.
2. Outcome and evidence boundary; distinguish observed, reported and unvalidated.
3. A small ASCII flow only when it helps, plus a compact decision/result table.
4. Selected commands, including profile/authentication/inspection when relevant,
   with runtime/directory and expected results. Label added reference helpers
   separately from evidenced commands; link shared references to avoid repetition.
5. One actual troubleshooting lesson; cleanup/retention and unvalidated limits.
6. Local wikilinks/heading links and project-relative evidence references.

Write human-readable titles, headings and prose in Spanish. Preserve literal
command syntax, service names and code identifiers. No community plugin is
required; no transcript/log dump. Recall prompts are optional. Add a separate
concept/incident reference only when it is reusable, not as a quota.

Keep the notes self-contained. Paths outside `notes/` are project references,
not vault wikilinks. Check headings after translation. Notes summarize learning;
checkpoints/archives hold detailed evidence and current execution state.

## Existing-vault integration

```text
Existing vault/
└── AWS Ops Forge -> <project>/notes/
```

Ask for the exact vault location before creating a link. Verify the parent and
ensure the destination is absent, including dangling symlinks. Do not search for
personal vaults, inspect unrelated notes or overwrite a destination. A Linux
pattern from the project root, after explicit path confirmation, is:

```sh
VAULT="<exact-existing-vault-path>"
test -d "$VAULT" &&
  test ! -e "$VAULT/AWS Ops Forge" &&
  test ! -L "$VAULT/AWS Ops Forge" &&
  ln -s -- "$PWD/notes" "$VAULT/AWS Ops Forge"
```

Do not store the real absolute path or an external symlink in the repository.
The project holds the real, ignored Markdown; the vault holds the symlink. Do
not add a nested `.obsidian/` directory here. Verify index/heading navigation in
Obsidian after setup; client/sync behavior varies. A missing link never blocks
lab closure. Removing the integration means unlinking only the vault entry,
not deleting its target notes. Moving the project requires updating the link.
