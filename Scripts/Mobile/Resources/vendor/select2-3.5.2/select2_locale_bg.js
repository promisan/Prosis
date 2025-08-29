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
 * Select2 Bulgarian translation.
 * 
 * @author  Lubomir Vikev <lubomirvikev@gmail.com>
 * @author  Uriy Efremochkin <efremochkin@uriy.me>
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['bg'] = {
        formatNoMatches: function () { return "Няма намерени съвпадения"; },
        formatInputTooShort: function (input, min) { var n = min - input.length; return "Моля въведете още " + n + " символ" + (n > 1 ? "а" : ""); },
        formatInputTooLong: function (input, max) { var n = input.length - max; return "Моля въведете с " + n + " по-малко символ" + (n > 1 ? "а" : ""); },
        formatSelectionTooBig: function (limit) { return "Можете да направите до " + limit + (limit > 1 ? " избора" : " избор"); },
        formatLoadMore: function (pageNumber) { return "Зареждат се още…"; },
        formatSearching: function () { return "Търсене…"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['bg']);
})(jQuery);
