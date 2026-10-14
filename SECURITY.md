# Security notes

- Never store a user's raw password in local storage, including platform-secure storage. Firebase Authentication manages the authenticated session.
- Treat Firebase client configuration as public app configuration, not as a secret. Protect data with Firebase Security Rules, callable-function authorization, App Check where appropriate, and server-side validation.
- Do not place AI provider keys or private backend credentials in this mobile repository.
- Avoid logging credentials, authentication tokens, or sensitive health data.
- Report suspected vulnerabilities privately to the repository maintainers rather than opening a public issue with exploit details.
