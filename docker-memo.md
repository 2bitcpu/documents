```
brew install docker docker-compose docker-buildx

mkdir -p ~/.docker/cli-plugins

ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
ln -sfn $(which docker-buildx) ~/.docker/cli-plugins/docker-buildx
docker buildx install

brew install colima

$ sw_vers
ProductName:            macOS
ProductVersion:         15.5
BuildVersion:           24F74

$ colima --version
colima version 0.8.1

$ docker --version
Docker version 28.2.2, build e6534b4eb7

$ docker compose version
Docker Compose version 2.37.0

colima start --profile aarc64 --cpu 2 --memory 2 --disk 32

colima start --profile x86_64 --arch x86_64 --cpu 2 --memory 2 --disk 32


export UID=$(id -u) && export GID=$(id -g) && docker-compose up -d

docker stop $(docker ps -q) && docker rm $(docker ps -q -a) && docker rmi $(docker images -q)

docker stop $(docker ps -q) && docker rm $(docker ps -q -a) && docker rmi $(docker images -q) && docker system prune



docker stop $(docker ps -q)

docker rm $(docker ps -q -a)

docker rmi $(docker images -q)

docker system prune

docker system df

docker volume rm $(docker volume ls -qf dangling=true)
```

```bash
mkdir -p ./public_html
cd ./public_html
docker run --rm --name nginx-dev -d -p 8080:80 --mount type=bind,source="$(pwd)",target=/usr/share/nginx/html nginx:latest
```
