DOTFILES_DIR = $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
$(info Dotfles installed at $(DOTFILES_DIR))

# Set defaults for XDG directories so we don't accidentally write to /sway
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME ?= $(HOME)/.local/share

AWESOME_DIR = $(XDG_CONFIG_HOME)/awesome
NVIM_DIR = $(XDG_CONFIG_HOME)/nvim
I3_DIR = $(XDG_CONFIG_HOME)/i3
I3STATUS_DIR = $(XDG_CONFIG_HOME)/i3status
SWAY_DIR = $(XDG_CONFIG_HOME)/sway
SWAYLOCK_DIR = $(XDG_CONFIG_HOME)/swaylock
WAYBAR_DIR = $(XDG_CONFIG_HOME)/waybar
HYPRLAND_DIR = $(XDG_CONFIG_HOME)/hypr
DUNST_DIR = $(XDG_CONFIG_HOME)/dunst
MAKO_DIR = $(XDG_CONFIG_HOME)/mako
MPDRIS2_DIR = $(XDG_CONFIG_HOME)/mpDris2
SYSTEMD_USER_DIR = $(XDG_CONFIG_HOME)/systemd/user
GIT_DIR = $(XDG_CONFIG_HOME)/git
RESOURCES_DIR = $(XDG_DATA_HOME)/dotfiles_resources
WAYLAND_SESSIONS_DIR = /usr/share/wayland-sessions

BINARY_DIR = $(HOME)/.local/bin

INSTALL_CMD = install
install = \
    echo "Installing $(1)"; \
    mkdir -p $$(dirname $(2)) && \
    if [ ! $$(readlink -f $(2)) -ef $(DOTFILES_DIR)/$(1) ]; then \
        ln --backup -s $(DOTFILES_DIR)/$(1) $(2); \
    fi

# Don't output commands unless run with `make VERBOSE=1`
$(VERBOSE).SILENT:

# Print help if no target is specified

TARGETS = bash profile emacs tmux sway i3 dunst mpdris2 applications awesome nvim xstuff zsh spacemacs top gdb git systemd bin

.PHONY: default
default: help

help:
	@echo "Choose a target to install from:"
	@echo "    $(TARGETS)"

# Print only if we aren't executing the help target
ifneq ($(MAKECMDGOALS),help)
ifneq ($(MAKECMDGOALS),)
$(info If you get a "Failed to create symbolic link: File exists", please backup/remove the offending file and rerun.)
$(info )
endif
endif

$(SYSTEMD_USER_DIR):
	mkdir -p $(SYSTEMD_USER_DIR)

.PHONY: all
all: $(TARGETS)

.PHONY: profile
profile:
	$(call install,profile,$(HOME)/.profile)

.PHONY: top
top:
	$(call install,toprc,$(HOME)/.toprc)

.PHONY: i3
i3: xstuff
	$(call install,i3/config,$(I3_DIR)/config)
	$(call install,i3/scripts,$(I3_DIR)/scripts)
	$(call install,i3/themes,$(I3_DIR)/themes)
	$(call install,i3/i3status.conf,$(I3STATUS_DIR)/config)
# Install dark theme as default
	i3/scripts/theme.bash install_only dark

.PHONY: resources
resources:
	$(call install,resources,$(RESOURCES_DIR))

.PHONY: waybar
waybar:
	$(call install,waybar,$(WAYBAR_DIR))

.PHONY: swaylock
swaylock:
	$(call install,swaylock,$(SWAYLOCK_DIR))

.PHONY: sway
sway: waybar swaylock resources
	$(call install,sway,$(SWAY_DIR))
	@echo "Installing Wayland session config for Sway. You might get a sudo prompt."
	sudo $(INSTALL_CMD) -m0644 -D sway/sway-in-a-shell.desktop $(WAYLAND_SESSIONS_DIR)
	sudo $(INSTALL_CMD) -m0644 -D sway/sway-unsupported-gpu.desktop $(WAYLAND_SESSIONS_DIR)
	sudo $(INSTALL_CMD) -m0755 -D sway/scripts/sway-in-a-shell /usr/local/bin

.PHONY: hyprland
hyprland: waybar swaylock resources
	$(call install,hyprland,$(HYPRLAND_DIR))

.PHONY: dunst
dunst:
	$(call install,dunst/dunstrc,$(DUNST_DIR)/dunstrc)

.PHONY: mako
mako:
	$(call install,mako/config,$(MAKO_DIR)/config)

.PHONY: mpdris2
mpdris2: $(SYSTEMD_USER_DIR)
	$(call install,mpDris2/mpDris2.conf,$(MPDRIS2_DIR)/mpDris2.conf)
	$(call install,mpDris2/mpDris2.service,$(SYSTEMD_USER_DIR)/mpDris2.service)

.PHONY: emacs
emacs:
	@echo "Downloading Emacs DOOM..."
	git clone https://github.com/hlissner/doom-emacs $(HOME)/.emacs.d
	@echo "Downloading DOOM config..."
	git clone -b writing https://github.com/jazzpi/doom-d.git $(HOME)/.doom.d
	git -C $(HOME)/.emacs.d checkout $$(cat $(HOME)/.doom.d/.doom-version)
	@echo "Installing DOOM"
	cd $(HOME)/.emacs.d && bin/doom install

.PHONY: applications
applications:
	$(call install,applications,$(XDG_DATA_HOME)/applications/from_dotfiles)

.PHONY: awesome
awesome:
	$(call install,awesome/rc.lua,$(AWESOME_DIR)/rc.lua)
	$(call install,awesome/mywidgets,$(AWESOME_DIR)/mywidgets)
	$(call install,awesome/themes/jazzpi,$(AWESOME_DIR)/themes/jazzpi)

.PHONY: nvim
nvim:
	$(call install,nvim/init.vim,$(NVIM_DIR)/init.vim)
	$(call install,nvim/ftplugin/markdown.vim,$(NVIM_DIR)/ftplugin/markdown.vim)
	$(call install,nvim/ftplugin/tex.vim,$(NVIM_DIR)/ftplugin/tex.vim)
# Download vim-plug
	curl -fLo $(NVIM_DIR)/autoload/plug.vim --create-dir \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Install plugins
	nvim -c "PlugInstall | qa"

.PHONY: xstuff
xstuff:
	$(call install,Xresources,$(HOME)/.Xresources)
	$(call install,xinitrc,$(HOME)/.xinitrc)

.PHONY: tmux
tmux:
	$(call install,tmux.conf,$(HOME)/.tmux.conf)

.PHONY: zsh
zsh:
	$(call install,zsh/zshrc,$(HOME)/.zshrc)
	$(call install,zsh/zshenv,$(HOME)/.zshenv)

.PHONY: spacemacs
spacemacs:
	$(call install,spacemacs,$(HOME)/.spacemacs)

.PHONY: bash
bash: profile
	$(call install,bash/bash_profile,$(HOME)/.bash_profile)
	$(call install,bash/bashrc,$(HOME)/.bashrc)
	$(call install,bash/inputrc,$(HOME)/.inputrc)

.PHONY: gdb
gdb: voltron
	$(call install,gdbinit,$(HOME)/.gdbinit)
	$(call install,gdbinit.py,$(HOME)/.gdbinit.py)

voltron:
	git submodule update --init voltron && cd voltron && sed -e "s/^GDB=.*/GDB=$(command -v arm-none-eabi-gdb)" -i install.sh && ./install.sh

.PHONY: git
git:
	$(call install,git/ignore,$(XDG_CONFIG_HOME)/git/ignore)
	$(call install,git/config,$(XDG_CONFIG_HOME)/git/config)

.PHONY: systemd
systemd:
	$(call install,systemd/user,$(XDG_CONFIG_HOME)/systemd/user)

.PHONY: bin
bin:
	$(call install,bin/compile-llvm,$(BINARY_DIR)/compile-llvm)
	$(call install,bin/git-use-id,$(BINARY_DIR)/git-use-id)
	$(call install,bin/git-add-id,$(BINARY_DIR)/git-add-id)
	$(call install,bin/monitor-waybar,$(BINARY_DIR)/monitor-waybar)

.PHONY: kitty
kitty:
	$(call install,kitty,$(XDG_CONFIG_HOME)/kitty)
