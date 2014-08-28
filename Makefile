build:
	docker build -t texastribune/pixelcite .

run:
	docker run --rm --name pixelcite --env-file env-docker -p 8000:8000 \
	  texastribune/pixelcite

shell:
	docker run --rm -i -t texastribune/pixelcite bash

save:
	docker save texastribune/pixelcite | gzip > /tmp/pixelcite.tar.gz

push: save
	aws s3 cp /tmp/pixelcite.tar.gz s3://pixelcite-utility/docker/pixelcite.tar.gz
