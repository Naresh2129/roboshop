mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo INput password Missing
  exit 1
fi
cp mysql.repo /etc/yum.repos./mysql.repo
dnf module disable mysql -y
dnf install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass ${mysql_root_password}