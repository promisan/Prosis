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
<cfoutput>

	<script language="JavaScript1.2">
	
	function showtreerole(role) {
	
	mis = document.getElementById("mission")
	w = #CLIENT.width# - 100;
	h = #CLIENT.height# - 150;
	window.open("#SESSION.root#/System/Organization/Access/OrganizationRolesView.cfm?Mission="+mission.value+"&Class=" + role, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes")
	
	}
	
	function showtext(r) {
	se = document.getElementById(r)
	
	if (se.className == "regular")
		{ se.className = "hide" 
	  } else { 
	     se.className = "regular" }
	  }
	
	</script>
	
</cfoutput>

<table width="100%" border="0" frame="hsides" bordercolor="silver" cellspacing="0" cellpadding="0" align="center">

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    Ref_Mission
WHERE  Mission IN (SELECT Mission FROM Ref_MissionModule WHERE SystemModule IN (SELECT SystemModule FROM Ref_AuthorizationRole))  
AND Operational = 1
<cfif SESSION.isAdministrator eq "No">
AND     Mission IN (SELECT Mission 
                    FROM   OrganizationAuthorization
					WHERE  Role = 'OrgUnitManager'
					AND    UserAccount = '#SESSION.acc#')
					</cfif>
</cfquery>

<cfparam name="URL.Mission" default="#Mission.Mission#">
<tr><td>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" class="formpadding">	
	<tr><td height="5"></td></tr>	
	<tr>
	  <td width="20%" height="20">&nbsp;&nbsp;Select tree:&nbsp;
	  <select name="mission" id="mission" onChange="reloadform(this.value)">
	   <cfoutput query="Mission">
	   <option value="#Mission#" <cfif #Mission# eq "#URL.Mission#">selected</cfif>>#Mission#</option>
	   </cfoutput>
	  </select>
	  </td>
	</tr>	
	<tr><td height="5"></td></tr>
	<tr><td id="treedet">
		<cfinclude template="OrganizationRolesDetail.cfm">
	</td></tr>
	</table>
	
</td></tr>
	
</table>	
