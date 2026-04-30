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
