```
brew install docker docker-compose docker-buildx

mkdir -p ~/.docker/cli-plugins

ln -sfn /usr/local/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
ln -sfn $(which docker-buildx) ~/.docker/cli-plugins/docker-buildx
docker buildx install

brew install colima

~ % sw_vers
ProductName:            macOS
ProductVersion:         14.5
BuildVersion:

~ % colima --version
colima version 0.6.10

~ % docker --version
Docker version 27.1.1, build 63125853e3

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