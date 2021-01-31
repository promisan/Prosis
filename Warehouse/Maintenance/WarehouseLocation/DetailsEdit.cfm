
<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   C.*,
				 (SELECT ItemDescription FROM Item WHERE ItemNo = C.ItemNo) as ItemDescription,
				 (SELECT UoMDescription FROM ItemUoM WHERE ItemNo = C.ItemNo and UoM = C.UoM) as UoMDescription
		FROM     WarehouseLocationCapacity C
		WHERE    C.Warehouse = '#url.warehouse#'
		AND		 C.Location = '#url.location#'
		AND		 C.DetailId = '#url.detailid#'
</cfquery>

<cf_screentop height="100%" 
    html="No" 
	scroll="Yes" 
	layout="webapp" 
	label="Details" 
	option="Maintaing Detail #get.ItemDescription# / #get.UoMDescription#" 
    banner="gray">

<cfoutput>

<table class="hide">
	<tr><td><iframe name="processEditWLCapacity" id="processEditWLCapacity" frameborder="0"></iframe></td></tr>
</table>
	
<cfform name="frmEditWLCapacity" action="DetailsEditSubmit.cfm?warehouse=#url.warehouse#&location=#url.location#&detailid=#url.detailid#" target="processEditWLCapacity">

<table width="80%" class="formpadding formspacing" align="center">
	
	<tr><td height="15"></td></tr>
	
	<tr>
		<td class="labelmedium2" width="25%"><cf_tl id="Description">:</td>
		<td>
			<cfinput type="text" class="regularxxl" name="DetailDescription" required="Yes" message="Please, enter a valid description." value="#get.DetailDescription#" size="40" maxlength="100">	
		</td>
	</tr>
	<tr>
		<td class="labelmedium2"><cf_tl id="Storage Code">:</td>
		<td>
			<cfinput type="text" class="regularxxl" name="DetailStorageCode" required="No" message="Please, enter a valid storage code." value="#get.DetailStorageCode#" size="10" maxlength="20">
		</td>
	</tr>
	<tr>
		<td class="labelmedium2"><cf_tl id="Capacity">:</td>
		<td>
			<cfinput type="text" class="regularxxl"  name="Capacity" required="Yes" message="Please, enter a valid numeric capacity." value="#get.Capacity#" validate="numeric" size="10" maxlength="10" style="text-align:right;padding-right:1px">
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td class="line" colspan="2"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="2" align="center">
			<cfoutput>
				<cf_tl id = "Save" var = "vSave">
				<input type="Submit" name="save" id="save" value="#vSave#" class="button10g">
			</cfoutput>
		</td>
	</tr>
	
</table>

</cfform>

</cfoutput>