# Agent Guidelines (kiko-selfhosted)

- Use **English** for all project artifacts (code, comments, commit messages, docs, README).
- **Scope:** **kiko-selfhosted** owns deployment (Helm, Compose, **`run/`**, chart CI). **[kiko](https://github.com/hrodrig/kiko)** owns the Go app, API, and container image — chart work stays in **`run/kubernetes/helm/kiko/`** here.
- Follow **git flow**: work on `develop`; **`main`** for production snapshots; **annotated tags** `v<semver>` on `main` for infra releases (see root **`VERSION`**).
- **`VERSION`** (repository root): canonical **kiko-selfhosted** semver (`0.1.0` style, no `v`). When it changes, align the README **Version** badge, optional CHANGELOG, and Git tag **`v…`** on **`main`**. **`Chart.yaml` `version:`** tracks the **Helm chart package** only — bump when **`run/kubernetes/helm/kiko/`** changes materially, **not** on every **`VERSION`** bump (see **`.cursor/rules/version-sync.mdc`**).
- **`KIKO_VERSION`** in **`${KIKO_HOST_DATA}/.env`**: pins the **application** OCI image (`ghcr.io/hrodrig/kiko:…`); align with **[kiko](https://github.com/hrodrig/kiko)** releases — not the same field as this repo’s **`VERSION`**.
- **kiko** uses **`make release-check`** (Go tests, coverage, security). **This repo** has no Go tests; **`make release-check`** here means **`helm lint`**, **`helm template`** + **kubeconform**, and **`docker compose … config`** for **minimal** (set **`KIKO_HOST_DATA`** for volume interpolation). Requires **helm**, **kubeconform**, and **docker** on **`PATH`**. Bare **`make`** lists targets.
- Keep **`run/`** paths, **`KIKO_HOST_DATA`**, and **`${KIKO_HOST_DATA}/.env`** documentation consistent across README files (always **`--env-file`** from the clone root).
- **Health probes:** liveness **`GET /api/v1/healthz`**, readiness **`GET /api/v1/readyz`**. Both must stay **exempt from rate limiting** when that lands upstream (see **`.cursor/rules/kiko-probes.mdc`**).
- **Database:** default **SQLite** (`KIKO_DATABASE_DRIVER=sqlite`, path under **`/data`**). **PostgreSQL/MySQL** via **`KIKO_DATABASE_DSN`** or Helm **`secrets.dsn`** — disable SQLite PVC when using external DB.
- Do not commit without first showing the proposed commit message and getting **explicit user approval**.
