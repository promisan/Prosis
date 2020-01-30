
<cfquery name="Delete"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE 
	FROM   Ref_PostTypeMission
	WHERE  PostType = '#Url.PostType#'
	AND	   Mission = '#url.mission#' 
</cfquery>

<cfoutput>
	<script>
		window.location = 'RecordListing.cfm?posttype=#url.posttype#&idmenu=#url.idmenu#';
	</script>
</cfoutput>