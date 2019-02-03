DOTFILES_DIR = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

AWESOME_DIR = ~/.config/awesome
NVIM_DIR = ~/.config/nvim
I3_DIR = ~/.config/i3
I3STATUS_DIR = ~/.config/i3status

install = \
    echo "Installing $(1)"; \
    mkdir -p $$(dirname $(2)) && \
    if [ ! $$(readlink -f $(2)) -ef $(DOTFILES_DIR)/$(1) ]; then \
        ln -s $(DOTFILES_DIR)/$(1) $(2); \
    fi

# Don't output commands unless run with `make VERBOSE=1`
$(VERBOSE).SILENT:

# Print help if no target is specified

.PHONY: default
default: help

help:
	@echo "Choose a target to install from:"
	@echo "    bash profile emacs tmux i3 awesome nvim xresources zsh spacemacs"

# Print only if we aren't executing the help target
ifneq ($(MAKECMDGOALS),help)
ifneq ($(MAKECMDGOALS),)
$(info If you get a "Failed to create symbolic link: File exists", please backup/remove the offending file and rerun.)
$(info )
endif
endif

.PHONY: all
all: bash profile emacs tmux i3 awesome nvim xresources zsh spacemacs

.PHONY: profile
profile:
	$(call install,profile,~/.profile)

.PHONY: i3
i3: xresources
	$(call install,i3/config,$(I3_DIR)/config)
	$(call install,i3/scripts,$(I3_DIR)/scripts)
	$(call install,i3/themes,$(I3_DIR)/themes)
	$(call install,i3/i3status.conf,$(I3STATUS_DIR)/config)
# Install dark theme as default
	i3/scripts/theme.bash install_only dark

.PHONY: emacs
emacs:
	@echo "Downloading Emacs DOOM..."
	git clone -b develop https://github.com/hlissner/doom-emacs ~/.emacs.d
	@echo "Downloading DOOM config..."
	git clone git@github.com:jazzpi/doom-d.git ~/.doom.d
	@echo "Installing DOOM"
	cd ~/.emacs.d && make install

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
bash: profile
	$(call install,bash/bashrc,~/.bashrc)
	$(call install,bash/inputrc,~/.inputrc)
