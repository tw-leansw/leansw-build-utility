
IMAGE_FROM=${LEANSW_DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}-dep

mkdir docker_tmp
cd docker_tmp

echo "begin generate Dockerfile"
source $HOME/.bashrc
echo "GO_TRIGGER_USER"
echo $GO_TRIGGER_USER

fmpp /var/lib/go-agent/pipelines/pipeline-docker-images/Dockerfile.dev \
-D"fromImageName:$IMAGE_FROM, \
goDevTriggerUser:$GO_TRIGGER_USER, \
goDevPipelineName:$GO_PIPELINE_NAME, \
goDevPipelineLabel:$GO_PIPELINE_LABEL, \
goDevRevision:$GO_REVISION, \
goDevToRevision:$GO_TO_REVISION, \
goDevFromRevision:$GO_FROM_REVISION " \
-oDockerfile.tmp

echo "generated Dockerfile:"
echo "============================"
cat Dockerfile.tmp
echo "============================"
IMAGE_BUILD=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:$GO_PIPELINE_LABEL
docker build -f Dockerfile.tmp -t  $IMAGE_BUILD .

docker rmi  $IMAGE_FROM

docker tag -f $IMAGE_BUILD $LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME
rm Dockerfile.tmp

cd ..

rm -rf docker_tmp

docker push $LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME
docker rmi  $LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME

docker push $IMAGE_BUILD
docker rmi $IMAGE_BUILD
