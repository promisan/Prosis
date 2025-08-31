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
/* Jalali calendar should supported soon! (Its implemented but I have to test it) */
(function( factory ) {
	if ( typeof define === "function" && define.amd ) {

		// AMD. Register as an anonymous module.
		define([ "../datepicker" ], factory );
	} else {

		// Browser globals
		factory( jQuery.datepicker );
	}
}(function( datepicker ) {

datepicker.regional['fa'] = {
	closeText: 'بستن',
	prevText: '&#x3C;قبلی',
	nextText: 'بعدی&#x3E;',
	currentText: 'امروز',
	monthNames: [
		'ژانویه',
		'فوریه',
		'مارس',
		'آوریل',
		'مه',
		'ژوئن',
		'ژوئیه',
		'اوت',
		'سپتامبر',
		'اکتبر',
		'نوامبر',
		'دسامبر'
	],
	monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
	dayNames: [
		'يکشنبه',
		'دوشنبه',
		'سه‌شنبه',
		'چهارشنبه',
		'پنجشنبه',
		'جمعه',
		'شنبه'
	],
	dayNamesShort: [
		'ی',
		'د',
		'س',
		'چ',
		'پ',
		'ج',
		'ش'
	],
	dayNamesMin: [
		'ی',
		'د',
		'س',
		'چ',
		'پ',
		'ج',
		'ش'
	],
	weekHeader: 'هف',
	dateFormat: 'yy/mm/dd',
	firstDay: 6,
	isRTL: true,
	showMonthAfterYear: false,
	yearSuffix: ''};
datepicker.setDefaults(datepicker.regional['fa']);

return datepicker.regional['fa'];

}));
