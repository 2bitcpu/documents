```
mkdir html
mkdir conf.d
mkdir log
```

```
docker run -d -it --rm --name nginx-local -p 8765:80 nginx:alpine
```

```
docker run -d -it --rm --name nginx-local --mount type=bind,source="$(pwd)/html",target=/usr/share/nginx/html -p 8765:80 nginx:alpine
```

```
docker run -d -it --rm --name nginx-local \
--mount type=bind,source="$(pwd)/html",target=/usr/share/nginx/html \
--mount type=bind,source="$(pwd)/conf.d",target=/etc/nginx/conf.d \
-p 8765:80 nginx:alpine
```

```
docker run -d -it --rm --name nginx-local \
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