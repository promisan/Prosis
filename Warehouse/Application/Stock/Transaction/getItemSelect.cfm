
<cfparam name="url.init" default="0">

<cfquery name="itm" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   Itemno, ItemDescription
	FROM     Item I
	WHERE    Destination = 'Distribution'
	AND      ItemNo IN (SELECT ItemNo 
	                    FROM   ItemWarehouseLocation 
						WHERE  Warehouse = '#url.warehouse#'	
                        AND    Location = '#url.location#') 
	ORDER BY ItemNo					
</cfquery>

	
	<cfoutput>
		
		<cfset url.itemNo = itm.ItemNo>
		
		<select name = "itemno"  id = "itemno" class="regularxl enterastab"
		  onchange="ptoken.navigate('../Transaction/getUOMSelect.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&ItemNo='+this.value,'uombox')">
			<cfloop query="itm">
				<option value="#itemNo#">#ItemNo# #ItemDescription#</option>
			</cfloop>
		</select>	
		
		<cfif url.init eq "0">
			
		<script>
		 
			ptoken.navigate('../Transaction/getUoMSelect.cfm?tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#','uombox')	
	
		</script>
		
		</cfif>
			
	</cfoutput>
	