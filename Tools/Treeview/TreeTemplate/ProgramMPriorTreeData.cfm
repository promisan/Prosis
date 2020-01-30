<cfoutput>

<cfquery name="Date" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT Created
  FROM ProgramSearch
  WHERE Status = '1'
  AND SearchCategory = '#Request.ArchiveClass#'
  AND OfficerUserId = '#SESSION.acc#'
</cfquery>

<cfif Date.recordCount neq "0">

['Prior Roster searches',null, 

<cfloop query = "Date">
 
  <cfset #CreatedDate# = #DateFormat(Date.Created, CLIENT.DateFormatShow)#>

  ['#CreatedDate#',null,
  
  <cfquery name="Datesearch" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT SearchId, Description
  FROM ProgramSearch
  WHERE Status = '1'
  AND SearchCategory = '#Request.ArchiveClass#'
  AND OfficerUserId = '#SESSION.acc#'
  AND Created = '#Date.Created#' 
     
</cfquery>

  <cfloop query="DateSearch">

  ['#SearchId# #Description#','ResultView.cfm?ID=#DateSearch.SearchId#'],
  
  </cfloop>],
  
  </cfloop>]  
  
</cfif>  
  
</cfoutput>


