FROM node:14.15.0@sha256:a2397f3a30c8631d761b6e7d13af5a1107b2222b7d0ec2f515640674a44a09fd

# Env vars
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV E2E_EXECUTABLE_PATH=google-chrome-stable

# Install Chrome and dependencies
RUN  apt-get update \
  && apt-get install -y wget gnupg ca-certificates procps libxss1 \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y google-chrome-stable \
  && rm -rf /var/lib/apt/lists/* \
  && wget --quiet https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/sbin/wait-for-it.sh \
  && chmod +x /usr/sbin/wait-for-it.sh

WORKDIR /home/pptruser/app
COPY ["index.js", "package.json", "yarn.lock", "./"]

# Add user so we don't need --no-sandbox.
# Needs --cap-add=SYS_ADMIN Docker flag (https://docs.docker.com/engine/reference/run/#additional-groups)
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser
RUN mkdir -p /home/pptruser/Downloads \
  && chown -R pptruser:pptruser /home/pptruser

# Run everything after as non-privileged user.
USER pptruser

RUN yarn

CMD ["node", "index.js"]