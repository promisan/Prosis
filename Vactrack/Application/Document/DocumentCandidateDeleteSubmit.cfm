
<cfquery name="Delete" 
 datasource="AppsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 DELETE DocumentCandidate
 WHERE DocumentNo  = '#URL.ajaxid#' AND PersonNo = '#URL.ID1#'
 </cfquery>
  
<cfinclude template="DocumentCandidate.cfm">
 