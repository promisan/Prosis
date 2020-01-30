<cfquery name="getMission"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT	*
	FROM	Ref_ParameterMission
	WHERE	Mission = '#url.mission#'
</cfquery>

<cfoutput>
	<input type="Hidden" name="vendorTree" id="vendorTree" value="#getMission.treeCustomer#">
</cfoutput>