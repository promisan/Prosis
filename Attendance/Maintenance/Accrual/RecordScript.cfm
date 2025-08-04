<!--
    Copyright © 2025 Promisan

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
<cf_tl id="Remove this line ?" var="lblRemove">
<cf_tl id="Do you want to remove this leave accrual record?" var="lblRemoveRec">

<cfoutput>
	<script>
		
		function ask() {
			if (confirm('#lblRemoveRec#')) {
				return true 
			}
			return false	
		}	
		
		function toggleCreditCalculation(c){
			if (c.value == 'Contract') {
				$('.clsCreditCalculation').hide();
				$('.clsCreditEntitlement').show();
			} else {
				$('.clsCreditCalculation').show();
				$('.clsCreditEntitlement').hide();
			}
		}
		
		function updateCountCreditRows() {
			if ($('.clsCreditRows').length == 0) {
				$('##CountCreditRows').val(0);
			} else {
				$('##CountCreditRows').val($('.clsCreditRows').last().attr('data-val'));
			}
		}
		
		function removeCreditLine(n){
			$('##CreditRow_'+n).remove();			
			updateCountCreditRows();
		}
		
		function addCreditLine(){
			var vNewRow = 1;
			if ($('.clsCreditRows').length > 0) {
				vNewRow = parseInt($('.clsCreditRows').last().attr('data-val')) + 1;
			}
			window['__AddCreditLineCB'] = function(){
				$('.clsCreditListing').append($('##divNewElement').html());
				$('##divNewElement').html('')
				updateCountCreditRows();
			};
			ptoken.navigate('#session.root#/Attendance/Maintenance/Accrual/CreditLine.cfm?style=background-color:C1FDC9;&currentRow='+vNewRow, 'divNewElement', '__AddCreditLineCB');
		}
	
	</script>
</cfoutput>