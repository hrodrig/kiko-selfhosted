# Compose minimal — kiko + SQLite

← [Back to docker-compose](../README.md).

Single **kiko** container with SQLite on a host bind mount (`${KIKO_HOST_DATA}/data` → `/data`).

## Quick start

```bash
export KIKO_HOST_DATA=/home/kiko/kiko-data
mkdir -p "$KIKO_HOST_DATA/data"
cp run/common/.env.example "$KIKO_HOST_DATA/.env"
# set KIKO_HOST_DATA inside .env to the same path

docker compose --env-file "$KIKO_HOST_DATA/.env" \
  -f run/docker-compose/minimal/docker-compose.yml up -d

curl -sS http://127.0.0.1:8080/api/v1/healthz
curl -sS http://127.0.0.1:8080/api/v1/readyz
```

## Tracking script

Add to your site (replace with your public URL):

```html
<script defer src="https://analytics.example.com/kiko.js"></script>
```

Set **`KIKO_PUBLIC_URL`** to that origin.

---

**[↑ Back to docker-compose](../README.md)**
