# DDEV-aware wrappers: auto-detect .ddev directories and route through DDEV.
# Falls back to native commands or Docker containers.

php() {
  if [ -d .ddev ]; then
    ddev php "$@"
  elif [ -n "$(type -P php)" ]; then
    command php "$@"
  else
    docker run -u $UID:$UID -it --rm -v $PWD:/app -w /app php:8-cli php "$@"
  fi
}

composer() {
  if [ -d .ddev ]; then
    ddev composer "$@"
  elif [ -n "$(type -P composer)" ]; then
    command composer "$@"
  else
    docker run -e COMPOSER_AUTH -u $UID:$UID -it --rm -v $PWD:/app composer/composer:2 composer "$@"
  fi
}

drush() {
  if [ -d .ddev ]; then
    ddev drush "$@"
  elif [ -n "$(type -P drush)" ]; then
    command drush "$@"
  else
    echo "Drush is not available on the host, please use the ddev container."
  fi
}

npm() {
  if [ -d .ddev ]; then
    ddev npm "$@"
  elif [ -n "$(type -P npm)" ]; then
    command npm "$@"
  else
    docker run -u $UID:$UID -it --rm -v $PWD:/app -w /app node:lts npm "$@"
  fi
}

node() {
  if [ -d .ddev ]; then
    ddev node "$@"
  elif [ -n "$(type -P node)" ]; then
    command node "$@"
  else
    docker run -u $UID:$UID -it --rm -v $PWD:/app -w /app node:lts node "$@"
  fi
}

bun() {
  if [ -d .ddev ]; then
    ddev bun "$@"
  elif [ -n "$(type -P bun)" ]; then
    command bun "$@"
  else
    docker run -u $UID:$UID -it --rm -v $PWD:/app -w /app oven/bun:latest bun "$@"
  fi
}
