#!/usr/bin/env bats

# Tests that core dotfiles exist after chezmoi apply

@test "bashrc exists and is a file" {
    [ -f "${HOME}/.bashrc" ]
}

@test "bashrc contains SSH agent setup" {
    grep -q "SSH_AUTH_SOCK" "${HOME}/.bashrc"
}

@test "bashrc contains bashrc.d sourcing" {
    grep -q "bashrc.d" "${HOME}/.bashrc"
}

@test "bashrc.d directory exists" {
    [ -d "${HOME}/.bashrc.d" ]
}

@test "git-aliases.sh exists in bashrc.d" {
    [ -f "${HOME}/.bashrc.d/git-aliases.sh" ]
}

@test "gitconfig exists and has correct user" {
    [ -f "${HOME}/.gitconfig" ]
    grep -q "testuser" "${HOME}/.gitconfig"
    grep -q "test@example.com" "${HOME}/.gitconfig"
}

@test "gitconfig has defaultBranch = main" {
    grep -q "defaultBranch = main" "${HOME}/.gitconfig"
}

@test "gitconfig has pull.rebase = true" {
    grep -q "rebase = true" "${HOME}/.gitconfig"
}

@test "vimrc exists" {
    [ -f "${HOME}/.vimrc" ]
}

@test "SSH config exists" {
    [ -f "${HOME}/.ssh/config" ]
    grep -q "github.com" "${HOME}/.ssh/config"
}

@test "SSH config covers platform.sh and upsun" {
    grep -q "platform.sh" "${HOME}/.ssh/config"
    grep -q "upsun.site" "${HOME}/.ssh/config"
}

@test "SSH config covers Drupal Code gitlab" {
    grep -q "git.drupal.org" "${HOME}/.ssh/config"
}

@test "SSH config has AddKeysToAgent" {
    grep -q "AddKeysToAgent yes" "${HOME}/.ssh/config"
}

@test "SSH key was generated" {
    [ -f "${HOME}/.ssh/id_ed25519" ]
    [ -f "${HOME}/.ssh/id_ed25519.pub" ]
}

@test "SSH public key contains configured email" {
    grep -q "test@example.com" "${HOME}/.ssh/id_ed25519.pub"
}

@test "local bin directory exists" {
    [ -d "${HOME}/.local/bin" ]
}

@test "PATH includes local bin" {
    grep -q '\.local/bin' "${HOME}/.bashrc"
}

@test "ddev-wrappers.sh exists when enabled" {
    # This test runs in the full-features container
    if [ -f "${HOME}/.bashrc.d/ddev-wrappers.sh" ]; then
        grep -q "ddev" "${HOME}/.bashrc.d/ddev-wrappers.sh"
    else
        skip "DDEV wrappers not enabled"
    fi
}

@test "git aliases contain common shortcuts" {
    grep -q "alias gs=" "${HOME}/.bashrc.d/git-aliases.sh"
    grep -q "alias gc=" "${HOME}/.bashrc.d/git-aliases.sh"
    grep -q "alias gp=" "${HOME}/.bashrc.d/git-aliases.sh"
}

@test "bashrc sources bash_aliases if present" {
    grep -q "bash_aliases" "${HOME}/.bashrc"
}
