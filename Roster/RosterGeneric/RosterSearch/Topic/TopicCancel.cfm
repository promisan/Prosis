
<!--- submitting --->

<cfquery name="Operator" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   DELETE FROM   RosterSearchLine
   WHERE  SearchId = '#URL.ID#'				  
   AND SearchClass = 'SelfAssessment'
   AND SelectId    = '#URL.selectid#'
   
</cfquery>	

<cfinclude template="Topic.cfm">
