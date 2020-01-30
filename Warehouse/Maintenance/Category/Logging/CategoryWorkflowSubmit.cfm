
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
				ColdFusion.navigate('Logging/CategoryWorkflowListing.cfm?category=#url.category#&code=#url.action#', 'divObservations_#url.action#');
				ColdFusion.Window.hide('mydialog'); 			
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
			ColdFusion.navigate('Logging/CategoryWorkflowListing.cfm?category=#url.category#&code=#url.action#', 'divObservations_#url.action#');
			ColdFusion.Window.hide('mydialog'); 			
		</script>
	</cfoutput>

</cfif>