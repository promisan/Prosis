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
 * Select2 Norwegian Bokmål translation.
 *
 * Author: Torgeir Veimo <torgeir.veimo@gmail.com>
 * Author: Bjørn Johansen <post@bjornjohansen.no>
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['nb'] = {
        formatMatches: function (matches) { if (matches === 1) { return "Ett resultat er tilgjengelig, trykk enter for å velge det."; } return matches + " resultater er tilgjengelig. Bruk piltastene opp og ned for å navigere."; },
        formatNoMatches: function () { return "Ingen treff"; },
        formatInputTooShort: function (input, min) { var n = min - input.length; return "Vennligst skriv inn " + n + (n>1 ? " flere tegn" : " tegn til"); },
        formatInputTooLong: function (input, max) { var n = input.length - max; return "Vennligst fjern " + n + " tegn"; },
        formatSelectionTooBig: function (limit) { return "Du kan velge maks " + limit + " elementer"; },
        formatLoadMore: function (pageNumber) { return "Laster flere resultater …"; },
        formatSearching: function () { return "Søker …"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['no']);
})(jQuery);

