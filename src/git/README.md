## Gogs setup
> Please consult with [Gogs on Docker Hub](https://hub.docker.com/r/gogs/gogs/) and [Gogs Documentation](https://gogs.io/docs) for more detail.

1. Stage Gogs (git) and MySQL (git-db) containers

    The following comands will navigate to the directory containing `git_docker_compose.yml` and run the containers in the background.  

    > The `.env` file in `/src/git` directory contains environment variable values for the containsers, review and modify if necessary.

    ```
    $ sudo cd /tmp/shoebox/src/git
    $ sudo docker-compose up -d
    ```

    <a name="docker-logs"></a>Run `sudo docker ps` to verify that `git` and `git-db` are up and runnig. Procced if no error detected, otherwise run `sudo docker logs [container name]` to check the logs for troubleshooting.

2. Configure Gogs

    - Navigate to git.yourdomain.com to open the Gogs installer page
    - Set configuration option as follows
      > Despite creating an admin user being optional it is recommended to creat one as a failover option in case the SMTP relay is unreachable.
      
      > Do not forget to replace `yourdomain.com` with the actual domain name and use real email addresses.

      | Database Settings |                                                                                           |
      | :---------------- | :---------------------------------------------------------------------------------------- |
      | Database Type     | **MySQL**                                                                                 |
      | Host              | _services:git-db:hostname_ from `git_docker_compose.yml`, leave the number port unchanged |
      | User              | _GOGS_MYSQL_USER_ from `.env`                                                             |
      | Password          | _GOGS_MYSQL_USER_PASSWORD_ from `.env`                                                    |
      | Database Name     | _GOGS_MYSQL_DATABASE_ from `.env`                                                         |
      
      | Application General Settings |                            |
      | :--------------------------- | :--------------------------|
      | Application URL              | https://git.yourdomain.com |

      | Optional Settings                        |                                      |
      | :--------------------------------------- | :----------------------------------- |
      | ***Email Service Settings***             |                                      |
      | SMTP Host                                | Accorgin to the SMTP relay settings  |
      | From                                     | i.e. git@yourdomain.com              |
      | Sender Email                             | Accorgin to the SMTP relay settings  |
      | Sender Password                          | Accorgin to the SMTP relay settings  |
      | Enable Register Confirmation             | [x] _Optional_                       |
      | Enable Mail Notification                 | [x]                                  |
      | ***Server and Other Services Settings*** |                                      |
      | Disable user self-registration           | [x]                                  |
      | Enable Require Sign In to View Pages     | [x]                                  |
      | ***Admin Account Settings***             |                                      |
      | Username                                 | i.e. gitadmin                        |
      | Admin Email                              | i.e. git@yourdomain.com              |

3. Press **Install Gogs**. If Gogs is installed successfuly it will create an `app.ini` configuration file at `$GOGS_ROOT/data/gogs/conf` (see `setup_volumes_storage.sh` for the `$GOGS_ROOT` value). Check [Googs Configuration Cheat Sheet](https://gogs.io/docs/advanced/configuration_cheat_sheet) for post installation configuration.

    > Do not forget to restart the `git` container after modifying `app.ini`, otherwise new configuration settings will not be applied.

4. Sign in with the admin user and follow the checklist:
    - [x] A new user can be created and receives an email notification upon registration
    - [x] A new repository can be created
    
    If the checks are passed Gogs is successfuly configured and ready for use. Otherwise, check the container logs (as mentioned [here](#docker-logs)) or Gogs logs at `$GOGS_ROOT/data/gogs/log`.