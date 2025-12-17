# CloudedX Demo Site Security Notes

- No secrets, API keys, or credentials are embedded in the static assets.
- The mock payment and notification flows do not call external services.
- In production, all sensitive settings should be provided via environment variables or a secrets manager.

