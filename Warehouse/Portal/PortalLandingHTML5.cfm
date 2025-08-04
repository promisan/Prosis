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



<!--- 1. pass the mission and check if user has been granted request rights --->

<cfparam name="url.idmenu" default="">
<cfparam name="url.systemfunctionid" default="#url.idmenu#">
<cfparam name="URL.Mission" default="Promisan">

<cfset access = "ALL">

<cfoutput>

<cfif access eq "NONE">

	<table align="center"><tr><td height="60" class="labelit">
	   No access was granted to your account to manage stock request and/or taskorder</font>
	      </td></tr>
	</table>
	<cfabort>

</cfif>

</cfoutput>

<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
</cfquery>
	
<cfajaximport tags="cfwindow,cfform,cfinput-datefield,cfdiv">

<cf_screentop html="No" jQuery="Yes">  <!--- 2/11/2012 this is superseded by the parent screen called Portal/Extended/LogonProcessMenu.cfm line 114 --->

<cf_dialogMaterial>
<cf_dialogProcurement>

<cf_ActionListingScript>
<cf_calendarViewscript>
<cf_fileLibraryScript>
<cf_presentationScript>
<cf_CalendarScript>
<cf_LayoutScript>
<cf_listingscript mode="regular">

<cfinclude template="ProcessScript.cfm">

<cfparam name="URL.Status" default="1">
<cfparam name="URL.Id"     default="0">
<cfparam name="URL.Mode"   default="regular">

<div style="width:100%; height:100%;">

	<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		
		<tr>
			<td id="portalcontent" height="100%">	
				
				<!--- main page for services --->
		
				<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">	  		
					<tr>
						<td height="100%">
							<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">						
								<tr>
									<td id="menucontent" name="menucontent" align="center" height="100%" valign="top">																								
										<cfinclude template="../../Portal/SelfService/HTML5/PortalFunctionOpen.cfm"> 
									</td>
								</tr>
							</table>
						</td>
					</tr>			
				</table>
											
			</td>
		</tr>				
				
	</table>

</div>
