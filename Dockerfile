FROM ubuntu:22.04
WORKDIR /apps
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y libhdf5-dev vim python3 python3-pip unzip curl pkg-config libssl-dev libffi-dev supervisor && \
    apt-get install -y pandoc texlive-latex-base texlive-fonts-recommended texlive-extra-utils texlive-latex-extra texlive-xetex &&\
    apt-get install -y texlive-lang-chinese librsvg2-bin texlive-fonts-extra &&\
    apt-get install -y ttf-wqy-zenhei xfonts-wqy fonts-wqy-zenhei &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

ADD ./conf/service.conf /etc/supervisor/conf.d/service.conf
ADD ./requirements.in ./requirements.in

RUN pip install -r requirements.in

ADD ./latex ./latex
ADD ./server.py ./server.py

RUN pip install neverland-compiler
RUN neverland-compiler -i server.py -d dist -v 3 -c server.py &&\
   mv ./dist /tmp/dist &&\
   rm -rf /app/* &&\
   mv /tmp/dist/* /app/
   
CMD ["supervisord", "-n"]
