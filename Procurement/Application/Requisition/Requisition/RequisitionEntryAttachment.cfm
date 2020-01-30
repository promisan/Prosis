
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfif Access eq "Edit" or Access eq "Limited" or getAdministrator(url.mission) eq "1">
	
		<cf_filelibraryN
			DocumentPath="#Parameter.RequisitionLibrary#"
			SubDirectory="#URL.ID#" 
			Filter=""
			Presentation="all"
			Insert="yes"
			Remove="yes"
			width="100%"	
			Loadscript="no"				
			border="1">	
			
<cfelse>

		<cf_filelibraryN
			DocumentPath="#Parameter.RequisitionLibrary#"
			SubDirectory="#URL.ID#" 
			Filter=""			
			Insert="yes"
			Remove="no"			
			Loadscript="no"
			width="100%"			
			border="1">	

</cfif>	

