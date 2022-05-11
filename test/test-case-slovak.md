curl -H "Content-Type: application/json" -X DELETE 'http://localhost:9200/lemmagen-analyzer-slovak'
## slovak analyzer 
## Create index with slovak tokenizer-whitespace
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
            "tokenizer": "whitespace",
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

## Try it using _analyze api
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_analyze?pretty' -d '{
  "text": "<p>ja tak <b>:)</b>!</p>Neils-Super-Duper, Líška rýchlo skoky nad lenivým psom, prosím Email mne pri john.smith@global-international.com ",
  "analyzer": "lemmagen_sk"
}'
```

response:
```
{
  "tokens" : [
    {
      "token" : "ja",
      "start_offset" : 3,
      "end_offset" : 5,
      "type" : "word",
      "position" : 0
    },
    {
      "token" : "tak",
      "start_offset" : 6,
      "end_offset" : 9,
      "type" : "word",
      "position" : 1
    },
    {
      "token" : "šťasný",
      "start_offset" : 13,
      "end_offset" : 20,
      "type" : "word",
      "position" : 2
    },
    {
      "token" : "neils",
      "start_offset" : 24,
      "end_offset" : 29,
      "type" : "word",
      "position" : 3
    },
    {
      "token" : "super",
      "start_offset" : 30,
      "end_offset" : 35,
      "type" : "word",
      "position" : 4
    },
    {
      "token" : "duper",
      "start_offset" : 36,
      "end_offset" : 41,
      "type" : "word",
      "position" : 5
    },
    {
      "token" : "líška",
      "start_offset" : 43,
      "end_offset" : 48,
      "type" : "word",
      "position" : 6
    },
    {
      "token" : "rýchlo",
      "start_offset" : 49,
      "end_offset" : 55,
      "type" : "word",
      "position" : 7
    },
    {
      "token" : "skok",
      "start_offset" : 56,
      "end_offset" : 61,
      "type" : "word",
      "position" : 8
    },
    {
      "token" : "nad",
      "start_offset" : 62,
      "end_offset" : 65,
      "type" : "word",
      "position" : 9
    },
    {
      "token" : "lenivý",
      "start_offset" : 66,
      "end_offset" : 73,
      "type" : "word",
      "position" : 10
    },
    {
      "token" : "psom",
      "start_offset" : 74,
      "end_offset" : 78,
      "type" : "word",
      "position" : 11
    },
    {
      "token" : "prosiť",
      "start_offset" : 80,
      "end_offset" : 86,
      "type" : "word",
      "position" : 12
    },
    {
      "token" : "email",
      "start_offset" : 87,
      "end_offset" : 92,
      "type" : "word",
      "position" : 13
    },
    {
      "token" : "ja",
      "start_offset" : 93,
      "end_offset" : 96,
      "type" : "word",
      "position" : 14
    },
    {
      "token" : "prieť",
      "start_offset" : 97,
      "end_offset" : 100,
      "type" : "word",
      "position" : 15
    },
    {
      "token" : "john",
      "start_offset" : 101,
      "end_offset" : 136,
      "type" : "word",
      "position" : 16
    },
    {
      "token" : "smith",
      "start_offset" : 101,
      "end_offset" : 136,
      "type" : "word",
      "position" : 17
    },
    {
      "token" : "global",
      "start_offset" : 101,
      "end_offset" : 136,
      "type" : "word",
      "position" : 18
    },
    {
      "token" : "international",
      "start_offset" : 101,
      "end_offset" : 136,
      "type" : "word",
      "position" : 19
    },
    {
      "token" : "ec",
      "start_offset" : 101,
      "end_offset" : 136,
      "type" : "word",
      "position" : 20
    }
  ]
}
```


## Index document
```
curl -H "Content-Type: application/json"  -X PUT 'http://localhost:9200/lemmagen-analyzer-slovak/_doc/1?refresh=wait_for' -d '{
    "user"         : "tester",
    "published_at" : "2022-05-11 12:12:12",
    "text"         : "<p>ja tak <b>:)</b>!</p>Neils-Super-Duper, Líška rýchlo skoky nad lenivým psom, prosím Email mne pri john.smith@global-international.com  "
}'
```
response:
```
{"_index":"lemmagen-analyzer-slovak","_id":"1","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}
```


## Search happy
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "šťasný"
    }
  }
}'
```
response:
```
{
  "took" : 37,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "lemmagen-analyzer-slovak",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>ja tak <b>:)</b>!</p>Neils-Super-Duper, Líška rýchlo skoky nad lenivým psom, prosím Email mne pri john.smith@global-international.com  "
        }
      }
    ]
  }
}
```



## Search super
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "super"
    }
  }
}'
```
response:
```
{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "lemmagen-analyzer-slovak",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>ja tak <b>:)</b>!</p>Neils-Super-Duper, Líška rýchlo skoky nad lenivým psom, prosím Email mne pri john.smith@global-international.com  "
        }
      }
    ]
  }
}
```



## Search quick
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "rýchly"
    }
  }
}'
```
response:
```
{
  "took" : 6,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 0,
      "relation" : "eq"
    },
    "max_score" : null,
    "hits" : [ ]
  }
}
```

## Search quickly
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "rýchlo"
    }
  }
}'
```
response:
```
{
  "took" : 10,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "lemmagen-analyzer-slovak",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>ja tak <b>:)</b>!</p>Neils-Super-Duper, Líška rýchlo skoky nad lenivým psom, prosím Email mne pri john.smith@global-international.com  "
        }
      }
    ]
  }
}
```

## Search jump
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "skok"
    }
  }
}'
```
response:
```
{
  "took" : 32,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "lemmagen-analyzer-slovak",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>ja tak <b>:)</b>!</p>Neils-Super-Duper, Líška rýchlo skoky nad lenivým psom, prosím Email mne pri john.smith@global-international.com  "
        }
      }
    ]
  }
}
```

## Search jumps
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "skoky"
    }
  }
}'
```
response:
```
{
  "took" : 12,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "lemmagen-analyzer-slovak",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>ja tak <b>:)</b>!</p>Neils-Super-Duper, Líška rýchlo skoky nad lenivým psom, prosím Email mne pri john.smith@global-international.com  "
        }
      }
    ]
  }
}
```

## Search john.smith@global-international.com
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovak/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "john.smith@global-international.com"
    }
  }
}'
```
response:
```
{
  "took" : 45,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 1.4384104,
    "hits" : [
      {
        "_index" : "lemmagen-analyzer-slovak",
        "_id" : "1",
        "_score" : 1.4384104,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>ja tak <b>:)</b>!</p>Neils-Super-Duper, Líška rýchlo skoky nad lenivým psom, prosím Email mne pri john.smith@global-international.com  "
        }
      }
    ]
  }
}
```

