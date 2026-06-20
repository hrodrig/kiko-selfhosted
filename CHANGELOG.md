# Changelog

All notable changes to **kiko-selfhosted** (deployment manifests) are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

- Document v0.4.0 proxy/filter settings, binary install, and SPA snippet.
- Pin default `KIKO_VERSION` / Helm examples to **v0.4.0**.
- MicroK8s ConfigMap: `KIKO_FILTER_TRUST_PROXY=true` for Ingress setups.

## [0.1.0] - 2026-06-19

### Added

- Initial repository skeleton: Compose minimal, Helm chart, MicroK8s raw manifests.
- Probes: liveness `GET /api/v1/healthz`, readiness `GET /api/v1/readyz`.
- Default SQLite mode with PVC; optional PostgreSQL via Secret / env.
