
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.fMission#' 
</cfquery>

<!---
<cfif Access eq "Edit" or Access eq "Limited" or getAdministrator(url.mission) eq "1">
--->
	
		<cf_filelibraryN
			DocumentPath="Promotion"
			SubDirectory="#URL.ID1#" 
			Filter=""
			Presentation="all"
			Insert="yes"
			ShowSize="0"
			Remove="yes"
			width="100%"	
			Loadscript="yes"				
			border="1">	

<!---			
<cfelse>

		<cf_filelibraryN
			DocumentPath="Promotion"
			SubDirectory="#URL.ID1#" 
			Filter=""			
			Insert="yes"
			ShowSize="0"
			Remove="no"			
			Loadscript="no"
			width="100%"			
			border="1">	

</cfif>	
--->

