# Dockerfile
# Use to generate an Ubuntu container with full Minecraft Bedrock install

# Usage: docker build ubuntu_craft_server .

FROM ubuntu:lunar-20221216

RUN apt-get update && apt install curl wget unzip ufw grep openssl -y

# add user and group perms
RUN useradd -m mcserver \
  && mkdir -p /home/mcserver/minecraft_bedrock \
  && ufw allow 19132


# install MC Bedrock to user home dir
RUN wget $(curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -s -L -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" https://minecraft.net/en-us/download/server/bedrock/ |  grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*') -O /home/mcserver/minecraft_bedrock/bedrock-server.zip \
  && unzip /home/mcserver/minecraft_bedrock/bedrock-server.zip -d /home/mcserver/minecraft_bedrock/ \
  && rm /home/mcserver/minecraft_bedrock/bedrock-server.zip \
  && chown -R mcserver: /home/mcserver/

# start local minecraft server
WORKDIR /home/mcserver/minecraft_bedrock/
ENV LD_LIBRARY_PATH=.
ENTRYPOINT [ "./bedrock_server" ]