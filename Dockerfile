FROM elasticsearch:8.1.3

RUN cd /usr/share/elasticsearch && ./bin/elasticsearch-plugin install https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v8.1.3/elasticsearch-analysis-lemmagen-8.1.3-plugin.zip
