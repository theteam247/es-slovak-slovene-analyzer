FROM centos:7
RUN yum install -y wget
RUN groupadd -r es && useradd -r -g es es
RUN mkdir -p /home/es/app
ENV ES_VER=8.1.3
ENV ES_HOME_PREFIX=/home/es/app
ENV ES_HOME=$ES_HOME_PREFIX/elasticsearch-$ES_VER
RUN wget -P ./ https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VER-linux-x86_64.tar.gz --no-check-certificate
RUN tar -zxvf ./elasticsearch-$ES_VER-linux-x86_64.tar.gz -C $ES_HOME_PREFIX
RUN chown -R es:es $ES_HOME
RUN cd $ES_HOME && ./bin/elasticsearch-plugin install https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v$ES_VER/elasticsearch-analysis-lemmagen-$ES_VER-plugin.zip
ENV LEM_PREFIX=$ES_HOME/config/lemmagen
RUN mkdir -p $LEM_PREFIX
RUN wget -P $LEM_PREFIX https://github.com/vhyza/lemmagen-lexicons/blob/master/free/lexicons/sk.lem --no-check-certificate && wget -P $LEM_PREFIX https://github.com/vhyza/lemmagen-lexicons/blob/master/free/lexicons/sl.lem --no-check-certificate

USER es
WORKDIR $ES_HOME
ENTRYPOINT [ "./bin/elasticsearch" ]





























