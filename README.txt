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

本バージョンではメールの評価が出来るようにローカルのみで有効なウェブメーラーを同梱しました。
以下のURLからウェブメーラーにログインして、OTRSにサポート依頼を投げることができます。
http://<ホストのIP>:<ポート>/webmail

ユーザとして以下の4アカウントを用意しています。
cust01/cust01
cust02/cust02
cust03/cust03
cust04/cust04

初期状態ではOTRSヘルプデスクのメールアドレスは以下の通りです。
helpdesk@eval-mail.local.domain

cust01〜cust04でWebメーラーにログインし、上のアドレスに対してメールを送るとOTRSに取り込まれます(5分ほどかかります)。また、OTRSからメールの返信を行うことができますので、メール関連の操作についてもお試しいただけるかと思います。


・「OTRSデーモンが起動していません」のメッセージは5〜10分ぐらい経つと消えます。
・OTRSの評価目的のイメージのため、本番での使用はお勧めしません。

