

<cfquery name="Update" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE 	ServiceItem
	SET    	SelfService      = '#Form.Selfservice#',
			UsageTopicGroup  = <cfif trim(Form.UsageTopicGroup) eq "">null<cfelse>'#Form.UsageTopicGroup#'</cfif>,
			UsageTopicDetail = <cfif trim(Form.UsageTopicDetail) eq "">null<cfelse>'#Form.UsageTopicDetail#'</cfif>,
			UsageActionClose = <cfif trim(Form.UsageActionClose) eq "">null<cfelse>'#Form.UsageActionClose#'</cfif>
	WHERE  	Code = '#url.id1#'
</cfquery>	


<cfinclude template="Selfservice.cfm">