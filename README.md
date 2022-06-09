## es-slovak-slovene-analyzer

### Setup with docker
```
composer up
```

> Wait a few minutes until it is finished.

```
curl -X GET 'http://127.0.0.1:9200'
```

> Elasticsearch is ok if some json result return.

### Config file

#### Dictionary come from lemmagen-lexicons repository
> https://github.com/vhyza/lemmagen-lexicons/raw/master/free/lexicons


#### Stop word

- slovak stop word from:
> https://raw.githubusercontent.com/stopwords-iso/stopwords-sl/master/raw/gh-stopwords-json-sl.txt

- slovene stop word from:
> https://raw.githubusercontent.com/stopwords-iso/stopwords-sk/master/raw/stopwords_file.txt

#### synonyms

- slovak stop word from:
https://raw.githubusercontent.com/SlovakNationalGallery/elasticsearch-slovencina/master/synonyms/sk_SK.txt

### Download

Get the latest plugin release from the following address
> https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases

### Upgrade

1. remove old version
```
cd /usr/share/elasticsearch
./bin/elasticsearch-plugin remove elasticsearch-analysis-lemmagen
```

2. install new version
```
cd /usr/share/elasticsearch
./bin/elasticsearch-plugin install <new version url>
```