This file dives through the files and folder structure to explain the use and setup of each one
```
/
├── .github/
    ├── readme.md
    ├── CODEOWNERS
    ├── CHANGELOG.md
    ├── Checklist
    ├── pull_request_template.md
    ├── ISSUE_TEMPLATE/
    ├── PULL_REQUEST_TEMPLATE/
    └── workflows/

├── .vscode/
    ├── compose.code-snippets
    ├── swarm.code-snippets
    └── settings.json

├── compose/
	└── group/
    	└── project.compose.yml

├── configs/   (not tracked by git)
	└── group/
		└── project/
			└── app.config

├── data/      (not tracked by git)
	└── group/
		└── project/
			└── app/

├── logs/      (not tracked by git)
	└── group/
		└── project/
			└── app.log

├── runners/
    └── compose.sh
    └── services.sh
    └── stack.sh
    └── custom.sh
    └── scheduled.sh

├── scripts/
    └── setup.sh
    └── genenv.sh
    └── gensec.sh
    └── runstack.sh


├── secrets/   (not tracked by git)
	└── group/
		└── project/
			└── service.env

├── services/  (not tracked by git)
    └── github-repo/
    └── staticapp/

└── stacks/
	└── group/
    	└── project.compose.yml

```

# .github/
consists of information about this repository and its functionality

- readme.md
the main readme(after the repo is setup for the server)
- CODEOWNERS
you along with anyone who should have ownership(responsibility) of the repo
- CHANGELOG.md
dated log of releases of changes made to the services/server
- Checklist
a simple checklist you may need before taking an action on the server
- pull_request_template.md
enables the user to pick the PR template on the create new PR screen

## ISSUE_TEMPLATE/
consists predifined issue templates helpful to keep track of issues faced by users(or yourself) to help you manage your server better :)

## PULL_REQUEST_TEMPLATE/
a bunch of pr templates to create proper PRs with details that are helpful instead of a generic data

## workflows/
Automated workflow file can go here to help you manage the server/s and deploy stuff without needing to manually login yourself
PS: run the template-setup.yml after installing/forking the repo to setup this repo

# .vscode/
consists of vscode setup for snippets and settings to help you create faster

- compose.code-snippets
compose code snippets to develop services and stacks quickly

- swarm.code-snippets
swarm code snippets to develop services and stacks quickly

- settings.json
vscode settings to prepare a dev env

# compose/
consists of project folders which contain your docker compose files
eg 
```
├── compose/
	└── collaboration/
    	└── project.compose.yml
    	└── chat.compose.yml

```
this helps you seperate the services and thier databases etc for ease of management
each of your files will be picked for automatically running with the scripts

# configs/
the common config folder for both compose and swarm services
_this folders contents are not tracked by git_

# data/
the folder holding all the data of your volumes map every volume to a folder or a subfolder to access and backup things well
_this folders contents are not tracked by git_

# logs/
can be used to setup and store all the logs from the services for ease of access
_this folders contents are not tracked by git_

# runners/
interdependant and automated scripts that do the main heavy lifting
need to automate some tasks add them here and to other scripts to call them directly(or add them to your crontab)

# scripts/
scripts that need manual invocations, useful for setups and stuff

# secrets/
used to store and track the envs/secrets etc
_this folders contents are not tracked by git_

# services/
custom services that may bit full github repos to custom static apps,etc
just add in the commands needed to run to get the seervice setup into the runners/services.sh script
_this folders contents are not tracked by git_

# stacks/
consists of project folders which contain your docker swarm compose files
eg 
```
├── stacks/
	└── collaboration/
    	└── project.compose.yml
    	└── chat.compose.yml

```
this helps you seperate the services and thier databases etc for ease of management
each of your files will be picked for automatically running with the scripts
