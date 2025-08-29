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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  banner="gray" 
			  bannerforce="Yes"
			  layout="webapp" 
			  jquery="Yes"
			  label="Payroll Items and Posting" 
			  option="Maintain salary items and Ledger posting"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfparam name="URL.ID1" default="">

<cfajaximport tags="cfform,cfdiv">
<cf_dialogLedger>
<cf_menuscript>

<cfoutput>
<script language="JavaScript">

function validate() {
    Prosis.busy('yes')	
	document.getElementById('formschedule').onsubmit() 
	if( _CF_error_messages.length == 0 ) {    	    	    
		_cf_loadingtexthtml='';	
		ptoken.navigate('PayrollScheduleSubmit.cfm?idMenu=#url.idmenu#','contentbox1','','','POST','formschedule')
	 }   
}	 

function ask() {
	if (confirm("Do you want to remove this item?")) {
		return true 
	}
	return false	
}

function removeAccount(row) {
	document.getElementById('glaccount_'+row).value = '';
	document.getElementById('glaccountname_'+row).value = '';	
}

function removeLiability(row) {
	document.getElementById('glaccountliability_'+row).value = '';
	document.getElementById('glaccountliabilityname_'+row).value = '';	
}

function applyaccount(acc,scope,fld) {
     ptoken.navigate('#session.root#/Payroll/Maintenance/SalaryItem/setAccount.cfm?field='+fld+'&account='+acc+'&scope='+scope,'processaccount')
}  

</script>

</cfoutput>

<table width="99%"
	   height="100%"
	   align="center">

	<tr>
		<td align="center" valign="top" style="padding:1px">
		
			<table width="100%" align="center">
				<tr>
				
				<cfset wd = "64">
				<cfset ht = "64">
				
				<cf_menutab item  = "1" 
			       iconsrc    = "Settings-02.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   class      = "highlight1"
				   name       = "General Settings"
				   source     = "RecordEdit.cfm?id1=#url.id1#&idMenu=#url.idmenu#">
				   
				<cfif url.id1 neq "">
				   
					 <cf_menutab item  = "2" 
				       iconsrc    = "Logos/System/Maintain.png" 
					   iconwidth  = "#wd#" 
					   iconheight = "#ht#" 
					   targetitem = "1"
					   name       = "Payroll and Ledger Posting"
					   source     = "PayrollSchedule.cfm?id1=#url.id1#&idMenu=#url.idmenu#">
				
				</cfif>
				
				<cfif url.id1 neq "">
				   
				 <cf_menutab item  = "3" 
			       iconsrc    = "Authorization.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "Grant access"
				   source     = "ItemRole.cfm?id=#url.id1#&idMenu=#url.idmenu#">
				
				</cfif>
				
				<td style="width:20%"></td>
				 
				 </tr>
			 </table>
		
		<td>
	</tr>
	<tr><td class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
	<td height="100%" valign="top">
	   <cf_divscroll>
	   <table width="100%" height="100%">
		<cf_menucontainer item="1" class="regular">
			 <cfinclude template="RecordEdit.cfm"> 
	 	<cf_menucontainer>	
	   </table>	
	   </cf_divscroll>
	</td>
	</tr>
	<tr><td height="1"></td></tr>
</table>

<cf_screenbottom layout="innerbox">