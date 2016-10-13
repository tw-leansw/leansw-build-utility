export LEANSW_DOCKER_REGISTRY=registry.cn-hangzhou.aliyuncs.com/leansw
export IMAGE_FROM=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:$DEV_LABEL
docker pull $IMAGE_FROM

IMAGE_RC_VERSION=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:rc-$GO_PIPELINE_LABEL
IMAGE_RC=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:rc

echo "\n\
from ${fromImageName}\n\
LABEL go.rc.trigger.user=${GO_TRIGGER_USER}\n\
LABEL go.rc.pipeline.name=${GO_PIPELINE_NAME}\n\
LABEL go.rc.pipeline.label=${GO_PIPELINE_LABEL}\n\
LABEL go.stage=rc\n\
" > Dockerfile.tmp

echo "generated Dockerfile:"
echo "============================"
cat Dockerfile.tmp
echo "============================"

docker build -f Dockerfile.tmp -t $IMAGE_RC_VERSION .
rm Dockerfile.tmp
docker rmi $IMAGE_FROM


docker tag $IMAGE_RC_VERSION $IMAGE_RC

docker push $IMAGE_RC_VERSION
docker rmi $IMAGE_RC_VERSION

docker push $IMAGE_RC
docker rmi $IMAGE_RC
