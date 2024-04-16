cp cart.service /etc/systemd/system/cart.service

curl -sl https://rpm.nodesource.com/setup_lts.x | bash
dnf install nodejs -y
useradd roboshop
mkdir /app
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
cd /app
npm install


systemctl daemon-reload
systemctl enable cart
systemctl restart cart