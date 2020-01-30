
<cfquery name="Class" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ProgramClass	
</cfquery>

<cfif url.par eq "">

	<select name="ProgramClass" class="regularxl">
	<option value="">All Classes</option>
	<cfoutput query="Class">
	<option value="#Code#">#Description#</option>
	</cfoutput>
	</select>
	
	<script>
	 document.getElementById('lineclass').className = "regular"
	</script>
	
<cfelse>

	<script>
	 document.getElementById('lineclass').className = "hide"
	</script>

</cfif>
