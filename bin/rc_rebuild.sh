export LEANSW_DOCKER_REGISTRY=registry.cn-hangzhou.aliyuncs.com/leansw
docker pull $LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME/$DEV_LABEL

IMAGE_RC_VERSION=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:rc-$GO_PIPELINE_LABEL
IMAGE_RC=$LEANSW_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:rc

echo "begin generate Dockerfile"
source $HOME/.bashrc
source "$HOME/.jenv/bin/jenv-init.sh"
jenv use java 1.8.0_71

fmpp /var/lib/go-agent/pipelines/pipeline-docker-images/Dockerfile.rc \
-D"fromImageName:$IMAGE_FROM, \
goRcTriggerUser:$GO_TRIGGER_USER, \
goRcPipelineName:$GO_PIPELINE_NAME, \
goRcPipelineLabel:$GO_PIPELINE_LABEL" -oDockerfile.tmp

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
