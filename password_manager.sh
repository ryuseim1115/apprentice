#!/bin/bash
output_file="personal_infomation.csv"
start_message="パスワードマネージャーへようこそ！"
require_service_name="サービス名を入力してください："
require_user_name="ユーザー名を入力してください："
require_password="パスワードを入力してください："
end_message="Thank you!"

if [ ! -e "$output_file" ]; then
touch "$output_file"
echo "サービス名,ユーザー名,パスワード" > "$output_file"
fi

echo "$start_message"

read -p "$require_service_name" service_name
read -p "$require_user_name" user_name
read -p "$require_password" password
echo "$service_name,$user_name,$password" >> "$output_file"

echo "$end_message"
