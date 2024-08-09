FROM ubuntu:22.04

ARG FLUTTER_VERSION

RUN apt-get clean &&\
  apt-get update &&\
  apt-get install -y build-essential bash curl wget file git unzip xz-utils zip libglu1-mesa cmake tar clang ninja-build pkg-config libgtk-3-dev make python3-pip python3-setuptools desktop-file-utils libgdk-pixbuf2.0-dev fakeroot strace fuse libunwind-dev locate patchelf gir1.2-appindicator3-0.1 libappindicator3-1 libappindicator3-dev libsecret-1-0 libjsoncpp25 libsecret-1-dev libjsoncpp-dev libnotify-bin libnotify-dev mpv libmpv-dev rpm libwebkit2gtk-4.1-0 libwebkit2gtk-4.1-dev libsoup-3.0-0 libsoup-3.0-dev libssl-dev && \
  rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/usr/local/rustup \
  CARGO_HOME=/usr/local/cargo \
  PATH=/usr/local/cargo/bin:$PATH

RUN mkdir -p $RUSTUP_HOME $CARGO_HOME && \
  chmod -R a+w $RUSTUP_HOME $CARGO_HOME

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y

WORKDIR /home/flutter

RUN git clone https://github.com/flutter/flutter.git -b ${FLUTTER_VERSION} --single-branch flutter-sdk

RUN flutter-sdk/bin/flutter precache

RUN flutter-sdk/bin/flutter config --no-analytics

ENV PATH="$PATH:/home/flutter/flutter-sdk/bin"
ENV PATH="$PATH:/home/flutter/flutter-sdk/bin/cache/dart-sdk/bin"
ENV PATH="$PATH:/home/flutter/.pub-cache/bin"
ENV PUB_CACHE="/home/flutter/.pub-cache"

RUN dart pub global activate flutter_distributor