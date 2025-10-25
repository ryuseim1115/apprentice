#!/bin/bash

#変数定義
output_file="personal_infomation.csv"
passphrase="tmp_passphrase"
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

#サービス名、ユーザー名、パスワードを保存するCSVファイルを作成
if [ ! -e "$output_file.gpg" ]; then
	touch "$output_file"
	gpg -c --batch --yes --passphrase "$passphrase" -o "$output_file.gpg" "$output_file"
	rm "$output_file"
fi

echo "$start_message"

while true; do
	read -p "$choice_message" choice
	if [ "$choice" = "$choice1" ]; then
		read -p "$require_service_name" service_name
		read -p "$require_user_name" user_name
		read -p "$require_password" password

		# 一時的に復号化
		gpg -d --batch --yes --passphrase "$passphrase" "$output_file.gpg" >"$output_file" 2>/dev/null
		#一時的にパスワードを保存
		echo "$service_name,$user_name,$password" >>"$output_file"
		#一時的に保存したパスワードを暗号化して保存
		gpg -c --batch --yes --passphrase "$passphrase" -o "$output_file.gpg" "$output_file"

		rm "$output_file"
		# #処理完了メッセージ
		echo "$password_store_success"
	fi

	if [ "$choice" = "$choice2" ]; then
		read -p "$require_service_name" service_name
		#一時的に復号化
		gpg -d --batch --yes --passphrase "$passphrase" "$output_file.gpg" >"$output_file" 2>/dev/null
		#サービス名をもとにユーザー名、パスワードを取得
		read result_service_name user_name password < <(awk -F',' -v val="$service_name" '$1 == val {print $1, $2, $3}' "$output_file")

		if [ -n "$result_service_name" ]; then
			echo "サービス名： $result_service_name"
			echo "ユーザー名： $user_name"
			echo "パスワード： $password"
		else
			echo "そのサービスは登録されていません。"
		fi
		rm "$output_file"
	fi

	if [ "$choice" = "$choice3" ]; then
		echo "$end_message"
		break
	fi
done
