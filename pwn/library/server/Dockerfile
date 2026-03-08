FROM alpine:latest
RUN apk add --no-cache socat

WORKDIR /opt/csgames
COPY library library
RUN chmod +x library

EXPOSE 12345
ENV PORT=12345

USER root
CMD socat TCP-LISTEN:${PORT},reuseaddr,fork EXEC:/opt/csgames/library,pty,rawer,stderr
