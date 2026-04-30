# Agent Guidelines

- All commits must be in English and descriptive. This, considering [Commit Guidelines](./COMMIT_GUIDELINES.md)
- We're going to prefer I18n.t over t methods on Internationalization because it's easier to see in the editor
- Avoid test translations from text. Try to test statuses in objects or html structure over text translations.
- Avoid `puts`/`print` debug output in tests and seeds unless it is strictly required for temporary debugging.
- For each new feature/fix/refactor ... we always use [develop-feature](.windsurf/workflows/develop-feature.md). No push directly to main
