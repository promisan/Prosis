
<cfparam name="URL.reqid"  default="">

<cfif url.reqid neq "">
	
	<cfquery name="get" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     RequisitionLine
			WHERE    RequisitionNo = '#url.ReqId#'					
	</cfquery>
	
	<cfset url.uom    = get.WarehouseUoM>
	<cfset url.itemno = get.WarehouseItemNo>

<cfelse>
	
	<cfparam name="URL.uom"    default="">
	<cfparam name="URL.itemno" default="">

</cfif>

<cfquery name="UoM" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo = '#url.ItemNo#'		
		AND      UoM    = '#url.UoM#'	
</cfquery>

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo = '#url.ItemNo#'		
</cfquery>

<cfoutput>

	<input type="hidden" name="quantityuom" id="quantityuom" value="#UoM.UoMDescription#" size="10" maxlength="20" class="regularxl" readonly> 

	<select name="warehouseuom" id="warehouseuom" class="enterastab regularxl" onchange="document.getElementById('quantityuom').value=this.options[this.selectedIndex].text">
	<cfloop query="get">
		<option value="#UoM#" <cfif url.uom eq UoM>selected</cfif>>#UoMDescription#</option>
	</cfloop>
	</select>

</cfoutput>		
	
					
	
		