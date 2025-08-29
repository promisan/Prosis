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

datepicker.regional['hr'] = {
	closeText: 'Zatvori',
	prevText: '&#x3C;',
	nextText: '&#x3E;',
	currentText: 'Danas',
	monthNames: ['Siječanj','Veljača','Ožujak','Travanj','Svibanj','Lipanj',
	'Srpanj','Kolovoz','Rujan','Listopad','Studeni','Prosinac'],
	monthNamesShort: ['Sij','Velj','Ožu','Tra','Svi','Lip',
	'Srp','Kol','Ruj','Lis','Stu','Pro'],
	dayNames: ['Nedjelja','Ponedjeljak','Utorak','Srijeda','Četvrtak','Petak','Subota'],
	dayNamesShort: ['Ned','Pon','Uto','Sri','Čet','Pet','Sub'],
	dayNamesMin: ['Ne','Po','Ut','Sr','Če','Pe','Su'],
	weekHeader: 'Tje',
	dateFormat: 'dd.mm.yy.',
	firstDay: 1,
	isRTL: false,
	showMonthAfterYear: false,
	yearSuffix: ''};
datepicker.setDefaults(datepicker.regional['hr']);

return datepicker.regional['hr'];

}));
