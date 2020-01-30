
<cfparam name="url.default" default="0">

<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ItemUoM	
	WHERE  ItemUoMId = '#url.ItemUomId#'			
</cfquery>	

<cfquery name="UoMList" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ItemUoM
	WHERE  ItemNo = '#get.ItemNo#'				
</cfquery>

<cfoutput>

<cfif url.default eq "1">	

	<input type="hidden" name="WarehouseReceiptUoMPrior" id="WarehouseReceiptUoMPrior" value="asis">
									
	<select name="WarehouseReceiptUoM" id="WarehouseReceiptUoM" class="regularxl enterastab" 
	  onchange="ptoken.navigate('#session.root#/procurement/application/receipt/ReceiptEntry/setReceiptPrice.cfm?requisitionno=#url.reqno#&receiptprice='+document.getElementById('receiptprice').value+'&prior='+document.getElementById('WarehouseReceiptUoMPrior').value+'&uom='+this.value,'process')">
	    <option value="asis" selected><cf_tl id="as in order"></option>		 
		<cfloop query="UoMList"><option value="#uoM#">#UoMDescription#</option></cfloop>
	</select>			

<cfelse>

	<input type="hidden" name="WarehouseReceiptUoMPrior" id="WarehouseReceiptUoMPrior" value="#url.uom#">
								
	<select name="WarehouseReceiptUoM" id="WarehouseReceiptUoM" class="regularxl enterastab"
	onchange="ptoken.navigate('#session.root#/procurement/application/receipt/ReceiptEntry/setReceiptPrice.cfm?requisitionno=#url.reqno#&receiptprice='+document.getElementById('receiptprice').value+'&prior='+document.getElementById('WarehouseReceiptUoMPrior').value+'&uom='+this.value,'process')">
	    <option value="asis" selected><cf_tl id="as in order"></option>		 
		<cfloop query="UoMList"><option value="#uoM#" <cfif UoM eq url.uom>selected</cfif>>#UoMDescription#</option></cfloop>
	</select>		

</cfif>

</cfoutput>