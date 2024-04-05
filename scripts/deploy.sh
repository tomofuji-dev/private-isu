# referenced from https://github.com/tatsuru/isucon13/blob/main/scripts/deploy

set -v

IP="3.115.50.102"
KEY_PATH="~/.ssh/isucon"
now=$(date +%Y%m%d-%H%M%S)
branch=${1-master}

update="cd /home/isucon/private_isu && git remote update && git checkout $branch && git pull && sudo mv ~/default.conf /etc/nginx/conf.d/default.conf"
restart="cd /home/isucon/private_isu/webapp/golang && /home/isucon/.local/go/bin/go build -o app && sudo systemctl restart isu-go"
# rotate_mysql="sudo mv -v /var/log/mysql/slow.log /var/log/mysql/slow.log.$now && mysqladmin -uisuconp -pisuconp flush-logs"
rotate_nginx="sudo mv -v /var/log/nginx/access.log /var/log/nginx/access.log.$now && sudo systemctl reload nginx"

# ssh isucon@privateisup "$update && $restart && $rotate_mysql && $rotate_nginx"
scp -i $KEY_PATH `git rev-parse --show-toplevel`/webapp/etc/nginx/conf.d/default.conf isucon@$IP:~/

ssh -i $KEY_PATH isucon@$IP "$update && $restart && $rotate_nginx"