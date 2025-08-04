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
 * Select2 Ukrainian translation.
 * 
 * @author  bigmihail <bigmihail@bigmir.net>
 * @author  Uriy Efremochkin <efremochkin@uriy.me>
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['uk'] = {
        formatMatches: function (matches) { return character(matches, "результат") + " знайдено, використовуйте клавіші зі стрілками вверх та вниз для навігації."; },
        formatNoMatches: function () { return "Нічого не знайдено"; },
        formatInputTooShort: function (input, min) { return "Введіть буль ласка ще " + character(min - input.length, "символ"); },
        formatInputTooLong: function (input, max) { return "Введіть буль ласка на " + character(input.length - max, "символ") + " менше"; },
        formatSelectionTooBig: function (limit) { return "Ви можете вибрати лише " + character(limit, "елемент"); },
        formatLoadMore: function (pageNumber) { return "Завантаження даних…"; },
        formatSearching: function () { return "Пошук…"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['uk']);

    function character (n, word) {
        return n + " " + word + (n%10 < 5 && n%10 > 0 && (n%100 < 5 || n%100 > 19) ? n%10 > 1 ? "и" : "" : "ів");
    }
})(jQuery);
