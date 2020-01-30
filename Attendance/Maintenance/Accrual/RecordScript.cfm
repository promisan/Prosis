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