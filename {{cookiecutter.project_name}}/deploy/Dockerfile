FROM python:3.7-slim-buster as python-base
ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1 \
    # pip:
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    # venv:
    VENV_PATH="/opt/.venv" \
    PATH="$PATH:/opt/.venv/bin"

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        build-essential \
        python3-dev \
        libpq-dev \
    # Cleaning cache:
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*


# We copy our Python requirements here to cache them
# and install only runtime deps using poetry
WORKDIR /opt/app
COPY ./deploy/requirements.txt ./requirements.txt
RUN python -m venv $VENV_PATH \
    && pip install --no-cache-dir -r requirements.txt \
    && useradd -d /opt/app -s /bin/bash user \
    && chown -R user:user /opt/app


FROM python-base as development

WORKDIR /opt/app
# Copying in our entrypoint
COPY ./deploy/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# venv already has runtime deps installed we get a quicker install
COPY ./deploy/requirements-dev.txt ./requirements-dev.txt
RUN pip install --no-cache-dir -r requirements-dev.txt

COPY ./setup.cfg ./
COPY app /opt/app

USER user

FROM python-base as production

WORKDIR /opt/app
COPY ./deploy/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
COPY . /opt/app

EXPOSE 8080
WORKDIR /opt/app
USER user
