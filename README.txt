お試し用のOTRS5 Helpdeskイメージです。

OTRS 5.0.9 helpdesk
Mysql 5.7.12

実行は以下のようにしてください。
docker run -d -p <ポート>:80 docker.io/hirami/otrs5_helpdesk_jp
もしくは
docker run -d -p <ポート>:80 hirami/otrs5_helpdesk_jp

コンテナ起動後、以下のURLでログイン画面にアクセスできます。
http://<ホストのIP>:<ポート>/otrs/index.pl

初期状態では、以下のアカウントが有効となっています。ログイン後適宜変更してください。
ID: root@localhost
PW: otrs-ioa

・「OTRSデーモンが起動していません」のメッセージは5〜10分ぐらい経つと消えます。
・OTRSの評価目的のイメージのため、本番での使用はお勧めしません。
・メール設定は無効としてあります。必要に応じて個別に設定してください。
