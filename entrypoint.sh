#!/bin/bash
set -e

# 1. 古いサーバーのゴミ（PIDファイル）を掃除
rm -f /app/tmp/pids/server.pid

# 2. 起動する直前に、本番DBの「工事」と「シード」を強制実行
# これをここに書くことで、Dockerコンテナが立ち上がるたびに確実にチェックが入ります
echo "Checking and running migrations..."
bundle exec rails db:migrate
bundle exec rails db:seed

# 3. 本来の起動コマンド（rails s など）を実行
exec "$@"