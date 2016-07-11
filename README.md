# leansw-pipeline-docker-image

docker file template(freemarker) for adding pipeline metadata

with shell script to rebuild docker image

```
fmpp Dockerfile.dev \
-D"fromImageName:haha, \
goDevPipelineName:pipelineName, \
goDevPipelineLabel:pipelineLabel, \
goDevRevision:revision, \
goDevToRevision:torevision, \
goDevFromRevision:fromrevision" \
-oDockerfile
```


