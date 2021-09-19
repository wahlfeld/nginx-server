#!/bin/bash
set -e

bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait

systemctl restart docker

docker run -p 80:80 -d nginx
