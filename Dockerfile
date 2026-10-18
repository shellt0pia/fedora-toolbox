FROM registry.fedoraproject.org/fedora-toolbox:44

LABEL org.opencontainers.image.url=https://github.com/shellt0pia/fedora-toolbox
LABEL org.opencontainers.image.authors="Victor 'shellt0pia' Bouvier-Deleau"

COPY etc/yum.repos.d/ /etc/yum.repos.d/
COPY etc/vulkan/icd.d/ /etc/vulkan/icd.d/
COPY extra-packages /

RUN dnf -y install $(<extra-packages) && \
    dnf clean all && \
    rm /extra-packages

RUN for executable in firefox flatpak op podman rpm-ostree systemctl xdg-open; do \
      ln -s /usr/bin/host-spawn /usr/local/bin/${executable}; \
    done
