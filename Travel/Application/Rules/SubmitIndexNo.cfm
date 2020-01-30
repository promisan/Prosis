
<!--- define if a candidate has been completed already --->

<!---cfparam name="Attributes.Action" default="0"--->
<cfparam name="Attributes.Person" default="0">

<cfquery name="CheckCandidate" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT PersonNo FROM Person
	WHERE PersonNo = '#Attributes.Person#'
	AND (IndexNo is NULL or IndexNo = '')
</cfquery>

<cfif CheckCandidate.RecordCount EQ 1>
   <cfset caller.go = "0">  
   <cfset caller.message = "Nominee has no IndexNo identified. Operation not allowed.">
<cfelse>   
   <cfset caller.go = "1">  
</cfif>