# MicroK8s — plain manifests

← [Back to run/README](../../../README.md).

Apply-order YAML for **MicroK8s** without Helm. Defaults: **SQLite** on a PVC, **1 replica**.

## Prerequisites

```bash
microk8s enable dns storage
# optional HTTPS ingress:
# microk8s enable ingress
```

## Install

```bash
kubectl apply -f run/kubernetes/manifests/microk8s/
kubectl -n kiko wait --for=condition=ready pod -l app.kubernetes.io/name=kiko --timeout=120s
```

## Smoke test

```bash
kubectl -n kiko port-forward svc/kiko 8080:8080
curl -sS http://127.0.0.1:8080/api/v1/healthz
curl -sS http://127.0.0.1:8080/api/v1/readyz
```

## PostgreSQL

Edit **`04-deployment.yaml`**: set `KIKO_DATABASE_DRIVER=postgres` and `KIKO_DATABASE_DSN` from Secret **`kiko-db`**. Disable or remove **`03-pvc.yaml`** if you do not need local SQLite storage.

## Ingress (Traefik)

Uncomment and edit **`06-ingress.yaml`**, then:

```bash
kubectl apply -f run/kubernetes/manifests/microk8s/06-ingress.yaml
```

With **`KIKO_FILTER_TRUST_PROXY=true`** in the ConfigMap, kiko uses the first public client IP from `X-Forwarded-For`.

### Debug client IP

```bash
curl -sS -X POST 'https://analytics.example.com/hit' \
  -H 'X-Debug-Request: true' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 Chrome/120' \
  -d '{"host":"example.com","path":"/"}'
```

### Protect stats API at ingress

Keep `/hit`, `/hit.gif`, and `/kiko.js` public; restrict `/api/v1/stats/*` with Traefik `Middleware` + `basicAuth` Secret. Example in the [repository README](../../../../README.md#behind-a-reverse-proxy).

### SPA tracking

```html
<script async src="https://analytics.example.com/kiko.js?hash=1"></script>
```

History API routes (`pushState` / `popstate`) are tracked by default.

---

**[↑ Back to run/README](../../../README.md)**
