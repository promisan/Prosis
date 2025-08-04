<!--
    Copyright © 2025 Promisan

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