
	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE    Ref_AccountGroup
	WHERE     AccountGroup  = '#URL.ID#'
	</cfquery>

<cfoutput>
<cflocation url="GroupResult.cfm?page=#URL.Page#&idmenu=#URL.idmenu#" addtoken="No">
</cfoutput>

