
<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">	
		
	<cfoutput>
	
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2" style="padding-left:30px;padding-right:30px;padding-top:5px;padding-bottom:5px" class="labelmedium">
	<font color="808080"><i>
	Enabling an item/uom for an entity, will generate a record for that item for any active Warehouse/Facility
	enabling the definition of both the sale price schedule as well as definition of max/min stock 
	for this item (dbo.ItemWarehouse). <br><br>
	Note: <br>
	
	1.	It will not generate a record in each storage location for that item, unless the location
	is actually used in transactions.	 <br>
	
	2.	Standard Cost price will be updated automatically if a BOM is defined for the item
	
	 
	</i></font>
	</td></tr>
	
	<tr><td height="13"></td></tr>
	
	<tr><td colspan="2" align="center" width="90%" style="border:1px dotted silver;padding:4px">
	
		<cfdiv bind="url:UoMMission/ItemUoMMissionListing.cfm?id=#url.id#&UoM=#URL.UoM#" id="itemUoMMissionlist"/>
				
	</td></tr>
	
	<tr><td colspan="2">
		<cfdiv id="itemUoMMissionedit"/>
	</td></tr>
	
	</cfoutput>	

</TABLE>
