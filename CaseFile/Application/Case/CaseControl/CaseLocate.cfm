
<cfquery name="Tab" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ClaimTypeTab
	WHERE   TabName = 'Control'
	AND     Mission='#url.mission#'
</cfquery>

<cflocation addtoken="No" url="#SESSION.root#/CaseFile/Application/Case/#Tab.TabTemplate#/ClaimLocate.cfm">