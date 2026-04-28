# iqual Developer Dotfiles

Standardized dotfiles for developer workstations using [chezmoi](https://www.chezmoi.io/). Designed for **Windows 11 + WSL2 (Ubuntu)** environments.

## Quick Start

For a new workstation, run inside WSL2 (Ubuntu):

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply iqual-ch/dotfiles
```

Chezmoi will prompt you for:
- **GitHub username** and **email** (used for git config)
- **Feature toggles** for optional tools

## What's Included

### Always On
| Tool | Description |
|------|-------------|
| **APT packages** | `make`, `git`, `socat`, `openssh-client`, `curl`, `wget`, `jq`, `bat`, `shellcheck`, `ripgrep` |
| **GitHub CLI (gh)** | GitHub command-line tool |
| **Upsun CLI** | Upsun hosting platform CLI |
| **age** | File encryption tool |
| **yq** | YAML processor |
| **xq** | XML/HTML processor |
| **fzf** | Fuzzy finder + `fzf-git-clone` for repo management |
| **Git config** | Default branch `main`, pull with rebase, `gh` credential helper |
| **SSH agent** | Auto-start in bashrc (always active, even if SSH setup is disabled) |
| **Git aliases** | Common shortcuts (`gs`, `gc`, `gco`, `gp`, etc.) and fzf-powered git functions |
| **bat alias** | Maps `bat` to `batcat` on Ubuntu/Debian where the binary name differs |
| **vimrc** | Syntax highlighting, line numbers, sensible defaults |

### Opt-In Features
| Feature | Default | Description |
|---------|---------|-------------|
| **SSH setup** | ✅ | SSH config for GitHub, Platform.sh/Upsun, Drupal Code + key generation with optional upload to GitHub/Upsun |
| **mise** | ✅ | Tool version manager (Node, Python) |
| **runme** | ❌ | Runnable markdown notebooks |
| **DDEV wrappers** | ❌ | Shell wrappers for php, composer, npm, etc. that auto-detect DDEV |
| **IDP helpers** | ❌ | Aliases for `m=make` and `c=code .` |
| **Upsun helpers** | ❌ | `pssh` function for interactive Upsun SSH via fzf |

### SSH Setup Details

When `enable_ssh_setup` is enabled (default), chezmoi will:

1. Deploy an SSH config covering **GitHub**, **Platform.sh/Upsun**, and **Drupal Code** (git.drupal.org)
2. Generate an ed25519 SSH key (skipped if one already exists)
3. Interactively offer to upload the public key to **GitHub** and **Upsun** using their CLIs
   - Automatically triggers login (`gh auth login` / `upsun auth:browser-login`) if not yet authenticated
   - Each upload is prompted individually
   - Key titles include the hostname and date for traceability (e.g. `DESKTOP-ABC-20260427`)
   - Skipped automatically in CI or non-interactive environments

## Customization

### Personal additions
Add custom shell configuration in `~/.bashrc.d/*.sh` — all files in this directory are automatically sourced. This is the recommended way to add personal aliases, functions, or tool integrations without modifying the managed dotfiles.

You can also use `~/.bash_aliases` for simple alias definitions.

### Reconfigure
To change your feature selections:

```bash
chezmoi init
```

### Update
To pull the latest dotfiles:

```bash
chezmoi update
```

## Internal Development

### Make targets

| Target | Description |
|--------|-------------|
| `make build` | Build the Docker test container |
| `make test` | Apply dotfiles and run BATS tests in container |
| `make apply` | Apply dotfiles in container (no tests) |
| `make shell` | Apply dotfiles and drop into an interactive shell for manual testing |

### Testing locally

```bash
# Build the container, apply dotfiles, and run all BATS tests:
make test

# Or drop into an interactive shell to poke around:
make shell
```

### CI
GitHub Actions automatically tests dotfiles on every push/PR with both full-feature and minimal (all opt-ins disabled) configurations.