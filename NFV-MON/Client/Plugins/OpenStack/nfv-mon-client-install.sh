#!/bin/bash

#For Open5GCore, uncomment
#printf "#!/bin/bash\nip route add default via 192.168.254.1\necho \"nameserver 192.168.254.1\" > /etc/resolv.conf\necho \"nameserver 8.8.8.8\" >> /etc/resolv.conf\necho \"domain epc.mnc001.mcc001.3gppnetwork.org\" >> /etc/resolv.conf" > /opt/Open5GCore/sbin/set_default_route_via_mgmt.sh
#printf "#!/bin/bash\nip route del default via 192.168.254.2\nip route del default via 192.168.254.1\necho \"domain epc.mnc001.mcc001.3gppnetwork.org\" > /etc/resolv.conf" > vim /opt/Open5GCore/sbin/unset_default_route_via_mgmt.sh

#/opt/Open5GCore/sbin/unset_default_route_via_mgmt.sh
#/opt/Open5GCore/sbin/set_default_route_via_mgmt.sh

sudo apt-get update
sudo apt-get install -y git build-essential libyajl-dev libsensors4-dev multipath-tools libi2c-dev liblvm2-dev libperl-dev automake autoconf flex bison libtool pkg-config libmnl-dev lm-sensors
git clone https://github.com/intel/intel-cmt-cat
cd intel-cmt-cat
make
make install
cd ..
git clone https://github.com/collectd/collectd/
cd collectd
./build.sh
./configure --enable-intel_rdt --enable-lvm --enable-netlink --enable-libvirt --enable-perl --enable-interface --enable-logfile --enable-memory --enable-exec --enable-sensors --enable-cpu --enable-network --enable-processes
make
make install
cd bindings/perl/
perl Makefile.PL
make
make install
modprobe msr
cd ~/
git clone https://github.com/michelgokan/collectd-top
cd collectd-top
perl Makefile.PL
make
make install
cd /opt/collectd/etc/
rm collectd.conf
wget https://gokan.me/wp-content/uploads/2018/02/collectd.conf_.txt
mv collectd.conf_.txt collectd.conf
/opt/collectd/sbin/collectd
/opt/collectd/sbin/collectdmon
