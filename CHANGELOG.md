# Changelog

All notable changes to **kiko-selfhosted** (deployment manifests) are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.1.3] - 2026-06-22

### Changed

- Bump kiko image references from **v0.4.3** to **v0.4.4** across Compose, Helm,
  MicroK8s, and docs (`.env.example`, `README.md`, `values.yaml`, `Chart.yaml`).
- Bump `appVersion` in Helm chart to `v0.4.4`.
- Bump Helm chart `version` 0.1.0 → 0.1.1.

## [0.1.2] - 2026-06-21

### Changed

- Bump kiko image references from **v0.4.0** to **v0.4.3** across Compose, Helm,
  MicroK8s, and docs (`.env.example`, `README.md`, `values.yaml`, `Chart.yaml`).
- Bump `appVersion` in Helm chart to `v0.4.3`.

## [0.1.1] - 2026-06-20

### Added

- CODE_OF_CONDUCT.md (Contributor Covenant).

### Changed

- Document v0.4.0 proxy/filter settings, binary install, and SPA snippet.
- Pin default `KIKO_VERSION` / Helm examples to **v0.4.0**.
- MicroK8s ConfigMap: `KIKO_FILTER_TRUST_PROXY=true` for Ingress setups.
- Mention kui reads `GET /api/v1/version` in health probes section.

## [0.1.0] - 2026-06-19

### Added

- Initial repository skeleton: Compose minimal, Helm chart, MicroK8s raw manifests.
- Probes: liveness `GET /api/v1/healthz`, readiness `GET /api/v1/readyz`.
- Default SQLite mode with PVC; optional PostgreSQL via Secret / env.
