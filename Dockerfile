#
# Create Docker container for python forwarder to service now
#
FROM alpine:3.8
LABEL Author="Alexandre Vaussant avaussant@axway.com"

#
#Cppy app files
#
RUN mkdir /app_py3

WORKDIR /app_py3
ENV PYTHONPATH=/app_py3

#
#Instal python libs
#
RUN apk update && apk upgrade
RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache


RUN set -e; \
	apk add --no-cache --virtual .build-deps \
                        openssl \
                        bash \
                        gcc \
                        libc-dev \
                        linux-headers \
                        build-base \
                        curl \
                        zlib-dev \
                        build-base \
                        linux-headers \
                        pcre-dev \
                        python3-dev




#
#Change right
#
RUN chmod +x /app_py3
RUN addgroup -S app && adduser -S -G app app
RUN chown -R app:app /app_py3
USER app

#
# args for -e option
#

ENV PORT=${PORT}

#
# Port used to expose
#
EXPOSE ${PORT}

