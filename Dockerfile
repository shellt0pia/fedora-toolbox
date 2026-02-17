FROM registry.fedoraproject.org/fedora-toolbox:43

LABEL org.opencontainers.image.url=https://github.com/shellt0pia/fedora-toolbox
LABEL org.opencontainers.image.authors="Victor 'shellt0pia' Bouvier-Deleau"

COPY etc/yum.repos.d/ /etc/yum.repos.d/
COPY extra-packages /

RUN dnf -y install $(<extra-packages) && \
    dnf clean all && \
    rm /extra-packages
RUN mkdir -p /usr/local/share/zsh/site-functions
RUN curl -fL -o /usr/local/bin/talosctl "https://github.com/siderolabs/talos/releases/latest/download/talosctl-linux-amd64" && \
    chmod +x /usr/local/bin/talosctl && \
    /usr/local/bin/talosctl completion zsh > /usr/local/share/zsh/site-functions/_talosctl
RUN curl -fL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /usr/local/bin/kubectl && \
    /usr/local/bin/kubectl completion zsh > /usr/local/share/zsh/site-functions/_kubectl

RUN for executable in firefox flatpak op podman rpm-ostree systemctl xdg-open; do \
      ln -s /usr/bin/host-spawn /usr/local/bin/${executable}; \
    done
