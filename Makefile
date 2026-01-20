# Makefile for venvctl

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

# Fixed directories for virtual environments.
ENV_DIR ?= $(HOME/Venvs)

install:
	@echo "[INFO] Installing venvctl into $(BINDIR)"
	@sudo cp bin/venvctl.sh $(BINDIR)/venvctl
	@sudo chmod +x $(BINDIR)/venvctl
	@echo "ENV_DIR=$(ENV_DIR)" | sudo tee /etc/venvctl.conf >/dev/null
	@echo "[INFO] Installation complete!"
	@echo "[INFO] Virtual environments will be stored in: $(ENV_DIR)"
	@echo "You can now run 'venvctl --help'"

uninstall:
	@echo "[INFO] Removing venvctl from $(BINDIR) ..."
	@sudo rm -f $(BINDIR)/venvctl
	@sudo rm -f /etc/venvctl.conf
	@echo "[INFO] Uninstallation complete!"

verify:
	@which venvctl >/dev/null 2>&1 && echo "venvctl is installed and available." || echo "venvctl not found in PATH"

.PHONY: install uninstall verify
