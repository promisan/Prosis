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
<cfquery name="validate" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_AssetActionCategoryWorkflow
		WHERE	ActionCategory = '#url.action#'
		AND		Category = '#url.category#'
		AND		Code = '#form.code#'
</cfquery>

<cf_tl id = "This code is already registered." var = "vErrorMsg">

<cfif url.code eq "">

	<cfif validate.recordcount eq 0>
	
		<cftry>
		
			<cfquery name="InsertActions" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_AssetActionCategory 
						(ActionCategory,
						Category,
						EnableTransaction,
						OfficerUserId,
				 		OfficerLastName,
				 		OfficerFirstName)
					VALUES
						('#url.action#',
						'#url.Category#',
						0,
						'#SESSION.acc#',
		    	  		'#SESSION.last#',		  
			  	  		'#SESSION.first#')
			</cfquery>
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         	 action ="Insert" 
								 contenttype="Scalar"
							 	 content="ActionCategory:#url.Action#, Category:#url.category#">
			
			<cfcatch></cfcatch>
		</cftry>
	
		<cfquery name="insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				INSERT INTO Ref_AssetActionCategoryWorkflow
					(
						ActionCategory,
						Category,
						Code,
						<cfif trim(form.description) neq "">Description,</cfif>
						<cfif trim(form.EntityClass) neq "">EntityClass,</cfif>
						Operational,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.action#',
						'#url.category#',
						'#form.code#',
						<cfif trim(form.description) neq "">'#form.description#',</cfif>
						<cfif trim(form.EntityClass) neq "">'#form.EntityClass#',</cfif>
						#form.operational#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         action ="Insert" 
							 content="#Form#">
		
		<cfoutput>
			<script>
				ptoken.navigate('Logging/CategoryWorkflowListing.cfm?category=#url.category#&code=#url.action#', 'divObservations_#url.action#');
				ProsisUI.closeWindow('mydialog'); 			
			</script>
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>
			<script>
				alert('#vErrorMsg#');
			</script>
		</cfoutput>
	
	</cfif>

<cfelse>

	<cfquery name="update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			UPDATE Ref_AssetActionCategoryWorkflow
			SET		Description = <cfif trim(form.description) neq "">'#form.description#'<cfelse>null</cfif>,
					EntityClass = <cfif trim(form.EntityClass) neq "">'#form.EntityClass#'<cfelse>null</cfif>,
					Operational = #form.operational#
			WHERE 	Code = '#form.code#'
	
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action ="Update" 
						 content="#Form#">
	
	<cfoutput>
		<script>
			ptoken.navigate('Logging/CategoryWorkflowListing.cfm?category=#url.category#&code=#url.action#', 'divObservations_#url.action#');
			ProsisUI.closeWindow('mydialog'); 			
		</script>
	</cfoutput>

</cfif>