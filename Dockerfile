FROM python:alpine AS build
RUN apk add --no-cache gcc make musl-dev linux-headers git \
 && pip3 wheel --wheel-dir=/wheels \
      git+https://github.com/Assarius/sanic-prometheus@Sanic_22 \
      kubernetes_asyncio \
      motor \
      pyjwt \
      pyyaml \
      sanic \
      velebit-useful-logs
FROM python:alpine
COPY --from=build /wheels /wheels
RUN pip3 install --no-index --find-links /wheels/*.whl && rm -Rfv /wheels
LABEL name="k-space/microservice-base" \
      version="rc" \
      maintainer="Lauri Võsandi <lauri@k-space.ee>"
