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

#### 4. Add analyzer to an existing index

- Create Index without analyzer

```
curl --location --request PUT 'http://localhost:9200/lemmagen-sl' \
--header 'Content-Type: application/json' \
--data-raw '{
    "mappings": {
        "properties": {
            "text": {
                "type": "text"
            }
        }
    }
}'
```

- Close index
> After the index is closed, the index can no longer be read or written
```
curl --location --request POST 'http://localhost:9200/lemmagen-sl/_close' \
--header 'Content-Type: application/json' \
--data-raw ''
```
- Add analyzer and filter
```
curl --location --request PUT 'http://localhost:9200/lemmagen-sl/_settings' \
--header 'Content-Type: application/json' \
--data-raw '{
    "analysis": {
        "analyzer": {
            "sl_analyzer":{
               "type":"custom",
               "tokenizer":"uax_url_email",
               "filter":[
                  "lowercase",
                  "lemmagen_filter_sl"
               ]
            }
        },
        "filter": {
            "lemmagen_filter_sl": {
                "type": "lemmagen",
                "lexicon": "sl"
            }
        }
    }
}'
```
- Open index
```
curl --location --request POST 'http://localhost:9200/lemmagen-sl/_open' \
--header 'Content-Type: application/json' \
--data-raw ''
```
- Add new properties to index with analyzer
```
curl --location --request PUT 'http://localhost:9200/lemmagen-sl/_mapping' \
--header 'Content-Type: application/json' \
--data-raw '{
    "properties": {
        "new_text": {
            "type": "text",
            "analyzer": "sl_analyzer"
        }
    }
}'
```
- Put example doc
```
curl --location --request PUT 'http://localhost:9200/lemmagen-sl/_doc/1' \
--header 'Content-Type: application/json' \
--data-raw '{
    "new_text": "Vreme je DANES Res lEpO"
}'
```

- Search text
> sl_analyzer will decompose `Vreme je DANES Res lEpO` into `vreme`, `biti`, `danes`, `res`, `lepo`
```
curl --location --request GET 'http://localhost:9200/lemmagen-sl/_search' \
--header 'Content-Type: application/json' \
--data-raw '{
    "query": {
        "query_string": {
            "query": "biti"
        }
    }
}'
```