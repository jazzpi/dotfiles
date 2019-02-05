# dotfiles

These are some configuration files I use.

To install, run

```bash
git clone https://github.com/jazzpi/dotfiles.git
cd dotfiles
make all
```

This may throw a bunch of errors where the configuration files already exist.
Please remove/backup them manually and repeat the command.

## Emacs

My Emacs configuration makes use of [DOOM
Emacs](https://github.com/hlissner/doom-emacs). My DOOM configuration is located
in a separate repo ([jazzpi/doom-d](https://github.com/jazzpi/doom-d)). Both
DOOM Emacs and my DOOM config are downloaded and installed by `make emacs`.

## i3

My i3bar makes use of [py3status](https://py3status.readthedocs.io/en/latest/),
which you will need to install.

The background is displayed using `feh`.

If [fzf](https://github.com/junegunn/fzf) is installed, it will be used instead
of `dmenu`.

## bash

My bash configuration includes support for, but does not require:

- [fzf](https://github.com/junegunn/fzf)
- [pyenv](https://github.com/pyenv/pyenv)
- [ROS](https://wiki.ros.org/) (tested with ROS Kinetic/Ubuntu Xenial, but
  should work with other distros too)
- [Racer](https://github.com/racer-rust/racer)

## Unmaintained

This repository also includes configuration files for some programs I no longer
use, so the config files may or may not work anymore:

- awesome
- nvim
- st
- zsh
- spacemacs
- tmux
