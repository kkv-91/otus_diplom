На локальной машине поднять докер контейнер:
1. установить docker (https://docs.docker.com/engine/install/ubuntu/), git
2. git clone https://github.com/kkv-91/otus_diplom
3. mkdir -p ./dags ./logs ./plugins ./config ./data ./data_worked
echo -e "AIRFLOW_UID=$(id -u)" > .env
4. в .env файл добавить данные для авторизации в KAGGLE API  
   KAGGLE_USERNAME=<your_user_name>
   KAGGLE_KEY=<your_secret_key>
5.  sudo docker compose up airflow-init -d  
6.  sudo docker compose up -d
   
Поднять metabase:
1. docker pull metabase/metabase:latest
2. docker run -d -p 3000:3000 --name metabase metabase/metabase

Создать pg-node:
1. Подключиться к виртуальной машине Linux по SSH - Создание пары ключей SSH: https://cloud.yandex.ru/docs/compute/operations/vm-connect/ssh#creating-ssh-keys
2. yc compute instance create \
    --name pg-node \
    --ssh-key ~/.ssh/id_rsa.pub \
    --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2204-lts,size=100,auto-delete=true \
    --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
    --memory 16G \
    --cores 4 \
    --zone ru-central1-a \
    --hostname pg-node
3. sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
4. wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
5. sudo apt-get update
6. sudo apt-get -y install postgresql
7. sudo pg_lsclusters 
8. sudo nano /etc/postgresql/17/main/pg_hba.conf
  
    host    all             all              <IP airflow, metabase>                       md5

9. sudo nano /etc/postgresql/17/main/postgresql.conf
        
    listen_addresses = '*'
   
10. sudo pg_ctlcluster 17 main restart

5. Задать пароль пользователю postgres
ALTER USER postgres WITH PASSWORD 'new_password';

На локальной машине с поднятыми контейнерами
1. Подключиться к airflow
http://localhost:8080/home
- Admin - Connections: Conn ID: postgres_analytics_otus
			Conn Type: Postgres
			Host: <IP адрес pg_node>
			Database: postgres
			Login: postgres
  			Password: <your_password>
			Port: 5432
- Admin - Variables: kaggle_dataset
			chicago/chicago-taxi-rides-2016

2. Подключиться к Metabase, выполнить регистрацию
http://localhost:3000/
Настроить подключение к Postgres:
			Conn ID: postgres_analytics_otus
			Conn Type: Postgres
			Host: <IP адрес pg_node>
			Database: postgres
			Login: postgres
  			Password: <your_password>
			Port: 5432
