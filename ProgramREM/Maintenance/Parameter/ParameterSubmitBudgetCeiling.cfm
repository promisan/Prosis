
<cf_preventCache>

<cftransaction>

	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ParameterMission
				SET BudgetCeilingClear             = '#Form.BudgetCeilingClear#',
					BudgetCeiling                  = '#Form.BudgetCeiling#'
			WHERE 	Mission                        = '#url.Mission#'
	</cfquery>
	
	
	<cfquery name="Resource" 
		 datasource="AppsProgram" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	
		  DELETE FROM Ref_ParameterMissionResource
		  WHERE Mission = '#url.Mission#'
	</cfquery>		
	
	<cfquery name="Resource" 
		 datasource="AppsProgram" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	
		  SELECT     *
		  FROM       Ref_Resource
	</cfquery>	
	
	<cfloop query="Resource">
	
			<cfparam name="form.#code#_ceiling" default="0">
	
			<cfset ceil = evaluate("form.#code#_ceiling")>
		
			<cfquery name="Insert" 
			 datasource="AppsProgram" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">	
			  INSERT INTO Ref_ParameterMissionResource
			          (Mission,Resource,Ceiling)
			  VALUES  ('#url.Mission#','#Code#','#ceil#')
			</cfquery>		
				
	</cfloop>	

</cftransaction>


<cfoutput>
	<script>
		ColdFusion.navigate("ParameterBudgetMenu.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#&selected=2", "contentbox5");
	</script>
</cfoutput>