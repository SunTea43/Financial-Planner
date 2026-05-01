---
name: pull-request-review
description: 'Review pull requests in this Rails project. Use when reviewing a PR, checking that the PR description explains the functionality clearly, confirming the implementation is covered by tests, and verifying that user-visible text includes the required translations.'
argument-hint: 'Provide the PR URL, branch, or diff to review'
user-invocable: true
---

# Pull Request Review

Use this skill to review a pull request against the repository standards for description quality, test coverage, and translations.

## When to Use

- Review a PR before approval.
- Check whether the PR body explains the feature or bug fix clearly.
- Validate that code changes are backed by tests.
- Confirm that new or changed user-visible strings have matching translation entries.

## Review Goals

The review must verify all of the following:

1. The PR description explains the functionality clearly.
2. The implementation exists in the diff and matches the described behavior.
3. Relevant automated tests were added or updated for the changed behavior.
4. Any user-visible text introduced or changed in the UI has the required translations.

## Procedure

1. Gather the review context.
- Read the PR description or summary first.
- Review the changed files and identify the functional area: controllers, components, models, services, views, JavaScript, and tests.
- Compare the PR body against the structure in `.github/pull_request_template.md` when that information is available.

2. Evaluate the PR description.
- Confirm the description states what functionality was added, changed, or fixed.
- Confirm the testing section includes concrete evidence, not just a vague statement.
- Flag missing context when the PR body omits the user-facing impact, business rule, or scope of the change.

3. Confirm the functionality exists in code.
- Trace the primary changed execution path in the diff.
- Verify the implementation matches the behavior claimed in the PR description.
- Flag mismatches between the PR description and the actual code.

4. Check tests.
- Look for added or updated tests in the relevant area: model, service, controller, component, integration, or system tests.
- Prefer tests that validate behavior and structure over assertions tied to translated copy.
- If behavior changed and no tests changed, treat that as a finding unless the change is strictly documentation, configuration, or another non-executable update.
- If the PR fixes a bug, expect a regression test unless there is a clear technical reason it cannot be added.

5. Check translations for user-visible text.
- Inspect views, components, helpers, mailers, and JavaScript for newly introduced or changed copy shown to users.
- Confirm the text is sourced through `I18n.t` rather than hard-coded strings when appropriate for the existing code path.
- Verify matching locale entries exist in the relevant files under `config/locales/`, especially both English and Spanish files when the feature uses project translations.
- If no user-visible text changed, explicitly record that the translation check was not applicable.

6. Produce the review output.
- List findings first, ordered by severity.
- For each finding, include the missing requirement, the affected files or area, and why it matters.
- If no findings are present, state that explicitly and mention any residual risk such as missing manual verification.

## Decision Points

- If the PR description is incomplete but the code is understandable, still report the missing description quality as a finding.
- If the code change is user-facing and tests are missing, report that even if manual testing is described.
- If translations are missing for visible text, report that even when the fallback locale would mask the issue locally.
- If the change is internal-only and introduces no user-visible text, skip the translation requirement and note that it was not applicable.

## Completion Checks

The review is complete only when you can answer each question:

- Is the PR description clear about the functionality delivered?
- Does the diff actually implement that functionality?
- Are the relevant tests present or updated?
- Are all changed user-visible texts translated appropriately?

## Repo Notes

- Prefer `I18n.t` over `t` when calling translations in reviewed code.
- Avoid reviewing tests based only on translation strings; favor object state or HTML structure assertions.