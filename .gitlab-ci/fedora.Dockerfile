FROM registry.fedoraproject.org/fedora:33

# TODO: remove --nogpgcheck when Fedora 
RUN dnf -y install \
    ccache \
    desktop-file-utils \
    gcc \
    gettext \
    git \
    gobject-introspection-devel \
    gtk-doc \
    ibus-devel \
    intltool \
    krb5-devel \
    libpwquality-devel \
    libsecret-devel \
    meson \
    ninja-build \
    "pkgconfig(accountsservice)" \
    "pkgconfig(cheese)" \
    "pkgconfig(cheese-gtk)" \
    "pkgconfig(flatpak)" \
    "pkgconfig(fontconfig)" \
    "pkgconfig(gdm)" \
    "pkgconfig(geocode-glib-1.0)" \
    "pkgconfig(gio-2.0)" \
    "pkgconfig(gio-unix-2.0)" \
    "pkgconfig(glib-2.0)" \
    "pkgconfig(gnome-desktop-3.0)" \
    "pkgconfig(goa-1.0)" \
    "pkgconfig(goa-backend-1.0)" \
    "pkgconfig(gstreamer-1.0)" \
    "pkgconfig(gtk+-3.0)" \
    "pkgconfig(gweather-3.0)" \
    "pkgconfig(libgeoclue-2.0)" \
    "pkgconfig(libnm)" \
    "pkgconfig(libnma)" \
    "pkgconfig(webkit2gtk-4.0)" \
    polkit-devel \
    rest-devel \
    && dnf clean all

RUN \
    git clone https://gitlab.freedesktop.org/pwithnall/malcontent.git /tmp/malcontent && \
    pushd /tmp/malcontent && \
    git checkout tags/0.6.0 && \
    meson setup --prefix /usr _build && \
    ninja -C _build install && \
    popd && \
    rm -r /tmp/malcontent

ARG HOST_USER_ID=5555
ENV HOST_USER_ID ${HOST_USER_ID}
RUN useradd -u $HOST_USER_ID -ms /bin/bash user

USER user
WORKDIR /home/user

ENV LANG C.utf8
ENV PATH="/usr/lib64/ccache:${PATH}"
