#!/usr/bin/env bash
set -e
set -u 

echo "Building images with version ${VERSION}"

cat /workspace/workspace/builder-base/Dockerfile > /workspace/workspace/builder-base/Dockerfile.base
cat /workspace/workspace/Dockerfile.common >> /workspace/workspace/builder-base/Dockerfile.base
cat /workspace/workspace/builder-base/Dockerfile.common >> /workspace/workspace/builder-base/Dockerfile.base

function build_image {
  name=$1
  base=$2
  echo "pack $name uses base image: $base"

  # generate a docker image
  cat /workspace/workspace/builder-base/Dockerfile.$base > /workspace/workspace/builder-base/Dockerfile.$name
  cat /workspace/workspace/Dockerfile.common >> Dockerfile.$name
  cat /workspace/workspace/builder-base/Dockerfile.common >> /workspace/workspace/builder-base/Dockerfile.$name
}

build_image "ruby" "rubybase"
build_image "swift" "swiftbase"