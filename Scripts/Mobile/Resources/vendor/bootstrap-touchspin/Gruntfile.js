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
module.exports = function (grunt) {

  grunt.initConfig({

    // Import package manifest
    pkg: grunt.file.readJSON("bootstrap-touchspin.jquery.json"),

    // Banner definitions
    meta: {
      banner: "/*\n" +
        " *  <%= pkg.title || pkg.name %> - v<%= pkg.version %>\n" +
        " *  <%= pkg.description %>\n" +
        " *  <%= pkg.homepage %>\n" +
        " *\n" +
        " *  Made by <%= pkg.author.name %>\n" +
        " *  Under <%= pkg.licenses[0].type %> License\n" +
        " */\n"
    },

    // Concat definitions
    concat: {
      js: {
        src: ["src/jquery.bootstrap-touchspin.js"],
        dest: "dist/jquery.bootstrap-touchspin.js"
      },
      css: {
        src: ["src/jquery.bootstrap-touchspin.css"],
        dest: "dist/jquery.bootstrap-touchspin.css"
      },
      options: {
        banner: "<%= meta.banner %>"
      }
    },

    // Lint definitions
    jshint: {
      files: ["src/jquery.bootstrap-touchspin.js"],
      options: {
        jshintrc: ".jshintrc"
      }
    },

    // Minify definitions
    uglify: {
      js: {
        src: ["dist/jquery.bootstrap-touchspin.js"],
        dest: "dist/jquery.bootstrap-touchspin.min.js"
      },
      options: {
        banner: "<%= meta.banner %>"
      }
    },

    cssmin: {
      css: {
        src: ["dist/jquery.bootstrap-touchspin.css"],
        dest: "dist/jquery.bootstrap-touchspin.min.css"
      },
      options: {
        banner: "<%= meta.banner %>"
      }
    }
  });

  grunt.loadNpmTasks("grunt-contrib-concat");
  grunt.loadNpmTasks("grunt-contrib-jshint");
  grunt.loadNpmTasks("grunt-contrib-uglify");
  grunt.loadNpmTasks("grunt-contrib-cssmin");

  grunt.registerTask("default", ["jshint", "concat", "uglify", "cssmin"]);
  grunt.registerTask("travis", ["jshint"]);

};
