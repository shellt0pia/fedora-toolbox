FROM registry.fedoraproject.org/fedora-toolbox:43

COPY usr/local/bin/ /usr/local/bin/

RUN chmod +x /usr/local/bin/host-runner && \
    for executable in firefox flatpak op podman rpm-ostree systemctl xdg-open; do \
      ln -s /usr/local/bin/host-runner /usr/local/bin/$executable; \
    done

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc

COPY etc/yum.repos.d/ /etc/yum.repos.d/

RUN dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

RUN dnf upgrade -y && \
    dnf install -y \
    openssh rsync curl wget \
    zsh zsh-autosuggestions zsh-syntax-highlighting fzf tmux starship git \
    levien-inconsolata-fonts \
    vim code \
    make butane checkpolicy policycoreutils \
    ansible python3-ansible-lint python3-passlib python3-netaddr python3-jmespath \
    ShellCheck \
    jq bat ripgrep \
    iputils tcpdump netcat ndisc6 bind-utils nmap whois ipcalc \
    p7zip zip unzip unrar \
    pandoc perl-Image-ExifTool ImageMagick \
    chezmoi bitwarden-cli \
    yt-dlp

RUN curl -fL -o /usr/local/bin/talosctl "https://github.com/siderolabs/talos/releases/latest/download/talosctl-linux-amd64" && chmod +x /usr/local/bin/talosctl

CMD /usr/bin/bash
