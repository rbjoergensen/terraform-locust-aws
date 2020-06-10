apt update -q
#apt upgrade -yqq
apt install -y python3-pip
pip3 install --no-cache-dir locust
mkdir /locust