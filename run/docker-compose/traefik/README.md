# Traefik + TLS (production-style)

← [Back to run/README](../../README.md).

**Traefik** terminates HTTPS (Let's Encrypt) and routes to **kiko** on the **`kiko_edge`** Docker network. No host port is published for kiko; only **80** and **443** for Traefik.

Compose **project** `kiko-edge` (containers `kiko-edge-traefik-1`, `kiko-edge-kiko-1`).

**Traefik image:** pinned in [`docker-compose.yml`](docker-compose.yml) (currently **`traefik:v3.6.17`**, 3.6.x line). Stay on **≥ v3.6.14** for published security fixes.

From the **repository root**:

```bash
export KIKO_HOST_DATA=/home/kiko/kiko-data
mkdir -p "$KIKO_HOST_DATA/data"
cp run/common/.env.example "${KIKO_HOST_DATA}/.env"
# Set KIKO_HOSTNAME, ACME_EMAIL, KIKO_VISITOR_SALT, KIKO_API_KEY,
# and KIKO_HOST_DATA (same absolute path)

docker compose --env-file "${KIKO_HOST_DATA}/.env" \
  -f run/docker-compose/traefik/docker-compose.yml up -d
```

Ensure DNS for `KIKO_HOSTNAME` points to this host and **80/443** are reachable for ACME.

**Exec / logs** (service names):

```bash
docker compose --env-file "${KIKO_HOST_DATA}/.env" \
  -f run/docker-compose/traefik/docker-compose.yml logs -f traefik
docker compose --env-file "${KIKO_HOST_DATA}/.env" \
  -f run/docker-compose/traefik/docker-compose.yml logs -f kiko
```

**kiko.js** will be served at `https://<KIKO_HOSTNAME>/kiko.js`.

---

**[↑ Back to run/README](../../README.md)**
