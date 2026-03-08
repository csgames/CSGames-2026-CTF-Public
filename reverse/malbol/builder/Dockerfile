FROM ubuntu:24.04 AS builder

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        gnucobol \
        build-essential \
        libc-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean autoclean

WORKDIR /src

COPY malbol.cob .

RUN cobc -x -free malbol.cob -o malbol

# FROM scratch AS exporter
# 
# COPY --from=builder /src/malbol /malbol

ENTRYPOINT ["sleep", "infinity"]
