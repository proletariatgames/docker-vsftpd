FROM centos:7

ARG USER_ID=14
ARG GROUP_ID=50

LABEL maintainer="Fer Uria <fauria@gmail.com>"
LABEL description="vsftpd Docker image based on Centos 7. Supports passive mode and virtual users."
LABEL license="Apache License 2.0"
LABEL usage="docker run -d -p [HOST PORT NUMBER]:21 -v [HOST FTP HOME]:/home/vsftpd fauria/vsftpd"
LABEL version="1.0"

RUN yum -y update && yum clean all
RUN yum install -y \
	vsftpd \
	db4-utils \
	db4 && yum clean all

RUN usermod -u ${USER_ID} ftp
RUN groupmod -g ${GROUP_ID} ftp

ENV FTP_USER **String**
ENV FTP_PASS **Random**
ENV PASV_ADDRESS **IPv4**
ENV PASV_ADDR_RESOLVE NO
ENV PASV_ENABLE YES
ENV PASV_MIN_PORT 21100
ENV PASV_MAX_PORT 21110
ENV XFERLOG_STD_FORMAT NO
ENV LOG_STDOUT **Boolean**
ENV FILE_OPEN_MODE 0666
ENV LOCAL_UMASK 077

COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY run-vsftpd.sh /usr/sbin/

RUN chmod +x /usr/sbin/run-vsftpd.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/

VOLUME /home/vsftpd
VOLUME /var/log/vsftpd

EXPOSE 20 21

CMD ["/usr/sbin/run-vsftpd.sh"]
