# NFV-Inspector: An automated NFV analysis, profiling and optimization platform for NFV researchers and engineers

## Documentation, guides and tutorials are under preparation. For group chat please follow the link below (Zulip Chat).


[![project chat](https://img.shields.io/badge/zulip-join_chat-brightgreen.svg)](https://nfv-inspector.zulipchat.com)

# Drop me an email if you need any help, I will respond quickly: michel {at sign} gokan {dot} me


# Table of Contents
1. [Introduction](#intoduction)
2. [Getting Started](#getting-started)
3. [Setup your test environment](#setup-your-test-environment)
4. [Install NFV-MON](#install-nfv-mon)
5. [Install NFV-MON](#install-nfv-mon)
6. [Install NFV-VMS](#install-nfv-vms)
7. [Install NFV-BMS](#install-nfv-bms)
8. [Install NFV-LAB](#install-nfv-lab)
9. [Kubernetes Support](#kubernetes)
10. [Example Results](#example-results)
11. [Call for contribution](#call-for-contribution)
12. [Acknowledgment](#acknowledgment)


## Introduction
NFV-Inspector is a systematic VNF profiling and analysis platform, designed for NFV researchers and engineers.
**Documentation, guides and tutorials are under preparation.**


## Getting Started
**Documentation, guides and tutorials are under preparation.**

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

###### Ubuntu/CentOS
  We include an script inside NFV-VMS for the ease of installation process. You should use it at least for the first time configuration.
  ````
  # cd {NFV-Inspector directory path}/NFV-VMS
  # ./install.sh
  Please enter MySQL server address (i.e 127.0.0.1): 
  {Enter you Mysql server address}
  Please enter MySQL server port (i.e 3306):
  {Enter you Mysql server port}
  Please enter MySQL server username (i.e root):
  {Enter you Mysql server username}
  Please enter MySQL server password : 
  {Enter you Mysql server password}
  Please enter MySQL server database (i.e NFV_VMS):
  {Enter the name of database you created in step1(install MySQL)}
  Please enter a comma seperated list of integration plugins to install (1=nfv-inspector-vms-kubernetes-plugin, 2=nfv-inspector-vms-openstack-plugin):
  1 or 2 or 1,2
  ````
  1. nfv-inspector-vms-kubernetes-plugin:
  
          # Please enter Kubernetes API server address (HINT: normally master node IP):
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
### Install Elasticsearch and Integrate it with OpenStack
In order to install Elasticsearch I wrote a complete guide in my blog: https://gokan.me/2018/02/18/collectd-elasticsearch-openstack/
### Install NFV-MON Client inside VMs
SSH inside each VM, and run `NFV-MON/nfv-mon-client-install.sh`. It will automatically get installed! To start collectd, use followings command:

  ````
  $ /opt/collectd/sbin/collectd
  ````

## Installation
In order to install each service, simply run `{service}/install.sh`.


# Contribution

## Contributors
* Michel Gokan Khan (Karlstad University, Karlstad, Sweden)
* Amirhossein Sorouri 

## Academic Supervisors
* John Javid Taheri (Karlstad University, Karlstad, Sweden)
* Andreas Kassler (Karlstad University, Karlstad, Sweden)

## Industry Collaborators
Ericsson (Stockholm, Sweden)

## Call for contribution
NFV-Inspector is open source, and contributions from the community is welcome. Many tasks, (some are low-hanging fruits), are listed and ready to be implemented. If you would like to contribute to the project, but don't know where to start, please send me an email to have a quick discussion: michel@gokan.me

## Acknowledgment
This work was partially supported by the Grant No. 20160182 funded by the Knowledge Foundation of Sweden. I would like to thank Prof. Javid Taheri for his kind helps and Mr. Marian Darula from Ericsson R&D department for his constructive feedbacks.
