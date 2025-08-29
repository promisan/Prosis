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
<cfoutput>

 <cfquery name="Mission" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT Mission
      FROM ProgramSearchResult R, ProgramPeriod Pe, Organization.dbo.Organization O
	  WHERE R.SearchId = #URL.ID1#
	  AND   R.ProgramId = Pe.ProgramId
	  AND   Pe.OrgUnit = O.OrgUnit
  </cfquery>
  
  <cfloop query="Mission">
  ['&nbsp;#Mission#','ResultListing.cfm?ID=ORG&ID1=#URL.ID1#&Lay=Users', 
  
  <cfquery name="Master" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT M.OrgUnitName, M.OrgUnit, M.OrgUnitCode, M.HierarchyCode
      FROM ProgramSearchResult R, ProgramPeriod Pe, Organization.dbo.Organization O, 
	  		Organization.dbo.#Client.LanPrefix#Organization M
	  WHERE R.SearchId = #URL.ID1#
	  AND   R.ProgramId = Pe.ProgramId
	  AND   Pe.OrgUnit = O.OrgUnit
	  AND   O.HierarchyRootUnit = M.OrgUnitCode
	  AND   O.MandateNo         = M.MandateNo
	  AND   O.Mission           = M.Mission 
	  AND   O.Mission			= '#Mission#'
	  ORDER BY M.HierarchyCode	  
  </cfquery>
    
      <cfloop query="Master">
	  ['#OrgUnitName#','ResultListing.cfm?ID=ORG&ID1=#URL.ID1#&ID2=#OrgUnit#',
	  
	  <cfset mas = #OrgUnit#>
	  
	  	  <cfquery name="Period" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT DISTINCT Pe.Period
      FROM ProgramSearchResult R, ProgramPeriod Pe, Organization.dbo.Organization O, Organization.dbo.Organization M
	  WHERE R.SearchId = #URL.ID1#
	  AND   M.OrgUnit = '#mas#'
	  AND   R.ProgramId = Pe.ProgramId
	  AND   Pe.OrgUnit = O.OrgUnit
	  AND   O.HierarchyRootUnit = M.OrgUnitCode
	  AND   O.MandateNo         = M.MandateNo
	  AND   O.Mission           = M.Mission
	  </cfquery>
	 
      <cfloop query="Period">
	  ['#Period#','ResultListing.cfm?ID=ORG&ID1=#URL.ID1#&ID2=#mas#&ID3=#Period#'],
      	   	  	  
	  </cfloop>],
	        	   	  	  
	  </cfloop>],
	  
	  </cfloop>

</cfoutput>



