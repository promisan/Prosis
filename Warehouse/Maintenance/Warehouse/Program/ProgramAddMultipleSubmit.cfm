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
<cfquery name="Warehouse" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM 	Warehouse
	WHERE 	Warehouse = '#url.warehouse#'
</cfquery>

<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT	P.*
	FROM	Program P 
	WHERE	P.Mission      = '#Warehouse.Mission#'
	AND		P.ProgramClass != 'Program'
</cfquery>

<cfloop query="get">

	<cfif isDefined("Form.prog_#programCode#")>
	
		<cftry>
			<cfquery name="insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO WarehouseProgram (
							Warehouse,
							ProgramCode,
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName ) 
					VALUES ('#url.warehouse#',
							'#ProgramCode#',
							1,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#' )
			</cfquery>
		<cfcatch></cfcatch>
		</cftry>
	
	<cfelse>
	
		<cftry>
			<cfquery name="delete" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE 
					FROM 	WarehouseProgram
					WHERE  	Warehouse = '#url.warehouse#'
					AND		ProgramCode = '#ProgramCode#'
			</cfquery>
		<cfcatch></cfcatch>
		</cftry>
			
	</cfif>
</cfloop>

<cfoutput>
	<script>
		parent.ProsisUI.closeWindow('mydialog'); 
		_cf_loadingtexthtml='';	
		parent.ptoken.navigate('Program/ProgramListing.cfm?warehouse=#url.warehouse#','contentbox2'); 
	</script>
</cfoutput>