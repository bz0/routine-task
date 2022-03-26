up:
	docker-compose down
	docker-compose up -d

build:
	docker-compose build --no-cache
	docker-compose run web rake db:create
	docker-compose up -d
