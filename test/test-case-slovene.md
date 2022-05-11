curl -H "Content-Type: application/json" -X DELETE 'http://localhost:9200/lemmagen-analyzer-slovene'
## slovene analyzer 
## Create index with slovene tokenizer-whitespace
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
            "tokenizer": "whitespace",
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

## Try it using _analyze api
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_analyze?pretty' -d '{
  "text": "<p>jaz tako <b>:)</b>!</p> Neils-Super-Duper, a lisica hitro skoki nad lenobnim psom, prosim E-pošta mene pri john.smith@global-international.com ",
  "analyzer": "lemmagen_sl"
}'
```

response:
```
{
  "tokens" : [
    {
      "token" : "jaz",
      "start_offset" : 3,
      "end_offset" : 6,
      "type" : "word",
      "position" : 0
    },
    {
      "token" : "tak",
      "start_offset" : 7,
      "end_offset" : 11,
      "type" : "word",
      "position" : 1
    },
    {
      "token" : "srečen",
      "start_offset" : 15,
      "end_offset" : 22,
      "type" : "word",
      "position" : 2
    },
    {
      "token" : "neils",
      "start_offset" : 27,
      "end_offset" : 32,
      "type" : "word",
      "position" : 3
    },
    {
      "token" : "super",
      "start_offset" : 33,
      "end_offset" : 38,
      "type" : "word",
      "position" : 4
    },
    {
      "token" : "duper",
      "start_offset" : 39,
      "end_offset" : 44,
      "type" : "word",
      "position" : 5
    },
    {
      "token" : "lisica",
      "start_offset" : 48,
      "end_offset" : 54,
      "type" : "word",
      "position" : 7
    },
    {
      "token" : "hit",
      "start_offset" : 55,
      "end_offset" : 60,
      "type" : "word",
      "position" : 8
    },
    {
      "token" : "skok",
      "start_offset" : 61,
      "end_offset" : 66,
      "type" : "word",
      "position" : 9
    },
    {
      "token" : "nad",
      "start_offset" : 67,
      "end_offset" : 70,
      "type" : "word",
      "position" : 10
    },
    {
      "token" : "lenoben",
      "start_offset" : 71,
      "end_offset" : 79,
      "type" : "word",
      "position" : 11
    },
    {
      "token" : "psom",
      "start_offset" : 80,
      "end_offset" : 84,
      "type" : "word",
      "position" : 12
    },
    {
      "token" : "prositi",
      "start_offset" : 86,
      "end_offset" : 92,
      "type" : "word",
      "position" : 13
    },
    {
      "token" : "e",
      "start_offset" : 93,
      "end_offset" : 94,
      "type" : "word",
      "position" : 14
    },
    {
      "token" : "pošta",
      "start_offset" : 95,
      "end_offset" : 100,
      "type" : "word",
      "position" : 15
    },
    {
      "token" : "mena",
      "start_offset" : 101,
      "end_offset" : 105,
      "type" : "word",
      "position" : 16
    },
    {
      "token" : "pri",
      "start_offset" : 106,
      "end_offset" : 109,
      "type" : "word",
      "position" : 17
    },
    {
      "token" : "john",
      "start_offset" : 110,
      "end_offset" : 114,
      "type" : "word",
      "position" : 18
    },
    {
      "token" : "smith",
      "start_offset" : 115,
      "end_offset" : 120,
      "type" : "word",
      "position" : 19
    },
    {
      "token" : "global",
      "start_offset" : 121,
      "end_offset" : 127,
      "type" : "word",
      "position" : 20
    },
    {
      "token" : "international",
      "start_offset" : 128,
      "end_offset" : 141,
      "type" : "word",
      "position" : 21
    },
    {
      "token" : "com",
      "start_offset" : 142,
      "end_offset" : 145,
      "type" : "word",
      "position" : 22
    }
  ]
}
```


## Index document
```
curl -H "Content-Type: application/json"  -X PUT 'http://localhost:9200/lemmagen-analyzer-slovene/_doc/1?refresh=wait_for' -d '{
    "user"         : "tester",
    "published_at" : "2022-05-11 12:12:12",
    "text"         : "<p>jaz tako <b>:)</b>!</p> Neils-Super-Duper, a lisica hitro skoki nad lenobnim psom, prosim E-pošta mene pri john.smith@global-international.com "
}'
```
response:
```
{"_index":"lemmagen-analyzer-slovene","_id":"1","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}
```

## Search happy
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "srečen"
    }
  }
}'
```
response:
```
{
  "took" : 3,
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
        "_index" : "lemmagen-analyzer-slovene",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>jaz tako <b>:)</b>!</p> Neils-Super-Duper, a lisica hitro skoki nad lenobnim psom, prosim E-pošta mene pri john.smith@global-international.com "
        }
      }
    ]
  }
}
```



## Search super
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_search?pretty' -d '{
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
        "_index" : "lemmagen-analyzer-slovene",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>jaz tako <b>:)</b>!</p> Neils-Super-Duper, a lisica hitro skoki nad lenobnim psom, prosim E-pošta mene pri john.smith@global-international.com "
        }
      }
    ]
  }
}
```



## Search quick
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "hitro"
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
        "_index" : "lemmagen-analyzer-slovene",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>jaz tako <b>:)</b>!</p> Neils-Super-Duper, a lisica hitro skoki nad lenobnim psom, prosim E-pošta mene pri john.smith@global-international.com "
        }
      }
    ]
  }
}
```


## Search quickly
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "hitro"
    }
  }
}'
```
response:
```
{
  "took" : 7,
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
        "_index" : "lemmagen-analyzer-slovene",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>jaz tako <b>:)</b>!</p> Neils-Super-Duper, a lisica hitro skoki nad lenobnim psom, prosim E-pošta mene pri john.smith@global-international.com "
        }
      }
    ]
  }
}
```


## Search jump
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_search?pretty' -d '{
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
        "_index" : "lemmagen-analyzer-slovene",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>jaz tako <b>:)</b>!</p> Neils-Super-Duper, a lisica hitro skoki nad lenobnim psom, prosim E-pošta mene pri john.smith@global-international.com "
        }
      }
    ]
  }
}
```


## Search jumps
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "skoki"
    }
  }
}'
```
response:
```
{
  "took" : 74,
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
        "_index" : "lemmagen-analyzer-slovene",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>jaz tako <b>:)</b>!</p> Neils-Super-Duper, a lisica hitro skoki nad lenobnim psom, prosim E-pošta mene pri john.smith@global-international.com "
        }
      }
    ]
  }
}
```

## Search john.smith@global-international.com
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-slovene/_search?pretty' -d '{
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
  "took" : 40,
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
        "_index" : "lemmagen-analyzer-slovene",
        "_id" : "1",
        "_score" : 1.4384104,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>jaz tako <b>:)</b>!</p> Neils-Super-Duper, a lisica hitro skoki nad lenobnim psom, prosim E-pošta mene pri john.smith@global-international.com "
        }
      }
    ]
  }
}
```































