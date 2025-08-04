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

<cfquery name="Parameter"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Parameter
</cfquery>


<cfquery name="ThisAudit"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM ProgramAudit.dbo.ProgramAudit
    WHERE ProgramCode='#URL.ProgramCode#'
	and Period='#URL.Period#'
	and AuditId='#URL.AuditId#'
</cfquery>


<cf_submenuleftscript>

<script language="JavaScript">

function recommendations()

{
   window.urllocation.value = "Recommendation/RecommendationView.cfm?ProgramCode=#URL.ProgramCode#&AuditId=#URL.AuditId#";

   parent.right.location.href = window.urllocation.value

}


</script>

</cfoutput>

<input type="hidden" name="urllocation" id="urllocation" value="AuditViewTop.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.period#&AuditId=#URL.AuditId#">


<cfset fcolor = "002350">


<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" class="menu">
<tr><td>
<cfoutput>
	<cfset heading = "Recommendations">
	<cfset module = "'Program'">
	<cfset selection = "'Audit'">
	<cfset menuclass = "'Recommendations'">
	<cfinclude template="../Tools/SubmenuLeft.cfm">
</cfoutput>


</td>
</tr>
<tr>
   <td><hr></td>
  </tr>

</table>
