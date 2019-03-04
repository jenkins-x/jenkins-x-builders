#!/usr/bin/env bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail


BUILDERS="dlang go go-maven gradle gradle4 gradle5 maven maven-java11 maven-nodejs maven-32 nodejs nodejs8x nodejs10x newman aws-cdk python python2 python37 rust scala terraform"


DOCKER_ORG=$1
VERSION=$2


## now loop through the above array
for i in $BUILDERS
do
  echo "updating builder-${i}"
  pushd builder-${i}
    sed -i.bak -e "s/FROM \(.*\)\/builder-\(.*\):\(.*\)/FROM ${DOCKER_ORG}\/builder-\2:${VERSION}/" Dockerfile
    rm Dockerfile.bak
    head -n 1 Dockerfile
  popd
done