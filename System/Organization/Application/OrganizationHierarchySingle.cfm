
<cfparam name="URL.Mission" default="">
<cfparam name="URL.Mandate" default="">
<cfparam name="URL.OrgUnit" default="">
<cfparam name="URL.ParentOrgUnit" default="">

 <cfquery name="parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Organization 
		WHERE 	Mission   = '#URL.Mission#'
		AND 	MandateNo = '#URL.Mandate#'
		AND		OrgUnit = '#url.ParentOrgUnit#'
		ORDER BY TreeOrder
</cfquery>

<cfif parent.recordCount eq 0>
	
	<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Organization 
			SET 	HierarchyCode = '#Level1#', 
					HierarchyRootUnit = OrgUnitCode
			WHERE 	OrgUnit = '#URL.OrgUnit#'
	</cfquery>

<cfelse>
	
</cfif>


