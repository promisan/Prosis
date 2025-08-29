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