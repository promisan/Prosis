
<!--- Create new missions --->
<cfquery name="GetMissionsSubmit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	M.*
		FROM   	Ref_MissionModule MM
				INNER JOIN Ref_Mission M
					ON MM.Mission = M.Mission
		WHERE  	MM.SystemModule = 'WorkOrder'
</cfquery>

<cftransaction>

	<!--- Remove all missions --->
	<cfquery name="clean" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE 
			FROM	WorkOrderServiceMission
			WHERE	ServiceDomain = '#url.id1#'
			AND		Reference = '#url.id2#'
	</cfquery>
	
	<cfloop query="GetMissionsSubmit">
	
		<cfif isDefined("form.mission_#mission#")>
		
			<cfset vOrgUnit = evaluate("form.orgunit1_#mission#")>
			
			<cfquery name="insert" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO WorkOrderServiceMission
						(
							ServiceDomain,
							Reference,
							Mission,
							OrgUnitImplementer,
							OfficerUserId,
						 	OfficerLastName,
					 		OfficerFirstName
						)
					VALUES
						(
							'#url.id1#',
							'#url.id2#',
							'#mission#',
							'#vOrgUnit#',
							'#SESSION.acc#',
			    	  		'#SESSION.last#',		  
				  	  		'#SESSION.first#'
						)
			</cfquery>
			
		</cfif>
		
	</cfloop>

</cftransaction>