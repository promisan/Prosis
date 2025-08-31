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
/**
 * Select2 Macedonian translation.
 * 
 * Author: Marko Aleksic <psybaron@gmail.com>
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['mk'] = {
        formatNoMatches: function () { return "Нема пронајдено совпаѓања"; },
        formatInputTooShort: function (input, min) { var n = min - input.length; return "Ве молиме внесете уште " + n + " карактер" + (n == 1 ? "" : "и"); },
        formatInputTooLong: function (input, max) { var n = input.length - max; return "Ве молиме внесете " + n + " помалку карактер" + (n == 1? "" : "и"); },
        formatSelectionTooBig: function (limit) { return "Можете да изберете само " + limit + " ставк" + (limit == 1 ? "а" : "и"); },
        formatLoadMore: function (pageNumber) { return "Вчитување резултати…"; },
        formatSearching: function () { return "Пребарување…"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['mk']);
})(jQuery);