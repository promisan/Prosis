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
<cf_screentop height="100%" scroll="Yes" html="No">

<cfoutput>

<cfsavecontent variable="SearchingRoles">
	   		 'ProcReqEntry',
			 'ProcReqReview',
			 'ProcReqObject',
			 'ProcReqCertify',
 			 'ProcManager',
			 'ProcAcc',
			 'ProcAccManager'
</cfsavecontent>

<cfquery name="Missions" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 SELECT DISTINCT A.Mission as qMission
 FROM   OrganizationAuthorization A 
 WHERE  A.UserAccount = '#SESSION.acc#'
 AND    A.Role IN (#preserveSingleQuotes(SearchingRoles)#)
</cfquery>


<cfparam name="url.Mission" default="#Missions.qMission#">
<cfparam name="url.ID" default="LOC">
<cfparam name="url.ID1" default="Locate">
<cfparam name="url.mode" default="all">

<script language="JavaScript">

function reloadMe() {
	sm = document.getElementById("sMission").value	
	window.location = "RequisitionView.cfm?mission="+sm
}

</script>

	<table width="100%" height="100%" border="0">
	<tr>
		<td height="10" width="5%"></td>

		<td height="80" valign="middle" align="left" width="98%" style="top; padding-left:10px">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden">
				<tr>
					<td style="z-index:1; width:646px; height:78px; position:absolute; right:0px; top:0px; background-image:url(#SESSION.root#/images/logos/BGV2.png); background-repeat:no-repeat">
					</td>
				</tr>
				<!---
				<tr>
					<td width="1500" height="80px" style="z-index:0; position:absolute; top:0px; left:0px; background-image:url(#SESSION.root#/images/logos/BG.jpg); background-repeat: repeat-x; background-position: top;">
					</td>
				</tr>--->
				<tr>
					<td style="z-index:5; position:absolute; top:23px; left:35px; ">
						<img src="#SESSION.root#/images/logos/Staffing/Staffing_Inquiry.jpg">
					</td>
				</tr>
				<tr>
					<td style="z-index:3; position:absolute; top:25px; left:90px; color:45617d; font-family:calibri; font-size:25px; font-weight:bold;">
						Procurement
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:5px; left:90px; color:e9f4ff; font-family:calibri; font-size:55px; font-weight:bold; z-index:2">
						Procurement
					</td>
				</tr>
				
				<tr>
					<td style="padding-left:8px;padding-top:4px;position:absolute; top:50px; left:90px; color:45617d; font-family:calibri; font-size:12px; font-weight:bold; z-index:4">
														
						<select name="sMission" id="sMission" class="regularxl" onChange="reloadMe()">
						<cfloop query="Missions">
						 	<option value="#qMission#" <cfif URL.Mission eq qMission>selected</cfif>>#qMission#</option>
						</cfloop>
						
					</td>
				</tr>
				
			</table>
		</td>
	</tr>
			
	<tr>
		<td height="100%" valign="top" colspan="2" style="padding-left:10px;padding-right:15px">	
		    <cfset url.id1 = "locate">	
			<cfinclude template="../../Application/Requisition/RequisitionView/RequisitionViewView.cfm">
		</td>
	</tr>
		
	</table>
	
</cfoutput>
