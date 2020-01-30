<!--- select relevant workflows --->
	
	<cfquery name="Class" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT R.*
		FROM     Ref_EntityClassPublish P, Ref_EntityClass R
		WHERE    R.EntityCode = 'ProcExecution'
		AND      P.EntityCode = R.EntityCode
		AND      P.EntityClass = R.EntityClass
		<!---
		AND     (R.EntityClassOwner is NULL or R.EntityClassOwner = '#URL.Owner#')
		--->
	</cfquery>

	<cfif Class.recordcount gte "1">
	
	    <select name="EntityClass" id="EntityClass" class="regularxl">
	    <cfoutput query="Class">
		<option value="#EntityClass#">#EntityClassName#</option>
		</cfoutput>
	    </select>
		
		<script>
		 try {
		 document.getElementById("save").className = "regular"
		 } catch(e) {}
		</script>
		
	<cfelse>
	
		<script>
		 try {
		 document.getElementById("save").className = "hide"
		 } catch(e) {}
		</script>
	
	    <font size="1" color="FF0000">Workflow not configured</font>	
	
	</cfif>	