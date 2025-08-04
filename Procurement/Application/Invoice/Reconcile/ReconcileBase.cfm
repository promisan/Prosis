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

<body leftmargin="4" topmargin="4" rightmargin="4" bottommargin="4">

<cfoutput>

<cftry>

	<cfquery name="Check" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT top 1 * 
		FROM stReconciliationIMIS
	</cfquery>	
			
	<cfcatch>
		Function is not enabled
		<cfabort>
	</cfcatch>	
		
</cftry>		

<cf_screentop html="No" jquery="Yes">

<cfajaximport tags="cfwindow">

<script language="JavaScript">
	
	function setstatus(TransactionNo,act)	{
	  
		if (act == "0")	{ 	
			
			ColdFusion.navigate('DialogAddProcess.cfm?Mission=#url.mission#&TransactionNo='+TransactionNo+'&act=0','td'+TransactionNo)														
			
		} else { 		
		    
			try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
			ColdFusion.Window.create('mydialog', 'Manual', '',{x:100,y:100,height:640,width:670,modal:true,resizable:false,center:true})    
			ColdFusion.navigate('DialogAdd.cfm?Mission=#url.mission#&TransactionNo='+TransactionNo,'mydialog') 
						
		}    
	}
	
	function setprocess(prg,per,gla,obj,tra,act) {				
		
		ColdFusion.navigate('DialogAddProcess.cfm?ObjectCode='+obj+'&GLAccount='+gla+'&Period='+per+'&ProgramCode='+prg+'&TransactionNo='+tra+'&act='+act,'td'+tra)															
		ColdFusion.Window.destroy('mydialog',true)	
	}
	
	
	
	function processinvoice() {  
	    _cf_loadingtexthtml='';	
	    ColdFusion.navigate('ReconcileResult.cfm?period=#url.period#&mission=#url.mission#','reconcile','','','POST','formreconcile')	
	}
	
	function matchinvoice() {  
	    _cf_loadingtexthtml='';	    
	    ColdFusion.navigate('ReconcileResult.cfm?mode=save&period=#url.period#&mission=#url.mission#','reconcile','','','POST','formreconcile')	
	}
	
	function deleteline(id) {
	    se = document.getElementById(id) 
		se.checked = false
		processinvoice()
	}
	
</script>

<cf_dialogProcurement>

<form name="formreconcile" id="formreconcile">
	<table width="100%" height="100%" cellspacing="0" cellpadding="0">
		
		<tr><td id="base">	
		
			<cfinclude template="ReconcileView.cfm">
		
			</td>
		</tr>
	
	</table>
</form>
</cfoutput>

</body>
