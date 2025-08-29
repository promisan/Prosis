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
<cf_tl id = "This program is already associated." var = "msg">

<cfquery name="validate" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM 	WarehouseProgram
		WHERE 	Warehouse   = '#form.warehouse#'
		AND 	ProgramCode = '#form.programCode#'
</cfquery>

<cfif form.programCodeOld eq "">

	<cfif validate.recordCount eq 0>
	
		<cfquery name="insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WarehouseProgram (
					Warehouse,
					ProgramCode,
					Operational,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName )
			VALUES (
					'#Form.Warehouse#',
					'#Form.ProgramCode#',
					#Form.Operational#,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#' )
		</cfquery>
		
		<cfoutput>
			<script>
			    _cf_loadingtexthtml='';	
				parent.ProsisUI.closeWindow('mydialog'); 
				parent.ptoken.navigate('Program/ProgramListing.cfm?warehouse=#form.warehouse#','contentbox2'); 
			</script>
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>
			<script>
				alert('#msg#');
			</script>
		</cfoutput>
	
	</cfif>	

<cfelse>

	<cfif validate.recordCount gt 0>
	
		<cfquery name="update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE WarehouseProgram
			SET
				Operational = #Form.Operational#
			WHERE
				ProgramCode = '#Form.ProgramCodeOld#'
		</cfquery>
		
		<cfoutput>
			<script>
			    _cf_loadingtexthtml='';	
				parent.ProsisUI.closeWindow('mydialog'); 
				parent.ptoken.navigate('Program/ProgramListing.cfm?warehouse=#form.warehouse#','contentbox2'); 
			</script>
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>
			<script>
				alert('#msg#');
			</script>
		</cfoutput>
	
	</cfif>

</cfif>