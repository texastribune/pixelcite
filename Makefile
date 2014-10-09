build:
	docker build -t texastribune/pixelcite .

run:
	docker run --rm --name pixelcite --env-file env-docker -p 8000:8000 \
	  texastribune/pixelcite

debug:
	docker run --volumes-from pixelcite -i -t ubuntu /bin/bash

tail:
	docker run --volumes-from pixelcite -i -t ubuntu tail -f /app/logs/*.log

run_debug:
	docker run --rm --name pixelcite --env-file env-docker -p 8000:8000 \
	  texastribune/pixelcite

# for testing the raw gunicorn server
test_gunicorn:
	docker run --rm --name pixelcite --env-file env-docker -p 8000:8000 \
	  --entrypoint /usr/local/bin/gunicorn texastribune/pixelcite \
	  -c /app/gunicorn.py --bind 0.0.0.0:8000 public_app:app

shell:
	docker run --rm -i -t texastribune/pixelcite bash

save:
	docker save texastribune/pixelcite | gzip > /tmp/pixelcite.tar.gz

push: save
	aws s3 cp /tmp/pixelcite.tar.gz s3://pixelcite-utility/docker/pixelcite.tar.gz
