#Servidor MineTest Game
FROM ubuntu:17.04
MAINTAINER Eduardo de Godoy Ferrari <eduardo___ferrari@outlook.com>


RUN apt-get update && apt-get install -y \
	git \
	wget \
	build-essential \ 
	libirrlicht-dev \
	cmake \
	libbz2-dev \
	libpng-dev \
	libjpeg-dev \
	libxxf86vm-dev \ 
	libgl1-mesa-dev \
	libsqlite3-dev \
	libogg-dev \
	libvorbis-dev \ 
	libopenal-dev \
	libcurl4-gnutls-dev \ 
	libfreetype6-dev \
    zlib1g-dev \
    libgmp-dev \
	libjsoncpp-dev \
	libpq-dev \
    postgresql-client \
    postgresql-server-dev-9.6 \
  	&& rm -rf /var/lib/apt/lists/*
    
RUN mkdir /tmp/minetest \
    && cd /tmp/minetest \ 
    && wget https://github.com/minetest/minetest/archive/master.tar.gz \
    && tar xf master.tar.gz \
    && cd minetest-master \
    && cd games \
    && wget https://github.com/minetest/minetest_game/archive/master.tar.gz \
    && tar xf master.tar.gz \
    && mv minetest_game-master minetest_game  \
    && cd .. \
	&& cmake . \ 
	-DBUILD_CLIENT=FALSE \
	-DBUILD_SERVER=TRUE \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCUSTOM_BINDIR=/usr/bin \
	-DCUSTOM_DOCDIR="/usr/share/doc/minetest" \
	-DCUSTOM_SHAREDIR="/usr/share/minetest" \
	-DENABLE_POSTGRESQL=TRUE \
	-DENABLE_GETTEXT=TRUE \
	-DRUN_IN_PLACE=FALSE \
	&& make -j 10 \
    && make install \
    && make clean \
	&& rm -r /tmp/minetest/

RUN mkdir -p /root/.minetest/worlds/mundo

COPY minetest.conf /root/.minetest/
COPY world.mt /root/.minetest/worlds/mundo

RUN cd /usr/share/minetest/games/minetest_game/mods \
	&& git clone  https://github.com/Sokomine/cottages.git \
	&& git clone  https://github.com/minetest-mods/awards.git \
	&& git clone  https://github.com/minetest-mods/biome_lib.git \
	&& git clone  https://github.com/minetest-mods/moretrees.git \
	&& git clone  https://github.com/minetest-mods/lightning.git \
	&& git clone  https://github.com/minetest-mods/hopper.git \
	&& git clone  https://github.com/minetest-mods/interact.git \
	&& git clone  https://github.com/stujones11/minetest-3d_armor.git \
	&& git clone  https://github.com/minetest-mods/edit.git \
	&& git clone  https://github.com/minetest-mods/mydeck.git\
	&& git clone  https://github.com/minetest-mods/coloured_nametag.git \
	&& git clone  https://github.com/minetest-mods/currency.git \
	&& git clone  https://github.com/ShadowNinja/areas.git \
	&& git clone  https://github.com/minetest-mods/xban2.git \
	&& git clone  https://github.com/cornernote/minetest-craft_guide.git \
	&& git clone  https://github.com/jordan4ibanez/item_drop.git\
	&& git clone  https://github.com/Neuromancer56/MinetestAmbience.git \
	&& git clone  https://github.com/BlockMen/hunger.git \
	&& git clone  https://github.com/BlockMen/hud.git \
	&& git clone  https://github.com/Jeija/minetest-mod-weather.git \
	&& git clone  https://github.com/tenplus1/mobs_redo.git \
	&& git clone  https://github.com/tenplus1/mobs_animal.git \
	&& git clone  https://github.com/tenplus1/mobs_monster.git \
	&& git clone  https://github.com/tenplus1/mobs_npc.git \
	&& git clone  https://github.com/tenplus1/mob_horse.git \
	&& git clone  https://github.com/minetest-mods/mob-engine.git
	#&& git clone  https://github.com/tenplus1/farming.git



EXPOSE 30080:30080/udp

ENTRYPOINT ["/bin/bash", "-c", "minetestserver"]
