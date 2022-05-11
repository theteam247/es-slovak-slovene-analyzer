FROM centos:7

ENV ES_VER=8.1.3
ENV ES_HOME_PREFIX=/home/es/app
ENV ES_HOME=$ES_HOME_PREFIX/elasticsearch-$ES_VER
ENV LEM_PREFIX=$ES_HOME/config/lemmagen

RUN yum install -y wget
RUN groupadd -r es && useradd -r -g es es
RUN mkdir -p $ES_HOME_PREFIX
RUN mkdir -p $LEM_PREFIX

RUN wget -P ./ https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VER-linux-x86_64.tar.gz --no-check-certificate
RUN tar -zxvf ./elasticsearch-$ES_VER-linux-x86_64.tar.gz -C $ES_HOME_PREFIX
RUN cd $ES_HOME && ./bin/elasticsearch-plugin install https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v$ES_VER/elasticsearch-analysis-lemmagen-$ES_VER-plugin.zip

RUN chown -R es:es $ES_HOME

USER es
WORKDIR $ES_HOME

ENTRYPOINT [ "./bin/elasticsearch", "-E", "xpack.security.enabled=false", "-E", "network.host=0.0.0.0", "-E", "node.name=${HOSTNAME}", "-E", "cluster.initial_master_nodes=${HOSTNAME}" ]




