# k3s-hetzner

Live desired state for a single-node K3s server on Hetzner Cloud.

- Public app: <https://www.bigconfig.website/>
- GitOps source: [`getcolors/k3s-helloworld`](https://github.com/getcolors/k3s-helloworld)
- Package: [`getcolors/k3s`](https://github.com/getcolors/k3s)

```sh
./k3s build
./k3s create --dry-run
./k3s create
./k3s kubectl get nodes
./k3s kubectl get pods -A
```

The cloud firewall exposes 22, 80, and 443. Kubernetes port 6443 is private;
`./k3s kubectl` invokes it over SSH. Flux deploys ExternalDNS and cert-manager
for the proxied `*.bigconfig.website` record and wildcard certificate.
Credentials live only in the gitignored `.envrc.private`.
