# mpeterson/jira
## Features
  * External data volume
  * Allow to override or add files to the image when building it.

## Usage
This example considers that you have a [data-only container](http://docs.docker.io/use/working_with_volumes/) however it's not needed for it to run correctly.

```bash
sudo docker run -d --volumes-from jira_data -e DATABASE_URL='postgresql://jira:jellyfish@172.17.0.2/jiradb' --link pgsql:pgsql -p 7990:7990 -p 7999:7999 --name jira mpeterson/jira
```

In this example we are exposing the default Jira's ports.

### Volumes
  * ```/data``` volume is where your sites should be contained. This path has a symlink as ```/opt/jira-home/```. Can be overriden via environmental variables.

It is recommended to use the [data-only container](http://docs.docker.io/use/working_with_volumes/) pattern and if you choose to do so then the volumes that it needs to have is ```/data```.

### Override files
In the case that the user wants to add files or override them in the image it can be done stated on this section. This is particularly useful for example to add a cronjob or add certificates.

Since docker 0.10 removed the command ```docker insert``` the image needs to be built from source.

For this a folder ```overrides/``` inside the path ```image/``` can be created. All files from there will be copied to the root of the system. So, for example, putting the following file ```image/overrides/etc/ssl/certs/cloud.crt``` would result in that file being put on ```/etc/ssl/certs/cloud.crt``` on the final image.

After that just run ```sudo make``` and the image will be created.

## Configuration
Configuration options are set by setting environment variables when running the image. This options should be passed to the container using docker
```-e <variable>```. What follows is a table of the supported variables:

Variable     | Function
------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------
DATA_DIR     | Allows to configure where the path that will hold the files. Bear in mind that since the Dockerfile has this hardcoded so it might be neccesary to build from source
DATABASE_URL | Connection URL specifying where and how to connect to a database dedicated to Jira. This variable is optional and if specified will cause the Jira setup wizard to skip the database setup set. Format: ```[database type]://[username]:[password]@[host]:[port]/[database name]```
