up:
	docker-compose down
	docker-compose up -d

build:
	docker-compose build --no-cache
	docker-compose run backend rake db:create
	docker-compose run backend rake db:seed
	docker-compose up -d
