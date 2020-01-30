
<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#get.Mission#' 
</cfquery>

<cfif getAdministrator(url.mission) eq "1">
	
		<cf_filelibraryN
			DocumentPath="ProgramEdition"
			SubDirectory="#URL.ID1#" 
			Filter=""
			Presentation="all"
			Insert="yes"
			Remove="yes"
			width="100%"	
			Loadscript="yes"				
			border="1">	
			
<cfelse>

		<cf_filelibraryN
			DocumentPath="ProgramEdition"
			SubDirectory="#URL.ID1#" 
			Filter=""			
			Insert="yes"
			Remove="no"			
			Loadscript="yes"
			width="100%"			
			border="1">	

</cfif>	

