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
/**
 * Select2 Hungarian translation
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['hu'] = {
        formatNoMatches: function () { return "Nincs találat."; },
        formatInputTooShort: function (input, min) { var n = min - input.length; return "Túl rövid. Még " + n + " karakter hiányzik."; },
        formatInputTooLong: function (input, max) { var n = input.length - max; return "Túl hosszú. " + n + " karakterrel több, mint kellene."; },
        formatSelectionTooBig: function (limit) { return "Csak " + limit + " elemet lehet kiválasztani."; },
        formatLoadMore: function (pageNumber) { return "Töltés…"; },
        formatSearching: function () { return "Keresés…"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['hu']);
})(jQuery);
