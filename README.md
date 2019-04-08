# NFV-Inspector: An automated NFV analysis, profiling and optimization platform for NFV researchers and engineers

## Documentation, guides and tutorials are under preparation. For group chat please follow the link below (Zulip Chat).


[![project chat](https://img.shields.io/badge/zulip-join_chat-brightgreen.svg)](https://nfv-inspector.zulipchat.com)

# Drop me an email if you need any help, I will respond quickly: michel {at sign} gokan {dot} me


# Table of Contents
1. [Introduction](#intoduction)
2. [Getting Started](#getting-started)
3. [Setup your test environment](#setup-your-test-environment)
4. [Install NFV-MON](#install-nfv-mon)
5. [Install NFV-VMS](#install-nfv-vms)
6. [Install NFV-BMS](#install-nfv-bms)
7. [Install NFV-LAB](#install-nfv-lab)
8. [Kubernetes Support](#kubernetes)
9.  [Example Results](#example-results)
10. [Call for contribution](#call-for-contribution)
11. [Acknowledgment](#acknowledgment)


## Introduction
NFV-Inspector is a systematic VNF profiling and analysis platform, designed for NFV researchers and engineers.
**Documentation, guides and tutorials are under preparation.**


## Getting Started
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Documentation, guides and tutorials are under preparation.**

## Installation
In order to install each service, we have included 'install.sh' files in them. you should simply run `{service}/install.sh` to install. In continue, we documented a step by step guide on how they work in each service.

## Setup your test environment
In order to install OpenStack, I wrote a complete guide in DOCS folder: https://github.com/michelgokan/nfv-inspector/tree/master/docs/openstack-installation-guide

In order to install/setup Kubernetes, I wrote a complete guide here: https://git.cs.kau.se/michkhan/Kubernetes-Cluster-Installation-Guide (will be publically available soon)


## Install NFV-VMS
#### 1- Install MySQL

In order to install/setup Mysql, based on your operating system, you could use the links below, or search it on google to find the best suited for your cases.

###### Ubuntu
* 18.04: https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-18-04 
* 16.04: https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-16-04 
* 14.04: https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-14-04

###### CentOs
* 7: https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-centos-7
* 6: https://devops.ionos.com/tutorials/install-mysql-on-centos-6/

  
###### Windows
* http://www.mysqltutorial.org/install-mysql/


After the Installation is done, you have to create table for NFV_VMS. The link below describes how to do common MySQL database administration tasks via command line. 

* https://www.a2hosting.com/kb/developer-corner/mysql/managing-mysql-databases-and-users-from-the-command-line

#### 2- Install Kubernetes
In order to install/setup Kubernetes, based on your operating system, you could use the links below, or search it on google to find the best suited for your cases.

###### Ubuntu/CentOS
* https://www.itzgeek.com/how-tos/linux/centos-how-tos/how-to-install-kubernetes-on-centos-7-ubuntu-18-04-16-04-debian-9.html

If you are about to use NFV-Inspector and your OS is ubuntu, for offline development, prototyping or testing you could just use microK8s. it is available in ubuntu software center and all you need to do is to use the pre installation of docker and kubectl in order to have kubectl environment K8s commands. Also in other operating systems the available light version is called minikube and you could use it instead of installing the whole package of docker and kubernetes.

###### Windows

* https://www.hanselman.com/blog/HowToSetUpKubernetesOnWindows10WithDockerForWindowsAndRunASPNETCore.aspx

####  3- Install NFV-VMS 

Based on your Operating system, you can use the following instructions:

###### Ubuntu
  We include an script inside NFV-VMS for the ease of installation process. You should use it at least for the first time configuration.
  ````
  # cd {NFV-Inspector directory path}/NFV-VMS
  # ./install.sh
  Please enter MySQL server address (i.e 127.0.0.1): 
  {Enter your Mysql server address}
  Please enter MySQL server port (i.e 3306):
  {Enter your Mysql server port}
  Please enter MySQL server username (i.e root):
  {Enter your Mysql server username}
  Please enter MySQL server password : 
  {Enter your Mysql server password}
  Please enter MySQL server database (i.e NFV_VMS):
  {Enter the name of database you created in step1(install MySQL)}
  Please enter a comma seperated list of integration plugins to install (1=nfv-inspector-vms-kubernetes-plugin, 2=nfv-inspector-vms-openstack-plugin):
  1 or 2 or 1,2
  ````
  1. nfv-inspector-vms-kubernetes-plugin:
  
          Please enter Kubernetes API server address (HINT: normally master node IP):
          {Enter your kubernetes master node IP}
          Please enter Kubernetes API server port (i.e 6443):
          {Enter your kubernetes master node Port}
          http or https (https):
          {Enter your kubernetes master node communication protocol}
          Paste a connection token here:
          {Enter your kubernetes master node authentication token \
          (normally you can get it via "kubectl describe secret" and paste it here)}
  2. nfv-inspector-vms-openstack-plugin:
      ###### Under Preparation.


###### Windows
###### NFV-VMS documentation, guids and tutorials for installing on windows are under preparation.

## Install NFV-MON

## A. Install NFV-MON Server

### 1- Install Elasticsearch and Integrate it with OpenStack
In order to install Elasticsearch I wrote a complete guide in my blog: https://gokan.me/2018/02/18/collectd-elasticsearch-openstack/

### 2- Install InfluxDB
In order to install/setup InfluxDB, based on your operating system, you could use the links below, or search it on google to find the best suited for your cases.

###### Ubuntu
* 18.04: https://www.howtoforge.com/tutorial/how-to-install-tig-stack-telegraf-influxdb-and-grafana-on-ubuntu-1804/
* 16.04: 
* 14.04: 

###### CentOs
* 7: https://computingforgeeks.com/install-grafana-and-influxdb-on-centos-7/

####  3- Install NFV-MON Server
We include an script inside NFV-MON Server for the ease of installation process. You should use it at least for the first time configuration.
  ````
    cd {NFV-Inspector directory path}/NFV-MON/Server
    ./install.sh
    Please NFV-VMS endpoint address (i.e. 127.0.0.1):
    {Enter your NFV-VMS IP address}
    Please NFV-VMS endpoint port (default port: 3000):
    {Enter your NFV-VMS Port Number}

    Attempting to connect to NFV_VMS based on the given configuration: 127.0.0.1:3000...
    NFV_VMS seems OK!
    ...
    Please select the time-series database backend plugin you want to use: (1=nfv-inspector-mon-influxdb-plugin, 2=nfv-inspector-mon-elasticsearch-plugin):
    1 or 2
  ````
   1. nfv-inspector-mon-influxdb-plugin:
   
          Please enter InfluxDB host (i.e 172.16.16.242):
          {Enter your influxdb host IP address}
          Please enter InfluxDB port (default: 8086):
          {Enter your influxdb host port number}
          Please enter InfluxDB username (if exists):
          {Enter your influxdb username required and exist}
          Please enter InfluxDB password (if exists):
          {Enter your influxdb password required and exist}
          Please enter the database name:
          {Enter any name for your influxdb database or Enter the database name created before}
          ...
          Installation Successful!
          Please visit http://127.0.0.1:3002/explorer to access NFV-MON Swagger API documentation

  2. nfv-inspector-mon-influxdb-plugin:
      ###### Under Preparation.

## B. Install NFV-MON Client
### Install NFV-MON Client inside VMs
SSH inside each VM, and run `NFV-MON/nfv-mon-client-install.sh`. It will automatically get installed! To start collectd, use followings command:

  ````
  $ /opt/collectd/sbin/collectd
  ````

## Install NFV-BMS
We include an script inside NFV-BMS for the ease of installation process. You should use it at least for the first time configuration.
  ````
    cd {NFV-Inspector directory path}/NFV-BMS
    ./install.sh
    Please enter NFV-MON server endpoint address (i.e. 127.0.0.1):
    {Enter your NFV-MON Server IP address}
    Please enter NFV-MON server endpoint port (default port: 3002): 
    {Enter your NFV-MON Server Port Number}

    Attempting to connect to NFV-MON server based on the given configuration: 127.0.0.1:3002...
    NFV-MON server seems OK!
    ...
    Please enter a benchmarking integration plugin to install and load (1=nfv-inspector-bms-hss-fe-plugin):
    {Default plugin to test how it works is included and have the number '1'. you could add your own plugin test and use it to test}
  ````

# Contribution

## Contributors
* Michel Gokan Khan (Karlstad University, Karlstad, Sweden)
* Amir Hossein Sorouri 

## Academic Supervisors
* John Javid Taheri (Karlstad University, Karlstad, Sweden)
* Andreas Kassler (Karlstad University, Karlstad, Sweden)

## Industry Collaborators
Ericsson (Stockholm, Sweden)

## Call for contribution
NFV-Inspector is open source, and contributions from the community is welcome. Many tasks, (some are low-hanging fruits), are listed and ready to be implemented. If you would like to contribute to the project, but don't know where to start, please send me an email to have a quick discussion: michel@gokan.me

## Acknowledgment
This work was partially supported by the Grant No. 20160182 funded by the Knowledge Foundation of Sweden. I would like to thank Prof. Javid Taheri for his kind helps and Mr. Marian Darula from Ericsson R&D department for his constructive feedbacks.
