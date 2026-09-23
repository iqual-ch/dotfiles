# iqual Developer Dotfiles

Standardized dotfiles for iqual developer workstations, managed with [chezmoi](https://www.chezmoi.io/). Built for **Windows 11 + WSL2 (Ubuntu)**.

## Quick Start

Inside WSL2 (Ubuntu), run:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply iqual-ch/dotfiles
```

You will be asked for your **GitHub username** and **email** (used for git), then for each optional feature. Everything is **enabled by default** — press Enter to accept, or answer `n` to opt out.

## What's Included

### Always on

| Component | Details |
|-----------|---------|
| **APT packages** | `make`, `git`, `socat`, `openssh-client`, `curl`, `wget`, `jq`, `bat`, `shellcheck`, `ripgrep`, `dnsutils`, `zstd` |
| **CLI tools** | `gh` (GitHub), `upsun`, `age`, `yq`, `xq`, `fzf` — installed to `~/.local/bin` |
| **Git** | Default branch `main`, pull with rebase, `gh` as credential helper, aliases (`gs`, `gc`, `gco`, `gp`, ...) and fzf-powered helpers like `fzf-git-clone` |
| **Shell** | `~/.bashrc` with SSH agent auto-start, `~/.local/bin` on `PATH`, tool completions, `bat` → `batcat` alias |
| **vim** | Syntax highlighting, line numbers, sensible defaults |

### Optional (enabled by default)

| Feature | Setting | Description |
|---------|---------|-------------|
| **SSH setup** | `enable_ssh_setup` | SSH config for GitHub, Platform.sh/Upsun and Drupal Code, key generation and upload (see below) |
| **mise** | `enable_mise` | Tool version manager; installs Node (LTS), Python and Bun |
| **Runme** | `enable_runme` | Runnable markdown notebooks |
| **DDEV wrappers** | `enable_ddev_wrappers` | `php`, `composer`, `npm`, etc. run through DDEV when a `.ddev/config.yaml` project config is present |
| **IDP helpers** | `enable_idp_helpers` | Aliases `m` (make) and `c` (code .) |
| **Upsun helpers** | `enable_upsun_helpers` | `pssh` — pick an Upsun project with fzf and SSH into it |

### SSH setup

With `enable_ssh_setup` on, chezmoi will:

1. Deploy an SSH config for **GitHub**, **Platform.sh/Upsun** and **Drupal Code** (git.drupal.org)
2. Generate an ed25519 key at `~/.ssh/id_ed25519` (skipped if one exists)
3. Offer to upload the public key to **GitHub** and **Upsun**. Enter accepts, `n` skips. You are logged in first if needed, and the key is titled `<hostname>-<date>`.

Uploads are skipped in CI and other non-interactive environments.

## Customization

- **Personal config**: put files in `~/.bashrc.d/*.sh` — they are sourced automatically. `~/.bash_aliases` works too.
- **Change features**: `chezmoi edit-config`, then `chezmoi apply`
- **Update**: `chezmoi update`

## Development

| Target | Description |
|--------|-------------|
| `make build` | Build the Docker test container |
| `make test` | Apply dotfiles in the container and run the BATS tests |
| `make apply` | Apply dotfiles in the container without tests |
| `make shell` | Apply dotfiles and open an interactive shell in the container |

CI runs the tests on every push and PR, once with all features enabled and once with all of them disabled.
