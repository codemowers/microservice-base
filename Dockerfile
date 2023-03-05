FROM python:alpine AS build
RUN apk add --no-cache gcc make musl-dev linux-headers libressl-dev libffi-dev git \
 && pip3 wheel --wheel-dir=/wheels \
      aiofile \
      cryptography \
      flask \
      git+https://github.com/laurivosandi/sanic-prometheus \
      kubernetes \
      kubernetes_asyncio \
      motor \
      prometheus-async \
      prometheus-flask-exporter \
      pyjwt \
      pyyaml \
      sanic \
      sanic-ext \
      sanic-wtf \
      ecs-logging

# Work around buggy setup.py in caio
RUN git clone https://github.com/mosquito/caio/ \
  && cd caio \
  && python3 setup.py bdist_wheel \
  && rm /wheels/*caio*.whl \
  && cp dist/*.whl /wheels/

# Generate image without build dependencies
FROM python:alpine
COPY --from=build /wheels /wheels
RUN pip3 install --no-index /wheels/*.whl && rm -Rfv /wheels
LABEL name="k-space/microservice-base" \
      version="rc" \
      maintainer="Lauri Võsandi <lauri@k-space.ee>"
ENV PYTHONUNBUFFERED=1
ENV CAIO_IMPL=linux
