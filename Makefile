.PHONY: clean setup build

clean:
	rm -rf publish **/.jekyll* *.log tmp .dart_tool node_modules
 
# setup: clean
# 	dart pub get
# 	yarn install
# 	bundle install
# 
# 	dart run grinder create-code-excerpts update-code-excerpts

setup: clean
	docker compose down
	docker rmi ghcr.io/angulardart-community/site:latest
	docker compose build --no-cache site

up:
	docker compose up site

down:
	docker compose down

run:
	docker compose run --rm site bash

excerpts:
	dart run grinder create-code-excerpts update-code-excerpts

build: excerpts
	bundle exec jekyll build

serve: excerpts
	bundle exec jekyll serve --livereload \
							 --incremental \
							 --host ${JEKYLL_SITE_HOST} \
							 --port ${JEKYLL_SITE_PORT} \
							 --trace
