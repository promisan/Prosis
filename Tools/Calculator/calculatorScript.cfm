<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="attributes.decimals"		default="2">
<cfparam name="attributes.class"		default="calculator">

<cfoutput>
	<link href="#session.root#/Scripts/Calculator/jquery.calculator.css" rel="stylesheet" />
	<script type="text/javascript" charset="utf-8" src="#session.root#/Scripts/Calculator/jquery.calculator.js"></script>
	
	<script>
		function doCalculator() {
			$("input.#attributes.class#").calculadora({
				decimals: #attributes.decimals#, //  Number of decimals to show in the calculator and in the result value. 
				useCommaAsDecimalMark: false // If true, use the comma to parse the numbers and to show the values.
			});
		}
		
		$(document).ready(function() {
			doCalculator();
		});
	</script>
</cfoutput>