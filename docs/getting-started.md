# Getting Started

## Requirements

- Ruby 3.2.2+
- PostgreSQL
- Node.js
- Yarn

## Local setup

1. Install dependencies.

```bash
bundle install
yarn install
```

2. Create and migrate the database.

```bash
bin/rails db:create
bin/rails db:migrate
```

3. Configure environment variables.

```bash
cp .env.example .env
```

Set values for:

- SMTP_ADDRESS
- SMTP_PORT
- SMTP_DOMAIN
- SMTP_USER_NAME
- SMTP_PASSWORD
- SMTP_FROM_ADDRESS
- APP_HOST
- SECRET_KEY_BASE

4. Seed sample data for development.

```bash
bin/rails db:seed
```

5. Start the app.

```bash
bin/dev
```

App URL: http://localhost:3000

## Optional: configure verified commits

To avoid Unverified commits in GitHub, configure signing and verified email as described in:

- [Verified Commits](./contributing/verified-commits.md)
