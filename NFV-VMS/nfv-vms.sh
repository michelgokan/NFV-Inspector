#!/bin/bash

declare -A cmd_opts
declare -A vms_ip

usage() { echo "Usage: $0 --cmd \"execScript\" [--os-select-vms <vms selection prefix>] [--file <file path>] [--exec \"<command>\"]" 1>&2; exit 1; }

echo "Parsing config file..."

while read line; do
    if [[ $line =~ ^"\s*#" ]]; then
	continue
    elif [[ $line =~ ^"["(.+)"]"$ ]]; then
	arrname=${BASH_REMATCH[1]}

	declare -A ${arrname}
    elif [[ $line =~ ^([_[:alpha:]][_[:alnum:]]*)"="(.*) ]]; then
	declare ${arrname}[${BASH_REMATCH[1]}]="${BASH_REMATCH[2]}"
    fi
done < config.ini


if [ -z ${VNFM_MAIN[source]+x} ]; then
    echo "Error: Set source in the config file!"
    exit 1
fi

echo "Reading arguments!"
optspec=":-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
		file|cmd|os-select-vms|exec)
                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    cmd_opts[${OPTARG}]="$val";
                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                    ;;
		file=*|cmd=*|os-select-vms=*|exec=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
                    cmd_opts[${opt}]="$val";
                    echo "Parsing option: '--${opt}', value: '${val}'" >&2
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
			usage;
			exit 1;
                    fi
                    ;;
            esac;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
		usage;
		exit 1;
            fi
            ;;
    esac
done

if [ -z ${cmd_opts[cmd]} ]; then
	echo "Error: No cmd defined!";
	usage;
fi

if [ ${VNFM_MAIN[source]} == "openstack" ]; then
    echo "Source set to ${VNFM_MAIN[source]}";
    
	export OS_USERNAME=${VNFM_OPENSTACK[OS_USERNAME]}
	export OS_PASSWORD=${VNFM_OPENSTACK[OS_PASSWORD]}
	export OS_PROJECT_NAME=${VNFM_OPENSTACK[OS_PROJECT_NAME]}
	export OS_AUTH_URL=${VNFM_OPENSTACK[OS_AUTH_URL]}
	export OS_VOLUME_API_VERSION=${VNFM_OPENSTACK[OS_VOLUME_API_VERSION]}
	export OS_IDENTITY_API_VERSION=${VNFM_OPENSTACK[OS_IDENTITY_API_VERSION]}
	export OS_PROJECT_DOMAIN_NAME=${VNFM_OPENSTACK[OS_PROJECT_DOMAIN_NAME]}
	export OS_USER_DOMAIN_NAME=${VNFM_OPENSTACK[OS_USER_DOMAIN_NAME]}

	test_access="$(openstack user list)";
	if [ $? -ne 0 ]; then
		echo "Error: No access to OpenStack! Make sure you correctly set all OS-* parameters in the config file!";
		exit 1;
	fi

    if [ -z ${cmd_opts[os-select-vms]+x} ]; then
        if [ -z ${VNFM_OPENSTACK[default_select_prefix]+x} ]; then
	    default_select_prefix=""
            echo "Caution: No default selection prefix set, will select all vms!"
        else
            default_select_prefix="${VNFM_OPENSTACK[default_select_prefix]}"
            echo "Selecting default prefix ${VNFM_OPENSTACK[default_select_prefix]}";
        fi
    else
	default_select_prefix="${cmd_opts[os-select-vms]}"
        echo "Selecting vms with prefix ${cmd_opts[os-select-vms]}";
    fi
        
    server_listX="$(openstack server list -c Name -c Networks -f value --name ^$default_select_prefix | gawk 'match($0, /mgmt=(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])/) { print $1","substr($0, RSTART+5, RLENGTH-5) }'; echo x)";
    server_list="${server_listX%?}"
    
    if [ -z $OS_AUTH_URL ]; then 
        echo "Error: No OS_AUTH_URL set! Please set all OS_* parameters in the config file and make sure you have OpenStack full admin access!";
        exit 1;
    fi
	
    OLDIFS=$IFS
    IFS=","
    while read vm_name ip_address
     do
	if [[ $vm_name ]]; then
         vms_ip["$vm_name"]="$ip_address"
	fi
     done <<< "$server_list"
     IFS=$OLDIFS
fi
    

case ${cmd_opts[cmd]} in
   "execScript")
	
      echo "Running command on All vms"   
      exec_type=0;
	echo "--exec = "{$cmd_opts[exec]};
	echo "--file = "$cmd_opts[file];
	 if [ -z ${cmd_opts[exec]+x} ]; then
		echo "No --exec command given!";	
		if [ -z ${cmd_opts[file]+x} ]; then
	  	 echo "No --file given!";
		 usage;
		 exit 1;
		else
		 exec_type=1;
		fi
	fi
	      
       
	for vm in "${!vms_ip[@]}"
	do
	   if [ $exec_type -eq 0 ]; then
		cmd_output="$(sshpass -p${VNFM_MAIN[su_password]} ssh ${VNFM_MAIN[su_username]}@${vms_ip[$vm]} ${cmd_opts[exec]})";
	   else
		cmd_output="$(sshpass -p${VNFM_MAIN[su_password]} ssh ${VNFM_MAIN[su_username]}@${vms_ip[$vm]} 'bash -s' < ${cmd_opts[file]})";
	   fi
	
           echo "$cmd_output";
	done
	;;
esac

