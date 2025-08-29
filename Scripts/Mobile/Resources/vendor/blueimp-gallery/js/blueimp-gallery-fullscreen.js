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
(function (factory) {
    'use strict';
    if (typeof define === 'function' && define.amd) {
        // Register as an anonymous AMD module:
        define([
            './blueimp-helper',
            './blueimp-gallery'
        ], factory);
    } else {
        // Browser globals:
        factory(
            window.blueimp.helper || window.jQuery,
            window.blueimp.Gallery
        );
    }
}(function ($, Gallery) {
    'use strict';

    $.extend(Gallery.prototype.options, {
        // Defines if the gallery should open in fullscreen mode:
        fullScreen: false
    });

    var initialize = Gallery.prototype.initialize,
        close = Gallery.prototype.close;

    $.extend(Gallery.prototype, {

        getFullScreenElement: function () {
            return document.fullscreenElement ||
                document.webkitFullscreenElement ||
                document.mozFullScreenElement ||
                document.msFullscreenElement;
        },

        requestFullScreen: function (element) {
            if (element.requestFullscreen) {
                element.requestFullscreen();
            } else if (element.webkitRequestFullscreen) {
                element.webkitRequestFullscreen();
            } else if (element.mozRequestFullScreen) {
                element.mozRequestFullScreen();
            } else if (element.msRequestFullscreen) {
                element.msRequestFullscreen();
            }
        },

        exitFullScreen: function () {
            if (document.exitFullscreen) {
                document.exitFullscreen();
            } else if (document.webkitCancelFullScreen) {
                document.webkitCancelFullScreen();
            } else if (document.mozCancelFullScreen) {
                document.mozCancelFullScreen();
            } else if (document.msExitFullscreen) {
                document.msExitFullscreen();
            }
        },

        initialize: function () {
            initialize.call(this);
            if (this.options.fullScreen && !this.getFullScreenElement()) {
                this.requestFullScreen(this.container[0]);
            }
        },

        close: function () {
            if (this.getFullScreenElement() === this.container[0]) {
                this.exitFullScreen();
            }
            close.call(this);
        }

    });

    return Gallery;
}));
