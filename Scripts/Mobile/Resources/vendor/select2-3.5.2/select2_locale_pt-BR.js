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
 * Select2 Brazilian Portuguese translation
 */
(function ($) {
    "use strict";

    $.fn.select2.locales['pt-BR'] = {
        formatNoMatches: function () { return "Nenhum resultado encontrado"; },
        formatAjaxError: function () { return "Erro na busca"; },
        formatInputTooShort: function (input, min) { var n = min - input.length; return "Digite " + (min == 1 ? "" : "mais") + " " + n + " caracter" + (n == 1? "" : "es"); },
        formatInputTooLong: function (input, max) { var n = input.length - max; return "Apague " + n + " caracter" + (n == 1? "" : "es"); },
        formatSelectionTooBig: function (limit) { return "Só é possível selecionar " + limit + " elemento" + (limit == 1 ? "" : "s"); },
        formatLoadMore: function (pageNumber) { return "Carregando mais resultados…"; },
        formatSearching: function () { return "Buscando…"; }
    };

    $.extend($.fn.select2.defaults, $.fn.select2.locales['pt-BR']);
})(jQuery);
