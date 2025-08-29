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
 * Select2 Croatian translation.
 *
 * @author  Edi Modrić <edi.modric@gmail.com>
 * @author  Uriy Efremochkin <efremochkin@uriy.me>
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['hr'] = {
        formatNoMatches: function () { return "Nema rezultata"; },
        formatInputTooShort: function (input, min) { return "Unesite još" + character(min - input.length); },
        formatInputTooLong: function (input, max) { return "Unesite" + character(input.length - max) + " manje"; },
        formatSelectionTooBig: function (limit) { return "Maksimalan broj odabranih stavki je " + limit; },
        formatLoadMore: function (pageNumber) { return "Učitavanje rezultata…"; },
        formatSearching: function () { return "Pretraga…"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['hr']);

    function character (n) {
        return " " + n + " znak" + (n%10 < 5 && n%10 > 0 && (n%100 < 5 || n%100 > 19) ? n%10 > 1 ? "a" : "" : "ova");
    }
})(jQuery);
