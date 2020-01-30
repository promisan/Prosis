<cfoutput>
			
	<!--- Query returning search results --->
	<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Parameter
	</cfquery>
	
	<cf_filelibraryN
		DocumentPath = "#Parameter.DocumentLibrary#"
		SubDirectory = "#url.id#" 
		Filter       = "Entitlement_#left(url.entitlementid,8)#"
		LoadScript   = "No"
		attachdialog = "yes"
		Insert       = "yes"
		Remove       = "yes"
		Listing      = "yes">


</cfoutput>			