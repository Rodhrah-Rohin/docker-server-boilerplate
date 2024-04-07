# Setup
- Add a new branch `STACK/stack_name` to github which will be the base for the services under the stack
- Add a new branch based off of the `STACK/stack_name` and name it `SERVICE/service_name` this comprises of only that service configuration

# Add a new Stack
- Plan out the stack and segregate them by only putting services that make sense in the stack
- Add the `stack`.yml file in the scoped folder(private|protected|public)
- Use the _stack_ snippet to get things done quicker
- Add relevant network/s volumes to the stack ⬇️

### Add a new Network/VLAN
- Use the run.sh in the corresponding scope of the network
	- If the network is only needed in private scope add it to the private run.sh file

### Add a new Volume
- Use the run.sh in the corresponding scope of the volume
	- If the volume is only needed in private scope add it to the private run.sh file

# Add a new Service
- Add a configuration file under the ../config/ folder
- Add envs/secrets to the service ⬇️

### Add new env vars
- You can use the [Scripts/genenv.sh](../Scripts/genenv.sh) file to generate envs securely

### Add new secrets
- You can use the [Scripts/gensec.sh](../Scripts/gensec.sh) file to generate secrets securely

# Finally
- Test out the changes locally
- Update the [CHANGELOG.md](./CHANGELOG.md)
- push to github and create a PR to the parent branch

- once merged ⬇️(For admins)
- ssh into the server, set up the [secrets](#add-new-secrets) and [envs](#add-new-env-vars)
- run the release.yml workflow in github
- verify successful run of the services by going through the [logs](../logs/)
