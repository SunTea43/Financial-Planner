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

2. Create an isolated worktree and branch
- Always implement features in a dedicated git worktree, never in the main workspace.
- Fetch the latest remote state first (no need to switch branches in the main workspace):

```bash
git fetch origin
```

- Use `<worktree-dir>` for filesystem-safe directory naming (for example, replace `/` in branch names with `-`).
- For a new branch, base it off `origin/main` to avoid touching the main workspace branch:

```bash
git worktree add -b <branch-name> ../<repo-name>_<worktree-dir> origin/main
```

- If the branch already exists **locally**, do not use `-b`:

```bash
git worktree add ../<repo-name>_<worktree-dir> <branch-name>
```

- If the branch exists **only on the remote** (e.g., when resuming work on another machine), use `origin/<branch-name>` as the start-point with `-b` to create a local branch that tracks it:

```bash
git worktree add -b <branch-name> ../<repo-name>_<worktree-dir> origin/<branch-name>
```

- Check current worktrees before creating a new one:

```bash
git worktree list
```

- Enter the new worktree directory before any code change, test, commit, or PR action.

3. Implement the feature
- Use a descriptive branch name such as `feature/add-user-dashboard`.
- Follow project conventions (Rails, Cells, SimpleForm, Bootstrap).
- Keep changes minimal and focused.
- Avoid unrelated refactors.
- Prefer native Bootstrap components for UI behavior before custom CSS/JS.
- Do not modify existing framework classes or add custom overrides in framework style files unless explicitly requested.

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

9. Clean up the worktree when finished
- After work is merged or no longer needed, remove the temporary worktree:

```bash
cd <path-to-main-repo>
git worktree remove ../<repo-name>_<worktree-dir>
```

- Keep only active feature worktrees to avoid stale directories.

## Notes

- If the request is documentation-only or config-only, skip tests/linters that do not apply.
- If existing workspace has unrelated dirty changes, do not revert them.
- If a matching feature worktree already exists, reuse it instead of creating duplicates.
