<!--- 
	Travel/Application/Rules/SubmitSelectCand.cfm
	
	Mark candidates being processed as selected.
	That is, set DocumentCandidate.Status = 3 according to these rules:
	For candidates handled by Travel Unit, when candidate has completed the Complete Travel Authorization step
	For candidates handled by MovCon, when candidate has completed the Submit to Movcon step
	For all candidates, status must not be equal to '6' (Stalled).
	
	Modification History:
	20Feb04 MM - created template
--->

<cfparam name="Attributes.Action" default="0">   <!--- this is the Document No --->
<cfparam name="Attributes.Person" default="0">	 <!--- this is the Person No --->

<cfquery name="UpdateCandidateStat" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	  UPDATE DocumentCandidate
	  SET Status = '3'
	  WHERE  DocumentNo = #Attributes.Action#
	  AND    PersonNo = '#Attributes.Person#'
	  AND 	 Status <> '6'
</cfquery>

<cfquery name="CheckSuccess" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	  SELECT * FROM DocumentCandidate
	  WHERE  DocumentNo = #Attributes.Action#
	  AND    PersonNo = '#Attributes.Person#'
	  AND    Status = '3'
</cfquery>

<cfif CheckSuccess.recordCount EQ 0>
   <cfset caller.go = "0">  
   <cfset caller.message = "Operation failed. Candidate has not been selected.">
<cfelse>   
   <cfset caller.go = "1">  
</cfif>

