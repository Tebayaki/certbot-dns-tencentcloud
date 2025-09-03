FROM python:3.10-alpine

ENV TZ=Asia/Shanghai
ENV PYTHONUNBUFFERED=1
ENV GOSU_VERSION=1.17

WORKDIR /app

COPY app /app

RUN set -eux; \
	\
	apk add --no-cache --virtual .gosu-deps \
		ca-certificates \
		dpkg \
		gnupg \
	; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
# clean up fetch dependencies
	apk del --no-network .gosu-deps; \
	\
	chmod +x /usr/local/bin/gosu; \
# verify that the binary works
	gosu --version; \
	gosu nobody true; \
	\
	apk add --no-cache shadow; \
	pip install --no-cache-dir --upgrade pip; \
	pip install --no-cache-dir -r requirements.txt; \
	pip uninstall -y pip setuptools wheel; \
	rm requirements.txt; \
	rm -rf /root/.cache/pip; \
	\
	adduser -D user1; \
	mkdir -p /data; \
	chown -R user1:user1 /app /data; \
	chmod +x /app/entrypoint.sh

CMD ["python", "main.py"]

ENTRYPOINT [ "/app/entrypoint.sh" ]