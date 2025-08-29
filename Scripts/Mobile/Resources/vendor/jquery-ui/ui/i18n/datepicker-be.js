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

datepicker.regional['be'] = {
	closeText: 'Зачыніць',
	prevText: '&larr;Папяр.',
	nextText: 'Наст.&rarr;',
	currentText: 'Сёньня',
	monthNames: ['Студзень','Люты','Сакавік','Красавік','Травень','Чэрвень',
	'Ліпень','Жнівень','Верасень','Кастрычнік','Лістапад','Сьнежань'],
	monthNamesShort: ['Сту','Лют','Сак','Кра','Тра','Чэр',
	'Ліп','Жні','Вер','Кас','Ліс','Сьн'],
	dayNames: ['нядзеля','панядзелак','аўторак','серада','чацьвер','пятніца','субота'],
	dayNamesShort: ['ндз','пнд','аўт','срд','чцв','птн','сбт'],
	dayNamesMin: ['Нд','Пн','Аў','Ср','Чц','Пт','Сб'],
	weekHeader: 'Тд',
	dateFormat: 'dd.mm.yy',
	firstDay: 1,
	isRTL: false,
	showMonthAfterYear: false,
	yearSuffix: ''};
datepicker.setDefaults(datepicker.regional['be']);

return datepicker.regional['be'];

}));
