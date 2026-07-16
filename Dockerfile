FROM debian:bookworm

COPY company.list /etc/apt/sources.list.d/company.list

RUN apt update && \
    apt -y upgrade

RUN apt -y install nginx

RUN apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/www/*

RUN mkdir -p /var/www/company.com/img

COPY index.html /var/www/company.com/
COPY img.jpg /var/www/company.com/img/

RUN chmod -R 754 /var/www/company.com

RUN useradd -m evgeniy

RUN groupadd zaitsev

RUN usermod -aG zaitsev evgeniy

RUN chown -R evgeniy:zaitsev /var/www/company.com

RUN sed -i 's#/var/www/html#/var/www/company.com#g' \
    /etc/nginx/sites-enabled/default

RUN sed -i 's/user www-data;/user evgeniy;/g' \
    /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
