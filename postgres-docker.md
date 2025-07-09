# PostgresSQLをサクッと試す

#### 下記の環境にて検証しています

```bash
$ sw_vers
ProductName:            macOS
ProductVersion:         15.5
BuildVersion:           24F74
$ colima --version
colima version 0.8.1
$ docker -v
Docker version 28.3.0, build 38b7060a21
```

## クライアントコンテナの準備

#### Dockerfileを作成します

```
FROM alpine:latest
RUN apk update && apk add --no-cache postgresql-client
```
#### Dockerfileをビルドします
```
docker build . -t postgres-client-image
```

## dockerネットワークの準備
コンテナ間で通信を行うには同じネットワークである必要があります
```
docker network create postgres-net
```

## サーバーコンテナの起動
永続化のためにHOSTのディレクトリをマウントします
```
mkdir -p ./data
docker run --rm --name postgres-server -d --mount type=bind,source="$(pwd)"/data,target=/var/lib/postgresql/data:rw --network postgres-net -p 5432:5432 -e POSTGRES_PASSWORD=password postgres:alpine
```

## クライアントコンテナの起動
起動してコンテナに入ります

```
docker run --rm -it --name postgres-client --network postgres-net postgres-client-image sh
```

#### クライアントコンテナからサーバーコンテナに接続します
```
psql -h postgres-server -U postgres
```
ユーザー```devuser```を作成してパスワード```devpwd```を設定します
```
create user devuser with password 'devpwd';
```
データベース```devdb```を作成してオーナーに```devuser```を設定します  
psqlからログアウトします
```
create database devdb with owner devuser;
quit
```
ユーザー```devuser```でデータベース```devdb```にログインします
```
psql -h postgres-server -d devdb -U devuser
```

スキーマを作成して、テーブルを作成して、データを追加します
```
create schema devschema;
create table devschema.account (
    id serial primary key,
    name varchar(64) not null
);
insert into devschema.account (name) values ('devname') returning *;
```
