# Contributing

**kiko-selfhosted** holds deployment manifests for [kiko](https://github.com/hrodrig/kiko). Application code and releases live in the **kiko** repository.

## Workflow

1. Branch from **`develop`**, open PRs into **`develop`**.
2. Keep **`VERSION`** and chart **`version`** in sync when tagging infra releases.
3. Run **`make release-check`** before tagging **`v<semver>`** on **`main`**.

## Scope

- Docker Compose, Helm, raw Kubernetes YAML, runbooks.
- Do **not** add application Go code here — propose changes upstream in **kiko**.
