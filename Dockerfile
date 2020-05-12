ARG RUBY_VERSION=latest
FROM ruby:${RUBY_VERSION}

RUN apt update --assume-yes \
    && apt install --assume-yes \
    build-essential libsdl2-dev libgl1-mesa-dev libopenal-dev libsndfile-dev \
    libmpg123-dev libgmp-dev libfontconfig1-dev \
    xorg-dev xvfb imagemagick

ARG USER=dev
ARG HOME=/home/${USER}

RUN useradd --create-home --shell /bin/bash ${USER}
USER ${USER}:${USER}

WORKDIR ${HOME}/web-crisis

COPY --chown=${USER}:${USER} Gemfile Gemfile.lock ./
RUN bundle check || bundle install

COPY --chown=${USER}:${USER} . ./
