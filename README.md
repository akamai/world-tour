# Akamai Developer World Tour Environment

Environment setup for Akamai Developer World Tour.

## Installation / runtime

This container is available in dockerhub. Ensure you have docker installed and run:

docker run -ti akamai/world-tour

## API credentials
It is a good practice to keep your API credentials file (.edgerc) on your local machine and map them to the docker container on runtime. You can use -v to map the credentials file:

docker run -ti -v ~/my-api-credentials.txt:/root/.edgerc akamai/world-tour

## License
[Apache License 2.0](LICENSE)
