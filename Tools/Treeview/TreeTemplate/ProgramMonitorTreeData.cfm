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



