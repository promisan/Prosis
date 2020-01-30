
<cfquery name="Delete" 
 datasource="appsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 DELETE JobPerson
 WHERE  JobNo  = '#URL.ajaxid#' and PersonClass = '#url.PersonClass#' AND PersonNo = '#URL.ID1#'
 </cfquery>
  
<cfinclude template="JobCandidate.cfm">
 