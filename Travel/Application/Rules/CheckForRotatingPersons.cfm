<!--- 
	Travel/Application/Rules/CheckForRotatingPersons.cfm
	
	1. Validation routine for the Identify Rotating Personnel worflow step.	
	2. Will not allow  this step to be 'Completed' (status=1) unless a rotating person record has been created.
	
	Called by: Travel/Application/Template/DocumentCandidateEditSubmit_Lines.cfm via entry in FlowActionRule table.	
	
	Modification history:
	20July04 - created file	
--->
<cfparam name="Attributes.Action" default="0">   	<!--- this the DocumentNo --->
<cfparam name="Attributes.Person" default="0">	 	<!--- this the PersonNo --->
<cfparam name="Attributes.ActionId" default="0">	<!--- this the ActionId (=36 for Milestone step --->
<cfparam name="Attributes.ActionStat" default="0">	<!--- this the Action Status chosen by the user in the workflow steps area of Document Edit page --->

<cfset caller.go = "1"> 

<cfif #Attributes.ActionStat# EQ 1>

	<cfquery name="CheckRotatingPerson" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT * FROM DocumentRotatingPerson
		WHERE DocumentNo = #Attributes.Action#
	</cfquery>

	<cfif CheckRotatingPerson.RecordCount EQ 0>
	   <cfset caller.go = "0">  
	   <cfoutput>
	   <cfset caller.message = "Rotating personnel have not been identified! At least one rotating person must be identified to mark step as completed.">
	   </cfoutput>
	</cfif>

</cfif>