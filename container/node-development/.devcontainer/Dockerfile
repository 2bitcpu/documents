FROM node:lts-slim

ARG USERID
ARG GROUPID
ARG USERNAME
ARG GROUPNAME
ARG PASSWORD

ENV TZ Asia/Tokyo

SHELL ["/bin/sh", "-c"]
RUN apt-get update && \
apt-get install -y --no-install-recommends \
sudo bash-completion bash sudo git ca-certificates vim curl wget && \
corepack enable pnpm && \ 
apt-get autoclean && apt-get autoremove && \
groupadd -o -g ${GROUPID} -r ${GROUPNAME} && \
useradd -m -s /bin/bash -u ${USERID} -g ${GROUPID} -G sudo ${USERNAME} && \
echo ${USERNAME}:${PASSWORD} | chpasswd && \
echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
echo "source /usr/share/bash-completion/completions/git" >> /home/${USERNAME}/.bashrc && \
echo "source /etc/bash_completion.d/git-prompt" >> /home/${USERNAME}/.bashrc && \
echo "PROMPT_COMMAND='PS1_CMD1=\$(__git_ps1 \" (%s)\")'; PS1='\[\e[38;5;40m\]\u@\h\[\e[0m\]:\[\e[38;5;39m\]\w\[\e[38;5;214m\]\${PS1_CMD1}\[\e[0m\]\\$ '" >> /home/${USERNAME}/.bashrc

USER ${USERNAME}
WORKDIR /home/${USERNAME}
