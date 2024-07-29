FROM ubuntu:20.04

ARG UID
ARG GID
ARG USERNAME
ARG GROUPNAME
ARG PASSWORD

RUN apt-get update && apt-get upgrade -y && apt-get install -y sudo git bash-completion tree vim curl wget build-essential && \
apt-get autoclean && apt-get autoremove && \
groupadd -o -g ${GID} -r ${GROUPNAME} && \
useradd -m -s /bin/bash -u ${UID} -g ${GID} -G sudo ${USERNAME} && \
echo ${USERNAME}:${PASSWORD} | chpasswd && \
echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
echo "source /usr/share/bash-completion/completions/git" >> /home/${USERNAME}/.bashrc && \
echo "source /etc/bash_completion.d/git-prompt" >> /home/${USERNAME}/.bashrc && \
echo "PROMPT_COMMAND='PS1_CMD1=\$(__git_ps1 \" (%s)\")'; PS1='\[\e[38;5;40m\]\u@\h\[\e[0m\]:\[\e[38;5;39m\]\w\[\e[38;5;214m\]\${PS1_CMD1}\[\e[0m\]\\$ '" >> /home/${USERNAME}/.bashrc

USER ${USERNAME}
WORKDIR /home/${USERNAME}

