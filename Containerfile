# Copyright (c) 2019 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM quay.io/centos/centos:8

RUN dnf update -y \
  && dnf install -y epel-release dnf-plugins-core \
  && dnf config-manager --set-disabled epel \
  && dnf config-manager --set-enabled powertools \
  && dnf module enable -y python38-devel \
  && dnf install -y python38-pip \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# NOTE(pabelanger): We do this to allow users to install python36 but not
# change python3 to python36.
RUN alternatives --set python3 /usr/bin/python3.8

# Upgrade pip to fix wheel cache for locally built wheels.
# See https://github.com/pypa/pip/issues/6852
RUN pip3.8 install --no-cache-dir -U pip

RUN pip3 install --no-cache-dir dumb-init

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
