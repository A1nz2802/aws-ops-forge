# Checkpoint: Guided Non-root Temporary Access

- Status: practice completed; Lab 000 is not reopened and its unresolved deliverables remain pending.
- Last updated: 2026-10-08.
- Business objective: operate AWS CLI from disposable Docker tooling using a non-root identity and temporary credentials, without long-term access keys or a plan upgrade.
- Design: standalone IAM console user `forge-learner` with MFA; AWS-managed `SignInLocalDevelopmentAccess`; browser-based `aws login --remote`; named profile `forge-learner`; selected region `us-east-2`.
- Constraints: default zero spend; exact action approval before AWS operations; no credentials, account identifiers, or billing screenshots in public artifacts.

## Evidence assessment

- Demonstrated by learner screenshots: CLI 2.32.7; active Free plan with available credits; final Docker listing had no containers matching `aws-ops-forge:lab000`.
- Demonstrated by learner-reported manual AWS tests: console login requested MFA and succeeded; named-profile temporary login succeeded; STS GetCallerIdentity returned the intended account and `forge-learner`; S3 ListBuckets was denied with exit code 254.
- Learner-confirmed configuration, not independently inspected: no IAM groups or access keys; only the requested sign-in policy attached; MFA enrolled.
- Demonstrated cleanup output: `aws logout` removed cached login credentials for the named profile. Output explicitly warned that tools with an already-loaded access token may continue using it until expiration, and stated a 15-minute access-token lifetime.
- Not demonstrated: server-side revocation, token expiry by timed testing, complete effective-permission inventory, CloudTrail authentication-event investigation, MFA conditions on all API operations, automated IaC reproduction.
- DOP-C02 task 6.1: partial coverage. A single-user lab is not organizational-scale identity management.

## Safety and retained state

- IAM user, console password, MFA device, and policy attachment intentionally retained. Future alteration or deletion requires new specific approval.
- Disposable container removed according to the final image-filtered listing. Docker image/build cache remain; other images, containers, and mounted storage were not inventoried.
- No deployment resources were reported created; no account-wide emptiness claim.
- Approval deviations: user creation, MFA enrollment, and CLI login/profile correction occurred before the respective specific approval was completed. Later STS, S3-denial, and final logout/container-cleanup steps received explicit approval.
- Correction to tutoring explanation: the observed logout message describes local cache removal and residual token validity, not a promise that server-side revocation completes after 15 minutes. Do not conflate access-token lifetime with the overall refreshable login-session lifetime.
- The profile label does not enforce identity, permissions, account, or region. STS supplies identity evidence; the denied S3 operation supplies one bounded authorization check.
- Identity Center organization access was not enabled; no Organizations or plan change was approved. A standalone account instance does not supply AWS-account access.

## Next session

- Open a new dedicated session to scope the next lab; no new AWS action is approved.
- Carry forward Lab 000's pending operating checklist and full preflight design without counting them as demonstrated.
- Prefer short executable tests and concise evidence-derived notes; no additional harness machinery is required.
