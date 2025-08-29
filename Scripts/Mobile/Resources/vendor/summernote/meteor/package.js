/*
 * Copyright © 2025 Promisan B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// package metadata file for Meteor.js
'use strict';

var packageName = 'summernote:summernote';  // http://atmospherejs.com/summernote:summernote
var where = 'client';  // where to install: 'client' or 'server'. For both, pass nothing.

var packageJson = JSON.parse(Npm.require("fs").readFileSync('package.json'));

Package.describe({
  name: packageName,
  summary: 'summernote (official): jQuery+Bootstrap+FontAwesome WYSIWYG editor with embedded images support',
  version: packageJson.version,
  git: 'https://github.com/HackerWins/summernote.git'
});

Package.onUse(function (api) {
  api.versionsFrom(['METEOR@0.9.0', 'METEOR@1.0']);
  api.use([
    'jquery',
    'twbs:bootstrap@3.3.1',
    'fortawesome:fontawesome@4.2.0'
  ], where);
  // no exports - summernote adds itself to jQuery
  api.addFiles([
    'dist/summernote.js',
    'dist/summernote.css'
  ], where);
});

Package.onTest(function (api) {
  api.use(packageName, where);
  api.use('tinytest', where);

  api.addFiles('meteor/test.js', where);
});
