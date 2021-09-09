

<cfquery name="delete"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE
		FROM 	Ref_Category
		WHERE 	Category = '#url.id1#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">
