cp src/main/docker/*  target/
docker build -t leansw/${DOCKER_IMAGE_NAME} -f target/Dockerfile  target
