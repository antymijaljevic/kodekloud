
# Level 1

## Day 1: Linux User Setup with Non-Interactive Shell
### https://di-marco.net/blog/it/2021-12-24-tips-how_to_disable_shell_access_to_user_account_in_linux/
sudo adduser mark -s /sbin/false
cat /etc/passwd

## Day 2: Temporary User Setup with Expiry
### https://www.geeksforgeeks.org/linux-unix/creating-a-user-with-an-expiry-date-in-linux/
ssh banner@stapp03
sudo useradd -e 2024-02-17 john
sudo passwd john
sudo chage -l john

## Day 3: Secure Root SSH Access
### https://askubuntu.com/questions/27559/how-do-i-disable-remote-ssh-login-as-root-from-a-server
sudo vi /etc/ssh/sshd_config
PermitRootLogin no

sudo systemctl list-unit-files | grep -i ssh
sudo systemctl is-enabled sshd.service
sudo systemctl restart sshd.service
sudo systemctl status sshd.service
ssh root@stapp01

## Day 4: Script Execution Permissions
### https://chmod-calculator.com/
<!-- 7 (owner): read(4) + write(2) + execute(1) = 7
5 (group): read(4) + execute(1) = 5
5 (other): read(4) + execute(1) = 5
a+rx = add read and execute for all -->

ssh steve@stapp02
sudo chmod 755 /tmp/xfusioncorp.sh
chmod a+rx /tmp/xfusioncorp.sh
ls -l 

## Day 5: SElinux Installation and Configuration
ssh tony@stapp01
cat /etc/*release
sudo yum update

sudo yum install policycoreutils.x86_64 selinux-policy selinux-policy-targeted libselinux-utils setroubleshoot-server setools setools-console mcstrans

getenforce
vi /etc/sysconfig/selinux
SELINUX=disabled

## Day 6: Create a Cron Job
ssh tony@stapp01
ssh steve@tapp02
ssh banner@tapp03
sudo yum install cronie -y
systemctl list-units
systemctl status crond
sudo crontab -u root -e
*/5 * * * * echo hello > /tmp/cron_text
sudo crontab -u root -l

## Day 7: Linux SSH Authentication
### https://askubuntu.com/questions/4830/easiest-way-to-copy-ssh-keys-to-another-machine/4833#4833
ls ~/.ssh/
ssh-keygen
ssh-copy-id tony@stapp01
ssh tony@stapp01
ssh-copy-id steve@stapp02
ssh steve@stapp02
ssh-copy-id banner@stapp03
ssh banner@stapp03

## Day 8: Install Ansible
### https://pypi.org/project/ansible/#history
### https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

pip3 --version
### global in /usr/local/lib/python3.x/dist-packages
sudo pip3 install ansible==4.9.0
ansible --version

## Day 9: MariaDB Troubleshooting
ssh peter@stdb01
systemctl status mariadb
sudo systemctl restart mariadb
journalctl -xeu mariadb.service # unit, end of pager, unit
journalctl -xeu mariadb.service | grep -i Warning
systemctl show mariadb
systemctl show mariadb --property=User
cat /usr/lib/systemd/system/mariadb.service
ls -laih /var/lib/mysql
sudo chown mysql:mysql -R /var/lib/mysql
sudo systemctl restart mariadb

## Day 10: Linux Bash Scripts
### https://www.hostinger.com/tutorials/linux-tar-command-with-examples?utm_campaign=Generic-Tutorials-DSA-t1|NT:Se|LO:Other-EU&utm_medium=ppc&gad_source=1&gad_campaignid=12231291749&gbraid=0AAAAADMy-hZYPlppLu26kIA3liEpdko69
ssh tony@stapp01
sudo yum install zip
which bash

ssh-keygen
ssh-copy-id clint@stbkp01
ssh clint@stbkp01

vi /scripts/news_backup.sh

#!/usr/bin/bash
zip -r /backup/xfusioncorp_news.zip /var/www/html/news
scp /backup/xfusioncorp_news.zip clint@stbkp01:/backup/xfusioncorp_news.zip

chmod +x /scripts/news_backup.sh
/scripts/news_backup.sh

##  Day 11: Install and Configure Tomcat Server
### https://www.digitalocean.com/community/tutorials/how-to-install-apache-tomcat-8-on-centos-7
### https://docs.microfocus.com/UCMDBB/11.0/Content/Browser/Config_Tomcat_Default_Port.htm

### Via binaries
ssh steve@stapp02

sudo yum update -y
sudo yum install java-1.8.0-openjdk-devel
java -version

sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
cd /tmp && wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.111/bin/apache-tomcat-9.0.111.tar.gz
sudo tar xzvf apache-tomcat-9.0.111.tar.gz -C /opt/tomcat --strip-components=1

sudo mkdir -p /opt/tomcat/{temp,work,logs}
sudo chown -R tomcat:tomcat /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/bin/*.sh'
readlink -f $(which java)
sudo vi /etc/systemd/system/tomcat.service

[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=oneshot
RemainAfterExit=yes

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.462.b08-4.el9.x86_64/"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target

scp /tmp/ROOT.war steve@stapp02:/tmp
cd /tmp && sudo mv ROOT.war /opt/tomcat/webapps

sudo vi /opt/tomcat/conf/server.xml

sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo systemctl status tomcat

curl http://stapp02:8086

### Via Yum
ssh steve@stapp02
sudo -i
yum install -y tomcat
systemctl status tomcat
vi /usr/share/tomcat/conf/server.xml
systemctl restart tomcat
scp /tmp/ROOT.war steve@stapp02:/tmp/
mv /tmp/ROOT.war /usr/share/tomcat/webapps/ROOT.war
chown tomcat:tomcat /usr/share/tomcat/webapps/ROOT.war
systemctl restart tomcat
curl http://stapp02:3004

## Day 12: Linux Network Services
### https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands
ssh tony@stapp01
systemctl status httpd
sudo netstat -nlp | grep :3004
ps -aux

systemctl stop sendmail
sudo kill 493
sudo systemctl restart httpd

### Firewall
sudo iptables -L -n -v
sudo iptables -I INPUT -p tcp --dport 5004 -j ACCEPT
sudo service iptables save
sudo systemctl restart iptables

curl http://stapp01:3004