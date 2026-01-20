# venvctl

**virtual environment control** (venvctl, inspired by systemctl) is a Bash utility to manage Python virtual environments in a fixed directory defined at installation. It simplifies the workflow of creating, activating, listing, and removing environments, ensuring consistency across projects.

## Installation

To install venvctl, just clone this repository and install it using the provided `Makefile`:

```bash
git clone https://github.com/pedronovaes/venvctl.git
cd venvctl
make install
```

By default, all environments will be stored in `~/.venvs`. If you want to customize this directory, specify it during installation:

```bash
sudo make install ENV_DIR=~/projects/envs
```

This will generate a configuration file at `/etc/venvctl.conf`:

```bash
ENV_DIR=/home/pedro/projects/envs
```

Run this command to ensure the installation was successful:

```bash
venvctl --help
```

### Uninstallation

To uninstall, run this command:

```bash
sudo make uninstall
```

This will delete both `/usr/local/bin/venvctl` and `/etc/venvctl.conf`.
