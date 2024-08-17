# VSCode Development Congtainer for Rust

#### 必要なもの
```
~ % sw_vers
ProductName:            macOS
ProductVersion:         14.5
BuildVersion:

~ % colima --version
colima version 0.6.10

~ % docker --version
Docker version 27.1.1, build 63125853e3
```

#### 構成
```
./devcontainer-rust
├── .devcontainer
│  ├── devcontainer.json
│  ├── compose.yml
│  ├── Dockerfile
│  └── Dockerfile.1.79
└── workspace
   └── READEME.md
```

```docker:Dockerfile
FROM rust:slim-bullseye

ARG USERID
ARG GROUPID
ARG USERNAME
ARG GROUPNAME
ARG PASSWORD

ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/sh", "-c"]
RUN apt-get update && \
apt-get install -y --no-install-recommends \
sudo git ca-certificates bash-completion vim curl wget locales && \
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
dpkg-reconfigure --frontend=noninteractive locales  && \
export LANG=en_US.UTF-8 && export LANGUAGE=en_US:en && export LC_ALL=en_US.UTF-8 && \
apt-get install -y upx && \
apt-get autoclean && apt-get autoremove && \
rm -r /var/lib/apt/lists/*  && \
groupadd -o -g ${GROUPID} -r ${GROUPNAME} && \
useradd -m -s /bin/bash -u ${USERID} -g ${GROUPID} -G sudo ${USERNAME} && \
echo ${USERNAME}:${PASSWORD} | chpasswd && \
echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
echo "source /usr/share/bash-completion/completions/git" >> /home/${USERNAME}/.bashrc && \
echo "source /etc/bash_completion.d/git-prompt" >> /home/${USERNAME}/.bashrc && \
echo "PROMPT_COMMAND='PS1_CMD1=\$(__git_ps1 \" (%s)\")'; PS1='\[\e[38;5;40m\]\u@\h\[\e[0m\]:\[\e[38;5;39m\]\w\[\e[38;5;214m\]\${PS1_CMD1}\[\e[0m\]\\$ '" >> /home/${USERNAME}/.bashrc

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

USER ${USERNAME}
WORKDIR /home/${USERNAME}

SHELL ["/bin/bash", "-c"]
RUN rustup component add rustfmt && rustup install nightly && rustup component add rust-src --toolchain nightly
```

上記の```Dockerfile```では最新バージョンがインストールされます  
古いバージョンを使いたい場合は  
```FROM rust:1.79-slim-bullseye```  
のようにバージョンを指定してください  
その場合、```nightly```のインストールには```nightly-yyyy-mm-dd```のように日付の指定が必要です  
日付には安定版のリリース日を指定します  
リリース日は、https://releases.rs/docs/ で調べることができます  
例えば1.79のリリース日は```13 June, 2024```となっていますので```nightly-2024-06-13```となります  
またnightlyビルド時にも日付を指定する必要があります
```bash
cargo +nightly-2024-06-13 build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --target aarch64-unknown-linux-gnu --release
```