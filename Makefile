.DEFAULT_GOAL := help

help:
	@echo ""
	@echo "Available tasks:"
	@echo "    encrypt-vars 				    		Encrypt your vars file"
	@echo "    decrypt-vars 				    		Decrypt your vars file"
	@echo "    apply 				    			Deploy your changes into your hosts"
	@echo "    safe-apply 				    			Deploy your changes into your hosts using vault pass"
	@echo "    code-deploy 				    		Pull latest changes "
	@echo "    safe-code-deploy 				    		Pull latest changes with vault pass"
	@echo "    update-config 				    		Update your env file"
	@echo "    safe-update-config 				    		Update your env file with vault pass"

	@echo ""

encrypt-vars:
	ansible-vault encrypt group_vars/vars.yml --vault-password-file .vault_pass.txt

decrypt-vars:
	ansible-vault decrypt group_vars/vars.yml --vault-password-file .vault_pass.txt

apply:
	ansible-playbook site.yml

safe-apply:
	ansible-playbook site.yml --vault-password-file  .vault_pass.txt


code-deploy:
	ansible-playbook code-deploy.yml

safe-code-deploy:
	ansible-playbook code-deploy.yml --vault-password-file  .vault_pass.txt

update-config:
	ansible-playbook code-deploy.yml --tags="env-file"

safe-update-config:
	ansible-playbook code-deploy.yml --tags="env-file" --vault-password-file  .vault_pass.txt



.PHONY: help  encrypt-vars decrypt-vars apply safe-apply
