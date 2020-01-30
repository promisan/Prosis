<!--- 
	SubmitMedical.cfm
	
	Automatically process the Request Medical Clearance and Medically-Clear Nominee workflow steps
	
	
--->

<cfparam name="Attributes.Action" default="0">   	<!--- this the DocumentNo --->
<cfparam name="Attributes.Person" default="0">	 	<!--- this the PersonNo --->
<cfparam name="Attributes.ActionId" default="0">	<!--- this the ActionId --->


<cfquery name="ProcessMedSteps" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
      UPDATE DocumentCandidateAction
	  SET 	ActionStatus = 7,
	  	  	ActionDateActual = 
			ActionReference
			ActionMemo
			ActionUserId
			ActionLastName
			ActionFirstName
			Created = Now()
	  WHERE DocumentNo = #Attributes.Action#
	    AND PersonNo = '#Attributes.Person#'
</cfquery>

<cfif CheckCandidate.recordCount EQ 1>
   <cfset caller.go = "0">  
   <cfset caller.message = "Candidate has no IndexNo identified. Operation not allowed.">
<cfelse>   
   <cfset caller.go = "1">  
</cfif>

