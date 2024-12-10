#!/bin/bash -xe

# Declare Variables
EFS_ENDPOINT=${FILE_SYSTEM_ID}.efs.${REGION}.amazonaws.com:/
GITCLONE_DB_ENDPOINT=${GIT_DB_ENDPOINT}
RESTORE_DB_ENDPOINT=${RESTORE_DB_EP}
LB_A_RECORD=${LOAD_B_DNS}
DB_USERNAME=${DB_USER}
DB_PASSWORD=${DB_PASS} 
DB_HOST_NAME=${DB_ID}

# Log script output to /var/log/user-data.log and system logger.
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd

sudo mkdir -p ${MOUNT_POINT}
sudo chown ec2-user:ec2-user ${MOUNT_POINT}


echo "$EFS_ENDPOINT ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0" | sudo tee -a /etc/fstab 
sudo mount -a -t nfs4


sudo chmod -R 755 /var/www/html


sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;


cd /var/www/html


if [ ! -f "/var/www/html/wp-config.php" ]
then
    git clone ${GIT_REPO}
    cp -r Retail_Repository/* /var/www/html
    sed -i "s|$GITCLONE_DB_ENDPOINT|$RESTORE_DB_ENDPOINT|g" "/var/www/html/wp-config.php"
else
    :
fi


sudo sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf


sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;


sudo find /var/www -type f -exec sudo chmod 0664 {} \;


sudo systemctl restart httpd
sudo service httpd restart


sudo systemctl enable httpd



sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5



mysql -h $RESTORE_DB_ENDPOINT -u $DB_USERNAME -p$DB_PASSWORD -D $DB_HOST_NAME -e "

UPDATE wp_options SET option_value = '$LB_A_RECORD' WHERE option_name = 'siteurl';

UPDATE wp_options SET option_value = '$LB_A_RECORD' WHERE option_name = 'home';"



sudo systemctl start lvm2-lvmetad.service
sudo systemctl enable lvm2-lvmetad.service


partitioned_disks=()


for disk in $(sudo lsblk -nlo NAME | grep '^xvd'); do
   
    if [[ $disk == "xvda1" ]]; then
        echo "/dev/$${disk} is skipped."
        continue
    fi


    if sudo lsblk -J | grep -q "$${disk}1"; then
        echo "/dev/$${disk} was already partitioned. Skipping..."
        continue
    else

        echo "Partitioning /dev/$${disk}..."
        echo -e "n\np\n1\n\n\nw" | sudo fdisk "/dev/$${disk}"
        
        
        sudo partprobe "/dev/$${disk}"

        
        partitioned_disks[$${#partitioned_disks[@]}]="/dev/$${disk}1"
    fi
done


for disk_partition in "$${partitioned_disks[@]}"; do
    sudo pvcreate "$${disk_partition}"
done


sudo vgcreate stack_vg "$${partitioned_disks[@]}"
sudo vgs


declare -a lists=(u01 u02 u03 u04)
for item in "$${lists[@]}"; do
    sudo lvcreate -L 5G -n "Lv_$${item}" stack_vg
    sudo mkfs.ext4 "/dev/stack_vg/Lv_$${item}"
done


sudo lvs


declare -a DIRECTORIES=(u01 u02 u03 backup)
for x in "$${DIRECTORIES[@]}"; do
   sudo mkdir -p "/$${x}"
done

sudo mount /dev/stack_vg/Lv_u01 /u01
sudo mount /dev/stack_vg/Lv_u02 /u02
sudo mount /dev/stack_vg/Lv_u03 /u03
sudo mount /dev/stack_vg/Lv_u04 /backup