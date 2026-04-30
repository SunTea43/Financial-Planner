# Seeding Data

Use seeds to quickly bootstrap local environments with sample records.

## Run seeds

```bash
bin/rails db:seed
```

## Reset and seed

```bash
bin/rails db:reset
```

## Guidelines

- Seeds must be idempotent.
- Prefer find_or_create_by! for stable records.
- Keep data realistic enough for manual testing and demos.
- Avoid production-only assumptions.
