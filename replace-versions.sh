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

function combine_with_base_image {
  base=$1
  builders=$2

  for i in $builders
  do
    echo "updating builder-${i}"
    pushd builder-${i}
      cp Dockerfile Dockerfile.bak
      cat /workspace/source/Dockerfile.${base}base > Dockerfile
      cat Dockerfile.bak >> Dockerfile
      rm Dockerfile.bak
      head -n 1 Dockerfile
    popd
  done
}

combine_with_base_image "maven" "maven-java11 maven-nodejs"
combine_with_base_image "go" "go go-maven terraform"
