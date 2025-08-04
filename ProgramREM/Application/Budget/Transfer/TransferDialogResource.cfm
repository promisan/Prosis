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

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE  EditionId = '#URL.EditionId#'	
	AND    E.Version = V.Code	
</cfquery>	

<cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission	
	WHERE  Mission = '#Edition.Mission#'	 
</cfquery>

<cfquery name="Resource" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Resource
	WHERE  Code IN (SELECT Resource 
	                FROM   Ref_Object 
					WHERE  ObjectUsage = '#Edition.ObjectUsage#'
					<!---
					AND    Code IN (SELECT ObjectCode 
	                                FROM ProgramAllotmentDetail
									WHERE ProgramCode IN (SELECT ProgramCode
									                      FROM   Program 
														  WHERE  Mission = '#URL.Mission#') 
			       	) --->
			 ) 	
	ORDER BY ListingOrder		 
</cfquery>

<cfoutput>

<select name="resource" class="regularxl" id="resource" onchange="resetfrom();resetto()">
    <option value="">--- <cf_tl id="select"> ---</option>
	<cfif param.BudgetTransferMode eq "2">
	  <option value="any">[<cf_tl id="Between classes">]</option>
	</cfif>
	<cfloop query="resource">
		<option value="#code#">#Description#</option>
	</cfloop>
</select>	

</cfoutput>

