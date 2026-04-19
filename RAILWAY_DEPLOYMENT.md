# Railway Deployment Guide

## Environment Variables Issue

If environment variables defined in Railway are not being detected, follow these steps:

### 1. Check Variable Scope

Railway has two levels for environment variables:
<<<<<<< HEAD
=======

>>>>>>> feature/configure-email-delivery
- **Project level**: Available to all services in the project
- **Service level**: Only available to the specific service

**Action**: Ensure your email configuration variables are defined at the **Service level** for your Rails application service.

### 2. Variable Names Must Match Exactly

Environment variables are case-sensitive. Ensure the names in Railway match exactly:

```text
SMTP_ADDRESS
SMTP_PORT
SMTP_DOMAIN
SMTP_USER_NAME
SMTP_PASSWORD
SMTP_FROM_ADDRESS
APP_HOST
SECRET_KEY_BASE
```

**Common mistakes**:
<<<<<<< HEAD
=======

>>>>>>> feature/configure-email-delivery
- Using lowercase instead of uppercase
- Extra spaces in variable names
- Using hyphens instead of underscores

### 3. Redeploy After Adding Variables

After adding environment variables in Railway:

1. Go to your service
2. Click "Redeploy" to restart the service with new variables
3. Variables are only available after a redeploy

### 4. Check Build vs Runtime

Some variables might need to be available during build time. In Railway:

- Variables are available during both build and runtime by default
- No special configuration needed for this

### 5. Debug Environment Variables

Since logging in production.rb can cause errors during assets:precompile, use these alternative methods to debug environment variables:

#### Method 1: Create a temporary controller action

Add a temporary action to any controller:

```ruby
# In app/controllers/application_controller.rb
def debug_env
  render json: {
    SMTP_ADDRESS: ENV['SMTP_ADDRESS'] ? 'SET' : 'NOT SET',
    SMTP_PORT: ENV['SMTP_PORT'] ? 'SET' : 'NOT SET',
    SMTP_DOMAIN: ENV['SMTP_DOMAIN'] ? 'SET' : 'NOT SET',
    SMTP_USER_NAME: ENV['SMTP_USER_NAME'] ? 'SET' : 'NOT SET',
    SMTP_PASSWORD: ENV['SMTP_PASSWORD'] ? 'SET' : 'NOT SET',
    SMTP_FROM_ADDRESS: ENV['SMTP_FROM_ADDRESS'] ? 'SET' : 'NOT SET',
    APP_HOST: ENV['APP_HOST'] ? 'SET' : 'NOT SET'
  }
end
```

Add to routes.rb temporarily:

```ruby
get '/debug_env', to: 'application#debug_env'
```

Visit `/debug_env` in production to see which variables are loaded.

#### Method 2: Use Rails console in Railway

1. Go to your service in Railway
2. Click "Console" tab
3. Run: `rails console`
4. Check variables: `ENV['SMTP_ADDRESS']`

#### Method 3: Check Railway UI

1. Go to your service in Railway
2. Settings → Variables
3. Verify all variables are listed with correct values

Remember to remove the temporary debug action after debugging!

### 6. Railway-Specific Configuration

For Railway deployment, ensure:

1. **Variables are set at Service level**:
<<<<<<< HEAD
=======

>>>>>>> feature/configure-email-delivery
   - Go to your Rails service
   - Settings → Variables
   - Add all required variables

2. **No trailing spaces**:
<<<<<<< HEAD
=======

>>>>>>> feature/configure-email-delivery
   - Ensure no spaces after variable values
   - Railway preserves trailing spaces

3. **Use proper format**:
<<<<<<< HEAD
=======

>>>>>>> feature/configure-email-delivery
   - Key: SMTP_ADDRESS
   - Value: smtp.gmail.com
   - No quotes around values

### 7. Alternative: Use Railway's Reference

If variables still don't work, you can use Railway's reference syntax in your code:

```ruby
# Instead of ENV.fetch("SMTP_USER_NAME")
user_name: ENV["SMTP_USER_NAME"] || ENV["RAILWAY_SMTP_USER_NAME"]
```

Then in Railway, name the variable: `RAILWAY_SMTP_USER_NAME`

### 8. Verify with Railway CLI

If you have Railway CLI installed, you can verify variables:

```bash
railway variables
railway variables ls
```

### Common Railway Issues

**Issue**: Variables work locally but not in Railway

**Solution**: Railway may require a redeploy after adding variables

**Issue**: Variables disappear after redeploy

**Solution**: Ensure variables are saved (click "Save" button in Railway UI)

**Issue**: Variables have wrong values

**Solution**: Check for trailing spaces or extra characters in Railway UI

## Testing Email Configuration

To test email configuration in Railway:

1. Add a temporary action in a controller to send a test email
2. Check logs for email delivery attempts
3. Verify the "Environment variables loaded" section shows all variables as "SET"
