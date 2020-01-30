


<cfcomponent output="false">
  <cffunction name="getList" returntype="any" output="false" access="remote">
	<cfargument name="LastUpdate" type="string" required="yes">

	<!--- Q Hanno : please use CGI variable to define host --->
	
	<cfquery name="Parameter" 
	datasource="AppsInit">
	SELECT *
	FROM Parameter
	WHERE HostName='127.0.0.1'
	</cfquery>

	<cfdirectory directory="#Parameter.ApplicationRootPath#" name="NewUpdates" action="LIST" filter="*.cfm" recurse="Yes">

	<!--- Get all directory information in a query of queries.--->
	
	<!--- Q Hanno : how would you know the format of the client's date --->
	
	<cfquery dbtype="query" name="NewUpdates">
		SELECT * FROM NewUpdates 
		WHERE   DateLastModified > '#DateFormat(LastUpdate, "dd/mm/yyyy")#'
	</cfquery>
	
	<cfxml variable="files">
		 <files>
			<cfoutput>
			<cfset i=0>
			<cfloop query="NewUpdates">
				<cfset dir=replace("#Directory#","#parameter.ApplicationRootPath#","")>
				<cfset i=#i#+1>
				<file id='#i#'>	
					<directory>#dir#</directory>
					<name>#Name#</name>
				</file>	
			</cfloop>
			</cfoutput>
		 </files>
	</cfxml>


   <cfreturn #files#>
  </cffunction>


</cfcomponent>