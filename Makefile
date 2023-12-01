OS=$(shell uname -s)

all: install-packages configure

no-packages: link-dotfiles link-acfiles

validate-os:
	OS=${OS} ./scripts/validate_os.sh

install-packages: validate-os link-dotfiles link-acfiles
	OS=${OS} ./scripts/install_packages.sh

link-dotfiles:
	./scripts/link_dotfiles.sh

link-acfiles:
	./scripts/link_acfiles.sh

enable-ssh: validate-os
	OS=${OS} ./scripts/enable_ssh.sh

configure: validate-os
	OS=${OS} ./scripts/configure.sh

