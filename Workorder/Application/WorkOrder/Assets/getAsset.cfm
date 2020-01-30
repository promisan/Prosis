
<cfoutput>

<cf_compression>

<cfparam name="url.assetid" default="">

<cfif url.assetid neq "">

	<cftry>
	
		<cfquery name="Get" 
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
				WHERE   ItemNo = '#get.itemno#'		 				 
		</cfquery>	
				
		<input type="hidden" name="AssetId" id="AssetId" value="#url.AssetId#">
				
		<script language="JavaScript">			
			
			document.getElementById('description').innerHTML   = "#get.description#"
			document.getElementById('make').innerHTML          = "#get.make#"
			document.getElementById('price').innerHTML         = "#numberformat(get.DepreciationBase,"__,__.__")#"
			document.getElementById('assetserialno').innerHTML = "#get.serialno#"
				
		</script>
			
	<cfcatch></cfcatch>
	</cftry>
	
	
</cfif>	

</cfoutput>


