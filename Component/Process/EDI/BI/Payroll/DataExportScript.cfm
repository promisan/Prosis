
<cfoutput>

	<cfajaximport tags="cfprogressbar,cfdiv">
	
	<script language="JavaScript">
	
		function doXML(transactionId,id) {		
			_cf_loadingtexthtml="";		
			document.getElementById('SendABN').style.display='none';
			ColdFusion.ProgressBar.start('pBar1') ;
		 	ptoken.navigate('#SESSION.root#/Custom/STL/Payroll/DataExport/DoABN.cfm?transactionId='+transactionId+'&id='+id, 'setABN');
		}
		
		
//		function doSUN(transactionId,id) {		
//			_cf_loadingtexthtml="";		
//			document.getElementById('SendSUN').style.display='none';
//			ColdFusion.ProgressBar.start('pBar2') ;
//		 	ptoken.navigate('#SESSION.root#/Custom/STL/Payroll/DataExport/DoSUN.cfm?transactionId='+transactionId+'&id='+id, 'setSUN');
//		}

		function doRefreshABN(transactionId,id) {		
		
			Ext.MessageBox.confirm('Delete', 'Are you sure you want to remove the already generated ABN files?', function(btn){
			   if(btn === 'yes'){
					_cf_loadingtexthtml="";		
					ColdFusion.ProgressBar.start('pBar1') ;
				 	ptoken.navigate('#SESSION.root#/Custom/STL/Payroll/DataExport/DoRefreshABN.cfm?transactionId='+transactionId+'&id='+id, 'setABN');
			   }
			   else{
			      //some code
			   }
			 });		
		}		
		
//		function doRefreshSUN(transactionId,id) {		
		
//			Ext.MessageBox.confirm('Delete', 'Are you sure you want to remove the already generated SUN file?', function(btn){
//			   if(btn === 'yes'){
//					_cf_loadingtexthtml="";		
//					ColdFusion.ProgressBar.start('pBar2') ;
//				 	ptoken.navigate('#SESSION.root#/Custom/STL/Payroll/DataExport/DoRefreshSUN.cfm?transactionId='+transactionId+'&id='+id, 'setSUN');
//			   }
//			   else{
//			      //some code
//			   }
//			 });		
//		}

	
	</script>

</cfoutput>