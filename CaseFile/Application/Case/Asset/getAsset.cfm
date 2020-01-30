
<cfoutput>

<cfparam name="url.assetid" default="">

<cfif url.assetid neq "">
	
	<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM AssetItem
			WHERE AssetId = '#url.AssetId#'	
	</cfquery>
	&nbsp;
	
	<input type="hidden" name="AssetId" value="#url.AssetId#">
	
	<script language="JavaScript">
		
		document.getElementById('serialno').innerHTML = "#get.serialno#"
		document.getElementById('description').innerHTML = "#get.description#"
		document.getElementById('make').innerHTML  = "#get.make#"
		document.getElementById('model').innerHTML = "#get.model#"
		document.getElementById('year').innerHTML  = "#get.depreciationyearstart#"
			
	</script>
		
	
</cfif>	

</cfoutput>

