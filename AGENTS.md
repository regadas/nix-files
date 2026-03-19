# Repository Guidelines

## Project Structure & Module Organization
This repository is a Nix Flake for macOS system management.

- `flake.nix`: central entrypoint; defines inputs and outputs for `darwinConfigurations` and standalone `homeConfigurations`.
- `flake.lock`: pinned dependency versions; update intentionally.
- `hosts/darwin/default.nix`: host-level nix-darwin settings and service toggles.
- `modules/shared/default.nix`: shared system settings applied across machines.
- `modules/shared/home-manager.nix`: shared user-level programs and package set.
- `README.md`: quick-start command for applying configs.

## Build, Test, and Development Commands
- `nix develop`: enter the dev shell (includes formatters like `nixpkgs-fmt` and `nixfmt-classic`).
- `darwin-rebuild build --flake .#<hostname>`: build a host config without activating it.
- `darwin-rebuild switch --flake .#<hostname>`: build and apply a host config.
- `home-manager switch --flake .#regadas-aarch64-darwin`: apply standalone Home Manager profile.
- `nix flake check`: validate flake evaluation and outputs.
- `nix flake update`: refresh flake inputs (typically followed by lockfile commit).

## Coding Style & Naming Conventions
- Use standard Nix formatting: 2-space indentation, explicit semicolons, and readable attrset grouping.
- Keep common logic in `modules/shared/`; keep machine-specific overrides in `hosts/darwin/`.
- Prefer `default.nix` as module entrypoints; use descriptive, lowercase attribute names.
- Format before committing, for example: `nixpkgs-fmt flake.nix hosts modules`.

## Testing Guidelines
There is no separate unit-test framework in this repo; validation is done by evaluation/build.

- Minimum check for every change: `nix flake check`.
- For system changes: `darwin-rebuild build --flake .#<affected-hostname>`.
- For Home Manager changes: build/switch the relevant `homeConfigurations` target.

## Commit & Pull Request Guidelines
Commit style in this repo is short, imperative, and focused (examples: `Update flake.lock`, `Add mdopen from cargo`, `Use emacs-plus`).

- Keep one logical change per commit.
- In PRs, include: scope summary, why the change is needed, affected host(s)/architecture(s), and commands run to validate.
- Link related issues when applicable.

## Security & Configuration Tips
- Do not commit secrets, tokens, or private machine details.
- Review `flake.lock` diffs carefully before merging.
- Keep fetched artifacts pinned with hashes (as done for plugin/source fetches).
