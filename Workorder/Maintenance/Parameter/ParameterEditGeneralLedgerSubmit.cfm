
<cfquery name="Area" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_AreaGLedger		
		ORDER BY ListingOrder
</cfquery>

<cfset areaList = "#valuelist(area.area)#">

<cftransaction>

	<cfquery name="Clear" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE 
			FROM 	Ref_ParameterMissionGLedger
			WHERE 	mission = '#URL.ID1#'
	</cfquery>
	
	<cfloop index="vArea" list="#areaList#" delimiters=",">
	
		<cfif isDefined("Form.glaccount_#vArea#")>
		
			<cfset vValidatedGLAccount = trim(evaluate("glaccount_#vArea#"))>
			<cfif vValidatedGLAccount neq "">
				<cfquery name="Clear" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_ParameterMissionGLedger
							(
								Mission,
								Area,
								GLAccount,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						VALUES
							(
								'#url.id1#',
								'#vArea#',
								'#vValidatedGLAccount#',
								'#session.acc#',
								'#session.last#',
								'#session.first#'
							)
				</cfquery>
			</cfif>
			
		</cfif>
		
	</cfloop>

</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate('ParameterEditGeneralLedger.cfm?ID1=#url.id1#','contentbox1')
	</script>
</cfoutput>