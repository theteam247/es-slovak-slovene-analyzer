curl -H "Content-Type: application/json" -X DELETE 'http://localhost:9200/lemmagen-analyzer-english'
## english analyzer 
## Create index with english tokenizer-whitespace
```
curl -H "Content-Type: application/json" -X PUT 'http://localhost:9200/lemmagen-analyzer-english' -d '
{"settings": {
    "index": {
      "analysis": {
        "filter": {
          "lemmagen_filter_en": {
            "type": "lemmagen",
            "lexicon": "en"
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
        },
        "analyzer": {
          "lemmagen_en": {
            "type": "custom",
            "tokenizer": "whitespace",
            "filter": [
              "lemmagen_filter_en",
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
        "analyzer": "lemmagen_en"
      }
    }
  }
}'
```
response:
```
{"acknowledged":true,"shards_acknowledged":true,"index":"lemmagen-analyzer-english"}
```

## Try it using _analyze api
```
curl -H "Content-Type: application/json"  -X GET 'http://localhost:9200/lemmagen-analyzer-english/_analyze?pretty' -d '{
  "text": "<p>I&apos;m so <b>:)</b>!</p> Neil''s-Super-Duper, a fox quickly jumps over the lazy dog, pls Email   me at john.smith@global-international.com ",
  "analyzer": "lemmagen_en"
}'
```

response:
```
{
  "tokens" : [
    {
      "token" : "i",
      "start_offset" : 3,
      "end_offset" : 11,
      "type" : "word",
      "position" : 0
    },
    {
      "token" : "m",
      "start_offset" : 3,
      "end_offset" : 11,
      "type" : "word",
      "position" : 1
    },
    {
      "token" : "so",
      "start_offset" : 12,
      "end_offset" : 14,
      "type" : "word",
      "position" : 2
    },
    {
      "token" : "happy",
      "start_offset" : 18,
      "end_offset" : 25,
      "type" : "word",
      "position" : 3
    },
    {
      "token" : "neils",
      "start_offset" : 30,
      "end_offset" : 35,
      "type" : "word",
      "position" : 4
    },
    {
      "token" : "super",
      "start_offset" : 36,
      "end_offset" : 41,
      "type" : "word",
      "position" : 5
    },
    {
      "token" : "duper",
      "start_offset" : 42,
      "end_offset" : 47,
      "type" : "word",
      "position" : 6
    },
    {
      "token" : "fox",
      "start_offset" : 51,
      "end_offset" : 54,
      "type" : "word",
      "position" : 8
    },
    {
      "token" : "quick",
      "start_offset" : 55,
      "end_offset" : 62,
      "type" : "word",
      "position" : 9
    },
    {
      "token" : "jump",
      "start_offset" : 63,
      "end_offset" : 68,
      "type" : "word",
      "position" : 10
    },
    {
      "token" : "over",
      "start_offset" : 69,
      "end_offset" : 73,
      "type" : "word",
      "position" : 11
    },
    {
      "token" : "lazy",
      "start_offset" : 78,
      "end_offset" : 82,
      "type" : "word",
      "position" : 13
    },
    {
      "token" : "dog",
      "start_offset" : 83,
      "end_offset" : 86,
      "type" : "word",
      "position" : 14
    },
    {
      "token" : "pl",
      "start_offset" : 88,
      "end_offset" : 91,
      "type" : "word",
      "position" : 15
    },
    {
      "token" : "email",
      "start_offset" : 92,
      "end_offset" : 97,
      "type" : "word",
      "position" : 16
    },
    {
      "token" : "me",
      "start_offset" : 100,
      "end_offset" : 102,
      "type" : "word",
      "position" : 17
    },
    {
      "token" : "john",
      "start_offset" : 106,
      "end_offset" : 110,
      "type" : "word",
      "position" : 19
    },
    {
      "token" : "smith",
      "start_offset" : 111,
      "end_offset" : 116,
      "type" : "word",
      "position" : 20
    },
    {
      "token" : "global",
      "start_offset" : 117,
      "end_offset" : 123,
      "type" : "word",
      "position" : 21
    },
    {
      "token" : "international",
      "start_offset" : 124,
      "end_offset" : 137,
      "type" : "word",
      "position" : 22
    },
    {
      "token" : "com",
      "start_offset" : 138,
      "end_offset" : 141,
      "type" : "word",
      "position" : 23
    }
  ]
}
```


## Index document
```
curl -H "Content-Type: application/json"  -X PUT 'http://localhost:9200/lemmagen-analyzer-english/_doc/1?refresh=wait_for' -d '{
    "user"         : "tester",
    "published_at" : "2022-05-11 12:12:12",
    "text"         : "<p>I&apos;m so <b>:)</b>!</p> Neil''s-Super-Duper, a fox quickly jumps over the lazy dog, pls Email   me at john.smith@global-international.com "
}'
```
response:
```
{"_index":"lemmagen-analyzer-english","_id":"1","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}
```

## Search happy
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-english/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "happy"
    }
  }
}'
```
response:
```
{
  "took" : 46,
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
        "_index" : "lemmagen-analyzer-english",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>I&apos;m so <b>:)</b>!</p> Neils-Super-Duper, a fox quickly jumps over the lazy dog, pls Email   me at john.smith@global-international.com "
        }
      }
    ]
  }
}
```



## Search super
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-english/_search?pretty' -d '{
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
        "_index" : "lemmagen-analyzer-english",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>I&apos;m so <b>:)</b>!</p> Neils-Super-Duper, a fox quickly jumps over the lazy dog, pls Email   me at john.smith@global-international.com "
        }
      }
    ]
  }
}
```



## Search quick
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-english/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "quick"
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
        "_index" : "lemmagen-analyzer-english",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>I&apos;m so <b>:)</b>!</p> Neils-Super-Duper, a fox quickly jumps over the lazy dog, pls Email   me at john.smith@global-international.com "
        }
      }
    ]
  }
}
```


## Search quickly
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-english/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "quickly"
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
        "_index" : "lemmagen-analyzer-english",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>I&apos;m so <b>:)</b>!</p> Neils-Super-Duper, a fox quickly jumps over the lazy dog, pls Email   me at john.smith@global-international.com "
        }
      }
    ]
  }
}
```


## Search jump
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-english/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "jump"
    }
  }
}'
```
response:
```
{
  "took" : 54,
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
        "_index" : "lemmagen-analyzer-english",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>I&apos;m so <b>:)</b>!</p> Neils-Super-Duper, a fox quickly jumps over the lazy dog, pls Email   me at john.smith@global-international.com "
        }
      }
    ]
  }
}
```


## Search jumps
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-english/_search?pretty' -d '{
  "query" : {
    "match" : {
      "text" : "jumps"
    }
  }
}'
```
response:
```
{
  "took" : 15,
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
        "_index" : "lemmagen-analyzer-english",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>I&apos;m so <b>:)</b>!</p> Neils-Super-Duper, a fox quickly jumps over the lazy dog, pls Email   me at john.smith@global-international.com "
        }
      }
    ]
  }
}
```

## Search john.smith@global-international.com
```
curl -H "Content-Type: application/json" -X GET 'http://localhost:9200/lemmagen-analyzer-english/_search?pretty' -d '{
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
  "took" : 23,
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
        "_index" : "lemmagen-analyzer-english",
        "_id" : "1",
        "_score" : 1.4384104,
        "_source" : {
          "user" : "tester",
          "published_at" : "2022-05-11 12:12:12",
          "text" : "<p>I&apos;m so <b>:)</b>!</p> Neils-Super-Duper, a fox quickly jumps over the lazy dog, pls Email   me at john.smith@global-international.com "
        }
      }
    ]
  }
}
```































