
![PyPI - Status](https://img.shields.io/pypi/status/Django.svg) [![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/) ![Read the Docs](https://img.shields.io/readthedocs/pip.svg) 
![Plugin on redmine.org](https://img.shields.io/redmine/plugin/rating/redmine_xlsx_format_issue_exporter.svg)



## What Is Ansible?
is an open source software that automates software provisioning, configuration management, and application deployment.

## The Keys Features of Ansible
### Agentless
There is no software or agent to be installed on the client that communicates back to the server.
### Idempotent
No matter how many times you call the operation, the result will be the same.
### Simple and extensible
Ansible is written in Python and uses YAML for playbook language, both of which are considered relatively easy to learn.


---

## Installion
Installing and Running Ansible
```bash
# ubuntu 
sudo apt-get install ansible
#mac-OS
brew install ansible
```
For other OS check [link](https://docs.ansible.com/ansible/2.5/installation_guide/intro_installation.html)

## Ansible Architecture
### Modules
small programs that do some work on the server, so for example instead of running this command
```bash 
sudo apt-get install htop
```
we can use apt module and install htop
```bash
- name: Install htop
  apt: name=htop
```

Using module give you the ability to know if it's installed or not.

## Plugins
Plugins are pieces of code that augment Ansible's core functionality. Ansible ships with a number of handy plugins, and you can easily write your own.
## Host inventories
To provide a list of hosts, we need to provide an inventory list. This is in the form of a hosts file.
In its simplest form, our hosts file could contain a single line:
```yml
35.178.45.231  ansible_ssh_user=ubuntu
```

## Playbooks
Ansible playbooks are a way to send commands to remote computers in a scripted way. Instead of using Ansible commands individually to remotely configure computers from the command line, you can configure entire complex environments by passing a script to one or more systems.

## group_vars
file contains set of variables for example db username and password.

## Roles
Roles are a way to group multiple tasks together into one container to do the automation in very effective manner with clean directory structures
## Handlers
Handlers are lists of tasks, not really any different from regular tasks, that are referenced by a globally unique name, and are notified by notifiers. If nothing notifies a handler, it will not run. Regardless of how many tasks notify a handler, it will run only once, after all of the tasks complete in a particular play.

## Tags
If you have a large playbook it may become useful to be able to run a specific part of the configuration without running the whole playbook.




### Disclaimer 
  This project will help you to deploy your Laravel project to your VPS  without a headache 
it contains by default PHP - MySql - Redis - Nginx

I suffered a lot while migrating my code base from VPS to another, I migrated my code base like 20 times between different servers 
then I had to automate the process to save my time 

currently I able to migrate from VPS to another in less than  5 minutes without any human interactions,  
i update my `hosts.ini`, run a single command `make apply` then I bring my coffee, watch Ansible. 

Pull my latest changes using a single command `make code-deploy`

 
## Project structure 
```
├── README.MD
├── MakeFile                # file contains some aliases to get started quickly 
├── .vault_pass.txt        # file contains your vault config pass
├── ansible.cfg           # contains ansible default config 
├── code-deploy.yml       # playbook to pull latest changes and deploy code 
├── files                    # file contains sql_dump if you have one 
│   └── dump.sql
├── group_vars                # file to store all your settings [ssh-keys,php_version,..etc]
│   └── vars.yml
├── handlers                # basic handlers to restart nginx || php-fpm
│   └── main.yml
├── hosts.ini                # file that contains your host IP 
├── logs                    # this file contains error log details 
│   └── ansible-log.log
├── roles
│   ├── bootstrap-app
│   │   └── tasks
│   │       └── main.yml
│   ├── code-deploy
│   │   ├── tasks
│   │   │   ├── config-files.yml
│   │   │   └── main.yml
│   │   └── templates
│   │       └── env.conf
│   ├── misc
│   │   └── tasks
│   │       └── main.yml
│   ├── mysql
│   │   └── tasks
│   │       ├── config.yml
│   │       └── main.yml
│   ├── nginx
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── templates
│   │       └── nginx.conf
│   ├── php
│   │   └── tasks
│   │       └── main.yml
│   └── redis
│       └── tasks
│           └── main.yml
├── scripts                                    # some important scripts
│   ├── install_composer.sh
│   └── startup.sh
└── site.yml                                    # Main playbook to deploy all tasks 
```

## Quick start 

Before you start make sure you did these steps into your VPS 
you can add it  as a startup script 

```
#!/bin/sh
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install -y python2.7 python3 python-pip
```


### Clone Repo 
```
git clone https://github.com/ahmedfaragmostafa/Ansible-in-action.git
```

## Update ssh-keys
you have to ad you server id_rsa.pub to your github access keys 
by login to your instance and 
``` bash
ssh-keygen
sudo chmod -R 644 .ssh/id_rsa
cat .ssh/id_rsa.pub
# add it to your git account
```

### Update `hosts.ini` file 
```
[aws]
#your server  IP
127.0.0.39
```

### Update `vars.yml` file 
you have to define you config inside `group_vars/vars.yml`

``` yml
#for example
ansible_ssh_user: "ubuntu"
current_user: "ubuntu"
server_name: "your WebSiteName"
repo_git_url: "you Repo"
mysql_db: sql_db
mysql_user: sql_user
mysql_pass: "put_your_db_pass"
```

by default, all these configs will be populated to `.env`
have a look at `env.conf` file 



### Encrypt & Decrypt your config  using vault [optional step]
``` bash
#first create .vault_pass.txt to save your key 
touch .vault_pass.txt
echo 'YOUR_CONFIG_PASS' > .vault_pass.txt

# encrypt your config
make encrypt-vars

# decrypt your config
make decrypt-vars
```

### Note
If you encrypted your config don't forget to use `--vault-password-file  .vault_pass.txt`
i added both options if you use  any commands that start with `safe-`
if you don't use vault use commands that don't have `safe-`

```
#with vault pass
make safe-apply 

# without 
make apply 
```

## MakeFile
run `make`  inside project dir you will get following tasks:- 

```
Available tasks:
    encrypt-vars                            Encrypt your vars file
    decrypt-vars                            Decrypt your vars file
    apply                                   Deploy your changes into your hosts
    safe-apply                              Deploy your changes into your hosts using vault pass
    code-deploy                             Pull latest changes
    safe-code-deploy                        Pull latest changes with vault pass
    update-config                           Update your env file
    safe-update-config                      Update your env file with vault pass
```


## Apply your changes

``` bash
# RUN PLAY BOOK
make apply

#to pull latest changes 
make  code-deploy

# run specific tag 
make apply  --tags="php" -vv

#install specfic tag
make apply   --tags="php" -vv

#update config files 
make update-config
```

## TODO
- [ ] Adding terraform 
- [ ] clone repo using local id_rsa 
- [ ] Ansible as provision in terraform 
- [ ] automate startup script
- [ ] automate and provision  instances and generate id_rsa key
