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