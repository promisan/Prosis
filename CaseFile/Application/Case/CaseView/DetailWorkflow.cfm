
<cfparam name="URL.Mode" default="Regular">

<cfif url.mode eq "regular">
   <cfset tool = "Yes">
<cfelse>
   <cfset tool = "No">   
</cfif>

<cfoutput>
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td id="#url.ajaxid#">

<cfquery name="GetClaim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Claim
	WHERE  ClaimId = '#url.ajaxid#'
</cfquery>

<cfquery name="Tab" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ClaimTypeTab
	WHERE   TabName = 'Control'	
	AND		Mission = '#GetClaim.Mission#'
</cfquery>

<cfinclude template="..\#Tab.TabTemplate#\ClaimWorkflow.cfm">
		
</td></tr>
</table>		

</cfoutput>
