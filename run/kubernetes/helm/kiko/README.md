# Helm chart — kiko

Install from a clone of **kiko-selfhosted** (chart is not shipped in the **kiko** app repo).

## SQLite (default)

```bash
helm upgrade --install kiko . \
  --namespace kiko --create-namespace \
  --set env.publicUrl=https://analytics.example.com \
  --set env.allowedHosts=gghstats.com,kzero.dev
```

## PostgreSQL

```bash
helm upgrade --install kiko . \
  --namespace kiko --create-namespace \
  --set persistence.enabled=false \
  --set database.driver=postgres \
  --set secrets.create=true \
  --set secrets.dsn='postgres://kiko:secret@postgres.default.svc.cluster.local:5432/kiko?sslmode=disable' \
  --set env.publicUrl=https://analytics.example.com
```

## Probes

| Probe | Path |
|-------|------|
| Liveness | `/api/v1/healthz` |
| Readiness | `/api/v1/readyz` |

Tune in **`values.yaml`** under **`probes`**.

← [Back to run/README](../../../README.md)
