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
 * Select2 Persian translation.
 * 
 * Author: Ali Choopan <choopan@arsh.co>
 * Author: Ebrahim Byagowi <ebrahim@gnu.org>
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['fa'] = {
        formatMatches: function (matches) { return matches + " نتیجه موجود است، کلیدهای جهت بالا و پایین را برای گشتن استفاده کنید."; },
        formatNoMatches: function () { return "نتیجه‌ای یافت نشد."; },
        formatInputTooShort: function (input, min) { var n = min - input.length; return "لطفاً " + n + " نویسه بیشتر وارد نمایید"; },
        formatInputTooLong: function (input, max) { var n = input.length - max; return "لطفاً " + n + " نویسه را حذف کنید."; },
        formatSelectionTooBig: function (limit) { return "شما فقط می‌توانید " + limit + " مورد را انتخاب کنید"; },
        formatLoadMore: function (pageNumber) { return "در حال بارگیری موارد بیشتر…"; },
        formatSearching: function () { return "در حال جستجو…"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['fa']);
})(jQuery);
