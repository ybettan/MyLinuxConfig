FROM fedora:latest

COPY / /MyLinuxConfig/

WORKDIR /MyLinuxConfig

ENTRYPOINT ["./setup.sh"]
