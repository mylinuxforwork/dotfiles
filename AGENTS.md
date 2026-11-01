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

## Documentation and Dependencies

- Keep documentation accurate, concise, and consistent with the actual implementation.
- Do not duplicate information already maintained elsewhere or add lengthy documentation without a clear benefit.
- Avoid new dependencies when the existing stack can solve the problem. Justify any dependency or build-system change.
- Never invent supported platforms, installation commands, test results, performance claims, or feature status.

## Reporting

- Summarize concrete changes with file paths and commit identifiers.
- Distinguish verified results from assumptions and unrun checks.
- List remaining manual validation, blockers, and issues intentionally left open.
