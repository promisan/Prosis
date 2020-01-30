
<cfquery name="Lines" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT    *
	 FROM      RequisitionLine
	 WHERE     JobNo = '#Object.ObjectKeyValue1#'
	 AND       ActionStatus NOT IN ('0z','9')
</cfquery>	 

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td align="center">Requirement</td></tr>
	
	<tr><td>

	<!--- show the sublines --->

	<table width="95%" align="center">
			
			<tr>
			    <td>No</td>
				<td>Item/Service</td>
				<td>Qty</td>
				<td>UoM</td>
				<td>Unit Price</td>
				<td>Extended Price</td>
			</tr>
			<tr><td colspan="5">
			<img src="#SESSION.root#/images/TableMidTop.gif" height="1" WIDTH="100%" alt="" border="0"></td></tr>
			<cfoutput query="lines">
			<tr>
			    <td>#currentrow#.</td>
				<td width="40%">#RequestDescription#</td>
				<td>#RequestQuantity#</td>	
				<td>#QuantityUoM#</td>
				<td>_____________</td>
				<td>_____________</td>
			</tr>
			<tr><td colspan="5">
				#Remarks#
			</td></tr>
			</cfoutput>
			
			<tr><td colspan="5" align="right">Total all items:</td><td>_____________</td></tr>
			<tr><td colspan="5" align="right">Discount:</td><td>_____________</td></tr>
			<tr><td colspan="5" align="right">Net Total:</td><td>_____________</td></tr>
			<tr><td colspan="5" align="right">Additional Charges:</td><td>_____________</td></tr>
			<tr><td colspan="5" align="right">Freight:</td><td>_____________</td></tr>
			<tr><td colspan="5" align="right">Grand Total:</td><td>_____________</td></tr>
	</table>
	
	</td></tr>	
	
	<tr><td>

	<!--- show the sublines --->

	<table width="95%" align="center">
	
		<tr><td>
		PLEASE SUPPLY THE FOLLOWING INFORMATION:
		</td></tr>
		
		<tr><td>
		I certify that I have read and understood the Specifications and that prices quoted are in accordance with the requirements as specified. 
		</td></tr>
		<tr><td>
		In compliance with this RFQ, and subject to all the conditions thereof, the undersigned offers to furnish any or all items upon which prices are quoted, at the prices set opposite each item, delivered at the point as specified if the contract is awarded.
		</td></tr>
		
		<tr>
		<td>[  ] YES</td>
		</tr>
		<tr>
		<td>[  ] NO</td>
		</tr>
		
		
		<tr><td>_________________________________________________________________</td></tr>
		<tr><td>(NAME IN PRINT, TITLE AND SIGNATURE OF AUTHORISED PERSONNEL)</td></tr>
		<tr><td height="4"></td></tr>
		<tr><td>
			<table cellspacing="0" cellpadding="0" class="formpadding">
				<tr><td>Name of Firm:</td><td><font color="0080FF"><b>#Vendor.OrgUnitName# #Vendor.OrgUnitCode#</b></td></tr>
				<tr><td>Telephone:</td><td>____________________________________________</td></tr>
				<tr><td>Fax:</td><td>____________________________________________</td></tr>
				<tr><td>eMail:</td><td>____________________________________________</td></tr>
				<tr><td>Date:</td><td>____________________________</td></tr>
			</TABLE>
			</td>
		</tr>	
		
	</table>
	</td></tr>	

</table>
