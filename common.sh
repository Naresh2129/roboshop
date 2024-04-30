log=/tmp/roboshop.log

func_apppreq() {
    echo -e "\e[36m>>>>>>>>>>>>>create application user<<<<<<<<<<<\e[0m"
    useradd roboshop &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>clean up existing application content<<<<<<<<<<<\e[0m"
    rm -rf /app &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>create application directory<<<<<<<<<<<\e[0m"
    mkdir /app &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>download application content<<<<<<<<<<<\e[0m"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>exatract application content<<<<<<<<<<<\e[0m"
    cd /app
    unzip /tmp/${component}.zip &>>${log}
    cd /app
}

func_systemd() {
    echo -e "\e[36m>>>>>>>>>>>>>start  ${component} service<<<<<<<<<<<\e[0m"
    systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl restart ${component} &>>${log}

}
func_nodejs() {
  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>>>>create user service<<<<<<<<<<<\e[0m"
  cp catalogue.service /etc/systemd/system/${component}.service &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>create mongodb repo<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>install nodejs repo<<<<<<<<<<<\e[0m"
  curl -sl https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>install nodejs<<<<<<<<<<<\e[0m"
  dnf install nodejs -y &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>download nodejs dependencies<<<<<<<<<<<\e[0m"
  npm install &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>install mongo client<<<<<<<<<<<\e[0m"
  dnf install mongodb-org-shell -y &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>load ${component} schema<<<<<<<<<<<\e[0m"
  mongo --host mongodb.nkdevops29.online </app/schema/${component}.js &>>${log}

  func_systemd
 }
 func_java(){
  echo -e "\e[36m>>>>>>>>>>>>>create  ${component} service<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>install maven<<<<<<<<<<<\e[0m"
  dnf install maven -y

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>> build ${component} service <<<<<<<<<<<\e[0m"
  mvn clean package
  mv target/shipping-1.0.jar shipping.jar &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>install my sql client <<<<<<<<<<<\e[0m"
  dnf install mysql -y &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>> load schema<<<<<<<<<<<\e[0m"
  mysql -h mysql.nkdevops29.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}

 func_systemd
}
