## Working with a local Repo  
/etc/yum.repos.d stores locations of 'known' repos  

YUM command line  
`yum commands`  
```
yum --help  
yum install  
yum update  
yum search  
yum provides  
yum makecache fast  
yum clean all
yum history
```

#### Yum Configurations
`yum conf file`
```
/etc/yum.conf
```
Configuration for global changes to yum  
`yum repository folder`  
```
/etc/yum.repos.d/
```
`/etc/yum.repos.d/local.repo`
```
[local-base]
name=local-base
baseurl=http://repo/base/
enabled=1
gpgcheck=0
```
Name in bracket has to be unique to each repository  
name is a descriptive name for human readablity  
baseurl is the location for yum to reach out for the repository  
enabled is that yum will use this entry  
gpgcheck is security check  

### **LAB Student Laptop**
**Create yum repo with the above fields and point it at our local repo**  
```
sudo vi /etc/yum.repo.d/local-yum.repo
```
 Copying local to sensor tip  
 `sudo cp local.rep local-yum.repo`  
 `sudo vi local-yum.repo`  
Use vi find and replace `%s/<find>/<replace>`  

Instal yum-utils to help in setting up a local repo  
`sudo yum install yum-utils`  
Create a local director to reposync the files to  
`mkdir /srv/repos`  
Reposync from a remote repo to the local filesystem  
`reposync -l --repoid=repo_name --download_path=/pwd/`  
This is the smallest command reposyn takes, with what each of the two flags does.  
For this lab, we use  
`reposync -l --repoid='repo id' --download_path=/srv/repos/ --newest-only --downloadcomps --download-metadata`  
Run this for each repo in the list.  

A more efficent ways to do this  
`yumdownloader <package>`  
This tool will down the rpm and resolve all the dependencies required for it if you know exactly what you need.  

Repotrack is a tool that performs a similar function, with a flag to designate the architure of the package to download to further tailor packages.  
`repotrack -a ARCH -p /pwd packages`  

## Creating Repo
Once the rpms have been setup in the local repo spot, use the tool `createrep`  
This tool will create the needed database so that yum know how to handle them.
`yum install createrepo`  
Create the databse file to make the local repo usable in the simplest form.  
`createrepo /repo/<name>`  
If we want to inclulde the groups/comps we need to pass it the flag and name of the comps

`createrepo local-base/`  

### Making the Repo accessible

Create a web listener  

`vi /etc/nginx/conf.d/repo.conf`  
This will create a new file to make the server to serve the repo we're making.  

```
server {
  listen 8008;
  location / {
   root /srv/repos;
   autoindex on;
   index index.html index.htm;
  }
  error_page 500 502 503 504 /50x.html;
  location = /50x.html{
    root /usr/share/nginx/html;
  }
}
```
```
firewall-cmd --add-port=8008/tcp --permanent
firewall-cmd --reload
```
These commands allow remote access to the repo on port 8008  
Then use the following to allow SELinux to alow the hosted content  
`chcon -R -u system_u -t httpd_sys_content_t /repos`  

Start the server setup on the laptop with nginx  
```
systemctl start nginx  -- On the laptop
curl <dns name>:8008   -- On the sensor
```

Configure /etc/nginx/conf.d/proxy.conf to skip having to include the port.  

```
server {
  listen 80;
  server_name repo perched-reop repo.perched.io perched-repo.perched.io

  proxy_max_temp_file_size 0;

  location / {
    proxy_set_header X-Real_IP $remote_addr;
    proxy_set_header Host $http_host;
    proxy_pass http://127.0.0.1:8008;
  }
}
```
