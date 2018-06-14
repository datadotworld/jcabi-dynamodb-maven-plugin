#   Copyright 2017 data.world, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

#!/bin/bash
set -o errexit -o nounset

do_release() {
    # These variables are passed as build parameters to CircleCI
    : 0.10-dw1
    : v0.10-dw1
    : 0.10-dw2-SNAPSHOT
    : ${MVN_RELEASE_USER_EMAIL}
    : ${MVN_RELEASE_USER_NAME}

    git config user.email "niraj.patel@data.world"
    git config user.name "Via CircleCI"

    mvn -B -Dtag=${MVN_RELEASE_TAG} release:clean release:prepare \
               -DreleaseVersion=${MVN_RELEASE_VER} \
               -DdevelopmentVersion=${MVN_RELEASE_DEV_VER} \
               -DscmCommentPrefix='[maven-release-plugin] [skip ci] ' \
               -Darguments="-DskipTests=true -Dinvoker.skip=true"

    mvn -B -s settings.xml release:perform \
               -Darguments="-DskipTests=true -Dinvoker.skip=true"

    mvn release:clean
}

#If the environment has a Maven release version set, let's do a release
do_release