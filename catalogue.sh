echo ">>>>>>>>>>>>>create catalogue service<<<<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service
echo ">>>>>>>>>>>>>create mongodb repo<<<<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo ">>>>>>>>>>>>>install nodejs repo<<<<<<<<<<<<<"
curl -sl https://rpm.nodesource.com/setup_lts.x | bash
echo ">>>>>>>>>>>>>install nodejs<<<<<<<<<<<<<"
dnf install nodejs -y
echo ">>>>>>>>>>>>>create application user<<<<<<<<<<<<<"
useradd roboshop
echo ">>>>>>>>>>>>>create application directory<<<<<<<<<<<<<"
mkdir /app
echo ">>>>>>>>>>>>>download application content<<<<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo ">>>>>>>>>>>>>exatract application content<<<<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app
echo ">>>>>>>>>>>>>install nodejs dependencies<<<<<<<<<<<<<"
npm install
echo ">>>>>>>>>>>>>install mongo client<<<<<<<<<<<<<"
dnf install mongodb-org-shell -y
echo ">>>>>>>>>>>>>load catalogue schema<<<<<<<<<<<<<"
mongo --host mongodb.nkdevops29.online </app/schema/catalogue.js
echo ">>>>>>>>>>>>>start  catalogue service<<<<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue