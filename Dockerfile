FROM fedora:latest

COPY / /MyLinuxConfig/

WORKDIR /MyLinuxConfig

RUN dnf -y install make

ENTRYPOINT ["make"]
