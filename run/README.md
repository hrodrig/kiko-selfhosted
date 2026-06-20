# How to run kiko (self-hosted)

← [Back to the repository README](../README.md).

| Directory | When to use |
|-----------|-------------|
| [`run/common/`](common/) | Shared **environment template** for Compose. Copy to **`${KIKO_HOST_DATA}/.env`**. |
| [`docker-compose/minimal/`](docker-compose/minimal/) | **One Compose service** — SQLite on a bind mount, quick VPS or lab. |
| [`kubernetes/helm/kiko/`](kubernetes/helm/kiko/) | **Helm chart** — MicroK8s, kind, production clusters. |
| [`kubernetes/manifests/microk8s/`](kubernetes/manifests/microk8s/) | **Plain YAML** — apply with `kubectl` on MicroK8s without Helm. |

Always pin the **published image tag** to your desired [kiko](https://github.com/hrodrig/kiko) release (`KIKO_VERSION` in [`.env.example`](common/.env.example)).

**Proxy / filtering:** set `KIKO_FILTER_TRUST_PROXY=true` behind Traefik or Ingress; see [repository README](../README.md#behind-a-reverse-proxy).

**Probes:** liveness **`/api/v1/healthz`**, readiness **`/api/v1/readyz`**.

---

**[↑ Back to the repository README](../README.md)**
