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

datepicker.regional['hi'] = {
	closeText: 'बंद',
	prevText: 'पिछला',
	nextText: 'अगला',
	currentText: 'आज',
	monthNames: ['जनवरी ','फरवरी','मार्च','अप्रेल','मई','जून',
	'जूलाई','अगस्त ','सितम्बर','अक्टूबर','नवम्बर','दिसम्बर'],
	monthNamesShort: ['जन', 'फर', 'मार्च', 'अप्रेल', 'मई', 'जून',
	'जूलाई', 'अग', 'सित', 'अक्ट', 'नव', 'दि'],
	dayNames: ['रविवार', 'सोमवार', 'मंगलवार', 'बुधवार', 'गुरुवार', 'शुक्रवार', 'शनिवार'],
	dayNamesShort: ['रवि', 'सोम', 'मंगल', 'बुध', 'गुरु', 'शुक्र', 'शनि'],
	dayNamesMin: ['रवि', 'सोम', 'मंगल', 'बुध', 'गुरु', 'शुक्र', 'शनि'],
	weekHeader: 'हफ्ता',
	dateFormat: 'dd/mm/yy',
	firstDay: 1,
	isRTL: false,
	showMonthAfterYear: false,
	yearSuffix: ''};
datepicker.setDefaults(datepicker.regional['hi']);

return datepicker.regional['hi'];

}));
