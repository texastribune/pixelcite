FROM texastribune/base
MAINTAINER tech@texastribune.org

RUN apt-get install nodejs nodejs-legacy npm -y

ADD requirements.txt /app/
WORKDIR /app
RUN pip install -r /app/requirements.txt

ADD package.json /app/
RUN npm install

ADD . /app/

# RUN apt-get install -yq zip
# RUN touch butts && zip -m data/copy.xlsx butts

EXPOSE 8000
CMD ["python", "public_app.py"]
