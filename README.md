# NFV-Inspector: An automated platform for systematic VNF profiling and analysis
## IMPORTANT NOTICE: ITS A PRE-ALPHA RELEASE JUST AS A PROOF OF CONCEPT! DO NOT USE IT IN PRODUCTION!

# Table of Contents
1. [Introduction](#intoduction)
2. [Getting Started](#getting-started)
3. [Setup your test environment](#setup-your-test-environment)
4. [Install NFV-MON](#install-nfv-mon)
5. [Install NFV-VMS](#install-nfv-vms)
6. [Install NFV-BMS](#install-nfv-bms)
7. [Install NFV-LAB](#install-nfv-lab)
8. [Example Results](#example-results)
9. [Call for contribution](#call-for-contribution)
10. [Acknowledgment](#acknowledgment)


## Introduction
## Getting Started
## Setup your test environment
In order to install OpenStack, I wrote a complete guide in DOCS folder: https://github.com/michelgokan/nfv-inspector/blob/master/DOCS/openstack-installation-guide/README.md
## Install NFV-MON
### Install Elasticsearch and Integrate it with OpenStack
In order to install Elasticsearch I wrote a complete guide in my blog: https://gokan.me/2018/02/18/collectd-elasticsearch-openstack/
### Install NFV-MON Client inside VMs
SSH inside each VM, and run `NFV-MON/nfv-mon-client-install.sh`. It will automatically get installed! To start collectd, use followings command:

  ````
  $ /opt/collectd/sbin/collectd
  ````

## Install NFV-VMS
In order to install NFV-VMS run `NFV-VMS/install.sh` on master node.

## Install NFV-BMS
In order to install NFV-BMS do as follows:

  ````
  $ cd NFV-BMS
  $ node install
  ````

## Install NFV-LAB
Still in pre-pre-alpha release! Will be added accordingly.

## Example Results
## Call for contribution
## Acknowledgment

