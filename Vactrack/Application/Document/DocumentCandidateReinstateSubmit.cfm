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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Check" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
	    FROM OrganizationObject
		WHERE ObjectKeyValue1 = '#URL.ID#'
		AND ObjectKeyValue2 = '#URL.ID1#'
		AND Operational  = 1
</cfquery>

<cfif check.recordcount eq "0">

	 <cfquery name="Status" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE DocumentCandidate
	 SET    Status = '0'
	 WHERE  DocumentNo  = '#URL.ID#' 
	 AND    PersonNo = '#URL.ID1#'
	 </cfquery>
 
<cfelse>

	<cfquery name="Status" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE DocumentCandidate
	 SET    Status = '2s'
	 WHERE  DocumentNo  = '#URL.ID#' 
	 AND    PersonNo = '#URL.ID1#'
	 </cfquery>

</cfif> 
 
<cfoutput>

	<script language="JavaScript">
	 	window.location = "DocumentEdit.cfm?ID=#url.id#";
	</script> 

</cfoutput>


