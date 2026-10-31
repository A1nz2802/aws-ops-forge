# Publication Security Review

This is a bounded review of the project before a private-to-public transition,
not a guarantee of secret absence, production readiness or permission to publish.

## Completed read-only checks

At local head `92af9ad`:

- Gitleaks 8.30.1 scanned 19 reachable commits after fetching the four current
  GitHub branch tips into local `refs/audit/github/heads/*`. The first local-only
  pass covered 12 commits; the broader pass also returned zero findings.
- The repository is not shallow. GitHub reported no tags at the time of review.
- Supplemental inspection of 93 historical text blobs found no matched personal
  absolute paths or non-dummy account-sized literals. Historical path checks found
  no private notes, PDFs, Terraform state/plans/private inputs or credential folders.
- Ten retained Actions runs, including both attempts of the publication run,
  yielded 11 log archives. Gitleaks returned zero secret findings for all of them.
  Archives were processed in memory, not persisted as raw logs.
- The three PNGs were visually/OCR reviewed earlier; no matched secret/identifier
  patterns or text metadata were found. OCR is not exhaustive image inspection.
- GitHub repository secrets, variables and workflow artifact inventories were
  empty at this check. This does not cover every possible GitHub credential scope.

The scanner image was pulled from the project's documented registry and pinned:

```text
ghcr.io/gitleaks/gitleaks:v8.30.1
sha256:c00b6bd0aeb3071cbcb79009cb16a60dd9e0a7c60e2be9ab65d25e6bc8abbb7f
```

Scans ran without network or Docker socket, with a read-only repository mount,
dropped capabilities and redacted output. Reports remain under ignored
`local/security/`. Pinning identifies inputs; it is not signature verification.
No credentials were actively validated against providers.

## Reproduce the history check

With a trusted Gitleaks installation, review all available local refs:

```sh
gitleaks git . --log-opts=--all --ignore-gitleaks-allow --redact=100
```

This does not fetch missing remote branches or inspect GitHub logs. Ensure the
refs/clone cover the intended scope before claiming a full-history result. A
nonzero result can be a finding or scanner error; inspect it with secrets redacted.
Do not create a baseline or broad allowlist just to obtain a green result.

## Approved metadata cleanup and delivery

- AWS-identifying metadata was present in three log archives from the two Lab 003
  runs. Account IDs/ARNs are not credentials, and removed resource IDs do not grant
  access. This was metadata hygiene, not evidence of credential compromise.
- After explicit approval, only the detailed logs for runs `40815767972` and
  `40817926160` were deleted. All three attempt-log downloads returned HTTP 404
  afterward. Both runs remain completed/successful; sanitized evidence, digest and
  the trust-repair explanation remain in the lab checkpoint. Other logs were kept.
- Final documentation delivery is approved using a real commit with `[skip ci]`;
  the learner performs the push and then the private-to-public change. Confirm
  delivery and absence of a new run before changing visibility. No AWS mutations,
  workflow reruns, history rewriting or paid-feature activation are included.
- A normal main push still triggers service CI. No automatic security job or AWS
  opt-in flag was added during this review. AWS resources/variables were removed;
  future executions need their own scope. Do not re-provision as a side effect.

## Remaining checks before public visibility

- The repository is still private as of this report. No visibility, billing or
  security settings have been changed by the audit. GitHub exposes Actions logs
  when a repo becomes public; the source scanner does not sanitize them itself.
- Choose a license if reuse is intended. Public visibility alone is not a broad
  open-source permission grant. Inspect applicable free secret-scanning/push
  protection and dependency-alert settings; do not enable paid features implicitly.

## Limits

No scanner proves absence of unknown formats, obfuscated secrets or missed binary
content. Deleted/unreachable Git objects, unqueried refs, PR/issue comments,
external copies and other service settings are outside these checks. No whole-AWS
account inventory or credential-validity assessment was performed. If a real
credential is discovered, revoke/rotate it first; history cleanup alone is not remediation.

Sources: [Gitleaks](https://github.com/gitleaks/gitleaks),
[GitHub secret scanning](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning),
[visibility consequences](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/setting-repository-visibility).
