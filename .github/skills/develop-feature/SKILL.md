---
name: develop-feature
description: 'Develop a complete feature from a natural-language description in a Rails app. Use when the user asks to create a branch, implement code, add tests, run linters, and open a pull request.'
argument-hint: 'Describe the feature to implement, including business rules and acceptance criteria'
user-invocable: true
---

# Develop Feature Workflow

Use this skill to implement an end-to-end feature request.

## Input

A feature description in natural language with:
- expected behavior
- constraints or dependencies
- acceptance criteria

## Procedure

1. Understand the feature request
- Clarify missing requirements before coding when needed.
- Identify affected models, controllers, views, services, and tests.

2. Create a branch
- Use a descriptive branch name such as `feature/add-user-dashboard`.
- If git tooling is available, create from `main`.
- If not, use a terminal command: `git checkout -b <branch-name> main`.

3. Implement the feature
- Follow project conventions (Rails, Cells, SimpleForm, Bootstrap).
- Keep changes minimal and focused.
- Avoid unrelated refactors.

4. Add or update tests
- Add unit tests for models/services and controller/integration/system tests as needed.
- Run relevant tests first, then full suite if required.
- Iterate until tests pass.

5. Run quality checks
- Run rubocop, brakeman, and bundler-audit when applicable.
- Always run brakeman with `--no-pager` to avoid opening an interactive pager session: `bin/brakeman --no-pager`.
- Fix relevant issues introduced by the change.

6. Commit using project guidelines
- Commit format: `<type>: <description>`.
- Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`.
- Use imperative present, lowercase first letter, no trailing period, max 72 chars.
- Commits must be in English.

7. Create a pull request
- Base branch: `main`.
- Use `.github/pull_request_template.md`.
- Include summary, test evidence, and deployment notes if relevant.
- Create draft or ready PR depending on confidence.

8. Verify final state
- Confirm branch contains intended commits.
- Confirm PR includes all relevant changes and checks.

## Notes

- If the request is documentation-only or config-only, skip tests/linters that do not apply.
- If existing workspace has unrelated dirty changes, do not revert them.
