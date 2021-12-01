sudo apt-get update && sudo apt-get upgrade -y 
sudo apt-get install apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 -y 
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update 
sudo apt-get install mongodb-org -y
wget -qO- 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9DA31620334BD75D9DCB49F368818C72E52529D4' | sudo apt-key add - -y
sudo systemctl daemon-reload
sudo systemctl enable mongod.service
sudo systemctl restart mongod.service
sudo systemctl --type=service --state=active | grep mongod
wget -q https://artifacts.elastic.co/GPG-KEY-elasticsearch -O myKey
sudo apt-key add myKey
echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install elasticsearch-oss -y
sudo tee -a /etc/elasticsearch/elasticsearch.yml > /dev/null <<EOT
cluster.name: graylog
action.auto_create_index: false
EOT
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl restart elasticsearch.service
sudo systemctl --type=service --state=active | grep elasticsearch
wget https://packages.graylog2.org/repo/packages/graylog-4.2-repository_latest.deb
sudo yes | dpkg -i graylog-4.2-repository_latest.deb
sudo apt-get update && sudo apt-get install graylog-server graylog-enterprise-plugins graylog-integrations-plugins graylog-enterprise-integrations-plugins -y
echo -n "Defina uma senha para o graylog: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1
sudo systemctl daemon-reload
sudo systemctl enable graylog-server.service
sudo systemctl start graylog-server.service
sudo systemctl --type=service --state=active | grep graylog
