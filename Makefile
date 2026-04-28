DOCKER_IMAGE_NAME = dotfiles-test

define CHEZMOI_CONFIG
[data]
github_username = "testuser"
email = "test@example.com"
enable_ssh_setup = true
enable_mise = true
enable_runme = true
enable_ddev_wrappers = true
enable_idp_helpers = true
enable_upsun_helpers = true
endef
export CHEZMOI_CONFIG

CHEZMOI_INIT = mkdir -p ~/.config/chezmoi && echo "$$CHEZMOI_CONFIG" > ~/.config/chezmoi/chezmoi.toml && chezmoi init --no-tty
CHEZMOI_APPLY = chezmoi apply --no-tty --force
DOCKER_RUN = docker run --rm \
	-e CHEZMOI_CONFIG \
	-v "$$(pwd):/home/developer/.local/share/chezmoi" \
	$(DOCKER_IMAGE_NAME)
DOCKER_RUN_IT = docker run -it --rm \
	-e CHEZMOI_CONFIG \
	-e TERM=xterm-256color \
	-v "$$(pwd):/home/developer/.local/share/chezmoi" \
	$(DOCKER_IMAGE_NAME)

.PHONY: docker
docker:
	@if ! docker inspect $(DOCKER_IMAGE_NAME) &>/dev/null; then \
		$(MAKE) build; \
	fi

.PHONY: build
build:
	docker build -t $(DOCKER_IMAGE_NAME) .

.PHONY: test
test: docker
	$(DOCKER_RUN) bash -c '$(CHEZMOI_INIT) && $(CHEZMOI_APPLY) && cd ~/.local/share/chezmoi && bats tests/'

.PHONY: apply
apply: docker
	$(DOCKER_RUN) bash -c '$(CHEZMOI_INIT) && $(CHEZMOI_APPLY) && echo "--- Dotfiles applied successfully ---"'

.PHONY: shell
shell: docker
	$(DOCKER_RUN_IT) bash -c '$(CHEZMOI_INIT) && $(CHEZMOI_APPLY) && exec bash --login'
