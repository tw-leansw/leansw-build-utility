#!/usr/bin/env bash
# Usage: docker_build.sh <stage> <service-name> <previous-stage-label>
# E.g. : docker_build.sh rc cd-metrics dev-88
# Available stages: dev, rc, release

# Parameters
GO_STAGE=${1}
SERVICE_NAME=${2}
LABLE_FROM=${3}
LEANSW_DOCKER_REGISTRY=reg.dev.twleansw.com/leansw

if [ "${GO_STAGE}" = "dev" ]; then
    cp src/main/docker/* target/
    echo "LABEL go.dev.revision=$(env | grep GO_REVISION_ | grep -o '[^=]*$')" >>target/Dockerfile
else
    IMAGE_FROM=${LEANSW_DOCKER_REGISTRY}/${SERVICE_NAME}:${LABLE_FROM}
    echo "FROM ${IMAGE_FROM}" >target/Dockerfile
fi

cat <<EOF >>Dockerfile.gen
LABEL go.dev.trigger.user=${GO_TRIGGER_USER}
LABEL go.dev.pipeline.name=${GO_PIPELINE_NAME}
LABEL go.dev.pipeline.label=${GO_PIPELINE_LABEL}
LABEL go.stage=${GO_STAGE}
EOF

echo "Triggered by: $GO_TRIGGER_USER"
echo "======== Dockerfile ========"
cat target/Dockerfile
echo "============================"

IMAGE_NAME=${LEANSW_DOCKER_REGISTRY}/${SERVICE_NAME}:${GO_STAGE}
IMAGE_NAME_WITH_VERSION=${IMAGE_NAME}-${GO_PIPELINE_LABEL}

docker build -f target/Dockerfile -t ${IMAGE_NAME} target
docker tag ${IMAGE_NAME} ${IMAGE_NAME_WITH_VERSION}

docker push ${IMAGE_NAME}
docker rmi ${IMAGE_NAME}

docker push ${IMAGE_NAME_WITH_VERSION}
docker rmi ${IMAGE_NAME_WITH_VERSION}
