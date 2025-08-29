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

datepicker.regional['sr'] = {
	closeText: 'Затвори',
	prevText: '&#x3C;',
	nextText: '&#x3E;',
	currentText: 'Данас',
	monthNames: ['Јануар','Фебруар','Март','Април','Мај','Јун',
	'Јул','Август','Септембар','Октобар','Новембар','Децембар'],
	monthNamesShort: ['Јан','Феб','Мар','Апр','Мај','Јун',
	'Јул','Авг','Сеп','Окт','Нов','Дец'],
	dayNames: ['Недеља','Понедељак','Уторак','Среда','Четвртак','Петак','Субота'],
	dayNamesShort: ['Нед','Пон','Уто','Сре','Чет','Пет','Суб'],
	dayNamesMin: ['Не','По','Ут','Ср','Че','Пе','Су'],
	weekHeader: 'Сед',
	dateFormat: 'dd.mm.yy',
	firstDay: 1,
	isRTL: false,
	showMonthAfterYear: false,
	yearSuffix: ''};
datepicker.setDefaults(datepicker.regional['sr']);

return datepicker.regional['sr'];

}));
