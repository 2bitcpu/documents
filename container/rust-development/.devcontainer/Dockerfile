FROM ubuntu:jammy

ARG USERID
ARG GROUPID
ARG USERNAME
ARG GROUPNAME
ARG PASSWORD

ENV TZ Asia/Tokyo
ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
apt-get install -y --no-install-recommends \
tzdata sudo bash-completion bash git ca-certificates vim curl wget && \
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
dpkg-reconfigure --frontend noninteractive tzdata && \
apt-get install -y --no-install-recommends build-essential upx && \
apt-get clean && \
groupadd -o -g ${GROUPID} -r ${GROUPNAME} && \
useradd -m -s /bin/bash -u ${USERID} -g ${GROUPID} -G sudo ${USERNAME} && \
echo ${USERNAME}:${PASSWORD} | chpasswd && \
echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
echo "source /usr/share/bash-completion/completions/git" >> /home/${USERNAME}/.bashrc && \
echo "source /etc/bash_completion.d/git-prompt" >> /home/${USERNAME}/.bashrc && \
echo "PROMPT_COMMAND='PS1_CMD1=\$(__git_ps1 \" (%s)\")'; PS1='\[\e[38;5;40m\]\u@\h\[\e[0m\]:\[\e[38;5;39m\]\w\[\e[38;5;214m\]\${PS1_CMD1}\[\e[0m\]\\$ '" >> /home/${USERNAME}/.bashrc

USER ${USERNAME}
WORKDIR /home/${USERNAME}

SHELL ["/bin/bash", "-c"]

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
source /home/${USERNAME}/.cargo/env && \
rustup component add rustfmt && \
rustup install nightly && \
rustup component add rust-src --toolchain nightly && \
cargo install wasm-pack && \
rustup target add wasm32-unknown-unknown && \
sudo rm -rf /var/lib/apt/lists/*
