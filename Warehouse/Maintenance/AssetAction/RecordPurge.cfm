<cfquery name="Delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_AssetAction
	 WHERE Code = '#URL.ID1#'
</cfquery>

<cfoutput>
	<script>
		#ajaxlink('RecordListing.cfm')#
	</script>
</cfoutput>
