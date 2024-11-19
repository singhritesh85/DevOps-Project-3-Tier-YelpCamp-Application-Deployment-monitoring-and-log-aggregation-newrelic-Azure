#!/bin/bash
/usr/sbin/useradd -s /bin/bash -m ritesh;
mkdir /home/ritesh/.ssh;
chmod -R 700 /home/ritesh;
echo "ssh-rsa XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ritesh@DESKTOP-0XXXXXX" >> /home/ritesh/.ssh/authorized_keys;
chmod 600 /home/ritesh/.ssh/authorized_keys;
chown ritesh:ritesh /home/ritesh/.ssh -R;
echo "ritesh  ALL=(ALL)  NOPASSWD:ALL" > /etc/sudoers.d/ritesh;
chmod 440 /etc/sudoers.d/ritesh;

############################################################### Installation of SonarQube ##############################################################

yum install -y zip unzip vim wget
useradd -s /bin/bash -m sonar;
echo "Password@#795" | passwd sonar --stdin;
echo "sonar  ALL=(ALL)  NOPASSWD:ALL" >> /etc/sudoers

cat >> /etc/sysctl.conf <<EOT
vm.max_map_count = 262144
fs.file-max = 65536
EOT

cat >> /etc/security/limits.conf <<EOF
sonar   -   nofile   65536

#Nofile is the maximum number of open files
EOF

sysctl -p
yum install -y java-17* git
cd /opt/ && wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.5.90363.zip
unzip sonarqube-9.9.5.90363.zip
mv /opt/sonarqube-9.9.5.90363 /opt/sonarqube
chown -R sonar:sonar /opt/sonarqube

cat > /etc/systemd/system/sonarqube.service <<END_OF_SCRIPT
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=always

[Install]
WantedBy=multi-user.target
END_OF_SCRIPT

####################################################################

mkdir /mederma;
mkfs.xfs /dev/sdc;
echo "/dev/sdc  /mederma  xfs  defaults 0 0" >> /etc/fstab;
mount -a;
