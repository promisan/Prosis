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
		Filter       = "#url.documenttype#_#left(url.documentid,8)#"
		LoadScript   = "No"
		attachdialog = "yes"
		Insert       = "yes"
		Remove       = "yes"
		Listing      = "yes">


</cfoutput>			