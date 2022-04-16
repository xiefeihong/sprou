FROM alpine:latest
LABEL maintainer "Xray Community <dev@xray.org>"

ENV TZ=Asia/Shanghai
WORKDIR /root
COPY xray_install.sh /root
COPY xray_run.sh /root

RUN set -ex \
	&& apk add --no-cache tzdata ca-certificates openssl socat curl \
	&& mkdir -p /etc/xray /usr/local/share/xray /var/log/xray \
	&& chmod +x /root/xray_install.sh /root/xray_run.sh \
	&& /root/xray_install.sh

VOLUME /etc/xray
CMD /root/xray_run.sh