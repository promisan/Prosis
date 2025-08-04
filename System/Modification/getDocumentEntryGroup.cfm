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
<!--- select a relevant authorization group --->

<cfparam name="url.selected"   default="">
<cfparam name="url.scope"      default="amend">
<cfparam name="url.entitycode" default="">
<cfparam name="url.owner"      default="">

<cfquery name="Workgroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Ref_EntityGroup
		WHERE   EntityCode = '#url.entityCode#'
		AND (Owner is NULL or Owner = '#URL.Owner#')
		AND  Operational = 1
</cfquery>

<cfif WorkGroup.recordcount gte "1">

    <cfoutput>
    <select name="#url.scope#Workgroup" id="#url.scope#Workgroup" class="regularxxl enterastab">
	 	<cfif WorkGroup.recordcount gt 1>
		 	<option value="0">[Select]</option>
		</cfif>
	    <cfloop query="Workgroup">
		<option value="#EntityGroup#" <cfif EntityGroup eq url.selected> selected </cfif>>#EntityGroupName#</option>
		</cfloop>
    </select>
	</cfoutput>
		
	<script>
		 b = document.getElementById("Save");
		 if (b)
		     b.className = "button10g"
	</script>
		
<cfelse>
	
	<script>
		 b = document.getElementById("Save");
		 if (b)
			 b.className = "hide"
	</script>
	
	<table><tr><td class="labelmedium2">
		
	<font color="FF0000">Workflow not configured</font>	
	
	</td></tr></table>
		
</cfif>		