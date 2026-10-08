# Agent guidelines

## This is a PUBLIC repository

Everything pushed here is world-readable and permanent: code, comments, commit messages, branch
names, PR titles and descriptions, review comments, test names, fixtures and assets. Closing a
PR, renaming a branch or force-pushing does not take any of it back, because GitHub keeps a
closed PR's original branch name and commits. The first push is the one that counts.

Never include:

- Partner, client or advertiser names, or any detail that could identify one (account, tenant
  or campaign IDs, deal terms, integration specifics). Say "a partner" or use a synthetic
  example, in branch names too.
- Partner brand assets: logos, screenshots or copy. Demo and sample content uses fictional
  brands.
- Internal service, system or class names, internal hostnames, dashboards, or links to private
  repos and tickets.
- Backend detail, especially how a payload is validated server-side. Describe what the SDK
  sends and receives, in partner-facing terms, and refer to a server change generically ("to
  match the server contract").

Before each push, PR, comment or reply, read the exact outgoing text, branch name included. If
you are unsure whether a detail is safe, leave it out and ask privately. Do not publish first
and edit it out later.

## Review guidelines

When reviewing PRs that touch this repo or downstream services, apply these
severity levels.

### P0 — block merge

- Hardcoded secrets or credentials (API keys, tokens, passwords, DB URIs)
- SQL string interpolation or concatenation (use parameterised queries only)

### P1 — strongly recommend fixing before merge

- Real customer PII in code or tests (names, emails, phone numbers, IP addresses — including hashed)
- `aws_iam_policy_attachment` Terraform resource (use `aws_iam_role_policy_attachment`)
- AI/ML Helm services using `Service.type: LoadBalancer` without internal annotation
- Missing input validation or sanitisation at API boundaries
- HTML/template rendering without escaping all 5 special chars (`<` `>` `"` `'` `&`)
- `VARCHAR` for user-visible strings in SQL Server (use `NVARCHAR`)
- `varchar`/`utf8` charset for user-visible strings in MySQL (use `utf8mb4`)
- Redis clients without DNS TTL re-resolution
- Submit buttons with no disabled state during async operations
- UI navigation hiding used as sole access control (no backend auth check)
- K8s Deployments/Services missing `service-type: internal|edge|public` label
