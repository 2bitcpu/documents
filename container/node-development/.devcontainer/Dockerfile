FROM ubuntu:focal

ARG USERID
ARG GROUPID
ARG USERNAME
ARG GROUPNAME
ARG PASSWORD

ENV TZ Asia/Tokyo

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive \
TZ=Asia/Tokyo \
apt-get install -y --no-install-recommends \
tzdata sudo bash-completion bash git ca-certificates vim curl wget && \
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
dpkg-reconfigure --frontend noninteractive tzdata && \
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs && \
npm install -g pnpm && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* && \
groupadd -o -g ${GROUPID} -r ${GROUPNAME} && \
useradd -m -s /bin/bash -u ${USERID} -g ${GROUPID} -G sudo ${USERNAME} && \
echo ${USERNAME}:${PASSWORD} | chpasswd && \
echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
echo "source /usr/share/bash-completion/completions/git" >> /home/${USERNAME}/.bashrc && \
echo "source /etc/bash_completion.d/git-prompt" >> /home/${USERNAME}/.bashrc && \
echo "PROMPT_COMMAND='PS1_CMD1=\$(__git_ps1 \" (%s)\")'; PS1='\[\e[38;5;40m\]\u@\h\[\e[0m\]:\[\e[38;5;39m\]\w\[\e[38;5;214m\]\${PS1_CMD1}\[\e[0m\]\\$ '" >> /home/${USERNAME}/.bashrc

USER ${USERNAME}
WORKDIR /home/${USERNAME}