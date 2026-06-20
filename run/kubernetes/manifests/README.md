# Kubernetes manifests (optional)

← [Back to run/README](../../README.md).

| Path | Description |
|------|-------------|
| [`microk8s/`](microk8s/) | Plain YAML for MicroK8s (`kubectl apply -f …`) |

The maintained install path is the **[Helm chart](../helm/kiko/)**. Generate a starting point with:

```bash
helm template kiko ../helm/kiko --namespace kiko > example-rendered.yaml
```

---

**[↑ Back to run/README](../../README.md)**
