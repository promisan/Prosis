#!/bin/bash
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


set -e

if [ "$#" != 1 ]; then
    echo "Please provide tag to checkout" >&2
    exit 1
fi
tag="$1"

while [ "$PWD" != '/' -a ! -f moment.js ]; do
    cd ..
done

if [ ! -f moment.js ]; then
    echo "Run me from the moment repo" >&2
    exit 1
fi

basename=$(basename $PWD)
src=moment-npm-git
dest=moment-npm

cd ..

rm -rf $src $dest

git clone $basename $src
mkdir $dest


cp $src/moment.js $dest
cp $src/package.json $dest
cp $src/README.md $dest
cp $src/LICENSE $dest
cp -r $src/locale $dest
cp -r $src/min $dest
cp $src/ender.js $dest
cp $src/package.js $dest

rm -rf $src

echo "Check out $dest"
