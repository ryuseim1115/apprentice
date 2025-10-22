#!/bin/bash

output_file="personal_infomation.csv"

header1="サービス名："
header2="ユーザー名："
header3="パスワード："

choice_message="次の選択肢から入力してください(Add Password/Get Password/Exit)："

choice1="Add Password"
choice2="Get Password"
choice3="Exit"

start_message="パスワードマネージャーへようこそ！"
require_service_name="サービス名を入力してください："
require_user_name="ユーザー名を入力してください："
require_password="パスワードを入力してください："
password_store_success="パスワードの追加は成功しました。"

end_message="Thank you!"

if [ ! -e "$output_file" ]; then
	touch "$output_file"
	echo "$header1,$header2,$header3" >"$output_file"
fi

echo "$start_message"

while true; do
	read -p "$choice_message" choice
	if [ "$choice" = "$choice1" ]; then
		read -p "$require_service_name" service_name
		read -p "$require_user_name" user_name
		read -p "$require_password" password
		echo "$service_name,$user_name,$password" >>"$output_file"
		echo "$password_store_success"
	fi

	if [ "$choice" = "$choice2" ]; then
		read -p "$require_service_name" service_name
		read service_name user_name password < <(awk -F',' -v val="$service_name" '$1 == val {print $1, $2, $3}' "$output_file")
		if [ -n "$user_name" ]; then
			echo "サービス名： $service_name"
			echo "ユーザー名： $user_name"
			echo "パスワード： $password"
		else
			echo "そのサービスは登録されていません。"
		fi
	fi

	if [ "$choice" = "$choice3" ]; then
		echo "$end_message"
		break
	fi
done
