
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


