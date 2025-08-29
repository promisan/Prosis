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
(function ($) {
  // template, editor
  var tmpl = $.summernote.renderer.getTemplate();
  var editor = $.summernote.eventHandler.getEditor();

  // add plugin
  $.summernote.addPlugin({
    name: 'hello', // name of plugin
    buttons: { // buttons
      hello: function () {

        return tmpl.iconButton('fa fa-header', {
          event : 'hello',
          title: 'hello',
          hide: true
        });
      },
      helloDropdown: function () {


        var list = '<li><a data-event="helloDropdown" href="#" data-value="summernote">summernote</a></li>';
        list += '<li><a data-event="helloDropdown" href="#" data-value="codemirror">Code Mirror</a></li>';
        var dropdown = '<ul class="dropdown-menu">' + list + '</ul>';

        return tmpl.iconButton('fa fa-header', {
          title: 'hello',
          hide: true,
          dropdown : dropdown
        });
      }

    },

    events: { // events
      hello: function (layoutInfo) {
        // Get current editable node
        var $editable = layoutInfo.editable();

        // Call insertText with 'hello'
        editor.insertText($editable, 'hello ');
      },
      helloDropdown: function (layoutInfo, value) {
        // Get current editable node
        var $editable = layoutInfo.editable();

        // Call insertText with 'hello'
        editor.insertText($editable, 'hello ' + value + '!!!!');
      }
    }
  });
})(jQuery);
