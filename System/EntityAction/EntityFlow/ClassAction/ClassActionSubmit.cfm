
<!--- update --->

<cfif URL.PublishNo eq "">
	<cfset tbl = "Ref_EntityClassAction">
<cfelse>
	<cfset tbl = "Ref_EntityActionPublish">
</cfif>
			
<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE #tbl#
		SET    Label#url.field#  = '#url.value#'
		WHERE  ActionCode = '#URL.ActionCode#'
		<cfif tbl eq "Ref_EntityActionPublish">
		AND    ActionPublishNo = '#URL.PublishNo#'
		<cfelse>
		AND    EntityCode  = '#URL.EntityCode#' 
	    AND    EntityClass = '#URL.EntityClass#'  
		</cfif>
</cfquery>

<script>
	Prosis.busy('no')
</script>