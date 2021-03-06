#!/usr/bin/env bash

PROJECT_PATH="/var/www/YYF"
TEMP_PATH="/tmp/"
CONF_PATH="/etc/httpd/conf/httpd.conf"

# sudo yum -y update

#################################
###[LAMP]
### 安装 apache php mysql
################################

# install httpd
# 安装 apache php gcc和git
sudo yum install -y httpd git \
    php php-opcache php-pdo_mysql php-mcrypt php-mbstring php-curl \
    php-devel gcc
    

# 安装mysql或者mariadb 会二者选一
sudo yum install -y mysql-server mariadb-server

#################################
###[YAF_EXTENTSION]
### 安装 yaf
################################
#判断yaf版本和php版本
#check the version of php and yaf
PHP_VERSION=$(php -v|grep --only-matching --perl-regexp "\d\.\d+\.\d+"|head -1);
if [[ ${PHP_VERSION} == "7."* ]]; then
    #php 7
    YAF_VERSION=yaf-3.0.3
else
    #php 5 
    YAF_VERSION=yaf-2.3.5
fi;
# 下载解压yaf
# download yaf
curl https://pecl.php.net/get/${YAF_VERSION}.tgz | tar zx -C $TEMP_PATH
# 编译安装 YAF
# compile and install YAF
cd ${TEMP_PATH}${YAF_VERSION} && phpize;
./configure && make && sudo make install

# 配置yaf(product 环境)
# configure yaf with product environment
sudo tee /etc/php.d/yaf.ini> /dev/null <<EOF
extension=yaf.so
[yaf]
yaf.environ=product
yaf.cache_config = 1
EOF

# configure the apache(httpd)
# 配置apache开机启动
sudo systemctl start httpd.service
sudo systemctl enable httpd
#防火墙允许httpd 部分系统有效
sudo firewall-cmd --permanent --add-service=http

# httpd webroot
# 配置 apache 根目录
sudo cp $CONF_PATH ${CONF_PATH}.back
sudo sed -i.back -e "s|\"/var/www/html\"|\"${PROJECT_PATH}/public\"|g" $CONF_PATH 

# clone YYF and initialize
# clone 代码  初始化
if [ ! -f $PROJECT_PATH ]; then
    sudo mkdir -p ${PROJECT_PATH}
fi;

sudo chown $UID ${PROJECT_PATH}

git clone https://github.com/YunYinORG/YYF.git ${PROJECT_PATH}
echo 0 | ${PROJECT_PATH}/init.cmd 

#重启apache服务器
#restart apache
sudo service httpd restart