FROM texastribune/supervisor
MAINTAINER tech@texastribune.org

RUN apt-get install nodejs nodejs-legacy npm -y

# --- BEGIN SNIP from WIP texastribune/gunicorn ---

# modified to work with this file structure

RUN apt-get -yq install nginx
# There's a known harmless warning generated here:
# See https://github.com/benoitc/gunicorn/issues/788
RUN pip install gunicorn==19.1.1

WORKDIR /app

RUN mkdir /app/run
ADD confs/gunicorn.py /app/
ADD confs/gunicorn.supervisor.conf /etc/supervisor/conf.d/

ADD confs/nginx.conf /app/
ADD confs/nginx.supervisor.conf /etc/supervisor/conf.d/

VOLUME ["/app/logs"]
EXPOSE 80

# --- END SNIP --

ADD . /app/

RUN pip install --quiet -r /app/requirements.txt
RUN npm install --quiet

RUN fab render
