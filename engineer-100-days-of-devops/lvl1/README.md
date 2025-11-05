
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