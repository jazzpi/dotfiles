DOTFILES_DIR = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

AWESOME_DIR = ~/.config/awesome
NVIM_DIR = ~/.config/nvim

DIRS = $(AWESOME_DIR) $(NVIM_DIR)

install = \
    mkdir -p $$(dirname $(2)) && \
    if [ ! $$(readlink -f $(2)) -ef $(DOTFILES_DIR)/$(1) ]; then \
        ln -s $(DOTFILES_DIR)/$(1) $(2); \
    fi

.PHONY: default
default: tmux bash

.PHONY: extended
extended: awesome tmux bash zsh

.PHONY: all
all: awesome nvim xresources tmux zsh spacemacs bash

$(DIRS):
	mkdir -p $@

.PHONY: awesome
awesome: $(AWESOME_DIR)
	$(call install,awesome/rc.lua,$(AWESOME_DIR)/rc.lua)
	$(call install,awesome/mywidgets,$(AWESOME_DIR)/mywidgets)
	$(call install,awesome/themes/jazzpi,$(AWESOME_DIR)/themes/jazzpi)

.PHONY: nvim
nvim: $(NVIM_DIR)
	$(call install,nvim/init.vim,$(NVIM_DIR)/init.vim)
	$(call install,nvim/ftplugin/markdown.vim,$(NVIM_DIR)/ftplugin/markdown.vim)
	$(call install,nvim/ftplugin/tex.vim,$(NVIM_DIR)/ftplugin/tex.vim)
# Download vim-plug
	curl -fLo $(NVIM_DIR)/autoload/plug.vim --create-dir \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Install plugins
	nvim -c "PlugInstall | qa"

.PHONY: xresources
xresources:
	$(call install,Xresources,~/.Xresources)

.PHONY: tmux
tmux:
	$(call install,tmux.conf,~/.tmux.conf)

.PHONY: zsh
zsh:
	$(call install,zsh/zshrc,~/.zshrc)
	$(call install,zsh/zshenv,~/.zshenv)

.PHONY: spacemacs
spacemacs:
	$(call install,spacemacs,~/.spacemacs)

.PHONY: bash
bash:
	$(call install,bash/bashrc,~/.bashrc)
