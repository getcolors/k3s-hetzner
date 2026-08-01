# CLAUDE.md

## What this repository is

Desired state for the live `k3s-hetzner` deployment: one Hetzner Cloud VPS,
K3s and Flux, OpenTofu state in the shared Cloudflare R2 bucket, and the public
`getcolors/k3s-helloworld` application.

`colors.yml` is source. `.colors/` is generated and must never be edited or
committed. `.envrc.private` contains credentials and is ignored by the
Default-deny `.gitignore`.

The root `k3s` launcher is a copy of
`.claude/skills/package-k3s-green/k3s`, installed from `getcolors/k3s` and
recorded in `skills-lock.json`. After `npx skills update -p -y`, re-copy it or
the root keeps running the old pin.

## Commands

```sh
./k3s build
./k3s create --dry-run
./k3s create
./k3s kubectl get nodes
./k3s kubectl get pods -A
./k3s kubectl apply -f - < manifest.yml
```

A real delete is protected. It destroys the VPS and its boot disk and requires
`COLORS_PAR_COMPUTE_PREVENT_DESTROY=false` for that invocation. Never edit the
committed `compute-prevent-destroy: true` to bypass the guard.

## Live architecture

- Hetzner server `k3s-hetzner`, `cx23`, Ubuntu 24.04, Nuremberg.
- K3s `v1.36.2+k3s1`, bundled Traefik and ServiceLB.
- Flux `v2.9.2` watches the public repository in `colors.yml`, branch `main`,
  path `./k8s`.
- GitHub Actions publishes an immutable GHCR image and commits its SHA into the
  Deployment; Flux pulls that commit. GitHub has no SSH or Kubernetes secret.
- The hostless Ingress serves `http://167.233.156.105/`.

The attached Hetzner firewall allows ICMP and TCP 22/80/443 only. K3s listens on
6443 locally, but that port is closed publicly. Do not open it; use
`./k3s kubectl`, which runs `sudo k3s kubectl` over the managed SSH alias.

## State and credentials

Remote state is `k3s-hetzner/k3s-compute.tfstate`. The profile and stage both
differ from other packages sharing the bucket.

Never export `COLORS_PAR_PROFILE`. The package refuses it because the overlay
could redirect this deployment at another project's state. Hetzner and R2
credentials live in `.envrc.private`; no credential belongs in `colors.yml`,
generated output, shell history, or documentation.

Build and dry-run intentionally check no credentials. A successful dry-run does
not prove a real provider login works.

## Verification

```sh
curl http://167.233.156.105/healthz
./k3s kubectl -n flux-system get gitrepository,kustomization
./k3s kubectl -n k3s-helloworld get deployment,pods,ingress
```

Expected: node Ready, Flux Ready, deployment 2/2, and health response `ok`.

## Git

Do not commit or push unless explicitly asked.
