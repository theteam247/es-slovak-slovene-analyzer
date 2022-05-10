## es-slovak-slovene-analyzer

## elasticsearch docker image build
1. docker-compose -f docker-compose.yaml build es  
Please wait a few minutes until it is finish.


## elasticsearch start docker container 
1. sysctl -w vm.max_map_count=262144 && sysctl -p
2. docker-compose -f docker-compose.yaml up es

## test 
1. curl -X GET 'http://127.0.0.1:9200'     
elasticsearch is ok if some json result return.

