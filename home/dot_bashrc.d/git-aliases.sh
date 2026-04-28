# Git aliases
alias g='git'
alias gs='git status'
alias gss='git status -s'
alias ga='git add'
alias gap='git add -p'
alias gb='git branch'
alias gba='git branch -av'
alias gc='git commit -v'
alias gcm='git commit -v -m'
alias gco='git checkout'
alias gob='git checkout -b'
alias gd='git diff'
alias gf='git fetch'
alias gm='git merge'
alias gp='git push'
alias gpl='git pull'

# Git log aliases
alias glog='git log'
alias gg='git log --graph --pretty=format:'\''%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset'\'' --abbrev-commit --date=relative'
alias ggf='git log --graph --date=short --pretty=format:'\''%C(auto)%h %Cgreen%an%Creset %Cblue%cd%Creset %C(auto)%d %s'\'''
alias ggs='gg --stat'


# fzf git: checkout branch with fuzzy finder
fco() {
  command -v fzf &> /dev/null || return 1
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fzf git: commit browser
fgg() {
  command -v fzf &> /dev/null || return 1
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# Change directory with fzf lookup and git cloning
cdd() {
  command -v fzf-git-clone &> /dev/null || return 1
  local target_dir
  target_dir=$(fzf-git-clone) || return 1
  echo "Changing directory to $target_dir"
  cd "$target_dir"
}

# Change directory and run VS Code
dc() {
  cdd && code .
}
