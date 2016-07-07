
docker pull $IMAGE_FROM 


echo "begin generate Dockerfile"
source $HOME/.bashrc
fmpp /var/lib/go-agent/pipelines/pipeline-docker-images/Dockerfile.rc \
-D"fromImageName:$IMAGE_FROM, \
goRcTriggerUser:$GO_TRIGGER_USER, \
goRcPipelineName:$GO_PIPELINE_NAME, \
goRcPipelineLabel:$GO_PIPELINE_LABEL" -oDockerfile.tmp

echo "generated Dockerfile:"
echo "============================"
cat Dockerfile.tmp
echo "============================"

docker build -f Dockerfile.tmp -t  $IMAGE_RC_VERSION .
rm Dockerfile.tmp
docker rmi $IMAGE_FROM


docker tag -f $IMAGE_RC_VERSION $IMAGE_RC

docker push $IMAGE_RC_VERSION
docker rmi $IMAGE_RC_VERSION

docker push $IMAGE_RC
docker rmi $IMAGE_RC
