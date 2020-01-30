<!--- select a relevant authorization group for workflow processing actors --->

<cfparam name="url.workgroup" default="">

<cfquery name="Workgroup" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
	FROM    Ref_Application
	WHERE   Owner = '#URL.Owner#'
</cfquery>


<cfif WorkGroup.recordcount gte "1">

    <select name="Workgroup" id="Workgroup"  class="regularxl" onChange="updateMission(this.value); updateGroup(document.getElementById('Mission'),this.value); updateRole(this.value);">
    <cfoutput query="Workgroup">
	<option value="#Code#" <cfif url.workgroup eq Code>selected</cfif>>#Description#</option>
	</cfoutput>
    </select>
	
	<script>
	 document.getElementById("save").className = "regular"
	</script>
	

<cfelse>

	<script>
	 document.getElementById("save").className = "hide"
	</script>
	
	<font size="2" color="FF0000">Workflow not configured</font>	
	
</cfif>		

<cfset AjaxOnLoad("initMissionRole")>