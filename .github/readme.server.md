# <SERVER_NAME> Server

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
- The project assumes you have git installed and configured on your server
- The project assumes you have SSH installed and configured on your server
- This project is most productive when worked on VSCode
	- Use the `stack` and `service` snippets to quickly get up and running while development
- The project intends to use the cloudflare tunnels to directly connect to the services without need of other network hassles - [Cloudflared Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/)
- There are 3 tunnels needed to securely seperate the private,protected, and public networks for added security
- DO NOT UPDATE THE INTERPOLATED DATA($SECRET_DIR, $DATA_DIR, etc) as they are used to run docker compose stacks programatically

## Guidelines/Steps
Please go through the [general list of good practices](./Guidelines.md)

## Files/Folder organization
### [check the folder.md in root of the project](../folder.md)

## Workflow of the project
### [Checklist can be found here](./Checklist.md)

## Read up a bit more
[Docker Compose](https://docs.docker.com/compose/)
[Cloudflare](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/)
