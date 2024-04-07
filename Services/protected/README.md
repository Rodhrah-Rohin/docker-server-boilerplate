# Private Service folder
This folder is to be used for only the admin level services eg: backup generator, system analytics, portainer, etc

### Files and folder structure
- compose/ - The main folder consisting of all the stacks in docker compose
  - NOTES!!!
    - Keep the compose file names as [stack].yml
    - To use the snippets for stack file you can type in `"stack","compose","docker-compose"`
      - Here VSCode will select all occurences of `network` for you to easily type and update after which you can press tab to go to `stack`
    - To use the service snippet you can type in `"service","compose-service"`
      - Here VSCode will select all occurences of `service` for you to easily type and update after which you can press tab to go to `stack`, `network` and `domain`
- configs/ - The configuration folder consisting of all the service configs
- logs/ - You can use this folder to store logs specific to this scope

- run.sh - Automatically run by root run.sh but you can add networks and volumes specific to this scope here
- README.md - HELLOOOOO

### How to use envfile and secrets in the compose files
#### Secrets
_note:Secrets are only applicable to supported images(generally the official images in docker hub)_
- use the [gensec.sh](../../Scripts/gensec.sh) file to generate secrets[needs root access]
- You can use the compose template and update/add the secrets you have added using the file above(you get a list of secrets paths that you can just copy paste in)
- declare the top level secrets in the container level as well( just give access to those secrets that the container needs access to/supports)
- add into the environment element in the container 
```
environment:
  - SECRET_ENV_FILE=/run/secrets/TOP_LEVEL_SECRET_NAME
```
_note:the _FILE is needed to read from the file instead of a direct value_

#### Env  Files
- use the [genenv.sh](../../Scripts/genenv.sh) file to generate secrets[needs root access]
- You can use the service template and update/add the envfiles you have added using the file above(you get a list of env paths to the services that you can just copy paste in)

## Where to store data

You may notice a lack of the data folder under scoped folders this is so that is can be securely stored some place else
If you used the setup.sh to set up this server then you may have set the data folder path that can be used with `$DATA_DIR` env variable
