INSTALL_DIR := /usr/local/bin
SCRIPT_NAME := sast.sh
COMMAND_NAME := sast

SHELL_CONFIG := $(HOME)/.bashrc
ifeq ($(shell echo $$SHELL), /bin/zsh)
    SHELL_CONFIG := $(HOME)/.zshrc
endif

all: install

install: copy_script configure_shell

copy_script:
	@echo "Copying script to $(INSTALL_DIR)..."
	@sudo cp $(SCRIPT_NAME) $(INSTALL_DIR)/$(COMMAND_NAME)
	@sudo chmod +x $(INSTALL_DIR)/$(COMMAND_NAME)

configure_shell:
	@echo "Configuring shell..."
	@if ! grep -Fxq 'export PATH=$$PATH:$(INSTALL_DIR)' $(SHELL_CONFIG); then \
		echo 'export PATH=$$PATH:$(INSTALL_DIR)' >> $(SHELL_CONFIG); \
		echo 'Added $(INSTALL_DIR) to PATH in $(SHELL_CONFIG)'; \
	fi
	@if ! grep -Fxq 'alias $(COMMAND_NAME)=$(INSTALL_DIR)/$(COMMAND_NAME)' $(SHELL_CONFIG); then \
		echo 'alias $(COMMAND_NAME)=$(INSTALL_DIR)/$(COMMAND_NAME)' >> $(SHELL_CONFIG); \
		echo 'Added alias $(COMMAND_NAME) to $(SHELL_CONFIG)'; \
	fi
	@echo "Installation complete. Please restart your terminal or run 'source $(SHELL_CONFIG)'."

uninstall:
	@echo "Removing script from $(INSTALL_DIR)..."
	@sudo rm -f $(INSTALL_DIR)/$(COMMAND_NAME)
	@echo "Removing configuration from $(SHELL_CONFIG)..."
	@sed -i '/export PATH=$$PATH:$(INSTALL_DIR)/d' $(SHELL_CONFIG)
	@sed -i '/alias $(COMMAND_NAME)=$(INSTALL_DIR)\/$(COMMAND_NAME)/d' $(SHELL_CONFIG)
	@echo "Uninstallation complete. Please restart your terminal or run 'source $(SHELL_CONFIG)'."
