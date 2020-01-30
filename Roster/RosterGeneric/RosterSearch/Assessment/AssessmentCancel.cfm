
<!--- submitting --->

<cfquery name="Operator" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   DELETE FROM   RosterSearchLine
   WHERE  SearchId = '#URL.ID#'				  
   AND SearchClass = '#URL.source#'
   AND SelectId    = '#URL.SelectId#'
</cfquery>	

<cfinclude template="Assessment.cfm">

<script>
	Prosis.busy("no")
</script>
