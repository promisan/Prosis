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
 * Select2 Romanian translation.
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['ro'] = {
        formatNoMatches: function () { return "Nu a fost găsit nimic"; },
        formatInputTooShort: function (input, min) { var n = min - input.length; return "Vă rugăm să introduceți incă " + n + " caracter" + (n == 1 ? "" : "e"); },
        formatInputTooLong: function (input, max) { var n = input.length - max; return "Vă rugăm să introduceți mai puțin de " + n + " caracter" + (n == 1? "" : "e"); },
        formatSelectionTooBig: function (limit) { return "Aveți voie să selectați cel mult " + limit + " element" + (limit == 1 ? "" : "e"); },
        formatLoadMore: function (pageNumber) { return "Se încarcă…"; },
        formatSearching: function () { return "Căutare…"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['ro']);
})(jQuery);
