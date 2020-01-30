<cf_param name="URL.personno" 		 default="" 		  type="string">

<cfoutput>
			
	<!--- Query returning search results --->
	<cfquery name="Parameter" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Parameter
	</cfquery>
		
	<cf_filelibraryN
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#url.personno#" 
		Filter="#left(url.id,8)#"
		LoadScript="No"
		attachdialog="Yes"
		maxfiles="2"
		box="appdocument"
		Insert="yes"
		Remove="yes"
		Listing="yes">
				
</cfoutput>			