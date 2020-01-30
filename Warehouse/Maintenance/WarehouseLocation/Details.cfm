
<cfparam name="url.mode" default="standard">

<cfquery name="getLast" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WarehouseLocationCapacity
		WHERE    Warehouse = '#url.warehouse#'
		AND		 Location = '#url.location#'
		ORDER BY Created DESC	
</cfquery>

<cfquery name="getLastIWL" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemWarehouseLocation
		WHERE    Warehouse = '#url.warehouse#'
		AND		 Location = '#url.location#'
		ORDER BY Created DESC	
</cfquery>

<cfform name="frmWLCapacity" action="DetailsSubmit.cfm?warehouse=#url.warehouse#&location=#url.location#">
	
<table width="90%" class="formpadding" cellspacing="0" cellpadding="0" align="center">

	<tr>
		<tr width="20%">
			<td height="35" class="labelmedium"><cf_tl id="Description">:</td>
			<td>
				<cfinput type="text" name="DetailDescription" class="regularxl" required="Yes" message="Please, enter a valid description." size="50" maxlength="100">	
			</td>
		</tr>
		<tr>
			<td height="35" class="labelmedium"><cf_tl id="Storage Code">:</td>
			<td>
				<cfinput type="text" name="DetailStorageCode" class="regularxl" required="No" message="Please, enter a valid storage code." size="10" maxlength="20">
			</td>
		</tr>
		<td height="35" class="labelmedium"><cf_tl id="Item">:</td>
		<td>
			<table width="100%" cellspacing="0" cellpadding="0">
				<tr>
				<td width="4%">				
					      
						   <cfset link = "#SESSION.root#/warehouse/application/stock/Transaction/getItem.cfm?mode=#url.mode#&showLocation=no">	
										      			   
						   <cf_selectlookup
							    box          = "itembox"
								link         = "#link#"
								title        = "Item Supplies Selection"
								icon         = "contract.gif"
								button       = "Yes"
								close        = "Yes"	
								filter1      = "warehouse"
								filter1value = "#url.warehouse#"						
								filter2      = "itemclass"
								filter2value = "Supply"
								class        = "Item"
								des1         = "ItemNo">	
								
							<input type="hidden" name="itemno" id="itemno">	
				
				</td>
				<td id="itembox">
					<cfset vItemNo = "">
					<cfif getLast.recordcount gt 0>
						<cfset vItemNo = getLast.ItemNo>
					<cfelse>
						<cfif getLastIWL.recordcount gt 0>
							<cfset vItemNo = getLastIWL.ItemNo>
						</cfif>
					</cfif>
					
					<cfif getLast.recordcount gt 0 or getLastIWL.recordcount gt 0>
						<cfdiv id="divItemNo" bind="url:#link#&itemno=#vItemNo#">
					</cfif>
				</td>
				</tr>
			
			</table>	
		</td>
	</tr>
	
	<tr>
	   <td height="22" class="labelmedium"><cf_tl id="Capacity"> / <cf_tl id="UoM">:</td>
	   <td>
		   <table cellspacing="0" cellpadding="0">
		   		<tr>
					<td>
						<cfinput type="text" name="Capacity" class="regularxl" required="Yes" message="Please, enter a valid numeric capacity." validate="numeric" size="10" maxlength="10" style="text-align:right;padding-right:1px">
					</td>
					<td width="5"></td>
		   			<td id="uombox"></td>
				</tr>
		   </table>	
	   </td>	
	</tr>
	
	<tr><td height="5"></td></tr>
	<tr><td class="line" colspan="2"></td></tr>
	<tr><td height="5"></td></tr>
	
	<tr>
		<td colspan="2" align="center">
			<cfoutput>
			<cf_tl id="Save" var="vSave">
				<input type="Submit" name="save" id="save" value="#vSave#" class="button10g" onclick="return checkItem();">
			</cfoutput>
		</td>
	</tr>
	
	<tr><td height="15"></td></tr>
	<tr>
		<td colspan="2">
			<cfdiv id="divWLCapacity" bind="url:DetailsListing.cfm?warehouse=#url.warehouse#&location=#url.location#">
		</td>
	</tr>
	
</table>

</cfform>
