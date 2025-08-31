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

datepicker.regional['eo'] = {
	closeText: 'Fermi',
	prevText: '&#x3C;Anta',
	nextText: 'Sekv&#x3E;',
	currentText: 'Nuna',
	monthNames: ['Januaro','Februaro','Marto','Aprilo','Majo','Junio',
	'Julio','Aŭgusto','Septembro','Oktobro','Novembro','Decembro'],
	monthNamesShort: ['Jan','Feb','Mar','Apr','Maj','Jun',
	'Jul','Aŭg','Sep','Okt','Nov','Dec'],
	dayNames: ['Dimanĉo','Lundo','Mardo','Merkredo','Ĵaŭdo','Vendredo','Sabato'],
	dayNamesShort: ['Dim','Lun','Mar','Mer','Ĵaŭ','Ven','Sab'],
	dayNamesMin: ['Di','Lu','Ma','Me','Ĵa','Ve','Sa'],
	weekHeader: 'Sb',
	dateFormat: 'dd/mm/yy',
	firstDay: 0,
	isRTL: false,
	showMonthAfterYear: false,
	yearSuffix: ''};
datepicker.setDefaults(datepicker.regional['eo']);

return datepicker.regional['eo'];

}));
