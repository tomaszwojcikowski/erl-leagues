.PHONY: test
test: 
	mix deps.get
	mix test

.PHONY: rel
rel:
	mix release prod

.PHONY: docker
docker:
	docker build -t derivico .

.PHONY: deploy
deploy: docker
	docker stack deploy --compose-file=docker-compose.yml prod
