#!/usr/bin/env bash

# Copyright 2018 The Kubeflow Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_ROOT=$(dirname ${BASH_SOURCE})/..

vendor/k8s.io/code-generator/generate-groups.sh \
  "deepcopy,client,informer,lister" \
  github.com/kubeflow/chainer-operator/pkg/client \
  github.com/kubeflow/chainer-operator/pkg/apis \
  chainer:v1alpha1 \
  --go-header-file ${SCRIPT_ROOT}/hack/boilerplate/boilerplate.go.txt

# Notice: The code in code-generator does not generate defaulter by default.
echo "Generating defaulters for v1alpha1"
${GOPATH}/bin/defaulter-gen  \
  --input-dirs github.com/kubeflow/chainer-operator/pkg/apis/chainer/v1alpha1 \
  -O zz_generated.defaults \
  --go-header-file hack/boilerplate/boilerplate.go.txt "$@"