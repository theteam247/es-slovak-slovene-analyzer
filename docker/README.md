## es-slovak-slovene-analyzer

## elasticsearch docker image build
1. docker-compose -f docker-compose.yaml build es
Please wait a few minutes until it is finish.

## elasticsearch start docker container 
1. sysctl -w vm.max_map_count=262144
2. sysctl -p
3. docker-compose -f docker-compose.yaml up es

## test 
1. local host run "curl -X GET 'http://127.0.0.1:9200'" setup is ok if some json result return.


