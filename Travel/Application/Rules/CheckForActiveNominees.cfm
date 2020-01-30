<!--- 
	Travel/Application/Rules/CheckForActiveNominees.cfm
	
	1. Validation routine for the Enter Nominee Data worflow step.	
	2. Will not allow  this step to be 'Completed' (status=1) unless a active nominee records exists for this document.
	
	Called by: Travel/Application/Template/DocumentCandidateEditSubmit_Lines.cfm via entry in FlowActionRule table.	
	
	Modification history:
	22July04 - created file
--->
<cfparam name="Attributes.Action" default="0">   	<!--- this the DocumentNo --->
<cfparam name="Attributes.Person" default="0">	 	<!--- this the PersonNo --->
<cfparam name="Attributes.ActionId" default="0">	<!--- this the ActionId (=36 for Milestone step --->
<cfparam name="Attributes.ActionStat" default="0">	<!--- this the Action Status chosen by the user in the workflow steps area of Document Edit page --->

<cfset caller.go = "1"> 

<cfif #Attributes.ActionStat# EQ 1>

	<cfquery name="CheckForActiveNominees" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT * FROM DocumentCandidate
		WHERE DocumentNo = #Attributes.Action#
		AND   Status IN ('0','1')
	</cfquery>

	<cfif CheckForActiveNominees.RecordCount EQ 0>
	   <cfset caller.go = "0">  
	   <cfoutput>
	   <cfset caller.message = "This is no active nominee for this request! At least one active nominee must exist to mark step as completed.">
	   </cfoutput>
	</cfif>

</cfif>