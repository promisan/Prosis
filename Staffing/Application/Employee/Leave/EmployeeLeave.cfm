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

<cf_screentop height="100%" html="No" scroll="Yes" jquery="Yes"  menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">

<cfajaximport tags="cfdiv,cfform">
<cf_calendarscript>
<cf_actionListingScript>
<cf_FileLibraryScript>

<cfoutput>
	
	<script language="JavaScript">
	
	function workflowdrill(key,box,mode) {
			
			    se = document.getElementById(box)
				ex = document.getElementById("exp"+key)
				co = document.getElementById("col"+key)
					
				if (se.className == "hide") {		
				   se.className = "regular" 		   
				   if (co) co.className = "regular"
				   if (ex) ex.className = "hide"				  
				   ptoken.navigate('#SESSION.root#/staffing/application/employee/leave/EmployeeLeaveEditWorkflow.cfm?ajaxid='+key,key)		   			  
				} else {  se.className = "hide"
				          if (ex) ex.className = "regular"
				   	      if (co) co.className = "hide" 
			    } 		
			}		
			
	function deduction(id) {
	
	    ProsisUI.createWindow('deduction', 'Amend deduction','', {height:document.body.clientHeight-80,width:500,modal:true,closable:true,center:true,minheight:200,minwidth:200 });
		ptoken.navigate('#SESSION.root#/staffing/application/Employee/Leave/Deduct/DeductionEdit.cfm?leaveid='+id,'deduction')	
		
	}		
	
	function deductionsave(id) {
	    
		_cf_loadingtexthtml='';	
	    ptoken.navigate('#SESSION.root#/staffing/application/Employee/Leave/Deduct/DeductionEditSubmit.cfm?leaveid='+id,'deduct_'+id,'','','POST','formdeduction')
	}
	
	function balancecorrection(id,bal) {
	
	    ptoken.open('#SESSION.root#/payroll/application/overtime/overtimeEntryCorrection.cfm?id='+id+'&balanceid='+bal)
		
	}
	
	</script>
		
	<cfparam name="URL.Mode" default="records">
	
	<table width="100%" height="100%" align="center">
	
		<tr>
			<td height="10" style="padding-top:3px;padding-left:7px;padding-bottom:3px">			
				  <cfset ctr      = "0">		
			      <cfset openmode = "close"> 
				  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
			 </td>
		</tr>	
		
		<tr><td height="100%" width="100%" align="center">
		        
				<table width="100%" height="100%">
				<tr><td style="padding-left:10px"><cfinclude template="EmployeeLeaveTab.cfm"></td></tr>
				</table>	
				
			</td>
		</tr>
		
	</table>

</cfoutput>
