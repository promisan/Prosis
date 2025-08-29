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

datepicker.regional['he'] = {
	closeText: 'סגור',
	prevText: '&#x3C;הקודם',
	nextText: 'הבא&#x3E;',
	currentText: 'היום',
	monthNames: ['ינואר','פברואר','מרץ','אפריל','מאי','יוני',
	'יולי','אוגוסט','ספטמבר','אוקטובר','נובמבר','דצמבר'],
	monthNamesShort: ['ינו','פבר','מרץ','אפר','מאי','יוני',
	'יולי','אוג','ספט','אוק','נוב','דצמ'],
	dayNames: ['ראשון','שני','שלישי','רביעי','חמישי','שישי','שבת'],
	dayNamesShort: ['א\'','ב\'','ג\'','ד\'','ה\'','ו\'','שבת'],
	dayNamesMin: ['א\'','ב\'','ג\'','ד\'','ה\'','ו\'','שבת'],
	weekHeader: 'Wk',
	dateFormat: 'dd/mm/yy',
	firstDay: 0,
	isRTL: true,
	showMonthAfterYear: false,
	yearSuffix: ''};
datepicker.setDefaults(datepicker.regional['he']);

return datepicker.regional['he'];

}));
