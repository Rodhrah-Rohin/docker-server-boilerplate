## General Guidelines for Server, Docker/Docker-compose, and Cloudflared

### Server
- Set up the repo under a meaninful folder instead of the default root
- Use the .env/.secret file to store the sensitive data
	- you can use the secrets folder to store the env files, use the genenv.sh to generate a bunch of them and get the env file paths to use in the compose files
	- similarly, for the secret files use the gensec.sh to generate a bunch of them and get the secret file paths
- Create a new user `Docker` that does not have root access and give docker access to only that user
	- This ensures that if any escalation happens it wont give the attacker access to the server

### Docker/Docker-compose
_A lot of the points below are picked from this [site](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/)_
- Do NOT Just blindly trust a image and host it, please do verify the contents and usage of the image as they may be used to do other tasks(Crypto mining)
- Isolation is key
	- have seperated networks for each stack and scope
	- you can create and reuse networks but keep the access them to bare minimum and if absolutely needed by the services
- Prefer using docker secrets but if that is a hassle
- Use the secret/env files to safely store the sensitive data
	- Have seperated files for each stack(prefer seperate services if you are up for it)
- Expose ports rather than mapping them
	- This ensures only cloudflared has access to them and no other entity can access it from outside the docker network until intended
	- If you are mapping ports than use the env files to hide the port in static code
- Use stable versions of the image instead of the latest ones
	- They tend to be more tested and robust
- Try to use images with alpine as the base image
	- These tend to be smaller in size helping you to have faster and smaller backups
	- They have lesser clutter of background services, which reduces your attack surface
- Run a vunerability checks on a good interval/every PR to have a secure server
- Have a easily understandable naming scheme predetermined
- Control docker resource usage

## Cloudflared
- Isolate the tunnels by hosting them in a network
	- This ensures cloudflared can't access other services it should not have access to(Eg. public cfd can still see private services if they are on the same network/vlan)
- Ideally have different domains for different scopes, but subdomains work just as well(Eg. \*.admin.domain.com is protected scope, \*.domain.com is public)
- Add and configure the private and protected scope apps/services to the zero trust even before developing the service
	- This helps you protect the service from the moment it is available
- Have the policies preconfigured so that you can setup quickly
