FROM python:alpine AS build
RUN apk add --no-cache gcc make musl-dev linux-headers \
 && pip3 wheel --wheel-dir=/wheels motor sanic sanic_prometheus

FROM python:alpine
COPY --from=build /wheels /wheels
RUN pip3 install --no-index --find-links /wheels/*.whl && rm -Rfv /wheels
LABEL name="k-space/microservice-base" \
      version="rc" \
      maintainer="Lauri Võsandi <lauri@k-space.ee>"
