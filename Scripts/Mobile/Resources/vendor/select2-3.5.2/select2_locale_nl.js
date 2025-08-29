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
 * Select2 Dutch translation
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['nl'] = {
        formatNoMatches: function () { return "Geen resultaten gevonden"; },
        formatInputTooShort: function (input, min) { var n = min - input.length; return "Vul nog " + n + " karakter" + (n == 1? "" : "s") + " in"; },
        formatInputTooLong: function (input, max) { var n = input.length - max; return "Haal " + n + " karakter" + (n == 1? "" : "s") + " weg"; },
        formatSelectionTooBig: function (limit) { return "Maximaal " + limit + " item" + (limit == 1 ? "" : "s") + " toegestaan"; },
        formatLoadMore: function (pageNumber) { return "Meer resultaten laden…"; },
        formatSearching: function () { return "Zoeken…"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['nl']);
})(jQuery);
