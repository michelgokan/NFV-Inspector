# NFV-Inspector: An automated platform for NFV researchers and engineers

## Documentation, guides and tutorials are under prepration.

# Table of Contents
1. [Introduction](#intoduction)
2. [Getting Started](#getting-started)
3. [Setup your test environment](#setup-your-test-environment)
4. [Install NFV-MON](#install-nfv-mon)
5. [Install NFV-VMS](#install-nfv-vms)
6. [Install NFV-BMS](#install-nfv-bms)
7. [Install NFV-LAB](#install-nfv-lab)
8. [Kubernetes Support](#kubernetes)
8. [Example Results](#example-results)
9. [Call for contribution](#call-for-contribution)
10. [Acknowledgment](#acknowledgment)


## Introduction
NFV-Inspector is a systematic VNF profiling and analysis platform, designed for NFV researchers and engineers.
**Documentation, guides and tutorials are under prepration.**


## Getting Started
**Documentation, guides and tutorials are under prepration.**

## Setup your test environment
In order to install OpenStack, I wrote a complete guide in DOCS folder: https://github.com/michelgokan/nfv-inspector/tree/master/docs/openstack-installation-guide

In order to install/setup Kubernetes, I wrote a complete guide here: https://git.cs.kau.se/michkhan/Kubernetes-Cluster-Installation-Guide (will be publically available soon)

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
Michel Gokan Khan (Karlstad University, Karlstad, Sweden)

## Academic Supervisors
* John Javid Taheri (Karlstad University, Karlstad, Sweden)
* Andreas Kassler (Karlstad University, Karlstad, Sweden)

## Industry Collaborators
Ericsson (Stockholm, Sweden)

## Call for contribution
NFV-Inspector is open source, and contributions from the community is welcome. Many tasks, (some are low-hanging fruits), are listed and ready to be implemented. If you would like to contribute to the project, but don't know where to start, please send me an email to have a quick discussion: michel@gokan.me

## Acknowledgment
This work was partially supported by the Grant No. 20160182 funded by the Knowledge Foundation of Sweden. I would like to thank Prof. Javid Taheri for his kind helps and Mr. Marian Darula from Ericsson R&D department for his constructive feedbacks.
