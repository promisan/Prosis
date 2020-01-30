
<cfparam name="URL.ID1" default="188"> 

<cfoutput>

 <cfquery name="Mission" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT Mission
      FROM ProgramSearchResult R, ProgramPeriod Pe, Program P
	  WHERE R.SearchId = #URL.ID1#
	  AND   R.ProgramId = Pe.ProgramId
	  AND   Pe.ProgramCode = P.ProgramCode
  </cfquery>

  <cfloop query="Mission">
  
  ['&nbsp;#Mission#',null, 
  
  <cfset Mis = #Mission.Mission#>
  
  <cfquery name="Master" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT MasterOrgUnitName, MasterOrgUnit, MasterOrgUnitCode
      FROM ProgramSearchResult R, ProgramPeriod Pe, Program P, 
	  			ProsisOLAP.dbo.Organization M
	  WHERE R.SearchId = #URL.ID1#
	  AND   R.ProgramId = Pe.ProgramId
	  AND   Pe.ProgramCode = P.ProgramCode 
	  AND   P.OrgUnit = M.OrgUnit
	  ORDER BY MasterOrgUnitCode
	  
  </cfquery>
  
      <cfloop query="Master">
	  ['#MasterOrgUnitCode# - #MasterOrgUnitName#','ResultListing.cfm?ID=ORG&ID1=#URL.ID1#&ID2=#MasterOrgUnit#',
	  
	  <cfset mas = #MasterOrgUnit#>
	  
	  	  <cfquery name="Period" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT DISTINCT Pe.Period
      FROM ProgramSearchResult R, ProgramPeriod Pe, Program P, ProsisOLAP.dbo.Organization M
	  WHERE R.SearchId = #URL.ID1#
	  AND   M.MasterOrgUnit = #mas#
	  AND   R.ProgramId = Pe.ProgramId
	  AND   Pe.ProgramCode = P.ProgramCode
	  AND   P.OrgUnit = M.OrgUnit
     </cfquery>

      <cfloop query="Period">
	  
	  ['#Period#','ResultListing.cfm?ID=ORG&ID1=#URL.ID1#&ID2=#mas#&ID3=#Period#'],
      	   	  	  
	  </cfloop>],
	        	   	  	  
	  </cfloop>],
	  
	  </cfloop>

</cfoutput>



