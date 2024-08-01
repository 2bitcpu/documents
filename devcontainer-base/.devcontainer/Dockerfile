FROM debian:bullseye-slim

ARG USERID
ARG GROUPID
ARG USERNAME
ARG GROUPNAME
ARG PASSWORD

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
apt-get install -y --no-install-recommends \
sudo git bash-completion tree vim curl wget locales && \
echo "LC_ALL=en_US.UTF-8" | tee -a /etc/environment && \
echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen && \
echo "LANG=en_US.UTF-8" | tee -a /etc/locale.conf && \
locale-gen en_US.UTF-8 && \
apt-get install -y upx && \
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
