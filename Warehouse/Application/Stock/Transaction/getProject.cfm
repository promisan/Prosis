
<!--- get the project --->

<cfparam name="url.selected" default="">

<cfquery name="program" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			SELECT   *
			FROM     WarehouseProgram D, Program.dbo.Program P
			WHERE    Warehouse     = '#url.warehouse#'		
			AND      D.ProgramCode =  P.ProgramCode
			AND      D.Operational = 1						 
</cfquery>		

<cfif program.recordcount gte "1">
   <select name="ProgramCode" id="ProgramCode" class="regularxl enterastab" onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}">
        <option value="">n/a</option>
		<cfoutput query="Program">
		<option value="#ProgramCode#" <cfif url.selected eq programcode>selected</cfif>>#ProgramName#</option>
		</cfoutput>
   </select>

    <script>
		document.getElementById("projectbox").className = "regular"
	</script>

<cfelse>
      <script>
			document.getElementById("projectbox").className = "hide"
	  </script>
		
</cfif>