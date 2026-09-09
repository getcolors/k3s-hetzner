# Shared compute migration

Installed `getcolors/k3s` revision `218a64a5fb5849297ad06f37a49a42163235a6c0`. Root launchers match the
installed skill payloads from a verified Skills CLI installation.
The existing lockfile records that installation.

Compute now uses colors-compute shared and node state under
`<profile>/compute/`. Application stages retain their existing ownership.
This refresh does not transfer resource ownership or apply infrastructure.
No live state, private credentials, or private key contents were read.

Before create, preserve the old state, inventory the existing resources and SSH
key ownership, and review explicit source/destination resource mappings and a
plan with no unintended replacement. Recognized legacy remote state causes the
library to refuse the operation. Do not discard old state or bypass that check.
The committed deployment profile and destroy protection are preserved.

Validation: the published green launchers built the desired state
in temporary directories with a sanitized environment. Compute documents were
present and rendered backend configuration contained no credentials. Offline
builds do not establish live authentication, migrated state, or application health.

Configuration changes:

- Made the documented external identity and existing IPv4 ingress policy explicit. Public Kubernetes API access remains closed.

The repeated-delete fix accepts only a validated destroyed deployment result
for delete, then stops before cleanup. Credential checks still run first.
No key files or state were read to validate this payload refresh; a sanitized
temporary build passed, and the committed desired-state bytes are unchanged.
