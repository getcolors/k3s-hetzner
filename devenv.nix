{ pkgs, lib, config, inputs, ... }:

{
  # The green package launcher resolves Clojure code by git SHA and drives
  # Ansible and OpenTofu to provision and configure the server.
  languages.clojure.enable = true;
  languages.ansible.enable = true;
  languages.opentofu.enable = true;

  packages = [
    pkgs.babashka
    pkgs.jet
    pkgs.hcl2json

    # The shared R2 state backend authenticates through the AWS credential
    # chain, while Hetzner Cloud is useful for inspecting the provisioned VPS.
    pkgs.awscli2
    pkgs.hcloud

    # Flux performs pull-based deployment inside K3s. kubectl reaches the
    # private Kubernetes API through the launcher's SSH tunnel.
    pkgs.fluxcd
    pkgs.kubectl
  ];
}
