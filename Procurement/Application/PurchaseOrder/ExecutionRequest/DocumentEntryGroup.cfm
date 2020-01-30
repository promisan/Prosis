<!--- select a relevant authorization group --->

	<cfquery name="Workgroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Ref_EntityGroup
		WHERE EntityCode = 'ProcExecution'
		<!---
		AND (Owner is NULL or Owner = '#URL.Owner#')
		--->
	</cfquery>
	
	<cfif WorkGroup.recordcount gte "1">
	
	    <select name="Workgroup" id="Workgroup" class="regularxl">
	    <cfoutput query="Workgroup">
		<option value="#EntityGroup#">#EntityGroupName#</option>
		</cfoutput>
	    </select>
			
	<cfelse>
	
		<script>
		 document.getElementById("group").className = "hide"
		</script>
								
		<input type="hidden" name="workgroup" id="workgroup" value="">		
		<font size="1">Workgroups were not configured</font>	
		
	</cfif>		