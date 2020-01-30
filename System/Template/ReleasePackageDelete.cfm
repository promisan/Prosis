
<cfquery name="Master" 
	  datasource="AppsControl">
      SELECT TOP 1 * 
	  FROM   ParameterSite
	  WHERE  ServerRole = 'QA'
	  ORDER BY ServerRole
</cfquery>
	
<cfquery name="List" 
	datasource="AppsControl">
	    SELECT * FROM ParameterSiteVersion
		WHERE ApplicationServer = '#URL.Site#'
		AND ActionStatus = '0'
</cfquery>


<cfloop query="List">


	<cfquery name="Delete" 
		datasource="AppsControl">
		    DELETE FROM  ParameterSiteVersion
			WHERE VersionId = '#VersionId#'
	</cfquery>
	
	<cftry>
	
	<cfdirectory action="DELETE"
             directory="#Master.ReplicaPath#\_distribution\#URL.Site#\v#DateFormat(VersionDate,'YYYYMMDD')#"
             recurse="Yes">
			 
			<cfcatch></cfcatch> 
			
	</cftry>		

</cfloop>

<cfajaximport tags="cfdiv,cfprogressbar">

<cfinclude template="TemplateLog.cfm">