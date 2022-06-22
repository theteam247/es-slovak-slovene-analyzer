## Setup plugin in es cluster

### Steps

#### 1. Install lemmagen plugin

##### For elasticsearch version 7.2.0
```
cd /usr/share/elasticsearch

./bin/elasticsearch-plugin install https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v7.2.0/elasticsearch-analysis-lemmagen-7.2.0-plugin.zip
```
##### For elasticsearch version 6.2.0
```
cd /usr/share/elasticsearch

./bin/elasticsearch-plugin install https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v6.2.0/elasticsearch-analysis-lemmagen-6.2.0-plugin.zip
```

#### 2. Copy config file
```
cd /usr/share/elasticsearch/config
mkdir lemmagen
cd lemmagen
wget https://github.com/vhyza/lemmagen-lexicons/raw/master/free/lexicons/en.lem
wget https://github.com/vhyza/lemmagen-lexicons/raw/master/free/lexicons/sk.lem
wget https://github.com/vhyza/lemmagen-lexicons/raw/master/free/lexicons/sl.lem

cd /usr/share/elasticsearch/config
mkdir stop-words
cd stop-words
wget https://raw.githubusercontent.com/stopwords-iso/stopwords-sk/master/raw/stopwords_file.txt -O sk.txt
wget https://raw.githubusercontent.com/stopwords-iso/stopwords-sl/master/raw/gh-stopwords-json-sl.txt -O sl.txt

cd /usr/share/elasticsearch/config
mkdir synonyms
cd synonyms
wget https://raw.githubusercontent.com/SlovakNationalGallery/elasticsearch-slovencina/master/synonyms/sk_SK.txt -O sk.txt
```

#### 3. Restart elasticsearch
After plugin installation and elasticsearch restart you should see in logs something like:
```
[2022-06-07T17:46:09,038][INFO ][o.e.p.PluginsService] [1rZCAqs] loaded plugin [elasticsearch-analysis-lemmagen]
```
