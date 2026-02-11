# Repository Guidelines

## Repository Status

- This is a personal repository and is currently under active development.
- Breaking changes are acceptable; do not prioritize backward compatibility
  unless explicitly requested.

## Project Structure & Module Organization

- `flake.nix` and `flake.lock` define the Nix flake entry point and pinned
  inputs.
- `nix/nixos/<host>/` holds host configs.
- `nix/nixosModules/` contains reusable NixOS modules (naming pattern
  `service-*.nix` plus `base.nix` and `desktop.nix`).
- `nix/homeModules/` contains Home Manager modules.
- `nix/packages/` is for custom package definitions (currently `yek.nix`).
- `configs/<app>/` stores application configs and scripts.
- `secrets/` contains SOPS-managed secrets (see `.sops.yaml` for rules).

## Build, Test, and Development Commands

- `nix flake check --impure --all-systems --print-build-logs` runs CI-equivalent
  checks, including linting (`statix check`) defined in the flake.
- `nixos-rebuild switch --flake .#gmk` applies the NixOS configuration for the
  `gmk` host.
- `statix check` (if installed) runs the Nix linter used by the flake checks.

## Coding Style & Naming Conventions

- Indentation: 2 spaces in `.nix` files; avoid tabs.
- Module naming: `service-<name>.nix` for service modules; host configs live
  under `nix/nixos/<host>/`.
- Keep attributes and inputs grouped logically (inputs, module args, then
  outputs).

## Testing Guidelines

- There are no unit tests in this repo; validation is done via
  `nix flake check`.
- Keep checks green in CI (`.github/workflows/ci.yml`). Run locally before
  pushing when possible.

## Agent-Specific Instructions

- Use the `mcp-nixos` MCP server for authoritative NixOS, Home Manager, and
  nix-darwin data. The upstream README documents a unified `nix` tool with
  actions like `search`, `info`, `stats`, `options`, `channels`, `flake-inputs`,
  and `cache`, plus sources such as `nixos`, `home-manager`, `darwin`, `flakes`,
  `flakehub`, `nixvim`, `noogle`, `wiki`, `nix-dev`, and `nixhub`. It also
  provides package version metadata via NixHub. Use it whenever you need
  verified package existence, option names, channels, flake inputs, cache
  status, or versions.
- When working on `flake.nix`, overlays, unfree handling, or dev shells, apply
  the `nix-best-practices` skill.
- When changing NixOS host configs or Home Manager integration (especially with
  `useGlobalPkgs`), apply the `nixos-best-practices` skill.

## Commit & Pull Request Guidelines

- Commit messages follow a lightweight Conventional Commits style: `fix: ...`,
  `ci: ...`, `refactor: ...`, `init: ...`. The first word of the sentence must
  start with a capital letter (for example `fix: Add ...`).
- No PR template is present; include a short summary, testing performed (or “not
  run”), and which hosts/modules are affected.

## Security & Configuration Tips

- Secrets should be stored in `secrets/` and encrypted via SOPS; follow
  `.sops.yaml` rules and avoid committing plaintext.
- When adding new services or applications, prefer a reusable module in
  `nix/nixosModules/` or `nix/homeModules/` and reference it from the host
  config.
