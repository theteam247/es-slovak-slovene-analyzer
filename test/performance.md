# Lemmagen analyzer permformance test

## Definition

### Tokenizer
> A tokenizer receives a stream of characters, breaks it up into individual tokens (usually individual words), and outputs a stream of tokens.

### Filter
> Token filters accept a stream of tokens from a tokenizer and can modify tokens (eg lowercasing), delete tokens (eg remove stopwords) or add tokens (eg synonyms).

### Analyzer
> Consists of a tokenizer and multiple filters

## Description

We take the analysis results of English text by the built-in tokenizer as the standard, Compare the analysis results of slovak/slovene by lemmagen analyzer and evaluate the performance of lemmagen analyzer

## List of tokenizers and filters for testing

### Tokenizers

1. Standard Tokenizer
> The standard tokenizer divides text into terms on word boundaries, as defined by the Unicode Text Segmentation algorithm. It removes most punctuation symbols. It is the best choice for most languages.

2. UAX URL Email Tokenizer
> The uax_url_email tokenizer is like the standard tokenizer except that it recognises URLs and email addresses as single tokens.

### Filters
1. Lowercase
> Changes token text to lowercase. For example, you can use the lowercase filter to change THE Lazy DoG to the lazy dog.
2. Uppercase
> Changes token text to uppercase. For example, you can use the uppercase filter to change the Lazy DoG to THE LAZY DOG.
3. Stop
> Removes stop words from a token stream.
4. Trim
> Removes leading and trailing whitespace from each token in a stream.
5. Kstem
> Provides KStem-based stemming
6. Word delimiter graph
> Splits tokens at non-alphanumeric characters. For example: Super-Duper → Super, Duper

## Create slovak and slovene based filters

1. Create filter for slovak
```bash
curl --location --request PUT 'https://localhost:9200/lemmagen-sk' \
--header 'Content-Type: application/json' \
--data-raw '{
  "settings": {
    "index": {
      "analysis": {
        "filter": {
          "lemmagen_filter_sk": {
            "type": "lemmagen",
            "lexicon": "sk"
          }
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "text": {
        "type": "text"
      }
    }
  }
}'
```
2. Create filter for slovene
```bash
curl --location --request PUT 'https://localhost:9200/lemmagen-sl' \
--header 'Content-Type: application/json' \
--data-raw '{
  "settings": {
    "index": {
      "analysis": {
        "filter": {
          "lemmagen_filter_sl": {
            "type": "lemmagen",
            "lexicon": "sl"
          }
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "text": {
        "type": "text"
      }
    }
  }
}'
```

## Test Cases
- UAX URL Email Tokenizer

1. English

Request:
```bash
curl --location --request POST 'https://localhost:9200/_analyze' \
--header 'Content-Type: application/json' \
--data-raw '{
  "tokenizer": "uax_url_email",
  "text": "Email me at john.smith@global-international.com"
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "Email",
            "start_offset": 0,
            "end_offset": 5,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "me",
            "start_offset": 6,
            "end_offset": 8,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "at",
            "start_offset": 9,
            "end_offset": 11,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "john.smith@global-international.com",
            "start_offset": 12,
            "end_offset": 47,
            "type": "<EMAIL>",
            "position": 3
        }
    ]
}
```

2. slovak
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sk/_analyze' \
--data-raw '{
  "tokenizer": "uax_url_email",
      "filter": [
        "lemmagen_filter_sk"
    ],
  "text": "Napíšte mi na john.smith@global-international.com"
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "Napísať",
            "start_offset": 0,
            "end_offset": 7,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "ja",
            "start_offset": 8,
            "end_offset": 10,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "na",
            "start_offset": 11,
            "end_offset": 13,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "john.smith@global-international.ec",
            "start_offset": 14,
            "end_offset": 49,
            "type": "<EMAIL>",
            "position": 3
        }
    ]
}
```
3. slovene
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sl/_analyze' \
--data-raw '{
  "tokenizer": "uax_url_email",
      "filter": [
        "lemmagen_filter_sl"
    ],
  "text": "Pošljite mi e-pošto na john.smith@global-international.com"
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "Poslati",
            "start_offset": 0,
            "end_offset": 8,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "jaz",
            "start_offset": 9,
            "end_offset": 11,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "e",
            "start_offset": 12,
            "end_offset": 13,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "pošta",
            "start_offset": 14,
            "end_offset": 19,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "na",
            "start_offset": 20,
            "end_offset": 22,
            "type": "<ALPHANUM>",
            "position": 4
        },
        {
            "token": "john.smith@global-international.com",
            "start_offset": 23,
            "end_offset": 58,
            "type": "<EMAIL>",
            "position": 5
        }
    ]
}
```

- Lowercase
1. English
Request:
```bash
curl --location --request POST 'https://localhost:9200/_analyze' \
--data-raw '{
  "tokenizer" : "standard",
  "filter" : ["lowercase"],
  "text" : "the Quick FoX JUMPs"
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "the",
            "start_offset": 0,
            "end_offset": 3,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "quick",
            "start_offset": 4,
            "end_offset": 9,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "fox",
            "start_offset": 10,
            "end_offset": 13,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "jumps",
            "start_offset": 14,
            "end_offset": 19,
            "type": "<ALPHANUM>",
            "position": 3
        }
    ]
}
```
2. slovak
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sk/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sk",
        "lowercase"
    ],
  "text": "Počasie JE dNes nAOZAj pekné"
}
'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "počasie",
            "start_offset": 0,
            "end_offset": 7,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "je",
            "start_offset": 8,
            "end_offset": 10,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "dnes",
            "start_offset": 11,
            "end_offset": 15,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "naozať",
            "start_offset": 16,
            "end_offset": 22,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "pekný",
            "start_offset": 23,
            "end_offset": 28,
            "type": "<ALPHANUM>",
            "position": 4
        }
    ]
}
```
3. slovene
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sl/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sl",
        "lowercase"
    ],
  "text": "Vreme je DANES res lEpO"
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "vreme",
            "start_offset": 0,
            "end_offset": 5,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "biti",
            "start_offset": 6,
            "end_offset": 8,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "danes",
            "start_offset": 9,
            "end_offset": 14,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "res",
            "start_offset": 15,
            "end_offset": 18,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "lepo",
            "start_offset": 19,
            "end_offset": 23,
            "type": "<ALPHANUM>",
            "position": 4
        }
    ]
}
```
- Uppercase
1. English
Request:
```bash
curl --location --request POST 'https://localhost:9200/_analyze' \
--data-raw '{
  "tokenizer" : "standard",
  "filter" : ["uppercase"],
  "text" : "the Quick FoX JUMPs"
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "THE",
            "start_offset": 0,
            "end_offset": 3,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "QUICK",
            "start_offset": 4,
            "end_offset": 9,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "FOX",
            "start_offset": 10,
            "end_offset": 13,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "JUMPS",
            "start_offset": 14,
            "end_offset": 19,
            "type": "<ALPHANUM>",
            "position": 3
        }
    ]
}
```
2. slovak
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sk/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sk",
        "uppercase"
    ],
  "text": "Počasie JE dNes nAOZAj pekné"
}
'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "POČASIE",
            "start_offset": 0,
            "end_offset": 7,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "JE",
            "start_offset": 8,
            "end_offset": 10,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "DNES",
            "start_offset": 11,
            "end_offset": 15,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "NAOZAŤ",
            "start_offset": 16,
            "end_offset": 22,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "PEKNÝ",
            "start_offset": 23,
            "end_offset": 28,
            "type": "<ALPHANUM>",
            "position": 4
        }
    ]
}
```
3. slovene
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sl/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sl",
        "uppercase"
    ],
  "text": "Vreme je DANES res lEpO"
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "VREME",
            "start_offset": 0,
            "end_offset": 5,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "BITI",
            "start_offset": 6,
            "end_offset": 8,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "DANES",
            "start_offset": 9,
            "end_offset": 14,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "RES",
            "start_offset": 15,
            "end_offset": 18,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "LEPO",
            "start_offset": 19,
            "end_offset": 23,
            "type": "<ALPHANUM>",
            "position": 4
        }
    ]
}
```
- Stop
1. English
Request:
```bash
curl --location --request POST 'https://localhost:9200/_analyze' \
--data-raw '{
  "tokenizer": "standard",
  "filter": [ "stop" ],
  "text": "a quick fox jumps over the lazy dog"
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "quick",
            "start_offset": 2,
            "end_offset": 7,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "fox",
            "start_offset": 8,
            "end_offset": 11,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "jumps",
            "start_offset": 12,
            "end_offset": 17,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "over",
            "start_offset": 18,
            "end_offset": 22,
            "type": "<ALPHANUM>",
            "position": 4
        },
        {
            "token": "lazy",
            "start_offset": 27,
            "end_offset": 31,
            "type": "<ALPHANUM>",
            "position": 6
        },
        {
            "token": "dog",
            "start_offset": 32,
            "end_offset": 35,
            "type": "<ALPHANUM>",
            "position": 7
        }
    ]
}
```
2. slovak
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sk/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sk",
        "stop"
    ],
  "text": "Počasie je dnes naozaj pekné"
}
'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "Počasie",
            "start_offset": 0,
            "end_offset": 7,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "jesť",
            "start_offset": 8,
            "end_offset": 10,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "dnes",
            "start_offset": 11,
            "end_offset": 15,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "naozaj",
            "start_offset": 16,
            "end_offset": 22,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "pekný",
            "start_offset": 23,
            "end_offset": 28,
            "type": "<ALPHANUM>",
            "position": 4
        }
    ]
}
```
3. slovene
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sl/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sl",
        "stop"
    ],
  "text": "Vreme je danes res lepo"
}
'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "Vreme",
            "start_offset": 0,
            "end_offset": 5,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "biti",
            "start_offset": 6,
            "end_offset": 8,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "danes",
            "start_offset": 9,
            "end_offset": 14,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "res",
            "start_offset": 15,
            "end_offset": 18,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "lep",
            "start_offset": 19,
            "end_offset": 23,
            "type": "<ALPHANUM>",
            "position": 4
        }
    ]
}
```
- Trim
1. English
Request:
```bash
curl --location --request POST 'https://localhost:9200/_analyze' \
--data-raw '{
  "tokenizer" : "standard",
  "filter" : ["trim"],
  "text" : " fox "
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "fox",
            "start_offset": 0,
            "end_offset": 5,
            "type": "word",
            "position": 0
        }
    ]
}
```
2. slovak
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sk/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sk",
        "trim"
    ],
  "text": "  Počasie  "
}
'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "Počasie",
            "start_offset": 2,
            "end_offset": 9,
            "type": "<ALPHANUM>",
            "position": 0
        }
    ]
}
```
3. slovene
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sl/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sl",
        "trim"
    ],
  "text": "  Vreme  "
}
'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "Vreme",
            "start_offset": 2,
            "end_offset": 7,
            "type": "<ALPHANUM>",
            "position": 0
        }
    ]
}
```
- Kstem
1. English
Request:
```bash
curl --location --request POST 'https://localhost:9200/_analyze' \
--data-raw '{
  "tokenizer": "standard",
  "filter": [ "kstem" ],
  "text": "the foxes jumping quickly"
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "the",
            "start_offset": 0,
            "end_offset": 3,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "fox",
            "start_offset": 4,
            "end_offset": 9,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "jump",
            "start_offset": 10,
            "end_offset": 17,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "quick",
            "start_offset": 18,
            "end_offset": 25,
            "type": "<ALPHANUM>",
            "position": 3
        }
    ]
}
```
2. slovak
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sk/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sk"
    ],
  "text": "líšky rýchlo skáču"
}
'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "líška",
            "start_offset": 0,
            "end_offset": 5,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "rýchlo",
            "start_offset": 6,
            "end_offset": 12,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "skákať",
            "start_offset": 13,
            "end_offset": 18,
            "type": "<ALPHANUM>",
            "position": 2
        }
    ]
}
```
3. slovene
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sl/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sl"
    ],
  "text": "lisice hitro skačejo"
}
'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "lisica",
            "start_offset": 0,
            "end_offset": 6,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "hiter",
            "start_offset": 7,
            "end_offset": 12,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "skači",
            "start_offset": 13,
            "end_offset": 20,
            "type": "<ALPHANUM>",
            "position": 2
        }
    ]
}
```
- Word delimiter graph
1. English
Request:
```bash
curl --location --request POST 'https://localhost:9200/_analyze' \
--data-raw '{
  "tokenizer": "standard",
  "filter": [ "word_delimiter_graph" ],
  "text": "Neil'\''s-Super-Duper-XL500--42+AutoCoder"
}'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "Neil",
            "start_offset": 0,
            "end_offset": 4,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "Super",
            "start_offset": 7,
            "end_offset": 12,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "Duper",
            "start_offset": 13,
            "end_offset": 18,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "XL",
            "start_offset": 19,
            "end_offset": 21,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "500",
            "start_offset": 21,
            "end_offset": 24,
            "type": "<ALPHANUM>",
            "position": 4
        },
        {
            "token": "42",
            "start_offset": 26,
            "end_offset": 28,
            "type": "<NUM>",
            "position": 5
        },
        {
            "token": "Auto",
            "start_offset": 29,
            "end_offset": 33,
            "type": "<ALPHANUM>",
            "position": 6
        },
        {
            "token": "Coder",
            "start_offset": 33,
            "end_offset": 38,
            "type": "<ALPHANUM>",
            "position": 7
        }
    ]
}
```
2. slovak
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sk/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sk",
        "word_delimiter_graph"
    ],
  "text": "líšky-rýchlo-xl500+skáču"
}
'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "líška",
            "start_offset": 0,
            "end_offset": 5,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "rýchlo",
            "start_offset": 6,
            "end_offset": 12,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "xl",
            "start_offset": 13,
            "end_offset": 15,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "500",
            "start_offset": 15,
            "end_offset": 18,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "skákať",
            "start_offset": 19,
            "end_offset": 24,
            "type": "<ALPHANUM>",
            "position": 4
        }
    ]
}
```
3. slovene
Request:
```bash
curl --location --request GET 'https://localhost:9200/lemmagen-sl/_analyze' \
--data-raw '{
  "tokenizer": "standard",
    "filter": [
        "lemmagen_filter_sl",
        "word_delimiter_graph"
    ],
  "text": "lisice-hitro+skačejo-xl500"
}
'
```
Response:
```bash
{
    "tokens": [
        {
            "token": "lisica",
            "start_offset": 0,
            "end_offset": 6,
            "type": "<ALPHANUM>",
            "position": 0
        },
        {
            "token": "hiter",
            "start_offset": 7,
            "end_offset": 12,
            "type": "<ALPHANUM>",
            "position": 1
        },
        {
            "token": "skači",
            "start_offset": 13,
            "end_offset": 20,
            "type": "<ALPHANUM>",
            "position": 2
        },
        {
            "token": "xl",
            "start_offset": 21,
            "end_offset": 23,
            "type": "<ALPHANUM>",
            "position": 3
        },
        {
            "token": "500",
            "start_offset": 23,
            "end_offset": 26,
            "type": "<ALPHANUM>",
            "position": 4
        }
    ]
}
```
