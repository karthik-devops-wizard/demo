FROM centos:latest
RUN yum -y install httpd
COPY /home/ubunut/docker/mediawiki-1.34.2 /var/www/html/mediawiki
EXPOSE 80

# Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
