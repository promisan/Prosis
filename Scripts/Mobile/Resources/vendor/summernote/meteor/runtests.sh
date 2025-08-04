#!/bin/sh
#
# Copyright © 2025 Promisan
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
#

# Test Meteor package before publishing to Atmospherejs.com

# Make sure Meteor is installed, per https://www.meteor.com/install.
# The curl'ed script is totally safe; takes 2 minutes to read its source and check.
type meteor >/dev/null 2>&1 || { curl https://install.meteor.com/ | sh; }

# sanity check: make sure we're in the root directory of the checkout
cd "$( dirname "$0" )/.."

# run tests and delete the temporary package.js even if Ctrl+C is pressed
int_trap() {
  printf "\nTests interrupted. Hopefully you verified in the browser that tests pass?\n\n"
}

trap int_trap INT

# Meteor expects package.js in the root directory of the checkout, so copy it there temporarily
cp meteor/package.js .

PACKAGE_NAME=$(grep -i name package.js | head -1 | cut -d "'" -f 2)

echo "Testing $PACKAGE_NAME..."

# provide an invalid MONGO_URL so Meteor doesn't bog us down with an empty Mongo database
MONGO_URL=mongodb:// meteor test-packages ./

# delete temporary build files and package.js
rm -rf ".build.*$PACKAGE_NAME" versions.json package.js
