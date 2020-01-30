<cfquery name="Delete" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_RequestWorkflow
		WHERE RequestType          = '#url.id1#'
		AND   RequestAction        = '#url.id2#'
</cfquery>	

<cfoutput>
	<script>   
		 ColdFusion.navigate('RequestWorkflowListing.cfm?id1=#url.id1#','listing');      
	</script> 
</cfoutput>