FROM python:3.12.3-slim

RUN apt-get update && apt-get install -y \
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

ENV PATH $PATH:/home/pythonuser/.pip/bin

RUN wget -O quarto.deb "https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.554/quarto-1.4.554-linux-amd64.deb" && \
    dpkg -i quarto.deb && \
    rm quarto.deb

USER pythonuser
RUN mkdir -p /home/pythonuser/.pip

WORKDIR /app

COPY . .

CMD ["bash"]
