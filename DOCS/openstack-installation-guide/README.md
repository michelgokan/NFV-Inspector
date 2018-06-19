# OpenStack Pike Automated Installation Guide on Ubuntu 16.04.3 LTS

### For all nodes (as root user):
Assume you have Ubuntu 16.04 server with openssh installed.

1. Go to `/etc/ssh/sshd_config` and change `PermitRootLogin` variable to `yes`:
    
    ````
	...
	PermitRootLogin yes
	...
	````

2. Set root password (ask administrator before doing it in a production serer):
`$ passwd root`
3. Set hostname:
`$ hostnamectl set-hostname '{node-name}'`
Replace `{node-name}` with one of the followings (as convention):
    - **Controller node:** controller
    - **Compute node:** compute{N} (N is node number. i.e: compute1 or compute2)
    - **Storage node:** block{N} (N is node number. i.e: block1 or block2)
    - **Network node:** network
    - **Object node:** object{N} (N is node number. i.e: object1 or object2)

4. Set interfaces correctly. There should be 2 interfaces on each node and It should look like this in /etc/network/interfaces:
    ````
    # The loopback network interface
    auto lo
    iface lo inet loopback
    
    # The primary network interface
    auto ens160
    iface ens160 inet static
            address 172.16.16.110
            netmask 255.255.240.0
            gateway 172.16.16.1
            dns-nameservers 4.2.2.4 8.8.8.8
    
    auto ens192
    iface ens192 inet manual
    up ip link set dev $IFACE up
    down ip link set dev $IFACE down
    ````
5. Remove `127.0.0.1 {hostname}` from /etc/hosts ***AND*** add nodes hostnames and ips. Your /etc/hosts file should almost look like this:

    ````
    127.0.0.1       localhost
    #127.0.0.1 .   {hostname} <- REMOVE
    #The following lines are desirable for IPv6 capable hosts
    ::1     localhost ip6-localhost ip6-loopback
    ff02::1 ip6-allnodes
    ff02::2 ip6-allrouters

    172.16.16.110 controller
    172.16.16.130 block1
    172.16.16.60 compute1
    172.16.16.66 compute2
    ````
6. Update repo:
`$ apt update`

7. Install some important packages:
`$ apt install vim git software-properties-common chrony curl thin-provisioning-tools python-software-properties openvswitch-switch netfilter-persistent`

8. Make sure your system locales installed and configured correctly. If not follow these steps:

    ````
    $ sudo locale-gen en_US en_US.UTF-8
    $ sudo dpkg-reconfigure locales
    ````
    
    Make sure to add these lines to the end of `/etc/environment`:
    
    ````
    ...
    LC_ALL=en_US.UTF-8
    LANG=en_US.UTF-8
    ````
    and then source it, logout and login again:
    ````
    $ source /etc/environment
    $ logout
    ````
    
9. Add openstack repo:
`$ add-apt-repository cloud-archive:pike`

10. Upgrade packages:
`$ apt update && apt dist-upgrade`

11. Install python openstack client:
`$ apt install python-openstackclient`

12. Set NTP server:
`$ vim /etc/chrony/chrony.conf`
    - For controller node, set university ntp ip address as below and comment out `pool 2.debian...` line:
    
    ````
    ...
    server 193.10.220.101 iburst
    #pool 2.debian.pool.ntp.org offline iburst
	...
	````
    - For other nodes, set the controller's ip address:
    
    ````
    ...
    server 172.16.16.110 iburst
    #pool 2.debian.pool.ntp.org offline iburst
	...
	````    
 

13. Add `br-int` bridge and set its mtu to 1500:

    ````
    $ ovs-vsctl add-br br-int
    $ ovs-vsctl set int br-int mtu_request=1500
    ````

14. Get tigerlinux openstack pike installer git repository and save it in your root home directory:
`$ git clone https://github.com/tigerlinux/openstack-pike-installer-ubuntu1604lts.git`

15. If you don't already have a personal access token in KAU GitLab, you need to create one! Go to "Personal Access Token" section and create a token with "api scope" enabled. You can create access token by following [this link](https://git.cs.kau.se/profile/personal_access_tokens "this link"). Save the generated access token to be able to download files from this GitLab project later.

    <img src="https://www.dropbox.com/s/gqr22bp1i6s9zc5/Screen%20Shot%202017-10-19%20at%2012.07.57.png?dl=1" width="300">

16. Disable firewall - You need to replace INSERT_YOUR_TOKEN_HERE with the token you generated in the previous command:

    ````
    $ curl --header "PRIVATE-TOKEN: INSERT_YOUR_TOKEN_HERE" "https://git.cs.kau.se/michkhan/openstack-guide/raw/master/bin/iptables-reset.sh" --remote-name
    $ chmod 777 iptables-reset.sh
    $ ./iptables-reset.sh
    ````

17. Reboot

### For controller node (as root user):

1. Install some packages:
`$ apt install cinder-common`

2. Add OVS br-provider bridge for your provider interface (the one without IP address) and set its mtu to 1500:
    ````
    $ ovs-vsctl add-br br-provider
    $ ovs-vsctl add-port br-provider ens192
    $ ovs-vsctl set int br-provider mtu_request=1500
    ````

3. Get controller config file using the token you created in step 16 (put it in `INSERT_YOUR_TOKEN_HERE` placeholder), double-check all the parameters and make sure you put correct ip addresses
    ````
    $ cd ~/openstack-pike-installer-ubuntu1604lts/configs
    $ curl --header "PRIVATE-TOKEN: INSERT_YOUR_TOKEN_HERE" "https://git.cs.kau.se/michkhan/openstack-guide/raw/master/tigerlinux_configs/controller_node/main-config.rc" --remote-name
    ````

4. Check for below variables:
    - `flat_network_create_list`: This should be in format of"provider:PROVIDER_INTERFACE" (the one without IP address) which in my case it is "provider:ens192"
    - Double check all variables ends with "host" like `ceilometerhost` or `novahost` and make sure they have correct IP address

5. Run the installer:
    ````
    $ cd ..
	$ ./main-installer.sh install | tee -a installation.log
    ````

6. Reboot

7. Verify horizon via http://controller/horizon

8. Verify compute services:

    ````
    $ source ~/keystonerc_fulladmin
    $ openstack compute service list
    +----+--------------+------------+----------+---------+-------+--------------+
    | ID | Binary       | Host       | Zone     | Status  | State | Updated At   |
    +----+--------------+------------+----------+---------+-------+--------------+
    |  3 | nova-        | controller | internal | enabled | up    | 2017-10-19T0 |
    |    | consoleauth  |            |          |         |       | 9:40:59.0000 |
    |    |              |            |          |         |       | 00           |
    |  4 | nova-        | controller | internal | enabled | up    | 2017-10-19T0 |
    |    | scheduler    |            |          |         |       | 9:40:59.0000 |
    |    |              |            |          |         |       | 00           |
    |  5 | nova-console | controller | internal | enabled | up    | 2017-10-19T0 |
    |    |              |            |          |         |       | 9:40:59.0000 |
    |    |              |            |          |         |       | 00           |
    |  6 | nova-        | controller | internal | enabled | up    | 2017-10-19T0 |
    |    | conductor    |            |          |         |       | 9:40:59.0000 |
    |    |              |            |          |         |       | 00           |
    +----+--------------+------------+----------+---------+-------+--------------+

    ````
    
### For compute node (as root user):

1. Add OVS br-provider bridge for your provider interface (the one without IP address) and set its mtu to 1500:
    ````
    $ ovs-vsctl add-br br-provider
    $ ovs-vsctl add-port br-provider enp5s0f1
    $ ovs-vsctl set int br-provider mtu_request=1500
    ````

2. Get compute config file using the token you created in step 16 (put it in `INSERT_YOUR_TOKEN_HERE` placeholder), double-check all the parameters and make sure you put correct ip addresses

    ````
    $ cd ~/openstack-pike-installer-ubuntu1604lts/configs
    $ curl --header "PRIVATE-TOKEN: INSERT_YOUR_TOKEN_HERE" "https://git.cs.kau.se/michkhan/openstack-guide/raw/master/tigerlinux_configs/compute_node/main-config.rc" --remote-name
    ````
    
3. Check for below variables:
    - `flat_network_create_list`: This should be in format of"provider:PROVIDER_INTERFACE" (the one without IP address) which in my case it is "provider:ens192"
    - Double check all variables ends with "host" like `ceilometerhost` or `novahost` and make sure they have correct IP address

4. Run the installer:
    ````
    $ cd ..
	$ ./main-installer.sh install | tee -a installation.log
    ````

5. Reboot	

6. Run this command on controller:
 
    ````
    su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
    ````

7. For glance, sometimes its needed to run below command (if `openstack image list` failed to run)
    
    ````
    $ su -s /bin/sh -c "glance-manage db_sync" glance
    $ su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
    $ su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
    $ su -s /bin/sh -c "nova-manage db sync" nova
    $ su -s /bin/sh -c "heat-manage db_sync" heat
    $ ceilometer-upgrade --skip-metering-database
    $
    AND THEN RESTART SERVICE
    $ service nova-api restart
    $ service nova-consoleauth restart
    $ service nova-scheduler restart
    $ service nova-conductor restart
    $ service nova-novncproxy restart
    $ service glance-api restart
    $ service glance-registry restart
    $ apt-get purge cinder-volume
    SOMETIMES TEARDOWN APP ARMOR AND RESTART AGAIN
    $ service apparmor teardown
    $ service apparmor start
    $ reboot
    ````

8. Make sure you have following settings on `/etc/nova/nova.conf` to enable "Cache Monitoring Technology" on all VMs being created:

````
....
[libvirt]
enabled_perf_events = cmt
virt_type = kvm
libvirt_type = kvm
....
````

9. Verify by running below commands on the controller node:
    ````
        $ source ~/keystonerc_fulladmin
        $ openstack compute service list
        +----+------------------+------------+----------+---------+-------+----------------------------+
        | ID | Binary           | Host       | Zone     | Status  | State | Updated At                 |
        +----+------------------+------------+----------+---------+-------+----------------------------+
        |  3 | nova-consoleauth | controller | internal | enabled | up    | 2017-10-19T13:03:20.000000 |
        |  4 | nova-scheduler   | controller | internal | enabled | up    | 2017-10-19T13:03:20.000000 |
        |  5 | nova-console     | controller | internal | enabled | up    | 2017-10-19T13:03:22.000000 |
        |  6 | nova-conductor   | controller | internal | enabled | up    | 2017-10-19T13:03:23.000000 |
        |  9 | nova-compute     | compute1   | nova     | enabled | up    | 2017-10-19T13:03:17.000000 |
        +----+------------------+------------+----------+---------+-------+----------------------------+
    
        ````

10. Make sure you have following package installed: nova-novncproxy

11. And your vnc config is like follows
    ````
    [vnc]
    enabled = True
    novncproxy_host = 172.16.16.60
    vncserver_proxyclient_address = 172.16.16.60
    novncproxy_base_url = http://172.16.16.110:6080/vnc_auto.html
    novncproxy_port = 6080
    vncserver_listen = 172.16.16.60
    keymap = en-us
    ````

12. Just in case you need desktop on Ubuntu server, run following commands to install GUI and connect using native Mac's screen sharing program:

    ````
    $ sudo apt-get install ubuntu-desktop x11vnc
    $ startx &
    $ x11vnc -display :0 -noxrecord -noxfixes -noxdamage -forever -passwd 123456 &
    

### For (Cinder) block storage node (as root user)

1. Assume we have 2 drives: 
    - `/dev/sda` for your local linux installation 
    - `/dev/sdb` for lvm storage

2. Install some packages:
 
    ````
    $ apt install lvm2
    ````
3. Create the LVM physical volume `/dev/sdb`:

    ````
    $ pvcreate /dev/sdb
    ````
    
4. Create the LVM volume group `cinder-volumes`:
    
    ````
    $ vgcreate cinder-volumes /dev/sdb
    ````

5. Open `/etc/lvm/lvm.conf` and in the devices section, add a filter that accepts the `/dev/sdb` device and rejects all other devices:

    ````
    devices {
    ...
    filter = [ "a/sdb/", "r/.*/"]
    
    ````

7. Get compute config file using the token you created in step 16 (put it in `INSERT_YOUR_TOKEN_HERE` placeholder), double-check all the parameters and make sure you put correct ip addresses

    ````
    $ cd ~/openstack-pike-installer-ubuntu1604lts/configs
    $ curl --header "PRIVATE-TOKEN: INSERT_YOUR_TOKEN_HERE" "https://git.cs.kau.se/michkhan/openstack-guide/raw/master/tigerlinux_configs/block_node/main-config.rc" --remote-name
    ````
    
8. Check below variables:
    - Double check all variables ends with "host" like `ceilometerhost` or `novahost` and make sure they have correct IP address

9. Run the installer:
    ````
    $ cd ..
	$ ./main-installer.sh install | tee -a installation.log
    ````

10. Run this command on controller node:
    
    ````
    $ su -s /bin/sh -c "cinder-manage db sync" cinder
    ````

11. Reboot

12. Verify on controller node:

    ````
    $ openstack volume service list
    +------------------+--------------------------+------+---------+-------+----------------------------+
    | Binary           | Host                     | Zone | Status  | State | Updated At                 |
    +------------------+--------------------------+------+---------+-------+----------------------------+
    | cinder-volume    | block1@lvm-172.16.16.202| nova | enabled | up    | 2017-10-19T15:12:25.000000 |
    | cinder-scheduler | controller               | nova | enabled | up    | 2017-10-19T15:12:18.000000 |
    +------------------+--------------------------+------+---------+-------+----------------------------+
    ````
    
13. Make sure your cinder.conf is almost similar to the [following link](https://git.cs.kau.se/michkhan/openstack-guide/blob/master/backups/NOV-2-2017-11-21-37/block1/cinder.conf).

### Setup OpenStack & Launch an Instance (as root user)

1. Remove all networks, instances, flavors and images if created

2. Create default flavors:

    ````
    $ openstack flavor create nano --id 0 --vcpus 1 --ram 128 --disk 1
    $ openstack flavor create m1.tiny --id 1 --vcpus 1 --ram 512 --disk 1
    $ openstack flavor create m1.small --id 2 --vcpus 1 --ram 2048 --disk 20
    $ openstack flavor create m1.small2 --id 3 --vcpus 1 --ram 4096 --disk 40
    $ openstack flavor create m1.medium --id 4 --vcpus 2 --ram 4096 --disk 40
    $ openstack flavor create m1.medium2 --id 5 --vcpus 2 --ram 4096 --disk 20
    $ openstack flavor create m1.large --id 6 --vcpus 4 --ram 8192 --disk 80
    $ openstack flavor create m1.large2 --id 7 --vcpus 4 --ram 8192 --disk 30
    $ openstack flavor create m1.xlarge --id 8 --vcpus 8 --ram 16384 --disk 160
    ````
    
3. Run below commands on controller node:

    ````
    $ source ~/keystonerc_fulladmin
    $ openstack network create --share --provider-physical-network provider --provider-network-type flat provider1
    $ openstack subnet create --subnet-range 172.16.16.0/20 --gateway 172.16.16.1 --network provider1 --allocation-pool start=172.16.16.230,end=172.16.16.250 --dns-nameserver 8.8.4.4 provider1-v4
    $ openstack subnet create --subnet-range fd00:172:16:16::/64 --gateway fd00:172:16:16::1 --ip-version 6 --ipv6-address-mode slaac --network provider1 --dns-nameserver 2001:4860:4860::8844 provider1-v6
    $ openstack network set --external provider1
    $ openstack network create selfservice1
    $ openstack subnet create --subnet-range 192.168.1.0/24 --network selfservice1 --dns-nameserver 8.8.4.4 selfservice1-v4
    $ openstack subnet create --subnet-range fd00:192:168:1::/64 --ip-version 6 --ipv6-ra-mode slaac --ipv6-address-mode slaac --network selfservice1 --dns-nameserver 2001:4860:4860::8844 selfservice1-v6
    $ openstack router create router1
    $ openstack router add subnet router1 selfservice1-v4
    $ openstack router add subnet router1 selfservice1-v6
    $ neutron router-gateway-set router1 provider1
    $
    $ wget download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
    $ openstack image create "cirrosnew" --file cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --public
    $ openstack server create --flavor m1.nano --image cirrosnew --nic net-id=SELFSERVICE_NET_ID_HERE --security-group default selfservice-instance
    $ openstack floating ip create provider1
    $ openstack server add floating ip selfservice-instance THE_FLOATING_IP_ADDRESS_HERE
    ````
    
4. To import Ubuntu server cloud image:

    ````
    $ wget http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
    $ openstack image create "Ubuntu 16.04 Server - Xenial" --file ^Cnial-server-cloudimg-amd64-disk1.img --disk-format qcow2 --container-format bare --public
    ````

5. Generate a key for yourself and create your desired instance! Then you will be able to ssh to that instance using following comand:

    ````
    $ ssh -i /path/to/your.key ubuntu@ip_address
    ````

6. You can use cloud-init to assign a password for the user ubuntu. In order to do that, on instance creation you go to the configuration tab and insert the code below as Customization Script.

    ````
    #cloud-config
    password: mypassword
    chpasswd: { expire: False }
    ssh_pwauth: True
    ````
    
7, After launch an instance, run following (nasty!) command on controller node to set MTUs:

    ````
    $ mysql -uroot -e "update neutrondb.networks set mtu=1500"
    ````
    

