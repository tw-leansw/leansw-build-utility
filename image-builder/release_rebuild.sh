export LEANSW_DOCKER_REGISTRY=registry.cn-hangzhou.aliyuncs.com/leansw
export IMAGE_FROM=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:rc-$RC_LABEL
docker pull $IMAGE_FROM

IMAGE_RELEASE_VERSION=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:release-$GO_PIPELINE_LABEL
IMAGE_RELEASE=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:release

echo " \
from ${IMAGE_FROM} \n\
LABEL go.release.trigger.user=${GO_TRIGGER_USER}\n\
LABEL go.release.pipeline.name=${GO_PIPELINE_NAME}\n\
LABEL go.release.pipeline.label=${GO_PIPELINE_LABEL}\n\
LABEL go.stage=release\n\
" > Dockerfile.tmp


LABEL go.dev.trigger.user=${GO_TRIGGER_USER}

echo "generated Dockerfile:"
echo "============================"
cat Dockerfile.tmp
echo "============================"

docker build -f Dockerfile.tmp -t  $IMAGE_RELEASE_VERSION .
rm Dockerfile.tmp
docker rmi $IMAGE_FROM


docker tag $IMAGE_RELEASE_VERSION $IMAGE_RELEASE
docker push $IMAGE_RELEASE
docker rmi $IMAGE_RELEASE

docker push $IMAGE_RELEASE_VERSION
docker rmi $IMAGE_RELEASE_VERSION
