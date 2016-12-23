#!/usr/bin/env bash
BUILD_UTILITY_FOLDER=${1:-_}

gradle clean copyDependencies 
gradle build
