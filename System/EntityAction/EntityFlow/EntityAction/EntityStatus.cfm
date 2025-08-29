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
 <cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityMission
		WHERE  EntityCode = '#url.EntityCode#'
		AND    Mission    = '#url.Mission#'
</cfquery>

<cfoutput>

<table cellspacing="0" cellpadding="0">
	<tr>
    	<td style="padding-top:2px">	
		 <cf_img icon="edit" onClick="entityedit('#url.entityCode#','#url.mission#')">		 			  
		</td>
		<td>&nbsp;</td>
		<td height="21" class="labelmedium">			 
		 <a href="javascript:entityedit('#url.entityCode#','#url.mission#')">
		 <cfif check.WorkflowEnabled eq "1"><font color="008000">Enabled<cfelse><font color="gray">Disabled</cfif>
		 </a>
		</td>
				
	</tr>
</table>
</cfoutput>		  
