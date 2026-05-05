# Railway Deployment

This document centralizes Railway deployment troubleshooting.

## Common issue

Environment variables are configured in Railway but not detected by the app.

## Checklist

1. Define variables at the service level for the Rails service.
2. Verify variable names are exact and uppercase.
3. Redeploy after creating or changing variables.
4. Check values do not contain trailing spaces.

Required variable names:

- SMTP_ADDRESS
- SMTP_PORT
- SMTP_DOMAIN
- SMTP_USER_NAME
- SMTP_PASSWORD
- SMTP_FROM_ADDRESS
- APP_HOST
- SECRET_KEY_BASE

## Debug options

- Use Railway console and run `rails console`.
- Check variables directly with `ENV["SMTP_ADDRESS"]` style checks.
- Verify service variables in Railway UI.

For historical context and the original notes, see RAILWAY_DEPLOYMENT.md in the project root.

## Background Jobs (Solid Queue Worker)

The application uses Solid Queue for background jobs (e.g., exchange rate updates). Jobs run in a **dedicated worker service** separate from the web server.

### Setup

1. In your Railway project, click **"+ New Service"** and select the same repository.
2. Set its **Start Command** to:
   ```
   bin/jobs start
   ```
3. Add the required environment variables to the worker service:

   | Variable | Description |
   |---|---|
   | `RAILS_MASTER_KEY` | Same value as the web service |
   | `DATABASE_URL` | Connection URL for the primary database |
   | `QUEUE_DATABASE_URL` | Connection URL for the Solid Queue database (`financial_planner_production_queue`) |

   > **Why `QUEUE_DATABASE_URL`?** Solid Queue uses a separate database (`queue` in `config/database.yml`). Rails resolves it via the `QUEUE_DATABASE_URL` env var. Without it, the worker will fail to find the Solid Queue tables.

4. Deploy the worker service.

> Do **not** set `SOLID_QUEUE_IN_PUMA=true` on either service.

### Scaling

To increase job concurrency, set on the worker service:

```
JOB_CONCURRENCY=2
```

The default is `1` process with 3 threads each (configured in `config/queue.yml`).
