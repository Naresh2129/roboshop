log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>>>create user service<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/user.service &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>create mongodb repo<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>install nodejs repo<<<<<<<<<<<\e[0m"
curl -sl https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>install nodejs<<<<<<<<<<<\e[0m"
dnf install nodejs -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>create application user<<<<<<<<<<<\e[0m"
useradd roboshop &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>create application directory<<<<<<<<<<<\e[0m"
rm -rf /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>create application directory<<<<<<<<<<<\e[0m"
mkdir /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>download application content<<<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

echo -e "\e[36m>>>>>>>>>>>>>exatract application content<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/user.zip &>>${log}
cd /app

echo -e "\e[36m>>>>>>>>>>>>>install nodejs dependencies<<<<<<<<<<<\e[0m"
npm install &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>install mongo client<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>load user schema<<<<<<<<<<<\e[0m"
mongo --host mongodb.nkdevops29.online </app/schema/user.js &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>start  user service<<<<<<<<<<<\e[0m"
systemctl daemon-reload &>>${log}
systemctl enable user &>>${log}
systemctl restart user &>>${log}
