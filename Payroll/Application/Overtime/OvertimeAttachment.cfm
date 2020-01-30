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
		DocumentPath = "Overtime"
		SubDirectory = "#url.id#" 
		Filter       = ""
		LoadScript   = "No"		
		Insert       = "yes"
		Remove       = "yes"
		Listing      = "yes">

</cfoutput>			