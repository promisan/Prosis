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