FROM python:3.11-slim

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HOME=/opt/hermes-home

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    ripgrep \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src

COPY upstream-hermes/ /src/

RUN python -m pip install --upgrade pip uv \
 && uv pip install --system ".[cli,pty,mcp,honcho]"

RUN useradd --create-home --home-dir /opt/hermes-home hermes \
 && mkdir -p /opt/hermes-home \
 && chown -R hermes:hermes /opt/hermes-home

WORKDIR /opt/hermes-home
USER hermes

EXPOSE 8642

CMD ["hermes", "gateway", "run"]
