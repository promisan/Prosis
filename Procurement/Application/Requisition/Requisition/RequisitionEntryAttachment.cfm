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
			ShowSize="0"
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
			ShowSize="0"
			Remove="no"			
			Loadscript="no"
			width="100%"			
			border="1">	

</cfif>	

