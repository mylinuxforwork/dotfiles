# Instructions for AI Coding Agents

These instructions apply to the entire repository. Follow any more specific `AGENTS.md` found in a subdirectory as well. If instructions conflict, prefer the most specific applicable project guidance, while preserving the safety rules below.

## Before Making Changes

- Read the project README, contribution guidance, relevant source files, tests, build configuration, and recent history before editing.
- Identify the default branch and work on it directly. Do not create branches or pull requests unless explicitly requested.
- Check the current working tree and latest remote state before writing. Never overwrite unrelated or newer work.
- Understand the reported problem and reproduce it where practical. Prefer fixing root causes over symptoms.
- Preserve existing architecture, public interfaces, user data, compatibility, and project conventions unless a change is necessary and justified.
- Do not assume a language, framework, package manager, build system, or test command. Discover and use what this repository actually provides.

## Issue Triage and Implementation

- Prioritize existing, actionable open issues over speculative features or cosmetic churn.
- Prefer small, independently verifiable issues that can be completed confidently. Work on multiple independent issues during a maintenance session when practical, without mixing unrelated changes into one commit.
- Do not close an issue merely because code was changed. Close it only after the stated acceptance criteria are met and the fix has been verified to the extent possible.
- Reference the relevant issue number in the commit message when a commit fixes an issue (for example, `Fixes #123` in the commit body when appropriate).
- Keep issues open when validation requires unavailable hardware, a user-specific environment, an interactive desktop session, credentials, or manual confirmation. Explain what remains to be checked instead of claiming completion.
- Do not close user-created issues or mark work as not planned unless the repository owner explicitly directs you to do so.

## Acceptance Criteria and Issue Checklists

- Write explicit, testable acceptance criteria for each issue before implementation. Use GitHub task-list checkboxes (`- [ ]`) so progress is visible and auditable.
- Treat every checkbox as a claim that must be supported by evidence. Check a box only after the corresponding behavior or deliverable has been implemented and verified; code changes, a commit, or a passing unrelated test are not sufficient evidence.
- Keep criteria specific and independently verifiable. Separate automated checks from manual, runtime, hardware, accessibility, and environment-dependent validation where relevant.
- Before closing an issue, re-read its current description and verify every acceptance criterion. Do not close it while any in-scope criterion remains incomplete or unverified.
- If work is incomplete, leave the issue open and keep the relevant boxes unchecked. State precisely what remains and what evidence or environment is needed.
- When auditing previously closed issues, compare each original acceptance criterion with the implementation and available test evidence. Update checkboxes honestly; never tick boxes retroactively based only on the fact that the issue was closed.
- Reopen a closed issue when an in-scope requirement remains incomplete or requires validation that has not occurred. Preserve the original context and explain the remaining work in the issue.
- For duplicate issues, link to the canonical issue and keep the duplicate's acceptance boxes unchecked unless the duplicate was independently completed and verified. Track completion on the canonical issue to avoid misleading duplicate checklists.
- After editing an issue description or state, fetch it again and confirm that the intended checklist and status were saved.


## Code Quality and Testing

- Follow the repository's established formatting, naming, documentation, dependency, and error-handling conventions.
- Add or update focused tests for behavior changes when the project has a suitable test setup.
- Run relevant available tests, linters, formatters, type checks, and build checks. Do not add CI workflows or checks without a concrete project need.
- Inspect the complete output and exit status of every check. Fix failures caused by your changes; investigate pre-existing failures and report them accurately.
- Review all commits created during the maintenance run and their associated CI/check results, not only the latest commit. Do not report a check as passing unless its result was actually observed.
- Static checks do not prove runtime, graphical, hardware, or platform integration behavior. In particular, do not claim GNOME Shell/session compatibility without testing in a real GNOME session.
- If a necessary test cannot be run in the available environment, state the limitation clearly and leave validation-dependent work unresolved.

## Git and Commit Practices

- Commit directly to the repository's existing default branch; do not force-push, rewrite history, reset away others' work, or amend published commits.
- Fetch/review the latest branch state before committing. Keep changes focused and avoid including unrelated modifications.
- Use the repository's documented commit convention. If none exists, use clear Conventional Commit messages such as `fix(scope): ...`, `feat(scope): ...`, `docs: ...`, or `test: ...`.
- Include issue references for issue-related commits. Do not create empty or misleading commits.
- After committing, verify the commit exists on the intended default branch and inspect the resulting diff/status.

### Administrative Commit Hygiene

- Do not create standalone commits solely for issue-triage edits, category changes, backlog counts, CI-ledger housekeeping, or routine maintenance notes.
- Keep routine triage and progress information in working notes or the relevant GitHub issues instead of creating repository commits.
- When a substantive code, test, or documentation change is already being committed, include only directly related maintenance-documentation updates in that same focused commit.
- Keep commits logically coherent. Never bundle unrelated changes merely to avoid an administrative-only commit.
- Do not rewrite or force-push published history to remove administrative commits that already exist.

## Documentation and Dependencies

- Keep documentation accurate, concise, and consistent with the actual implementation.
- Do not duplicate information already maintained elsewhere or add lengthy documentation without a clear benefit.
- Avoid new dependencies when the existing stack can solve the problem. Justify any dependency or build-system change.
- Never invent supported platforms, installation commands, test results, performance claims, or feature status.

## Reporting

- Summarize concrete changes with file paths and commit identifiers.
- Distinguish verified results from assumptions and unrun checks.
- List remaining manual validation, blockers, and issues intentionally left open.

## Maintenance Session Execution

- Start by reviewing actionable open issues in batches. Identify dependencies, shared root causes, acceptance criteria, and tasks that do not require unavailable runtime access.
- Do not limit a maintenance session to one issue when several independent, source-verifiable issues are ready. Implement multiple useful fixes in the same session and continue until actionable work is exhausted or a genuine blocker remains.
- Group related fixes into coherent commits when they share a root cause or change set. Keep unrelated work in separate focused commits; do not create a commit for every trivial edit or combine unrelated issues merely to increase issue count. Preserve any stricter repository-specific commit requirements above.
- Do not pause for approval or send a progress report after every issue or commit. Continue through the planned batch, verify the work, and report at a meaningful stopping point.
- If an issue requires unavailable hardware, credentials, a live desktop session, or user confirmation, leave it open and continue with independently verifiable work.
- Treat each commit as unfinished until its associated CI and checks reach a final state. Inspect failed job details, fix regressions introduced by the change, and rerun relevant checks. Pending checks are not passing checks.
- Before ending a session, review all commits made during that session, their CI results, remaining actionable issues, and required manual validation.
- Optimize for verified issue completion and a healthy default branch, not commit volume, issue-closure volume, or frequent status messages.

## Incremental Commit CI Audit Ledger

- Read `docs/maintenance/commit-ci-audit.md` before reviewing commit checks.
- Compare its checkpoint with the current default-branch head. Review only newer commits plus older **red**, **pending**, or explicitly unresolved entries; do not repeatedly audit full history.
- Record each checked commit's full SHA, subject, observed result, date, and workflow/run reference when available.
- **green** = observed completed success; **red** = observed completed failure; **pending** = unfinished run; **unavailable** = evidence not exposed; **not applicable** = workflow configuration confirms no relevant check is triggered.
- Empty status lists, missing badges, or absent workflow records are **unavailable**, never implicit passes or failures.
- Preserve red history. Append failed job/step, diagnosis, classification, fix commit(s), rerun attempts, and final verified outcome. Associate reruns with the original failing commit.
- Advance the checkpoint only after reviewing the newer range, and carry unresolved entries forward.
- Include ledger/AGENTS setup commits in the next incremental review unless explicitly recorded as checked.

## Issue Classification System

Classify every open issue into exactly one of these categories during triage. Record the category and a brief evidence-based reason in the issue notes or maintenance tracker; do not apply a category based on guesswork.

- **Category A — Fully actionable:** The issue can be implemented, tested, and fully verified with the available source code, automated tests, and CI. No user laptop, live desktop session, special hardware, or manual confirmation is required. Prioritize these issues and close them only after their acceptance criteria are met and verification succeeds.
- **Category B — Implementation ready, validation pending:** The implementation can be completed now, but final acceptance requires unavailable real-world validation such as a live GNOME session, visual/accessibility inspection, or measurements on target hardware. Implement and automate everything possible, but keep the issue open until the remaining validation is completed and recorded.
- **Category C — Environment-dependent:** Reliable implementation or verification is not currently possible without a specific laptop, hardware, operating system/runtime, device, or interactive environment. Document the missing environment and any useful reproduction steps; keep the issue open.
- **Category D — Blocked by external dependencies:** Progress depends on an unavailable external service, upstream change, third-party project, API, or other dependency outside this repository. Identify the exact dependency and the condition that will unblock the work; revisit when it changes.
- **Category E — Needs the repository owner's decision or information:** The issue needs a preference, clarification, approval, credentials, missing requirements, or other information only the owner can provide. Ask the owner a specific, concise question instead of silently deferring it. Once answered, reclassify the issue into the appropriate category and continue.

### Classification workflow

- Review all open issues and assign the best-supported category, with a short reason and any outstanding acceptance criteria.
- Work through Category A first; then complete the implementation portions of Category B where useful. Do not confuse implementation completion with final validation.
- For Category E, ask the owner promptly and track the answer needed. Do not leave it indefinitely in a generic blocked/deferred bucket.
- Keep Categories B, C, and D visible and actionable: state exactly what remains, who or what can unblock it, and when it should be revisited.
- Reassess categories when code, tests, CI, upstream dependencies, environments, or owner decisions change. Never close an issue solely because it has been categorized.
