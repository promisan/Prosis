
<cfoutput>

<cfquery name="Date" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT Created
  FROM PersonSearch
  WHERE Status = '1'
  AND OfficerUserId = '#SESSION.acc#'
  ORDER BY Created DESC
</cfquery>

<cfif Date.recordCount neq "0">

['&nbsp;Prior searches',null, 

<cfloop query = "Date">
 
  <cfset #CreatedDate# = #DateFormat(Date.Created, CLIENT.DateFormatShow)#>

  ['#CreatedDate#',null,
  
  <cfquery name="Datesearch" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT SearchId, Description
  FROM PersonSearch
  WHERE Status = '1'
  AND OfficerUserId = '#SESSION.acc#'
  AND Created = '#DateFormat(Date.Created, CLIENT.DateSQL)#' 
     
</cfquery>

  <cfloop query="DateSearch">

  ['#SearchId# #Description#','SearchTree.cfm?ID1=#DateSearch.SearchId#&Mission=#URL.Mission#'],
  
  </cfloop>],
  
  </cfloop>]  
  
</cfif>  
  
</cfoutput>


