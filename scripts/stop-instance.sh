#!/bin/bash

# atサービスを起動
sudo systemctl enable --now atd

# 3分後にインスタンスを停止するコマンドをスケジュール
echo 'INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) && aws ec2 stop-instances --instance-ids $INSTANCE_ID' | at now + 3 minutes
