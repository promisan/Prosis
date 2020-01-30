
<cfoutput>

<cfparam name="url.assetid" default="">

<cfif url.assetid neq "">

	<cftry>
	
		<cfquery name="GetAsset" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    AssetItem
				WHERE   AssetId = '#url.AssetId#'	
		</cfquery>
		
		<cfquery name="UoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  TOP 1 *
				FROM    ItemUoM
				WHERE   ItemNo = '#getAsset.itemno#'		 				 
		</cfquery>			
				
		<input type="hidden" name="AssetId" id="AssetId" value="#url.AssetId#">&nbsp;
		
		<script language="JavaScript">
			
			document.getElementById('serialno').value      = "#getAsset.serialno#"
			document.getElementById('description').value   = "#getAsset.description#"
			document.getElementById('make').value          = "#getAsset.make#"
			document.getElementById('price').value         = "#numberformat(UoM.StandardCost,"__,__.__")#"
			document.getElementById('assetbarcode').value  = "#getAsset.assetBarCode#"
			document.getElementById('assetdecalno').value  = "#getAsset.assetDecalNo#"
			document.getElementById('consumption').disabled = false
			document.getElementById('resetasset').className = "regular"
				
		</script>
	
	<cfcatch></cfcatch>
	</cftry>
	
	
</cfif>	

</cfoutput>

