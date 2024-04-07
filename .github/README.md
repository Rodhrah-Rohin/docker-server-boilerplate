# <SERVER_NAME> Server

## VPS Details 
**Server Code**: <SERVER_CODE>

**Specification**:
	
	- CPU:  <SERVER_CPU_COUNT>

	- RAM: <SERVER_RAM>

	- Storage: <SERVER_STORAGE_CAPACITY> <SERVER_STORAGE_TYPE>


# First steps
- Run the template-setup action in github

- Setup these variable in github for proper functioning of workflows
	- SSH_HOST
	- SSH_USERNAME
	- SSH_PASSWORD
	- SSH_PRIVATE_KEY
	- PATH (The path from root where you have set the repo in the server)

## Precautions/Disclaimers
- This is a template made for personal use and is based on my specific use case, although as the template consists of the general pieces used to maintain docker stacks you can use it to fit your projects/deployments as well
- The template is intended to be used on a LINUX SERVER only
- This project is most productive when worked on VSCode
	- Use the `stack` and `service` snippets to quickly get up and running while development
- The resolver used to internally resolve hostnames to domain names is traefik - [Traefik Docs](https://doc.traefik.io/traefik/)
- The project intends to use the cloudflare tunnels to directly connect to the services without need of other network hassles - [Cloudflared Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/)
- There are 3 tunnels needed to securely seperate the private,protected, and public networks for added security
- DO NOT UPDATE THE INTERPOLATED DATA($SECRET_DIR, $DATA_DIR, etc) as they are used to run docker compose stacks programatically

## Guidelines/Steps
Please go through the [general list of good practices](./Guidelines.md)

## Files/Folder organization

- .Github/ - Consists of all information and functions related to github
	- Workflows/ - Consists of automated workflows to help you manage the deployment and management of you server
		- Release.yml - releases the code in main branch and deploys the services
		- schedule.yml - runs tasks on a schedule like updates, backups, health checks, etc
	- CHANGELOG.md - track the updates and help others understand what changed
	- Guidelines.md - a good set of suggestions to use to help you run secure and stable  services
	- README.md - Hellooo 😊

- Services/ - Consists of the scope seperated services
	- Private/ - Services needed only to the administration
		- Readme.md - Please read through before development
	- Protected/ - Services accessible to the company employees as well
		- Readme.md - Please read through before development
	- Public/ - Accessible by anyone on the internet
		- Readme.md - Please read through before development

- Templates/ - Consists of templates that can be used to quickly configure services
	- service.yml - this is a service snippet to quickly get a service pasted(add these to the VSCODE snippets to be more efficient)
	- stack.compose.yml - this is a service snippet to quickly get a service pasted(add these to the VSCODE snippets to be more efficient)

- logs/ - Consists of all the logs created by the repository(high level)

- Scripts/ - Consists of scripts to help you quickly maintain the configurations
	- setup.sh - first time initialization to help properly set up, install, and configure docker with docker compose __suggested to delete this file after a completed install__
	- genenv.sh - generate a bunch of env files securely to use in compose files
	- gensec.sh - generate a bunch of secret files securely to use in compose files


- run.sh - the list of commands fired to setup/update the services

## Workflow of the project
### [Checklist can be found here](./Checklist.md)

## Read up a bit more
[Docker Compose](https://docs.docker.com/compose/)
[Traefik](https://doc.traefik.io/traefik/)
[Cloudflare](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/)
