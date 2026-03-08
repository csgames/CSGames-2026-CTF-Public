FROM ubuntu:24.04

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        libc6               \
        libcob4             \
        libgmp10            \
        libncursesw6        \
        libtinfo6           \
        libdb5.3            \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean autoclean \
    && rm -rf /var/cache/apt/archives/*

WORKDIR /app

COPY flag.txt /root/flag.txt
COPY malbol ./malbol

RUN chmod +x ./malbol

CMD ["sleep", "infinity"]
