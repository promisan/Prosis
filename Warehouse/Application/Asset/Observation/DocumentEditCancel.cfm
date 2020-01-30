
<cfquery name="Update" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE FROM AssetItemObservation	
	 WHERE ObservationId = '#URL.Id#'	
</cfquery>	

<cfoutput>
	
	<script>
	 try {	
		opener.applyfilter('','','content') } catch(e) {}
	    window.close()
	</script>

</cfoutput>

