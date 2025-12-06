# Docker Compose Snippet Guide

This guide explains the available snippet prefixes you can type to quickly insert Docker Compose configurations, along with descriptions and variable explanations.

***

## Snippets Overview with Prefixes

1. **Docker Compose Service (file level)**
    - Prefixes: `df`, `docker-service`
    - Description: Creates a basic Docker Compose file with a name based on the folder and filename, and sections for volumes, networks, and services.
    - Variables:
        - `${1}`: Group folder name from current directory
        - `${2}`: Base filename without extension
2. **Compose New Local Volume (file level: volume)**
    - Prefixes: `nlv`
    - Prefixes: `cnlv`, `composenewlocalvolume`
    - Prefixes: `snlv`, `swarmnewlocalvolume` (for swarm)
    - Description: Defines a new local volume with a name derived from folder, filename, and service name.
    - Variables:
        - `$1`: Service or volume identifier (e.g., "app")
        - `${2}`: Filename base
        - `${3}`: Directory name from current folder
        - `${1}_data`: Volume key name
        - Uses driver options with `device` bound to path `$DATA_DIR/...`
3. **Compose Existing Local Volume (file level: volume)**
    - Prefixes: `elv`
    - Prefixes: `celv`, `composeexistinglocalvolume`
    - Prefixes: `selv`, `swarmexistinglocalvolume` (for swarm)
    - Description: Connects to an existing external volume by name.
    - Variables:
        - Same as "Compose New Local Volume" for naming and binding.
4. **Compose New Local Network (file level: network)**
    - Prefixes: `nln`
    - Prefixes: `cnln`, `composenewlocalnetwork`
    - Prefixes: `snln`, `swarmnewlocalnetwork` (for swarm)
    - Description: Creates a new Docker network with customizable settings and placeholders for attachable and labels.
    - Variables:
        - `$1`: Network identifier
        - `${2}`: Folder name
        - `${1}`: Filename base (used again for network name)
5. **Compose Existing Local Network (file level: network)**
    - Prefixes: `eln`
    - Prefixes: `celn`, `composeexistinglocalnetwork`
    - Prefixes: `seln`, `swarmexistinglocalnetwork` (for swarm)
    - Description: Connects to an existing external network.
    - Variables:
        - Same as new network for naming.

***

## Service Level Snippets

6. **Docker Service Init/Info Section**
    - Prefixes: `init`,`info`, `dcsinfo`, `serviceinfo`, `initservice`
    - Description: Basic service configuration including image, container name, hostname, domain, aliases, description, and labels.
    - Variables:
        - `$1`: Service name
        - `${2}`: Domain (default example.com)
        - `${3}`: Description
        - `${4}`: Justification for service
        - `${5}`, `${6}`: Image and tag
        - `${7}`, `${8}`: Filename base and directory for naming container usage

> Before proceeding further copy your Service name as further steps use clipboard  to autofill fields 

7. **Docker Service Control Section**
    - Prefixes: `control`, `dcscontrol`, `servicecontrol`
    - Description: Controls privileges, restart policies, dependencies with conditional restart and requirement flags.
    - Variables:
        - `${1}`: privileged (true/false)
        - `${2}`: restart policy (no, always, on-failure, etc.)
        - `${3}`: dependency service name
        - `${4}`: dependency condition
        - `${5}`, `${6}`: restart and required flags for dependency

        7.1 **Docker Swarm Deploy Section**
          - Prefixes: `swarm`, `deploy`, `dcsswarm`, `dcsdeploy`, `servicedeploy`, `serviceswarm`
          - Description: Swarm deployment mode including replicas, placement constraints, resources, restart policies, rollback, and update configurations.
          - Variables:
              - `${1}`: Endpoint mode (vip, dnsrr)
              - `${2}`: Replicas count
              - `${3}`: Global mode true/false
              - `${4}`: Node role manager/worker
              - `${5}-${8}`: CPU and memory limits and reservations
              - `${9}-${24}`: Restart, rollback, and update policy configuration parameters
8. **Docker Service Environment Section**
    - Prefixes: `env`, `dcsenv`, `serviceenv`
    - Description: Environment variable file inclusion and optional inline environment variables.
    - Variables:
        - `${3}`, `${2}`, `${1}`: Folder, filename base, and filename (clipboard by default) used in env_file path
9. **Docker Service Network Section**
    - Prefixes: `net`, `dcsnet`, `servicenet`
    - Description: Network mode, network attachment, ports, exposure, DNS, and links configuration.
    - Variables:
        - `${3}`: Network mode (none, host, service, container)
        - `${5}`, `${4}`: Folder and filename base used for network naming
        - `${1}`, `${2}`: Expose and internal port numbers
        - `${6}`: link service name
10. **Docker Service Storage Section**
    - Prefixes: `store`, `dcsstore`, `servicestore`
    - Description: Storage size options and volumes binding.
    - Variables:
        - `${1}`: Size limit
        - `${5}`, `${4}`, `${3}`: Folder, filename base, and other identifiers for volume name
        - `${2}`: Internal volume path
11. **Docker Service Health Section**
    - Prefixes: `logs`, `health`, `dcslogs`, `dcshealth`, `servicelogs`, `servicehealth`
    - Description: Container health check test command, timing parameters, logging driver, and options.
    - Variables:
        - `${1}`: Attach flag true/false
        - `${2}`: Health check test command
        - `${3}, ${4}, ${5}, ${6}`: Interval, timeout, retries, start period settings
        - `${7}`: Logging driver (json-file, local, syslog)
12. **Docker Service Hardware Section**
    - Prefixes: `hw`, `dcshw`, `servicehw`
    - Description: CPU allocation and memory settings for the service.
    - Variables:
        - `${1}`: CPU count
        - `${2}`: CPU percent
        - `${3}`: Memory limit
        - `${4}`: Memory reservation
13. **Docker Service Capabilities Section**
    - Prefixes: `cap`, `dcscap`, `servicecap`
    - Description: Adding/dropping Linux capabilities from containers.
    - Variables:
        - `${1}`: Capabilities to add (default ALL)
        - `${2}`: Capabilities to drop (default ALL)


## How to Use the Snippets

- Start with the **`df`** prefix snippet to create the overall Docker Compose file scaffold. This sets the project name based on your directory and filename.
- Define volumes and networks:
    - Use **`nlv`** to create new local volumes.
    - Use **`nln`** to create new local networks.
- Add your services under the `services:` section using the service-level snippets:
    - **`info`** for service basics like image, container name, description.
    - **`control`** to add restart policies, privilege settings, and dependencies.
    - **`deploy`** for Docker Swarm deployment configuration (replicas, placement, resources).
    - **`env`** for environment variables and env_file inclusion.
    - **`net`** to configure network mode, ports, and DNS settings.
    - **`store`** for volume mounting and storage options.
    - **`logs`** or **`health`** for healthchecks and logging.
    - **`hw`** to specify hardware limits like CPU and memory.
    - **`cap`** for setting container capabilities.

***

## Example Docker Compose File Using Snippets

```yaml
name: "myproject_myapp"

volumes:
  cnlv_data:
    name: "myproject_myapp_app_volume"
    driver: local
    driver_opts:
      device: \$DATA_DIR/myproject/myapp/app/
      o: bind
      type: local

networks:
  cnln_network:
    name: "myproject_myapp_network"
    # attachable: true

services:
  web:
    # info
    image: "nginx:latest"
    container_name: "myproject_myapp_web"
    hostname: "web_myapp_myproject"
    domainname: "web.example.com"
    aliases:
      - "web.myapp.myproject"
      - "web.example.com"
    description: "A simple nginx web server"
    labels:
      com.portainer.infra.commin.description: "A simple nginx web server"
      com.portainer.infra.commin.justification: "Serve web content"

    # control
    privileged: false
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
        restart: true
        required: true

    # env
    env_file:
      - \$SECRETS_DIR/myproject/myapp/web.env
    # environment:
    #   - ENV_VAR=value

    # net
    network_mode: bridge
    networks:
      - myproject_myapp_network
    ports:
      - "8080:80"
    expose:
      - "80"
    dns:
      - "1.1.1.1"
      - "8.8.8.8"
    links:
      - db

    # store
    storage_opts:
      size: "1G"
    volumes:
      - myproject_myapp_app_data:/var/www/html

    # logs/health
    attach: true
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost/ || exit 1"]
      interval: 1m
      timeout: 10s
      retries: 3
      start_period: 1m
    logging:
      driver: json-file
      options:
        max-size: 10m
        max-file: 3

    # hw
    cpu_count: 1
    cpu_percent: 100
    mem_limit: 512M
    mem_reservation: 256M

    # cap
    cap_add:
      - NET_ADMIN
    cap_drop:
      - ALL

    # deploy
    deploy:
      endpoint_mode: vip
      mode:
        replicated:
          replicas: 2
      placement:
        constraints:
          - node.role == worker
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
        window: 120s
      rollback_config:
        parallelism: 0
        delay: 0s
        failure_action: pause
        monitor: 0
        max_failure_ratio: 0
        order: stop-first
      update_config:
        parallelism: 1
        delay: 5s
        failure_action: continue
        monitor: 0
        max_failure_ratio: 0
        order: start-first

  db:
    image: postgres:13
    environment:
      POSTGRES_USER: example
      POSTGRES_DB: exampledb
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 30s
      timeout: 10s
      retries: 5
    volumes:
      - myproject_myapp_db_data:/var/lib/postgresql/data
    networks:
      - myproject_myapp_network

volumes:
  myproject_myapp_app_data:
  myproject_myapp_db_data:

networks:
  myproject_myapp_network:
```


***

## Explanation for Users

- Begin with the **`df`** prefix snippet to scaffold your compose file name, volumes, networks, and services.
- Use **`cnlv`** to declare new local volumes for persistent data storage tied to your project.
- Use **`cnln`** to set up a dedicated network for your services to communicate securely.
- Define your application services by combining the informational snippet (`info`) with control parameters (`control`) for restart and dependency management.
- Configure environmental configuration using `env` with environment files for cleaner management.
- Setup networking options (`net`) including ports, DNS, and network mode.
- Add storage mounts to your containers with `store` to preserve data.
- Use `logs` or `health` to setup container healthchecks and logging configuration.
- Limit resource usage and allocate CPU/memory via `hw`.
- Adjust Linux capabilities securely via `cap`.
- If deploying in a swarm, configure the swarm deployment specifics with `deploy`.

This layered approach using snippets accelerates Docker Compose file creation and ensures standardized, documented service definitions, volumes, and networks.
