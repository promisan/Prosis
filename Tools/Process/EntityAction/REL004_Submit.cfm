
<cfquery name="Master" 
  datasource="AppsControl" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT  TOP 1 *
  FROM    ParameterSite
  WHERE   ServerRole = 'QA' 
</cfquery>  

<cfquery name="Site" 
  datasource="AppsControl" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT  S.*, 
          V.VersionDate as ReleaseDate
  FROM    ParameterSite S, ParameterSiteVersion V
  WHERE   S.ApplicationServer = V.ApplicationServer
  AND     VersionId = '#Object.ObjectKeyValue4#'
</cfquery>  

<!--- sync code add/updated templates --->

<cfexecute name="#Master.ReplicaPath#\_distribution\#Site.ApplicationServer#\v#DateFormat(Site.ReleaseDate,'YYYYMMDD')#\SyncVersion.bat" 
           timeOut="15">
</cfexecute>

<!--- remove templates --->

<cfquery name="Delete" 
  datasource="AppsControl" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT  PathName,FileName
  FROM    Ref_Template
  WHERE   VersionDateRemoved <= '#DateFormat(Site.ReleaseDate,client.dateSQL)#' 
  AND     Source = '#Master.ApplicationServer#'
</cfquery>

<cfloop query="delete">

    <cfif pathName eq "[root]">
	 <cfset path = "">
	<cfelse>
	 <cfset path = PathName> 
	</cfif>

	<cftry>
	
		<cffile action="DELETE" file="#Site.ReplicaPath#/#path#/#fileName#">
		<cfcatch></cfcatch>

	</cftry> 

</cfloop> 

<!--- update release information --->

<cftransaction>

	<cfquery name="SetVersion" 
		 datasource="AppsControl"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			UPDATE ParameterSite
			SET VersionDate = '#DateFormat(Site.ReleaseDate,client.dateSQL)#'
			WHERE ApplicationServer = '#Site.ApplicationServer#'
		
	</cfquery>
	
	<cfquery name="UpdateVersion" 
		 datasource="AppsControl"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			UPDATE ParameterSiteVersion
			SET ActionStatus = 1
			WHERE VersionId = '#Object.ObjectKeyValue4#'
	</cfquery>

</cftransaction>	