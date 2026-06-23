# kiko-selfhosted

[![Version](https://img.shields.io/badge/version-0.1.4-blue)](https://github.com/hrodrig/kiko-selfhosted/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![App image on GHCR](https://img.shields.io/badge/image-ghcr.io%2Fhrodrig%2Fkiko-2496ED?logo=github)](https://github.com/hrodrig/kiko/pkgs/container/kiko)
[![kiko app](https://img.shields.io/badge/app-hrodrig%2Fkiko-181717?logo=github)](https://github.com/hrodrig/kiko)

Deployment manifests for **[kiko](https://github.com/hrodrig/kiko)** — privacy-first web analytics collector. Compose, Helm, and **MicroK8s** raw YAML. **Application source:** [github.com/hrodrig/kiko](https://github.com/hrodrig/kiko).

> **Note:** This repository covers **kiko alone** (the collector). Examples here are minimal and focused on collecting hits. If you are looking for a **complete stack with the kui dashboard** (users, roles, analytics UI), see **[github.com/hrodrig/kui-selfhosted](https://github.com/hrodrig/kui-selfhosted)** — the sibling repo that wires kiko + kui together with shared secrets, probes, and ingress.
>
> For **VPS best practices** (security hardening, firewall, Docker Compose setup), see **[gghstats-selfhosted VPS recommendations](https://github.com/hrodrig/gghstats-selfhosted/tree/main/run/vps-recommended)**.

**Releases:** Root **`VERSION`** and Git tags **`v<semver>`** on **`main`** name repository snapshots. Work in progress lands on **`develop`** first.

---

## Table of contents

- [Pick a path](#pick-a-path)
- [Docker Compose minimal](#docker-compose-minimal)
- [Kubernetes Helm](#kubernetes-helm)
- [MicroK8s raw manifests](#microk8s-raw-manifests)
- [Binary install](#binary-install)
- [Behind a reverse proxy](#behind-a-reverse-proxy)
- [Health probes](#health-probes)
- [Database modes](#database-modes)
- [Repository layout](#repository-layout)
- [License](#license)

---

## Pick a path

| You want… | Section |
|-----------|---------|
| **Compose, one service** (quick VPS / lab) | [Docker Compose minimal](#docker-compose-minimal) |
| **Kubernetes / Helm** (MicroK8s, kind, any cluster) | [Kubernetes Helm](#kubernetes-helm) |
| **Plain YAML on MicroK8s** (no Helm) | [MicroK8s raw manifests](#microk8s-raw-manifests) |
| **Binary on the host** (no container) | [Binary install](#binary-install) |

Shared env template: **[`run/common/.env.example`](run/common/.env.example)**. Walkthroughs: **[`run/README.md`](run/README.md)**.

Default image tag in examples: **`v0.5.0`** ([kiko releases](https://github.com/hrodrig/kiko/releases)); override with **`KIKO_VERSION`** or **`KIKO_IMAGE`**.

---

## Docker Compose minimal

```bash
export KIKO_HOST_DATA=/home/kiko/kiko-data
mkdir -p "$KIKO_HOST_DATA"
cp run/common/.env.example "$KIKO_HOST_DATA/.env"
# edit KIKO_PUBLIC_URL, KIKO_ALLOWED_HOSTS, etc.

docker compose --env-file "$KIKO_HOST_DATA/.env" \
  -f run/docker-compose/minimal/docker-compose.yml up -d

curl -sS http://127.0.0.1:8080/api/v1/healthz
```

Details: **[`run/docker-compose/minimal/README.md`](run/docker-compose/minimal/README.md)**.

---

## Kubernetes Helm

From a clone of this repository:

```bash
helm upgrade --install kiko run/kubernetes/helm/kiko \
  --namespace kiko --create-namespace \
  --set image.tag=v0.5.0 \
  --set env.publicUrl=https://analytics.example.com
```

Chart README: **[`run/kubernetes/helm/kiko/README.md`](run/kubernetes/helm/kiko/README.md)**.

---

## MicroK8s raw manifests

For a single-node **MicroK8s** cluster (Traefik ingress add-on optional):

```bash
microk8s enable dns storage
kubectl apply -f run/kubernetes/manifests/microk8s/
kubectl -n kiko wait --for=condition=ready pod -l app.kubernetes.io/name=kiko --timeout=120s
kubectl -n kiko port-forward svc/kiko 8080:8080
curl -sS http://127.0.0.1:8080/api/v1/readyz
```

See **[`run/kubernetes/manifests/microk8s/README.md`](run/kubernetes/manifests/microk8s/README.md)**.

---

## Binary install

Install the static binary from [kiko releases](https://github.com/hrodrig/kiko/releases) (no Docker):

```bash
curl -fsSL https://raw.githubusercontent.com/hrodrig/kiko/main/scripts/install.sh | sh
# pin: VERSION=v0.5.0 sh install.sh
```

Copy [`run/common/.env.example`](run/common/.env.example) to `/etc/kiko/kiko.yml` or export `KIKO_*` vars, then `kiko serve`. Use **systemd** unit from the [kiko repo](https://github.com/hrodrig/kiko/tree/main/contrib/systemd) when packaging for a VPS.

---

## Behind a reverse proxy

When kiko sits behind Traefik, nginx, or an Ingress controller, enable **`KIKO_FILTER_TRUST_PROXY=true`** so visitor hashing uses the first **public** IP from `X-Forwarded-For` / `X-Real-IP`.

**Verify forwarding** (does not record a hit when rejected):

```bash
curl -sS -X POST 'https://analytics.example.com/hit' \
  -H 'X-Debug-Request: true' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 Chrome/120' \
  -d '{"host":"example.com","path":"/"}'
```

Response JSON includes `client_ip`, `accepted`, and `reason`. Rejected ingest hits still return a GIF with **`X-Kiko-Dropped: 1`**.

**SPA sites:** load `kiko.js` with **`?hash=1`** when using hash-based routing; History API routes are tracked automatically.

Filter knobs (`block_bots`, referrer spam, datacenter CIDRs, per-host rate limits): see [kiko `configs/kiko.yml.sample`](https://github.com/hrodrig/kiko/blob/main/configs/kiko.yml.sample) and map via `KIKO_FILTER_*` in [`.env.example`](run/common/.env.example).

---

## Health probes

| Probe | Path | Use |
|-------|------|-----|
| **Liveness** | `GET /api/v1/healthz` | Process alive — always `200` |
| **Readiness** | `GET /api/v1/readyz` | DB reachable — `503` when backend is down |

Both paths should stay **exempt from rate limiting** when that feature is enabled upstream.

**kui** reads **`GET /api/v1/version`** (public, no auth) to display the connected kiko version.

---

## Database modes

| Mode | Default | Kubernetes |
|------|---------|------------|
| **SQLite** | `./data/kiko.db` | PVC at `/data` (Helm `persistence.enabled: true`) |
| **PostgreSQL** | — | `database.driver: postgres` + DSN Secret |
| **MySQL** | — | `database.driver: mysql` + DSN Secret |

SQLite is the zero-config default (one replica, `ReadWriteOnce` PVC). Use PostgreSQL when you need a shared DB or HA outside the pod.

---

## Repository layout

```
run/
  common/              # .env.example
  docker-compose/      # minimal stack
  kubernetes/
    helm/kiko/         # maintained Helm chart
    manifests/microk8s/ # plain YAML for MicroK8s
```

---

## License

MIT — see [LICENSE](LICENSE).
