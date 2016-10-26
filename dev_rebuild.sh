export LEANSW_DOCKER_REGISTRY=registry.cn-hangzhou.aliyuncs.com/leansw
IMAGE_FROM=leansw/${DOCKER_IMAGE_NAME}
docker rmi ${IMAGE_FROM}:bak
docker tag ${IMAGE_FROM} ${IMAGE_FROM}:bak
mkdir docker_tmp
cd docker_tmp

echo "GO_TRIGGER_USER"
echo $GO_TRIGGER_USER

rm -f Dockerfile.tmp
echo "FROM ${IMAGE_FROM}" >> Dockerfile.tmp
echo "LABEL go.dev.trigger.user=${GO_TRIGGER_USER}" >> Dockerfile.tmp
echo "LABEL go.dev.pipeline.name=${GO_PIPELINE_NAME}" >> Dockerfile.tmp
echo "LABEL go.dev.pipeline.label=${GO_PIPELINE_LABEL}" >> Dockerfile.tmp
echo "LABEL go.dev.revision=${GO_REVISION}" >> Dockerfile.tmp
echo "LABEL go.dev.to.revision=${GO_TO_REVISION}" >> Dockerfile.tmp
echo "LABEL go.dev.from.revision=${GO_FROM_REVISION}" >> Dockerfile.tmp
echo "LABEL go.stage=dev" >> Dockerfile.tmp

echo "generated Dockerfile:"
echo "============================"
cat Dockerfile.tmp
echo "============================"
IMAGE_BUILD=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:$GO_PIPELINE_LABEL
docker build -f Dockerfile.tmp -t  $IMAGE_BUILD .

docker rmi  $IMAGE_FROM

docker tag $IMAGE_BUILD $LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME
rm Dockerfile.tmp

cd ..

rm -rf docker_tmp

docker push $LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME
docker rmi  $LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME

docker push $IMAGE_BUILD
docker rmi $IMAGE_BUILD
