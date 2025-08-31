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
/* NOTE: monthNames are the original months names and they are the Arabic names, not the new months name فبراير - يناير and there isn't any Arabic roots for these months */
(function( factory ) {
	if ( typeof define === "function" && define.amd ) {

		// AMD. Register as an anonymous module.
		define([ "../datepicker" ], factory );
	} else {

		// Browser globals
		factory( jQuery.datepicker );
	}
}(function( datepicker ) {

datepicker.regional['ar'] = {
	closeText: 'إغلاق',
	prevText: '&#x3C;السابق',
	nextText: 'التالي&#x3E;',
	currentText: 'اليوم',
	monthNames: ['كانون الثاني', 'شباط', 'آذار', 'نيسان', 'مايو', 'حزيران',
	'تموز', 'آب', 'أيلول',	'تشرين الأول', 'تشرين الثاني', 'كانون الأول'],
	monthNamesShort: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
	dayNames: ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'],
	dayNamesShort: ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'],
	dayNamesMin: ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س'],
	weekHeader: 'أسبوع',
	dateFormat: 'dd/mm/yy',
	firstDay: 6,
		isRTL: true,
	showMonthAfterYear: false,
	yearSuffix: ''};
datepicker.setDefaults(datepicker.regional['ar']);

return datepicker.regional['ar'];

}));
