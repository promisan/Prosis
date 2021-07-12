

<cfoutput>

	<cfajaximport tags="cfprogressbar,cfdiv">
	
	<script language="JavaScript">
	
		function doPrepare(transactionId) {		
			_cf_loadingtexthtml="";		
			document.getElementById('Send').style.display='none';
			ColdFusion.ProgressBar.start('pBar') ;
		 	ptoken.navigate('#SESSION.root#/Payroll/Application/Payroll/SalarySlipPrintBatch.cfm?transactionId='+transactionId, 'setdocument');
		}
	
	</script>

</cfoutput>