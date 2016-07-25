#!/bin/bash
# init
DEP_IMG=${LEANSW_DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}-dep
docker pull ${DEP_IMG} && echo "Pulling dependency image successfully." || echo "Can not pull Dependency image."
OLD_SHA=$( docker inspect -f '{{ index .Config.Labels "lean.dependency.sha" }}' ${DEP_IMG} )
CURRENT_SHA=$( mvn dependency:list |grep -e '\[INFO\]    ' |shasum |grep -e '[a-z0-9]*' -o )
echo "[Dep Image shasum]:" ${OLD_SHA}
echo "[Current shasum]:" ${CURRENT_SHA}

function rebuild_dep_img ()
{
  echo "Begin rebuilding dep image..."
  mkdir docker_tmp
  echo "Copying dependency libs to target/lib ..."
  mvn dependency:copy-dependencies -DoutputDirectory=docker_tmp/target/lib
  [[ $?=0 ]] && echo "Copy dependencies Done." || exit 1
  cd docker_tmp
  IMAGE_BUILD=${DOCKER_IMAGE_NAME}_dep_tmp
  cat /var/lib/go-agent/pipelines/pipeline-docker-images/Dockerfile.dep > Dockerfile
  docker build --build-arg currentSHA=${CURRENT_SHA} -t ${IMAGE_BUILD} .
  [[ $?=0 ]] && echo "Successfully build dep image:" ${IMAGE_BUILD} || exit 1
  docker rmi ${DEP_IMG}
  echo "Removed:" ${DEP_IMG}
  docker tag -f ${IMAGE_BUILD} ${LEANSW_DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}-dep
  echo "Successfully tag image: " ${LEANSW_DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}-dep
  docker push ${LEANSW_DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}-dep
  docker rmi ${IMAGE_BUILD}
  [[ $?=0 ]] && echo "push done." || exit 1
  cd .. && rm -rf docker_tmp
  exit 0
}
# run
[[ ${OLD_SHA} != ${CURRENT_SHA} ]] && rebuild_dep_img || echo "Dependency libs not changed."
