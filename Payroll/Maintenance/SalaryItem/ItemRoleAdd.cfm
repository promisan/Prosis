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


<cfquery name="Role" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AuthorizationRole  
	WHERE  Role = '#URL.Role#'
</cfquery>

<table cellspacing="0" cellpadding="0">
<tr class="fixlengthlist">
<cfif role.recordcount eq "1">
	
	<cfset label = ListToArray(Role.AccessLevelLabelList)>
		   
	<cfoutput>
	  <cfloop index="lvl" from="0" to="#role.accessLevels-1#">
	      <cftry><td class="labelmedium">#label[lvl+1]#:<cfcatch>l:#lvl#</cfcatch></td></cftry>
		  <td style="padding-left:4px;padding-right:12px"><input class="radiol" type="checkbox" name="AccessLevelList" id="AccessLevelList" checked value="#lvl#"></td>
	  </cfloop>
	</cfoutput>

	<script>
		document.getElementById("add").className = "button10g"
	</script>
	
<cfelse>

	<script>
		document.getElementById("add").className = "hide"
	</script>
	
</cfif>
</tr>
</table>