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
<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No">

<cf_insertAreaGLedger Area="Production"    Description="Production" BillingEntry="0">
<cf_insertAreaGLedger Area="Receivable"    Description="Receivable" BillingEntry="0">
<cf_insertAreaGLedger Area="Income"        Description="Income"     BillingEntry="0">
<cf_insertAreaGLedger Area="Return"        Description="Return"     BillingEntry="0">
<cf_insertAreaGLedger Area="Shipping"      Description="Shipping"   BillingEntry="1">
<cf_insertAreaGLedger Area="Insurance"     Description="Insurance"  BillingEntry="1">
<cf_insertAreaGLedger Area="Discount"      Description="Discount"   BillingEntry="1">

<cf_insertResourceMode Code="Purchase"    Description="Acquisition and Receipt">
<cf_insertResourceMode Code="None"        Description="Not applicable">
<cf_insertResourceMode Code="Receipt"     Description="Provided by 3rd party">

<cf_menuscript>
<cf_calendarscript>
<cf_dialogLedger>
 
<cfquery name="MissionList" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission	
	WHERE  Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'WorkOrder')
</cfquery>

<cfajaximport tags="cfform,cfwindow,cfdiv">
<cfinclude template="../../../System/EntityAction/EntityFlow/EntityAction/EntityScript.cfm">
<cfparam name="URL.Mission" default="#MissionList.Mission#">
 
<script> 

 function reload(mis) {
	 window.location = "ParameterEdit.cfm?idmenu=<cfoutput>#URL.Idmenu#</cfoutput>&mission="+mis
 }
 
 function applyaccount(acc,area) {
 	ptoken.navigate('setaccount.cfm?account='+acc+'&area='+area,'process')
 }
 
</script>

<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	
		
<!--- Entry form --->

<table width="96%" cellspacing="1" cellpadding="1" align="center">
		
	<tr>
		
	<td valign="top">
	
		<table width="100%" cellspacing="2" cellpadding="2">
			
			<tr><td height="4"></td></tr>
			<tr><td class="labelit"><b><font color="6688aa">Attention:</td></tr>
			<tr><td height="3"></td></tr>
			<tr><td class="labelit"><font color="808080">
			Workorder Setup Parameters are applied per Entity (Mission) and should <b>only</b> be changed if you are absolutely certain of their effect on the system.
			</td></tr>
			<tr><td height="5"></td></tr>			
			<tr><td class="labelit"><font color="808080">In case you have any doubt always consult your assigned focal point.</td></tr>
			<tr><td height="5"></td></tr>
			
		</table>
		
	</td>
	</tr>
	
	<tr><td colspan="2" height="1" class="line"></td></tr>			
	<tr><td valign="top" width="800">			
	
	<!--- top menu --->
				
		<table border="0" width="100%" align="center" class="formpadding" cellspacing="0" cellpadding="0">		  		
						
			<cfset ht = "64">
			<cfset wd = "64">
							
			<tr>					
					<td width="3%" align="center" style="padding-right:4px">
					<select name="selmis" id="selmis" size="3" style="width:130px;height:69px;" class="regularxl" onChange="document.getElementById('menu1').click()">
					
						<cfoutput query="MissionList">
						 <option value="#Mission#" <cfif currentrow eq "1" or mission eq "#URL.mission#">selected</cfif>>#Mission#
						</cfoutput>		
				
					</select>					
					</td>
					
					<cf_menutab item       = "1" 
					            iconsrc    = "Logos/WorkOrder/General.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								padding    = "0"
								class      = "highlight1"
								name       = "General Settings"
								source     = "ParameterEditMiscellaneous.cfm?ID1={selmis}">																					
					
					<cf_menutab item       = "2" 
					            iconsrc    = "Logos/WorkOrder/Order.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								padding    = "0"
								targetitem = "1"								
								name       = "Request and Workorder"
								source     = "ParameterEditWorkOrderRequisition.cfm?ID1={selmis}">															
								
					<cf_menutab item       = "3" 
					            iconsrc    = "Logos/WorkOrder/Billing.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								padding    = "0"
								targetitem = "1"								
								name       = "General Ledger"
								source     = "ParameterEditGeneralLedger.cfm?ID1={selmis}">
										
		</table>
		
		
		</td>							
	
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>

	<tr><td height="100%">
	<cf_menucontainer item="1" class="regular">		
		<cfinclude template="ParameterEditMiscellaneous.cfm">
	</cf_menucontainer>
	</td></tr>				
	
	
</table>