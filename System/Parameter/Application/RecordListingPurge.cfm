<cfquery name="Clean"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM
		Ref_Application
		WHERE Code = '#url.application#'
	</cfquery>
	
	
	<cfinclude template="RecordListingDetail.cfm">