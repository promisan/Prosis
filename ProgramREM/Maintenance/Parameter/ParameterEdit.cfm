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

<cf_insertClass Code= "Amendment"   Description= "Amendment">	
<cf_insertClass Code= "Snapshot"    Description= "Snapshot Entry">	
<cf_insertClass Code= "Transaction" Description= "Transactional, underlying details">	
<cf_insertClass Code= "Transfer"    Description= "Transfer">	
<cf_insertClass Code= "Update Cell" Description= "Transactional, update snapshot">	

<cfajaximport tags="cfform">

<style>
 
 TD {
	padding : 1px; }
  
 </style>

<cf_screentop html="No" height="100%" jquery="yes" scroll="Yes">
 
<cfquery name="MissionList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ParameterMission
		WHERE 	Mission IN (SELECT Mission 
		                    FROM   Organization.dbo.Ref_MissionModule 
							WHERE  SystemModule = 'Program')  
</cfquery>

<cfparam name="URL.Mission" default="#MissionList.Mission#">

<cfif url.mission eq "">
	<cfset url.mission =  missionList.Mission>
</cfif>

    <cfquery name="Get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
   </cfquery>
 
<script>

 function reload(mis) {
	 window.location = "ParameterEdit.cfm?idmenu=<cfoutput>#url.idmenu#</cfoutput>&mission="+mis
 }
  
 function validate() {
	document.parameter.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
		ColdFusion.navigate('ParameterSubmit.cfm?idmenu=#URL.Idmenu#&mission=#URL.mission#','detail','','','POST','parameter')
	 }   
 }		
</script>

<cfset Page         = "0">
<cfset add          = "0">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfinclude template = "../HeaderMaintain.cfm"> 		

<cfoutput query="get">

<tr><td>

<table width="99%" bgcolor="white" cellspacing="0" cellpadding="0" align="center">
  				
	<tr><td colspan="1">		
	
	<table width="99%" align="center">
	<tr>
	
	
		
	<cf_menuscript>
	
		
	</tr>
	
	<tr>
	
	<td colspan="1" height="30" align="center" style="padding-top:5px">		
	
			
		<!--- top menu --->
				
		<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">		  		
								
			<cfset ht = "64">
			<cfset wd = "64">
					
			<tr class="line">
			
				<td valign="top" style="width:10%;padding-top:12px;padding-left:30px;padding-right:10px">
		
					<select name="mission" id="mission" onchange="Prosis.busy('yes');reload(this.value)" size="1" style="font-size:19px;width:160px;height:30px" class="regularxl">
											<cfloop query="MissionList">
												 <option value="#Mission#" <cfif mission eq "#URL.mission#">selected</cfif>>#Mission#
											</cfloop>
										</select>
						
				</td>	
							
						
					<cf_menutab item       = "1" 					            
					            iconsrc    = "Sub-Modules.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								class      = "highlight1"
								name       = "Sub Modules"
								source     = "ParameterEditModules.cfm?idmenu=#URL.Idmenu#&mission={mission}">			
									
					<cf_menutab item       = "2" 
					            iconsrc    = "Settings-02.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 								
								name       = "Program"
								source     = "ParameterEditProgram.cfm?idmenu=#URL.Idmenu#&mission={mission}">								
								
					<cf_menutab item       = "3" 
					            iconsrc    = "Progress.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 								
								name       = "Progress"
								source     = "ParameterEditProgress.cfm?idmenu=#URL.Idmenu#&mission={mission}">
					
					<cfif EnableDonor eq "0">
					   <cfset itemclass = "hide">					  
					<cfelse>					
					   <cfset itemclass = "">   
					</cfif>   
					
						<cf_menutab item       = "4" 
									itemclass  = "#itemclass#"
						            iconsrc    = "Logos/Program/Donor.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 								
									name       = "Donor"
									source     = "ParameterDonorMenu.cfm?idmenu=#URL.Idmenu#&mission={mission}">
									
										
					<cfif EnableBudget eq "0">
					   <cfset itemclass = "hide">
					<cfelse>
					   <cfset itemclass = "">   
					</cfif> 
															
						<cf_menutab item       = "5" 
									itemclass  = "#itemclass#"	
						            iconsrc    = "Budget.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 								
									name       = "Budget"
									source     = "ParameterBudgetMenu.cfm?idmenu=#URL.Idmenu#&mission={mission}">
									
										
					<cfif EnableIndicator eq "0">
					   <cfset itemclass = "hide">
					<cfelse>
					   <cfset itemclass = "">   
					</cfif> 
															
					  	<cf_menutab item       = "6" 
						        itemclass  = "#itemclass#"
					            iconsrc    = "KPI.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 								
								name       = "KPI Management"
								source     = "ParameterEditKPI.cfm?idmenu=#URL.Idmenu#&mission={mission}">
								
							
											
													
																			 		
				</tr>
		</table>
		
		</td>
		</tr>
					
		<tr><td height="100%">
			
			<table width="100%" 
			      border="0"
				  height="100%"
				  cellspacing="0" 
				  cellpadding="0" 
				  align="center">	  	 		
								
					<cf_menucontainer item="1" class="regular">
					     <cfinclude template="ParameterEditModules.cfm">		
					<cf_menucontainer>
					
					<cf_menucontainer item="2" class="hide">
					<cf_menucontainer>
					
					<cf_menucontainer item="3" class="hide">
					<cf_menucontainer>
					
					<cf_menucontainer item="4" class="hide">
					<cf_menucontainer>
					
					<cf_menucontainer item="5" class="hide">
					<cf_menucontainer>
					
					<cf_menucontainer item="6" class="hide">
					<cf_menucontainer>
								
			</table>
			</td>
	</tr>	
	
	<tr>	
	<td align="center>
	
		<table width="100%" cellspacing="0" cellpadding="0">
				
			<tr><td align="center" class="labelit"><font color="gray">
			Program Setup Parameters are applied per Entity (Mission) and should <b>only</b> be changed if you are absolutely certain of their effect on the system.
			</td></tr>
				
			<tr><td align="center" class="labelit"><font color="gray">In case you have any doubt always consult your assignated focal point.</td></tr>
						
		</table>
		
	</td>	
	</tr>			
	
	</table>
	
	</td></tr>
				
</table>

</cfoutput>
