#!/bin/bash
# init
export LEANSW_DOCKER_REGISTRY = registry.cn-hangzhou.aliyuncs.com/leansw
DEP_IMG=${LEANSW_DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:dep
docker pull ${DEP_IMG} && echo "Pulling dependency image successfully." || echo "Can not pull Dependency image. Still going on to build new dep image."
OLD_SHA=$( docker inspect -f '{{ index .Config.Labels "lean.dependency.sha" }}' ${DEP_IMG} )
CURRENT_SHA=$( mvn dependency:list -DincludeScope=runtime |grep -e '\[INFO\]    ' |shasum |grep -e '[a-z0-9]*' -o )
echo "[Dep Image shasum]:" ${OLD_SHA}
echo "[Current shasum]:" ${CURRENT_SHA}

function rebuild_dep_img ()
{
  echo "Begin rebuilding dep image..."
  mkdir docker_tmp
  echo "Copying dependency libs to target/lib ..."
  mvn dependency:copy-dependencies -DincludeScope=runtime -DoutputDirectory=docker_tmp/target/lib
  [[ $?=0 ]] && echo "Copy dependencies Done." || (echo "Error occurs copy dependency libs. Aborting..." && exit 1)
  cd docker_tmp
  IMAGE_BUILD=${DOCKER_IMAGE_NAME}_dep_tmp
  cat /var/lib/go-agent/pipelines/pipeline-docker-images/Dockerfile.dep > Dockerfile
  docker build --build-arg currentSHA=${CURRENT_SHA} -t ${IMAGE_BUILD} .
  [[ $?=0 ]] && echo "Successfully build dep image:" ${IMAGE_BUILD} || (echo "Error occurs when building dep image. Aborting..." && exit 1)
  docker rmi ${DEP_IMG} && echo "Removed original dep image:" ${DEP_IMG}
  docker tag -f ${IMAGE_BUILD} ${LEANSW_DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:dep && echo "Successfully tag image: " ${LEANSW_DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:dep
  docker rmi ${IMAGE_BUILD} && echo "Removed temp build image:" ${IMAGE_BUILD}
  docker push ${LEANSW_DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:dep
  [[ $?=0 ]] && echo "push done." || (echo "Error occurs when pushing dep images. Aborting..." && exit 1)
  cd .. && rm -rf docker_tmp
  exit 0
}
# run
[[ ${OLD_SHA} != ${CURRENT_SHA} ]] && rebuild_dep_img || echo "Dependency libs not changed."
