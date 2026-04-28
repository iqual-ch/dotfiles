# Upsun helpers (requires upsun CLI and fzf)

# pssh - SSH into an Upsun project environment with fzf selection
pssh() {
  if ! command -v upsun &>/dev/null; then
    echo "pssh: upsun CLI not found." >&2
    return 1
  fi

  local project_id
  project_id=$(upsun projects --columns=title,id,organization_name --format=tsv -c0 \
    | column -t \
    | fzf --ansi -i -1 --height=50% --reverse -0 --header-lines=1 --inline-info --border \
    | awk '{print $2}')
  [ -z "$project_id" ] && printf "pssh: no project selected.\n" && return 1

  local exec_cmd="$*"
  if [ "${exec_cmd:0:1}" = "-" ]; then
    upsun ssh -p "$project_id" $exec_cmd
  elif [ -n "$exec_cmd" ]; then
    upsun ssh -p "$project_id" -e main "$exec_cmd"
  else
    upsun ssh -p "$project_id" -e main
  fi
}
