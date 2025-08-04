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
 * Select2 Korean translation.
 * 
 * @author  Swen Mun <longfinfunnel@gmail.com>
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['ko'] = {
        formatNoMatches: function () { return "결과 없음"; },
        formatInputTooShort: function (input, min) { var n = min - input.length; return "너무 짧습니다. "+n+"글자 더 입력해주세요."; },
        formatInputTooLong: function (input, max) { var n = input.length - max; return "너무 깁니다. "+n+"글자 지워주세요."; },
        formatSelectionTooBig: function (limit) { return "최대 "+limit+"개까지만 선택하실 수 있습니다."; },
        formatLoadMore: function (pageNumber) { return "불러오는 중…"; },
        formatSearching: function () { return "검색 중…"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['ko']);
})(jQuery);
