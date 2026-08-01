# k3s-hetzner

Live desired state for a single-node K3s server on Hetzner Cloud.

- Public app: <https://www.bigconfig.website/>
- GitOps source: [`getcolors/k3s-helloworld`](https://github.com/getcolors/k3s-helloworld)
- Package: [`getcolors/k3s`](https://github.com/getcolors/k3s)

```sh
./green build
./green create --dry-run
./green create
./green kubectl get nodes
./green kubectl get pods -A
```

The cloud firewall exposes 22, 80, and 443. Kubernetes port 6443 is private;
`./green kubectl` invokes it over SSH. Flux deploys ExternalDNS and cert-manager
for the proxied `*.bigconfig.website` record and wildcard certificate.
Credentials live only in the gitignored `.envrc.private`.
