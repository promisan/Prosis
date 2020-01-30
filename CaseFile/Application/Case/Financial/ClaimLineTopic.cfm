<!--- embedded workflow dialog for claim lines --->

<cfquery name="Context" 
	datasource="AppsCaseFile">
	SELECT   *
	FROM     stQuestionaireContent T 
	WHERE    T.TopicId         = '#Object.ObjectKeyValue4#'	
</cfquery>

<cfset url.claimId   = "#context.claimid#">
<cfset url.topiccode = "#context.topiccode#">

<cfinclude template="ClaimLine.cfm">
	