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
(function( factory ) {
	if ( typeof define === "function" && define.amd ) {

		// AMD. Register as an anonymous module.
		define([ "../datepicker" ], factory );
	} else {

		// Browser globals
		factory( jQuery.datepicker );
	}
}(function( datepicker ) {

datepicker.regional['kk'] = {
	closeText: 'Жабу',
	prevText: '&#x3C;Алдыңғы',
	nextText: 'Келесі&#x3E;',
	currentText: 'Бүгін',
	monthNames: ['Қаңтар','Ақпан','Наурыз','Сәуір','Мамыр','Маусым',
	'Шілде','Тамыз','Қыркүйек','Қазан','Қараша','Желтоқсан'],
	monthNamesShort: ['Қаң','Ақп','Нау','Сәу','Мам','Мау',
	'Шіл','Там','Қыр','Қаз','Қар','Жел'],
	dayNames: ['Жексенбі','Дүйсенбі','Сейсенбі','Сәрсенбі','Бейсенбі','Жұма','Сенбі'],
	dayNamesShort: ['жкс','дсн','ссн','срс','бсн','жма','снб'],
	dayNamesMin: ['Жк','Дс','Сс','Ср','Бс','Жм','Сн'],
	weekHeader: 'Не',
	dateFormat: 'dd.mm.yy',
	firstDay: 1,
	isRTL: false,
	showMonthAfterYear: false,
	yearSuffix: ''};
datepicker.setDefaults(datepicker.regional['kk']);

return datepicker.regional['kk'];

}));
