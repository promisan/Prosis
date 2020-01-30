
<cfparam name="url.init" default="0">

<cfquery name="uomlist" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   UoM, UoMDescription
	FROM     ItemUoM U
	WHERE    ItemNo IN (SELECT ItemNo 
	                    FROM   ItemWarehouseLocation 
						WHERE  Warehouse = '#url.warehouse#'	
                        AND    Location  = '#url.location#'	
						AND    ItemNo    = '#url.itemno#'
						AND    UoM       = U.UoM) 
				
</cfquery>

<cfoutput>

<select name="uom" id="uom" class="enterastab regularxl" onchange="ptoken.navigate('../Transaction/TransactionDetailLines.cfm?systemfunctionid='+document.getElementById('systemfunctionid').value+'&tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&ItemNo=#url.itemno#&UoM='+this.value,'detail');ColdFusion.navigate('../Transaction/LogReading/TransactionLogReading.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#&UoM='+this.value,'readingbox')">
	<cfloop query="uomlist">
		<option value="#uom#">#UoMDescription#</option>
	</cfloop>
</select>			
	
	<cfset url.uom = uomlist.uom>
	
	<cfif url.init eq "0">
				
		<script>	
			ptoken.navigate('../Transaction/TransactionDetailLines.cfm?systemfunctionid='+document.getElementById('systemfunctionid').value+'&tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#&UoM=#uomlist.uom#','detail')			
			ptoken.navigate('../Transaction/getTransactionUoMSelect.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#&UoM=#uomlist.uom#','uomtransaction')			
			ptoken.navigate('../Transaction/LogReading/TransactionLogReading.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#&UoM=#uomlist.uom#','readingbox')	
			ptoken.navigate('../Transaction/getCategorySelect.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#&UoM=#uomlist.uom#','categoryboxcontent')								
			ptoken.navigate('../Transaction/getAsset.cfm','assetbox')
		    document.getElementById('assetselect').value  = ''
		</script>
		
	</cfif>
		

</cfoutput>