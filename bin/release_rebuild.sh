
docker pull $IMAGE_FROM

IMAGE_RELEASE_VERSION=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:release-$GO_PIPELINE_LABEL
IMAGE_RELEASE=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:release


echo "begin generate Dockerfile"
source $HOME/.bashrc
fmpp /var/lib/go-agent/pipelines/pipeline-docker-images/Dockerfile.release \
-D"fromImageName:$IMAGE_FROM, \
goReleaseTriggerUser:$GO_TRIGGER_USER, \
goReleasePipelineName:$GO_PIPELINE_NAME, \
goReleasePipelineLabel:$GO_PIPELINE_LABEL" -oDockerfile.tmp

echo "generated Dockerfile:"
echo "============================"
cat Dockerfile.tmp
echo "============================"

docker build -f Dockerfile.tmp -t  $IMAGE_RELEASE_VERSION .
rm Dockerfile.tmp
docker rmi $IMAGE_FROM


docker tag -f $IMAGE_RELEASE_VERSION $IMAGE_RELEASE
docker push $IMAGE_RELEASE
docker rmi $IMAGE_RELEASE

docker push $IMAGE_RELEASE_VERSION
docker rmi $IMAGE_RELEASE_VERSION
