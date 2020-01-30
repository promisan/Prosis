<cfquery name="getSuggestion" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 classification 
	FROM     Item
	WHERE    Mission = '#URL.mission#' 
	AND      Classification LIKE '#URL.code#%'
	ORDER BY Created DESC
</cfquery>

<cfoutput>

#getSuggestion.classification#	

<script>
	$('##ItemNoExternal').val('#URL.code#');
	$('##ItemBarcode').val('#URL.code#');
</script>

</cfoutput>
