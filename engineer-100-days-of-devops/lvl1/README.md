
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

# Day 7: Linux SSH Authentication
## https://askubuntu.com/questions/4830/easiest-way-to-copy-ssh-keys-to-another-machine/4833#4833
ls ~/.ssh/
ssh-keygen
ssh-copy-id tony@stapp01
ssh tony@stapp01
ssh-copy-id steve@stapp02
ssh steve@stapp02
ssh-copy-id banner@stapp03
ssh banner@stapp03

# Day 8: Install Ansible
## https://pypi.org/project/ansible/#history
## https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

pip3 --version
### global in /usr/local/lib/python3.x/dist-packages
sudo pip3 install ansible==4.9.0
ansible --version

# Day 9: MariaDB Troubleshooting
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