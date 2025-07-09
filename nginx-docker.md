# nginxをサクッと試す

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

```
mkdir -p html
mkdir -p conf.d
mkdir -p log
```

```
docker run -d --rm --name nginx-local -p 8765:80 nginx:alpine
```

```
docker run -d --rm --name nginx-local --mount type=bind,source="$(pwd)/html",target=/usr/share/nginx/html -p 8765:80 nginx:alpine
```

```
docker run -d --rm --name nginx-local \
--mount type=bind,source="$(pwd)/html",target=/usr/share/nginx/html \
--mount type=bind,source="$(pwd)/conf.d",target=/etc/nginx/conf.d \
-p 8765:80 nginx:alpine
```

```
docker run -d --rm --name nginx-local \
--mount type=bind,source="$(pwd)/html",target=/usr/share/nginx/html \
--mount type=bind,source="$(pwd)/conf.d",target=/etc/nginx/conf.d \
--mount type=bind,source="$(pwd)/log",target=/var/log/nginx \
-p 8765:80 nginx:alpine
```

```
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log main;
    #error_log   /var/log/nginx/host.error.log info;
    access_log  off;
    error_log   /dev/null debug;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

```
docker exec -it --user root nginx-local /bin/sh
nginx -s reload
```