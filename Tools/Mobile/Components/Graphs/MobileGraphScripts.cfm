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
<cfoutput>
	<script>
		//Add commas to number
		function numberAddCommas(nStr)
		{
			nStr += '';
			x = nStr.split('.');
			x1 = x[0];
			x2 = x.length > 1 ? '.' + x[1] : '';
			var rgx = /(\d+)(\d{3})/;
			while (rgx.test(x1)) {
				x1 = x1.replace(rgx, '$1' + ',' + '$2');
			}
			return x1 + x2;
		}

		//Round to N decimals
		function roundNumber(num, dec) {
			if (dec == 0) { return num; }
			return Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
		}

		//Format labels
		function formatLabels(pValue, pDecimals, pThousands, pPre, pPost) {			
			var vValue = $.trim(pValue);

			if (isNaN(vValue) || vValue == '') { return vValue; }
			if (pThousands) { vValue = vValue / 1000.0; }
			vValue = roundNumber(vValue, pDecimals);
			return pPre + numberAddCommas(vValue) + pPost;
		}

	</script>
</cfoutput>