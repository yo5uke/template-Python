FROM python:3.12.3-slim

RUN apt update && apt install -y \
    locales \
    openssh-client \
    wget \
    git \
    bash \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i '$d' /etc/locale.gen \
    && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN useradd -m -s /bin/bash pythonuser

ENV PATH $PATH:/home/pythonuser/.cache/pip/bin

ENV QUARTO_MINOR_VERSION=1.5
ENV QUARTO_PATCH_VERSION=45

RUN wget -O quarto.deb https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_MINOR_VERSION}.${QUARTO_PATCH_VERSION}/quarto-${QUARTO_MINOR_VERSION}.${QUARTO_PATCH_VERSION}-linux-amd64.deb && \
    dpkg -i quarto.deb && \
    rm quarto.deb

USER pythonuser
RUN mkdir -p /home/pythonuser/.cache

WORKDIR /app

COPY . .

CMD ["bash"]
