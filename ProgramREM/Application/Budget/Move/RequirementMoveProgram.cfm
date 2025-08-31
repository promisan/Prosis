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
<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     Pe.reference, P.*
		FROM       ProgramPeriod Pe, Program P
		WHERE      Pe.ProgramCode = P.ProgramCode
		AND        Pe.Period   = '#url.period#'
		
		AND        Pe.OrgUnit  = '#url.orgunit#'
		
		AND        Pe.Status       != '9'
		AND        Pe.RecordStatus != '9'
		<!---
		AND        P.ProgramCode IN (SELECT  ProgramCode 
		                              FROM   ProgramAllotment
									   WHERE ProgramCode = P.ProgramCode 
									   AND   Period    = '#url.period#' 
									   AND   EditionId = '#url.editionid#')
									   --->
		ORDER By reference
		
</cfquery>

<cfoutput>		
			   
	<select name="programcode" id="programcode" class="regularxl"
	   onchange="ColdFusion.navigate('../Request/RequestSummary.cfm?history=no&summarymode=program&editionid=#url.editionid#&period=#url.period#&programcode='+this.value,'programtarget')">
	   <cfloop query="Program">
	   <option value="#ProgramCode#" <cfif url.programcode eq programcode>selected</cfif>>#Reference# #ProgramName# [#ProgramCode#]</option>
	   </cfloop>				   
	</select>	

</cfoutput>
