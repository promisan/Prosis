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
 * Select2 Polish translation.
 *
 * @author  Jan Kondratowicz <jan@kondratowicz.pl>
 * @author  Uriy Efremochkin <efremochkin@uriy.me>
 * @author  Michał Połtyn <mike@poltyn.com>
 * @author  Damian Zajkowski <damian.zajkowski@gmail.com>
 */
(function($) {
    "use strict";

    $.fn.select2.locales['pl'] = {
        formatNoMatches: function() {
            return "Brak wyników";
        },
        formatInputTooShort: function(input, min) {
            return "Wpisz co najmniej" + character(min - input.length, "znak", "i");
        },
        formatInputTooLong: function(input, max) {
            return "Wpisana fraza jest za długa o" + character(input.length - max, "znak", "i");
        },
        formatSelectionTooBig: function(limit) {
            return "Możesz zaznaczyć najwyżej" + character(limit, "element", "y");
        },
        formatLoadMore: function(pageNumber) {
            return "Ładowanie wyników…";
        },
        formatSearching: function() {
            return "Szukanie…";
        }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['pl']);

    function character(n, word, pluralSuffix) {
        //Liczba pojedyncza - brak suffiksu
        //jeden znak
        //jeden element
        var suffix = '';
        if (n > 1 && n < 5) {
            //Liczaba mnoga ilość od 2 do 4 - własny suffiks
            //Dwa znaki, trzy znaki, cztery znaki.
            //Dwa elementy, trzy elementy, cztery elementy
            suffix = pluralSuffix;
        } else if (n == 0 || n >= 5) {
            //Ilość 0 suffiks ów
            //Liczaba mnoga w ilości 5 i więcej - suffiks ów (nie poprawny dla wszystkich wyrazów, np. 100 wiadomości)
            //Zero znaków, Pięć znaków, sześć znaków, siedem znaków, osiem znaków.
            //Zero elementów Pięć elementów, sześć elementów, siedem elementów, osiem elementów.
            suffix = 'ów';
        }
        return " " + n + " " + word + suffix;
    }
})(jQuery);
