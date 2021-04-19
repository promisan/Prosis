
	<cfquery name="get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Item
		WHERE  ItemNo = '#URL.ID#'
	</cfquery>

<cfif getAdministrator(get.mission) eq "1">
	
		<cf_filelibraryN
			DocumentPath="WarehouseItem"
			SubDirectory="#URL.Id#" 
			Filter=""
			Presentation="all"
			Insert="yes"
			ShowSize="0"
			Remove="yes"
			width="100%"	
			Loadscript="no"				
			border="1">	
			
<cfelse>

		<cf_filelibraryN
			DocumentPath="WarehouseItem"
			SubDirectory="#URL.ID#" 
			Filter=""			
			Insert="yes"
			ShowSize="0"
			Remove="no"			
			Loadscript="no"
			width="100%"			
			border="1">	

</cfif>	

