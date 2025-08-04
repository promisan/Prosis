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
/* global define, window, document */

(function (factory) {
    'use strict';
    if (typeof define === 'function' && define.amd) {
        define([
            'jquery',
            './blueimp-gallery'
        ], factory);
    } else {
        factory(
            window.jQuery,
            window.blueimp.Gallery
        );
    }
}(function ($, Gallery) {
    'use strict';

    // Global click handler to open links with data-gallery attribute
    // in the Gallery lightbox:
    $(document).on('click', '[data-gallery]', function (event) {
        // Get the container id from the data-gallery attribute:
        var id = $(this).data('gallery'),
            widget = $(id),
            container = (widget.length && widget) ||
                $(Gallery.prototype.options.container),
            callbacks = {
                onopen: function () {
                    container
                        .data('gallery', this)
                        .trigger('open');
                },
                onopened: function () {
                    container.trigger('opened');
                },
                onslide: function () {
                    container.trigger('slide', arguments);
                },
                onslideend: function () {
                    container.trigger('slideend', arguments);
                },
                onslidecomplete: function () {
                    container.trigger('slidecomplete', arguments);
                },
                onclose: function () {
                    container.trigger('close');
                },
                onclosed: function () {
                    container
                        .trigger('closed')
                        .removeData('gallery');
                }
            },
            options = $.extend(
                // Retrieve custom options from data-attributes
                // on the Gallery widget:
                container.data(),
                {
                    container: container[0],
                    index: this,
                    event: event
                },
                callbacks
            ),
            // Select all links with the same data-gallery attribute:
            links = $('[data-gallery="' + id + '"]');
        if (options.filter) {
            links = links.filter(options.filter);
        }
        return new Gallery(links, options);
    });

}));
