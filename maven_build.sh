#!/usr/bin/env bash
BUILD_UTILITY_FOLDER=${1:-_}

mvn clean dependency:copy-dependencies -U -DincludeScope=runtime -s ${BUILD_UTILITY_FOLDER}/mvn_settings.xml -DoutputDirectory=target/lib 
mvn -U package -DskipTests=true -s ${BUILD_UTILITY_FOLDER}/mvn_settings.xml
