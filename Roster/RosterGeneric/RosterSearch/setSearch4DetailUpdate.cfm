
<cfquery name="Update" 
   datasource="appsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   UPDATE RosterSearchLine
	   SET    SelectParameter = '#url.parametervalue#'
	   WHERE  SearchId        = '#URL.ID#'
	   AND    SearchClass     = '#URL.Class#'
	   AND    Selectid        = '#URL.SelectId#' 
   </cfquery>
