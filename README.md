# leansw-pipeline-docker-image

docker file template(freemarker) for adding pipeline metadata


```
fmpp Dockerfile.dev -D"fromImageName:haha, goDevPipelineName:pipelineName, goDevPipelineLabel:pipelineLabel, goDevRevision:revision, goDevToRevision:torevision, goDevFromRevision:fromrevision" -oDockerfile
```

fmpp /var/go/leansw-pipeline-docker-image/Dockerfile.dev -D"fromImageName:leansw/$DOCKER_IMAGE_NAME, goDevPipelineName:$GO_PIPELINE_NAME, goDevPipelineLabel:$GO_PIPELINE_LABEL, goDevRevision:$GO_REVISION, goDevToRevision:$GO_TO_REVISION, goDevFromRevision:GO_FROM_REVISION" -oDockerfile.tmp
```
