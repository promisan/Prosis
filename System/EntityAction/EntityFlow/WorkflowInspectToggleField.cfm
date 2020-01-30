<cfif URL.isTextBox eq "No">
	<cfset ToggleValue = #IIF(ToggleValue eq 1, 0, 1)#>
</cfif>

<cfif URL.PublishNo eq "">
	
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_EntityClassAction
		SET #Toggle# = #ToggleValue#
		WHERE ActionCode  = '#URL.ActionCode#'
		AND   EntityClass = '#URL.EntityClass#'
		AND   EntityCode  = '#URL.EntityCode#'
		</cfquery>
				
	<cfelse>
	
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_EntityActionPublish
		SET #Toggle# = #ToggleValue#
		WHERE ActionCode    = '#URL.ActionCode#'
		AND  ActionPublishNo = '#URL.PublishNo#'
		</cfquery>

</cfif>

<cf_compression>
