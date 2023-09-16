FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y jq
RUN apt-get install -y curl
RUN apt-get install -y gh
COPY assets/check assets/in assets/out /opt/resource/
RUN chmod +x /opt/resource/*