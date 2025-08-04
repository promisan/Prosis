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
<cfinclude template="../../../Tools/CFReport/Anonymous/PublicInit.cfm">

<HTML><HEAD>
	<TITLE>Parameters - Edit Form</TITLE>
</HEAD><body leftmargin="4" topmargin="4" rightmargin="4" bottommargin="4">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<style>
 
 TD {
	padding : 2px; }  
 </style> 
 
 <cf_screentop html="No" jquery="Yes">
 
<cfquery name="MissionList" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission IN (SELECT Mission 
    	               FROM   Organization.dbo.Ref_MissionModule 
					   WHERE  SystemModule = 'Staffing')
	AND    Mission IN (SELECT Mission
	                   FROM   Organization.dbo.Ref_Mission
					   WHERE  Operational = 1)					   
</cfquery>

<cfajaximport tags="cfform,cfdiv">
<cfinclude template="../../../System/EntityAction/EntityFlow/EntityAction/EntityScript.cfm">
<cfinclude template="InsertActionData.cfm">
<cfparam name="URL.Mission" default="#MissionList.Mission#">
 
<script> 
 function reload(mis) {
	 window.location = "ParameterEdit.cfm?idmenu=<cfoutput>#URL.Idmenu#</cfoutput>&mission="+mis
 }
</script>

<cf_menuscript>

<table height="100%" width="100%">
<tr>
<td height="8%">
	
	<cfset Page         = "0">
	<cfset add          = "0">
	<cfset save         = "0"> 
	<cfinclude template = "../HeaderMaintain.cfm"> 	
		
</td>
</tr>

<tr>
<td height="94%" valign="top">

	<table height="100%" width="97%" align="center">
							
		<tr><td valign="top" width="800">		
		
		<!--- top menu --->
					
			<table width="100%" align="center">		  		
							
				<cfset ht = "40">
				<cfset wd = "40">
								
				<tr class="line">					
							
						<cf_menutab item       = "1" 
						            iconsrc    = "Logos/System/Global.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									padding    = "0"
									class      = "highlight1"
									name       = "Global Settings (all entities)"
									source     = "ParameterEditMiscellaneous.cfm">										
						
						<td width="3%" align="center">
						<select name="selmis" id="selmis" class="regularxxl" style="background-color:f1f1f1;border:0px;font-size:27px;height:55;width:230px" 
						   onChange="document.getElementById('menu2').click()">
						
							<cfoutput query="MissionList">
							 <option value="#Mission#" <cfif mission eq "#URL.mission#">selected</cfif>>#Mission#
							</cfoutput>		
					
						</select>					
						</td>				
						
						<cf_menutab item       = "2" 
						            iconsrc    = "Logos/Staffing/Staffing.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									padding    = "0"
									targetitem = "1"								
									name       = "Staffing table"
									source     = "ParameterEditStaffing.cfm?mission={selmis}">		
									
						<cf_menutab item       = "3" 
						            iconsrc    = "Logos/Staffing/Contract.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									padding    = "0"
									targetitem = "1"								
									name       = "Contract and Appointment"
									source     = "ParameterEditContract.cfm?mission={selmis}">		
									
						<cf_menutab item       = "4" 
						            iconsrc    = "Logos/Attendance/Schedule.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									padding    = "0"
									targetitem = "1"								
									name       = "Time and attendance"
									source     = "ParameterEditLeave.cfm?mission={selmis}">									
											
			</table>
			
			
			</td>							
		
		</tr>
		
		<tr><td height="100%">
			<cf_divscroll>
			<table width="100%" height="100%">
				<cf_menucontainer item="1" class="regular">
					<cfinclude template="ParameterEditMiscellaneous.cfm">
				</cf_menucontainer>
			</table>
			</cf_divscroll>
		</td></tr>	
				
	</table>

</td>

</tr>

<tr>
		
	<td class="line" valign="top">
	
		<table align="center" class="formpadding">						
			
			<tr><td  align="center" class="labelit">
			Staffing Setup Parameters are applied per Entity (Mission) and should <b>only</b> be changed if you are absolutely certain of their effect on the system.
			</td></tr>				
			<tr><td  align="center" class="labelit">In case you have any doubt always consult your assignated focal point.</td></tr>
			<tr><td height="5"></td></tr>
			
		</table>
		
	</td>
	</tr>

</table>
