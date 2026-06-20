# kiko-selfhosted — optional automation (no Go build).

.DEFAULT_GOAL := help

CHART_DIR ?= run/kubernetes/helm/kiko
KUBERNETES_VERSION ?= 1.30.0

.PHONY: help release-check

help:
	@echo "kiko-selfhosted — make targets"
	@echo ""
	@echo "  make release-check   helm lint + template + kubeconform; compose config"
	@echo ""
	@echo "Requires: helm, kubeconform, docker (compose plugin)"

release-check:
	@command -v helm >/dev/null 2>&1 || { echo "helm not found"; exit 1; }
	@command -v kubeconform >/dev/null 2>&1 || { echo "kubeconform not found"; exit 1; }
	@command -v docker >/dev/null 2>&1 || { echo "docker not found"; exit 1; }
	@echo "release-check: helm lint $(CHART_DIR)..."
	@helm lint "$(CHART_DIR)"
	@echo "release-check: helm template + kubeconform..."
	@helm template test-rel "$(CHART_DIR)" --namespace kiko | \
		kubeconform -strict -kubernetes-version "$(KUBERNETES_VERSION)" -summary -
	@echo "release-check: docker compose config (minimal)..."
	@KIKO_HOST_DATA=/tmp/kiko-compose-check \
		docker compose --env-file run/common/.env.example \
		-f run/docker-compose/minimal/docker-compose.yml config >/dev/null
	@echo "release-check passed."
