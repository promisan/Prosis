
<cfquery name="Last" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     Ref_EntityClassPublish
	WHERE    EntityCode = '#URL.EntityCode#'
	AND      EntityClass ='#URL.EntityClass#'
	ORDER BY Created DESC
</cfquery>

<cfoutput>
<script>
	window.location = "FlowView.cfm?entitycode=#url.entitycode#&entityclass=#URL.entityClass#&publishno=#Last.ActionPublishNo#"
</script>
</cfoutput>
