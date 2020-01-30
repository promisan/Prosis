<cfparam name="url.lot" default="" >

<cfoutput>
<input type="button" value="Print Barcodes" style="width:200" class="button10g" 
     onclick="window.open('#client.root#/Warehouse/Maintenance/Item/UoM/UoMBarCode/ItemUoMBarCodePrint.cfm?itemno=#url.itemno#&uom=#url.uom#&numberOfLabels=#url.labels#&whs=#url.whs#&lot=#url.lot#')">
</cfoutput>
