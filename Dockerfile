FROM asciidoctor/docker-asciidoctor:latest

USER root

# Tools needed for the build
RUN apk add --no-cache zip rsync git openjdk17-jre wget unzip vale

# Install hunspell + English GB dictionaries for Vale
RUN apk add --no-cache hunspell hunspell-en

# Install write-good Vale grammar rules inside the container
RUN mkdir -p /opt/vale/styles \
  && curl -sL https://github.com/errata-ai/write-good/releases/latest/download/write-good.zip \
     -o /tmp/write-good.zip \
  && unzip /tmp/write-good.zip -d /opt/vale/styles \
  && rm /tmp/write-good.zip

# Install epubcheck 4.2.6
RUN wget -O /tmp/epubcheck.zip https://github.com/w3c/epubcheck/releases/download/v4.2.6/epubcheck-4.2.6.zip \
    && unzip /tmp/epubcheck.zip -d /opt \
    && mv /opt/epubcheck-4.2.6 /opt/epubcheck \
    && rm /tmp/epubcheck.zip

# Add wrapper script
RUN printf '#!/bin/sh\nexec java -jar /opt/epubcheck/epubcheck.jar "$@"\n' \
      > /usr/local/bin/epubcheck \
    && chmod +x /usr/local/bin/epubcheck

# Install Node.js + npm on Alpine
RUN apk add --no-cache nodejs npm

# Copy package.json for QR code generator
COPY package.json package-lock.json* /workspace/

# Install node dependencies
RUN cd /workspace && npm install
