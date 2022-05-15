[toc]
# Lemmagen analyzer test case



## Instalation
### Lemmagen-analyzer-slovak + Lemmagen-analyzer-slovene
elasticsearch8.1.3 + Lemmagen (https://github.com/vhyza/elasticsearch-analysis-lemmagen/tree/v8.1.3)

### Slovak-extra-analyzer + Slovene-synonym-analyzer
elasticsearch7.10.2 
org.wikimedia.search:extra:7.10.2-wmf1 
extra-analysis-slovak:7.10.2-wmf1 (https://github.com/vhyza/elasticsearch-analysis-lemmagen/tree/v8.1.3)
elasticsearch-slovencina (https://github.com/SlovakNationalGallery/elasticsearch-slovencina)




## Create analyzer

### Create es-buildin-analyzer
```
curl -H "Content-Type: application/json" -X PUT 'http://localhost:9200/es-buildin-analyzer' -d '
{"settings": {
    "index": {
      "analysis": {
        "analyzer": {
          "es_buildin_analyzer": {
            "tokenizer": "uax_url_email",
            "filter": [
              "trim",
              "lowercase",
              "kstem",
              "stop",
              "word_delimiter_graph"
            ],
            "char_filter": [
              "html_strip",
              "myCharFilterMap"
            ]
          }
        },
        "char_filter": {
          "myCharFilterMap": {
            "type": "mapping",
            "mappings": [
              ":) => _happy_",
              ":( => _sad_"
            ]
          }
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "text": {
        "type": "text",
        "analyzer": "es_buildin_analyzer"
      }
    }
  }
}'
```
response:
```
{"acknowledged":true,"shards_acknowledged":true,"index":"es-buildin-analyzer"}
```


### Create lemmagen-analyzer-slovak
```
curl -H "Content-Type: application/json" -X PUT 'http://localhost:9200/lemmagen-analyzer-slovak' -d '
{"settings": {
    "index": {
      "analysis": {
        "filter": {
          "lemmagen_filter_sk": {
            "type": "lemmagen",
            "lexicon": "sk"
          }
        },
        "char_filter": {
          "myCharFilterMap": {
            "type": "mapping",
            "mappings": [
              ":) => _šťasný_",
              ":( => _smutný_"
            ]
          }
        },
        "analyzer": {
          "lemmagen_sk": {
            "type": "custom",
            "tokenizer": "uax_url_email",
            "filter": [
              "lemmagen_filter_sk",
              "trim",
              "lowercase",
              "kstem",
              "stop",
              "word_delimiter_graph"
            ],
            "char_filter": [
              "html_strip",
              "myCharFilterMap"
            ]
          }
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "text": {
        "type": "text",
        "analyzer": "lemmagen_sk"
      }
    }
  }
}'
```
response:
```
{"acknowledged":true,"shards_acknowledged":true,"index":"lemmagen-analyzer-slovak"}
```


### Create Slovak-extra-analyzer
```
curl -H "Content-Type: application/json" -X PUT 'http://localhost:9200/slovak-extra-analyzer' -d '
{"settings": {
    "index": {
      "analysis": {
        "filter": {
          "skstemmer": {
            "type": "slovak_stemmer"
          }
        },
        "char_filter": {
          "myCharFilterMap": {
            "type": "mapping",
            "mappings": [
              ":) => _šťasný_",
              ":( => _smutný_"
            ]
          }
        },
        "analyzer": {
          "slovak_extra_analyzer": {
            "type": "custom",
            "tokenizer": "uax_url_email",
            "filter": [
              "skstemmer",
              "trim",
              "lowercase",
              "stop",
              "word_delimiter_graph"
            ],
            "char_filter": [
              "html_strip",
              "myCharFilterMap"
            ]
          }
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "text": {
        "type": "text",
        "analyzer": "slovak_extra_analyzer"
      }
    }
  }
}'
```
response:
```
{"acknowledged":true,"shards_acknowledged":true,"index":"slovak-extra-analyzer"}
```



### Create lemmagen-analyzer-slovene
```
curl -H "Content-Type: application/json" -X PUT 'http://localhost:9200/lemmagen-analyzer-slovene' -d '
{"settings": {
    "index": {
      "analysis": {
        "filter": {
          "lemmagen_filter_sl": {
            "type": "lemmagen",
            "lexicon": "sl"
          }
        },
        "char_filter": {
          "myCharFilterMap": {
            "type": "mapping",
            "mappings": [
              ":) => _srečen_",
              ":( => _žalostno_"
            ]
          }
        },
        "analyzer": {
          "lemmagen_sl": {
            "type": "custom",
            "tokenizer": "uax_url_email",
            "filter": [
              "lemmagen_filter_sl",
              "trim",
              "lowercase",
              "kstem",
              "stop",
              "word_delimiter_graph"
            ],
            "char_filter": [
              "html_strip",
              "myCharFilterMap"
            ]
          }
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "text": {
        "type": "text",
        "analyzer": "lemmagen_sl"
      }
    }
  }
}'
```
response:
```
{"acknowledged":true,"shards_acknowledged":true,"index":"lemmagen-analyzer-slovene"}
```


### Create Slovene-synonym
```
curl -H "Content-Type: application/json" -X PUT 'http://localhost:9200/slovencina-synonym' -d '
{
  "settings": {
    "analysis": {
      "filter": {
        "lemmagen_filter_sk": {
          "type": "lemmagen",
          "lexicon": "sk"
        },
        "sk_SK" : {
          "type" : "hunspell",
          "locale" : "sk_SK",
          "dedup" : true,
          "recursion_level" : 0
        },
        "synonym_filter": {
          "type": "synonym",
          "synonyms_path": "synonyms/sk_SK.txt",
          "ignore_case": true
        },
        "stopwords_SK": {
          "type": "stop",
          "stopwords_path": "stop-words/stop-words-slovak.txt",
          "ignore_case": true
        }
      },
      "char_filter": {
        "myCharFilterMap": {
            "type": "mapping",
            "mappings": [
              ":) => _srečen_",
              ":( => _žalostno_"
            ]
        }
      },
      "analyzer": {
        "slovencina_synonym": {
          "type": "custom",
          "tokenizer": "uax_url_email",
          "filter": [
            "trim",
            "stopwords_SK",
            "lemmagen_filter_sk",
            "lowercase",
            "stopwords_SK",
            "synonym_filter",
            "asciifolding",
            "word_delimiter_graph"
          ],
          "char_filter": [
            "html_strip",
            "myCharFilterMap"
          ]
        }
      }
    }
  }
}'
```
response:
```
{"acknowledged":true,"shards_acknowledged":true,"index":"slovencina-synonym"}
```


## uax_url_email tokenizer
** support by Lemmagen analyzer for slovak and slovene**

### English-”john.smith@global-international.com”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/es-buildin-analyzer/_analyze?pretty' -d '{
  "text": "Email me at john.smith@global-international.com",
  "analyzer": "es_buildin_analyzer"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "email",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "me",
      "start_offset" : 6,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "john",
      "start_offset" : 12,
      "end_offset" : 16,
      "type" : "<EMAIL>",
      "position" : 3
    },
    {
      "token" : "smith",
      "start_offset" : 17,
      "end_offset" : 22,
      "type" : "<EMAIL>",
      "position" : 4
    },
    {
      "token" : "global",
      "start_offset" : 23,
      "end_offset" : 29,
      "type" : "<EMAIL>",
      "position" : 5
    },
    {
      "token" : "international",
      "start_offset" : 30,
      "end_offset" : 43,
      "type" : "<EMAIL>",
      "position" : 6
    },
    {
      "token" : "com",
      "start_offset" : 44,
      "end_offset" : 47,
      "type" : "<EMAIL>",
      "position" : 7
    }
  ]
}
```


### Slovak-lemmagen-”john.smith@global-international.com”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "Napíšte mi na john.smith@global-international.com",
  "analyzer": "lemmagen_sk"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "napísať",
      "start_offset" : 0,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "ja",
      "start_offset" : 8,
      "end_offset" : 10,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "na",
      "start_offset" : 11,
      "end_offset" : 13,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "john",
      "start_offset" : 14,
      "end_offset" : 49,
      "type" : "<EMAIL>",
      "position" : 3
    },
    {
      "token" : "smith",
      "start_offset" : 14,
      "end_offset" : 49,
      "type" : "<EMAIL>",
      "position" : 4
    },
    {
      "token" : "global",
      "start_offset" : 14,
      "end_offset" : 49,
      "type" : "<EMAIL>",
      "position" : 5
    },
    {
      "token" : "international",
      "start_offset" : 14,
      "end_offset" : 49,
      "type" : "<EMAIL>",
      "position" : 6
    },
    {
      "token" : "ec",
      "start_offset" : 14,
      "end_offset" : 49,
      "type" : "<EMAIL>",
      "position" : 7
    }
  ]
}
```

### Slovak-extra-analyzer-”john.smith@global-international.com”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovak-extra-analyzer/_analyze?pretty' -d '{
  "text": "Napíšte mi na john.smith@global-international.com",
  "analyzer": "slovak_extra_analyzer"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "napísk",
      "start_offset" : 0,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "mi",
      "start_offset" : 8,
      "end_offset" : 10,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "na",
      "start_offset" : 11,
      "end_offset" : 13,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "john",
      "start_offset" : 14,
      "end_offset" : 49,
      "type" : "<EMAIL>",
      "position" : 3
    },
    {
      "token" : "smith",
      "start_offset" : 14,
      "end_offset" : 49,
      "type" : "<EMAIL>",
      "position" : 4
    },
    {
      "token" : "global",
      "start_offset" : 14,
      "end_offset" : 49,
      "type" : "<EMAIL>",
      "position" : 5
    },
    {
      "token" : "international",
      "start_offset" : 14,
      "end_offset" : 49,
      "type" : "<EMAIL>",
      "position" : 6
    },
    {
      "token" : "c",
      "start_offset" : 14,
      "end_offset" : 49,
      "type" : "<EMAIL>",
      "position" : 7
    }
  ]
}
```



### Slovene-lemmagen-”john.smith@global-international.com”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "Pošljite mi e-pošto na john.smith@global-international.com",
  "analyzer": "lemmagen_sl"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "poslati",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "jaz",
      "start_offset" : 9,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "e",
      "start_offset" : 12,
      "end_offset" : 13,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "pošta",
      "start_offset" : 14,
      "end_offset" : 19,
      "type" : "<ALPHANUM>",
      "position" : 3
    },
    {
      "token" : "na",
      "start_offset" : 20,
      "end_offset" : 22,
      "type" : "<ALPHANUM>",
      "position" : 4
    },
    {
      "token" : "john",
      "start_offset" : 23,
      "end_offset" : 27,
      "type" : "<EMAIL>",
      "position" : 5
    },
    {
      "token" : "smith",
      "start_offset" : 28,
      "end_offset" : 33,
      "type" : "<EMAIL>",
      "position" : 6
    },
    {
      "token" : "global",
      "start_offset" : 34,
      "end_offset" : 40,
      "type" : "<EMAIL>",
      "position" : 7
    },
    {
      "token" : "international",
      "start_offset" : 41,
      "end_offset" : 54,
      "type" : "<EMAIL>",
      "position" : 8
    },
    {
      "token" : "com",
      "start_offset" : 55,
      "end_offset" : 58,
      "type" : "<EMAIL>",
      "position" : 9
    }
  ]
}
```


### Slovene-synonym-”john.smith@global-international.com”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovencina-synonym/_analyze?pretty' -d '{
  "text": "Pošljite mi e-pošto na john.smith@global-international.com",
  "analyzer": "slovencina_synonym"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "posljit",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "e",
      "start_offset" : 12,
      "end_offset" : 13,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "posto",
      "start_offset" : 14,
      "end_offset" : 19,
      "type" : "<ALPHANUM>",
      "position" : 3
    },
    {
      "token" : "john",
      "start_offset" : 23,
      "end_offset" : 58,
      "type" : "<EMAIL>",
      "position" : 5
    },
    {
      "token" : "smith",
      "start_offset" : 23,
      "end_offset" : 58,
      "type" : "<EMAIL>",
      "position" : 6
    },
    {
      "token" : "global",
      "start_offset" : 23,
      "end_offset" : 58,
      "type" : "<EMAIL>",
      "position" : 7
    },
    {
      "token" : "international",
      "start_offset" : 23,
      "end_offset" : 58,
      "type" : "<EMAIL>",
      "position" : 8
    },
    {
      "token" : "ec",
      "start_offset" : 23,
      "end_offset" : 58,
      "type" : "<EMAIL>",
      "position" : 9
    }
  ]
}
```


## Tokenfilter-lowercase
** not support by Lemmagen analyzer for slovak **
** and slovene not case sensitive **
### English-”fox Quick Jump”

```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/es-buildin-analyzer/_analyze?pretty' -d '{
  "text": "fox Quick Jump ",
  "analyzer": "es_buildin_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "fox",
      "start_offset" : 0,
      "end_offset" : 3,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "quick",
      "start_offset" : 4,
      "end_offset" : 9,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "jump",
      "start_offset" : 10,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


### Slovak-lemmagen-”fox Quick Jump”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "líška Rýchly skok",
  "analyzer": "lemmagen_sk"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "líška",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "rýchly",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skok",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


### Slovak-lemmagen-”fox quick jump”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "líška rýchly skok",
  "analyzer": "lemmagen_sk"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "líška",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "rýchly",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skok",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```



### Slovak-extra-analyzer-”fox Quick Jump”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovak-extra-analyzer/_analyze?pretty' -d '{
  "text": "líška Rýchly skok",
  "analyzer": "slovak_extra_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "líšk",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "rýchl",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skok",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


### Slovak-extra-analyzer-”fox quick jump”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovak-extra-analyzer/_analyze?pretty' -d '{
  "text": "líška rýchly skok",
  "analyzer": "slovak_extra_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "líšk",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "rýchl",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skok",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```

### Slovene-lemmagen-”fox Quick Jump”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "lisica hitri skok",
  "analyzer": "lemmagen_sl"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "lisica",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "hit",
      "start_offset" : 7,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skok",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


### Slovene-lemmagen-”fox quick jump”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "lisica hitri skok",
  "analyzer": "lemmagen_sl"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "lisica",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "hit",
      "start_offset" : 7,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skok",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```



### Slovene-synonym-”fox Quick Jump”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovencina-synonym/_analyze?pretty' -d '{
  "text": "lisica hitri skok",
  "analyzer": "slovencina_synonym"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "lisica",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "hiter",
      "start_offset" : 7,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skok",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "vypad",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "SYNONYM",
      "position" : 2
    }
  ]
}
```

### Slovene-synonym-”fox quick jump”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovencina-synonym/_analyze?pretty' -d '{
  "text": "lisica hitri skok",
  "analyzer": "slovencina_synonym"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "lisica",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "hiter",
      "start_offset" : 7,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skok",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "vypad",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "SYNONYM",
      "position" : 2
    }
  ]
}
```





## Tokenfilter-strip
** support by Lemmagen analyzer for slovak/slovene **
### English-”      fox      ”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/es-buildin-analyzer/_analyze?pretty' -d '{
  "text": "      fox      ",
  "analyzer": "es_buildin_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "fox",
      "start_offset" : 6,
      "end_offset" : 9,
      "type" : "<ALPHANUM>",
      "position" : 0
    }
  ]
}
```


### Slovak-lemmagen-”      fox      ”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "      líška      ",
  "analyzer": "lemmagen_sk"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "líška",
      "start_offset" : 6,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 0
    }
  ]
}
```



### Slovak-extra-analyzer-”      fox      ”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovak-extra-analyzer/_analyze?pretty' -d '{
  "text": "      líška      ",
  "analyzer": "slovak_extra_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "líšk",
      "start_offset" : 6,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 0
    }
  ]
}
```


### Slovene-lemmagen-”      fox      ”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "      lisica      ",
  "analyzer": "lemmagen_sl"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "lisica",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 0
    }
  ]
}
```


### slovene-synonym”      fox      ”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovencina-synonym/_analyze?pretty' -d '{
  "text": "      lisica      ",
  "analyzer": "slovencina_synonym"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "lisica",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 0
    }
  ]
}
```


## Tokenfilter-stop
** support by Lemmagen analyzer for slovak/slovene **
### English-"a bird fly to the hometown"
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/es-buildin-analyzer/_analyze?pretty' -d '{
  "text": "a bird fly to the hometown",
  "analyzer": "es_buildin_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "bird",
      "start_offset" : 2,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "fly",
      "start_offset" : 7,
      "end_offset" : 10,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "hometown",
      "start_offset" : 18,
      "end_offset" : 26,
      "type" : "<ALPHANUM>",
      "position" : 5
    }
  ]
}
```


### Slovak-lemmagen-"a bird fly to the hometown"
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "vtáčik priletí do rodného mesta",
  "analyzer": "lemmagen_sk"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "vtáčik",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "priletieť",
      "start_offset" : 7,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "dobrý",
      "start_offset" : 15,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "rodný",
      "start_offset" : 18,
      "end_offset" : 25,
      "type" : "<ALPHANUM>",
      "position" : 3
    },
    {
      "token" : "mesto",
      "start_offset" : 26,
      "end_offset" : 31,
      "type" : "<ALPHANUM>",
      "position" : 4
    }
  ]
}
```



### Slovak-extra-analyzer-"a bird fly to the hometown"
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovak-extra-analyzer/_analyze?pretty' -d '{
  "text": "vtáčik priletí do rodného mesta",
  "analyzer": "slovak_extra_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "vtáčik",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "prilet",
      "start_offset" : 7,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "do",
      "start_offset" : 15,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "rodn",
      "start_offset" : 18,
      "end_offset" : 25,
      "type" : "<ALPHANUM>",
      "position" : 3
    },
    {
      "token" : "mest",
      "start_offset" : 26,
      "end_offset" : 31,
      "type" : "<ALPHANUM>",
      "position" : 4
    }
  ]
}
```



### Slovene-lemmagen-"a bird fly to the hometown"
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "ptica poleti v domači kraj",
  "analyzer": "lemmagen_sl"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "ptica",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "poleti",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "v",
      "start_offset" : 13,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "domač",
      "start_offset" : 15,
      "end_offset" : 21,
      "type" : "<ALPHANUM>",
      "position" : 3
    },
    {
      "token" : "kraj",
      "start_offset" : 22,
      "end_offset" : 26,
      "type" : "<ALPHANUM>",
      "position" : 4
    }
  ]
}
```


### Slovene-synonym-"a bird fly to the hometown"
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovencina-synonym/_analyze?pretty' -d '{
  "text": "ptica poleti v domači kraj",
  "analyzer": "slovencina_synonym"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "ptica",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "let",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "domac",
      "start_offset" : 15,
      "end_offset" : 21,
      "type" : "<ALPHANUM>",
      "position" : 3
    },
    {
      "token" : "kraj",
      "start_offset" : 22,
      "end_offset" : 26,
      "type" : "<ALPHANUM>",
      "position" : 4
    },
    {
      "token" : "lem",
      "start_offset" : 22,
      "end_offset" : 26,
      "type" : "SYNONYM",
      "position" : 4
    },
    {
      "token" : "obruba",
      "start_offset" : 22,
      "end_offset" : 26,
      "type" : "SYNONYM",
      "position" : 4
    },
    {
      "token" : "okraj",
      "start_offset" : 22,
      "end_offset" : 26,
      "type" : "SYNONYM",
      "position" : 4
    },
    {
      "token" : "oblast",
      "start_offset" : 22,
      "end_offset" : 26,
      "type" : "SYNONYM",
      "position" : 4
    }
  ]
}
```



## Tokenfilter-word_delimiter_graph
** support by Lemmagen analyzer for slovak/slovene **
### English-”super-computer-xl500”

```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/es-buildin-analyzer/_analyze?pretty' -d '{
  "text": "super-computer-xl500",
  "analyzer": "es_buildin_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "super",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "computer",
      "start_offset" : 6,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "xl",
      "start_offset" : 15,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "500",
      "start_offset" : 17,
      "end_offset" : 20,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```




### Slovak-lemmagen-”super-computer-xl500”
```super-computer-xl500
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "skvelé-počítač-xl500",
  "analyzer": "lemmagen_sk"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "skvelý",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "počítač",
      "start_offset" : 7,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "xl",
      "start_offset" : 15,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "500",
      "start_offset" : 17,
      "end_offset" : 20,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```


### Slovak-extra-analyzer-”super-computer-xl500”
```super-computer-xl500
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovak-extra-analyzer/_analyze?pretty' -d '{
  "text": "skvelé-počítač-xl500",
  "analyzer": "slovak_extra_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "skvel",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "počítač",
      "start_offset" : 7,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "xl",
      "start_offset" : 15,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "500",
      "start_offset" : 17,
      "end_offset" : 20,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```

### Slovene-lemmagen-”super-computer-xl500”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "super-računalnik-xl500",
  "analyzer": "lemmagen_sl"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "super",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "računalnik",
      "start_offset" : 6,
      "end_offset" : 16,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "xl",
      "start_offset" : 17,
      "end_offset" : 19,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "500",
      "start_offset" : 19,
      "end_offset" : 22,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```



### slovene-synonym”super-computer-xl500”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovencina-synonym/_analyze?pretty' -d '{
  "text": "super-računalnik-xl500",
  "analyzer": "slovencina_synonym"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "super",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "dobre",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "SYNONYM",
      "position" : 0
    },
    {
      "token" : "spravny",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "SYNONYM",
      "position" : 0
    },
    {
      "token" : "extra",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "SYNONYM",
      "position" : 0
    },
    {
      "token" : "senzacny",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "SYNONYM",
      "position" : 0
    },
    {
      "token" : "vynikajuci",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "SYNONYM",
      "position" : 0
    },
    {
      "token" : "racunalnik",
      "start_offset" : 6,
      "end_offset" : 16,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "xl",
      "start_offset" : 17,
      "end_offset" : 19,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "500",
      "start_offset" : 19,
      "end_offset" : 22,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```


## Tokenfilter-stemmer
** not support by Lemmagen analyzer for slovak/slovene **
### English-”the foxes jumping quickly”

```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/es-buildin-analyzer/_analyze?pretty' -d '{
  "text": "the foxes jumping quickly",
  "analyzer": "es_buildin_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "fox",
      "start_offset" : 4,
      "end_offset" : 9,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "jump",
      "start_offset" : 10,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "quick",
      "start_offset" : 18,
      "end_offset" : 25,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```


### Slovak-lemmagen-”the foxes jumping quickly”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "líšky rýchlo skáču",
  "analyzer": "lemmagen_sk"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "líška",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "rýchlo",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skákať",
      "start_offset" : 13,
      "end_offset" : 18,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```



### Slovak-lemmagen-”the fox jump quick”

```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "líška rýchlo skočí",
  "analyzer": "lemmagen_sk"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "líška",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "rýchlo",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skočiť",
      "start_offset" : 13,
      "end_offset" : 18,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```



### Slovak-extra-analyzer-”the foxes jumping quickly”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovak-extra-analyzer/_analyze?pretty' -d '{
  "text": "líšky rýchlo skáču",
  "analyzer": "slovak_extra_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "líšk",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "rýchl",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skáču",
      "start_offset" : 13,
      "end_offset" : 18,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


### Slovak-extra-analyzer-”the fox jump quick”

```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovak-extra-analyzer/_analyze?pretty' -d '{
  "text": "líška rýchlo skočí",
  "analyzer": "slovak_extra_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "líšk",
      "start_offset" : 0,
      "end_offset" : 5,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "rýchl",
      "start_offset" : 6,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skoč",
      "start_offset" : 13,
      "end_offset" : 18,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


### Slovene-lemmagen-”the foxes jumping quickly”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "lisice hitro skačejo",
  "analyzer": "lemmagen_sl"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "lisica",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "hit",
      "start_offset" : 7,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skači",
      "start_offset" : 13,
      "end_offset" : 20,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```



### Slovene-lemmagen-”the fox jump quick”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "lisica hitro skoči",
  "analyzer": "lemmagen_sl"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "lisica",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "hit",
      "start_offset" : 7,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skočiti",
      "start_offset" : 13,
      "end_offset" : 18,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


### Slovene-synonym-”the foxes jumping quickly”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovencina-synonym/_analyze?pretty' -d '{
  "text": "lisice hitro skačejo",
  "analyzer": "slovencina_synonym"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "lisica",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "hitro",
      "start_offset" : 7,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skacejo",
      "start_offset" : 13,
      "end_offset" : 20,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```

### Slovene-synonym-”the fox jump quick”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovencina-synonym/_analyze?pretty' -d '{
  "text": "lisica hitro skoči",
  "analyzer": "slovencina_synonym"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "lisica",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "hitro",
      "start_offset" : 7,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "skoc",
      "start_offset" : 13,
      "end_offset" : 18,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```



## Charfilter-html_strip
** support by Lemmagen analyzer for slovak/slovene **
### English-"<p>I am so <b>happy</b>!</p>"

```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/es-buildin-analyzer/_analyze?pretty' -d '{
  "text": "<p>I am so <b>happy</b>!</p>",
  "analyzer": "es_buildin_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "i",
      "start_offset" : 3,
      "end_offset" : 4,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "am",
      "start_offset" : 5,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "so",
      "start_offset" : 8,
      "end_offset" : 10,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "happy",
      "start_offset" : 14,
      "end_offset" : 23,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```


### Slovak-lemmagen-"<p>I am so <b>happy</b>!</p>"
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "<p>Som taký <b>šťastný</b>!</p>",
  "analyzer": "lemmagen_sk"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "sý",
      "start_offset" : 3,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "taký",
      "start_offset" : 7,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "šťastný",
      "start_offset" : 15,
      "end_offset" : 26,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


### Slovak-extra-analyzer-"<p>I am so <b>happy</b>!</p>"
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovak-extra-analyzer/_analyze?pretty' -d '{
  "text": "<p>Som taký <b>šťastný</b>!</p>",
  "analyzer": "slovak_extra_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "som",
      "start_offset" : 3,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "tak",
      "start_offset" : 7,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "šťastn",
      "start_offset" : 15,
      "end_offset" : 26,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


### Slovene-lemmagen-"<p>I am so <b>happy</b>!</p>"
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "<p>Tako sem <b>srečna</b>!</p>",
  "analyzer": "lemmagen_sl"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "tak",
      "start_offset" : 3,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "sem",
      "start_offset" : 8,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "srečen",
      "start_offset" : 15,
      "end_offset" : 25,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


### Slovene-synonym-"<p>I am so <b>happy</b>!</p>"
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovencina-synonym/_analyze?pretty' -d '{
  "text": "<p>Tako sem <b>srečna</b>!</p>",
  "analyzer": "slovencina_synonym"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "tako",
      "start_offset" : 3,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "sem",
      "start_offset" : 8,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "srecny",
      "start_offset" : 15,
      "end_offset" : 25,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
```


## Charfilter-mapping
** support by Lemmagen analyzer for slovak/slovene **
### English-”I am so :)”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/es-buildin-analyzer/_analyze?pretty' -d '{
  "text": "I am so :)",
  "analyzer": "es_buildin_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "i",
      "start_offset" : 0,
      "end_offset" : 1,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "am",
      "start_offset" : 2,
      "end_offset" : 4,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "so",
      "start_offset" : 5,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "happy",
      "start_offset" : 8,
      "end_offset" : 10,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```


### Slovak-lemmagen-”I am so :)”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "Ja som taký :)",
  "analyzer": "lemmagen_sk"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "ja",
      "start_offset" : 0,
      "end_offset" : 2,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "byť",
      "start_offset" : 3,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "taký",
      "start_offset" : 7,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "šťasný",
      "start_offset" : 12,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```


### Slovak-extra-analyzer-”I am so :)”
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovak-extra-analyzer/_analyze?pretty' -d '{
  "text": "Ja som taký :)",
  "analyzer": "slovak_extra_analyzer"
}'
```
response
```
{
  "tokens" : [
    {
      "token" : "ja",
      "start_offset" : 0,
      "end_offset" : 2,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "som",
      "start_offset" : 3,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "tak",
      "start_offset" : 7,
      "end_offset" : 11,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "šťasný",
      "start_offset" : 12,
      "end_offset" : 14,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```

### Slovene-lemmagen-”I am so :)”

```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "Jaz sem tako :)",
  "analyzer": "lemmagen_sl"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "jaz",
      "start_offset" : 0,
      "end_offset" : 3,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "sem",
      "start_offset" : 4,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "tak",
      "start_offset" : 8,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "srečen",
      "start_offset" : 13,
      "end_offset" : 15,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```



### slovene-synonym-”I am so :)”

```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/slovencina-synonym/_analyze?pretty' -d '{
  "text": "Jaz sem tako :)",
  "analyzer": "slovencina_synonym"
}'
```
response:
```
{
  "tokens" : [
    {
      "token" : "jaz",
      "start_offset" : 0,
      "end_offset" : 3,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "sem",
      "start_offset" : 4,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "tako",
      "start_offset" : 8,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 2
    },
    {
      "token" : "srecen",
      "start_offset" : 13,
      "end_offset" : 15,
      "type" : "<ALPHANUM>",
      "position" : 3
    }
  ]
}
```
























