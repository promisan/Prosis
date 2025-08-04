/*
 * Copyright © 2025 Promisan
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
module.exports = function(grunt) {

  require('load-grunt-tasks')(grunt);

  var concatAnim;

  grunt.initConfig({

    pkg: grunt.file.readJSON('package.json'),

    concat: {
      dist: {
        src: [ 'source/_base.css', 'source/**/*.css' ], // _base.css required for .animated helper class
        dest: 'animate.css'
      }
    },

    autoprefixer: { // https://github.com/nDmitry/grunt-autoprefixer
      options: {
        browsers: ['last 3 versions', 'bb 10', 'android 3']
      },
      no_dest: {
        src: 'animate.css' // output file
      }
    },

    cssmin: {
      minify: {
        src: ['animate.css'],
        dest: 'animate.min.css',
      }
    },

    watch: {
      css: {
        files: [ 'source/**/*', 'animate-config.json' ],
        tasks: ['default']
      }
    }

  });

  // fuction to perform custom task
  concatAnim = function () {

    var categories = grunt.file.readJSON('animate-config.json'),
      category, files, file,
      target = [ 'source/_base.css' ],
      count = 0;

    for ( category in categories ) {
      if ( categories.hasOwnProperty(category) ) {
        files = categories[category]
        for (file in files) {
          if ( files.hasOwnProperty(file) && files[file] ) {
            target.push('source/' + category + '/' + file + '.css');
            count += 1;
          }
        }
      }
    }

    if (!count) {
      grunt.log.writeln('No animations activated.');
    } else {
      grunt.log.writeln(count + (count > 1 ? ' animations' : ' animation') + ' activated.');
    }

    grunt.config('concat', { 'animate.css': target });
    grunt.task.run('concat');

  };

  // register task
  grunt.registerTask('concat-anim', 'Concatenates activated animations', concatAnim); // custom task
  grunt.registerTask('default', ['concat-anim', 'autoprefixer', 'cssmin']);
  grunt.registerTask('dev', ['watch']);

};
