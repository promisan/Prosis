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
<cfquery name = "CaseFileClass"  
	  datasource="AppsCaseFile" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT   DISTINCT CL.Code, CL.Description
	    FROM     Claim C INNER JOIN
	             Ref_ClaimTypeClass CL ON C.ClaimTypeClass = CL.Code INNER JOIN
	             Ref_ClaimType R ON C.ClaimType = R.Code AND C.ClaimType = R.Code
	    WHERE    C.Mission   = '#url.mission#'
		<cfif url.casetype neq "Any">
		AND      C.ClaimType = '#url.casetype#'
		</cfif>
	    ORDER BY CL.Code
</cfquery>	

	
<select name="CaseClass" style="font:12px" id="CaseClass">

          <option value="Any"><cf_tl id="Any"></option>
		<cfoutput query="CaseFileClass">
		  <option value="#Code#">#Description#</option>
		</cfoutput>
		
</select>					