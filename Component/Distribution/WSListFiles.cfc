<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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