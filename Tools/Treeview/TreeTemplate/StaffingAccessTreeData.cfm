
<cfoutput>

['<b>Mission</b>',null, 

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT M.Mission
  FROM Ref_Mission M, Ref_MissionModule R
  WHERE M.Mission = R.Mission
  AND R.SystemModule = 'Staffing'
</cfquery>

<cfloop query = "Mission">
 
  <cfset Mis = Mission.Mission>

  ['#Mission#',null,
  
  <cfquery name="Posttype" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT Posttype
  FROM Ref_PostType
</cfquery>

  <cfloop query="Posttype">

  ['#Posttype#','UserAccess.cfm?ID=MIS&ID1=#Mis#&ID2=#Posttype#'],
  
  </cfloop>],
  
  </cfloop>]

  
</cfoutput>


