<!--- 
	CheckIndexNo.cfm
	
	1. Validate Generate IMIS number workflow step.
	2. Check if nominee already has index number assigned to it.	

	Called by: Travel/Application/Template/DocumentCandidateEditSubmit_Lines.cfm
--->

<!---cfparam name="Attributes.Action" default="0"--->
<cfparam name="Attributes.Person" default="0">

<cfquery name="CheckIndex" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT PersonNo FROM Person
	WHERE PersonNo = '#Attributes.Person#'
	AND (IndexNo is NULL or IndexNo = '')
</cfquery>

<cfif CheckIndex.RecordCount EQ 1>
   <cfset caller.go = "0">  
   <cfset caller.message = "Nominee has no IndexNo identified. Operation not allowed.">
<cfelse>   
   <cfset caller.go = "1">  
</cfif>