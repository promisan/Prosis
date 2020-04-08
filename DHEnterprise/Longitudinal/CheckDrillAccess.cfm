<cfset vDrillAccess = false>

<cfif isdefined("session.acc") AND session.acc neq "">

	<cfquery name="getDrillAccess" 
		datasource="AppsOrganization">
			SELECT	R.*
			FROM	OrganizationAuthorization OA
					INNER JOIN Ref_AuthorizationRole R
						ON OA.Role = R.Role
			WHERE	OA.UserAccount = '#session.acc#'
			AND		R.SystemModule = 'Staffing'
			AND		R.Role != 'HRInquiry'	
			UNION
			SELECT	R.*
			FROM	OrganizationAuthorization OA
					INNER JOIN Ref_AuthorizationRole R
						ON OA.Role = R.Role
			WHERE	OA.UserAccount = '#session.acc#'
			AND		R.SystemModule = 'System'
			AND		R.Role = 'Support'	
	</cfquery>
	
	<cfif getDrillAccess.recordCount gt 0>
		<cfset vDrillAccess = true>
	</cfif>

</cfif>