
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

<tr><td align="center">
	Delivery Point
	</td></tr>
	
	<tr><td>
	
	<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding"></table>
		<tr><td><img src="#SESSION.root#/images/TableMidTop.gif" height="1" WIDTH="100%" alt="" border="0"></td></tr>
		<tr>
			<td>United Nations (Maximum overhead clearance for truck delivieries - 11.9 Ft)</td>
		</tr>
		<tr><td>48th Street and 1st Avenue</td></tr>
		<tr><td>New York, N.Y. 10017</td></tr>
	    <tr><td><img src="#SESSION.root#/images/TableMidTop.gif" height="1" WIDTH="100%" alt="" border="0"></td></tr>
		<tr><td height="10"></td></tr>
	</table>
	
	</td></tr>
	
	<tr><td>

		<!--- show the sublines --->
	
		<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
							
				<tr><td colspan="1" align="right">Payment Terms:</td>
				    <td>________________________</td></tr>
				<tr><td colspan="1" align="right">Delivery Point:</td>
				    <td>________________________</td></tr>
				<tr><td colspan="1" align="right">Shipping Mode:</td>
				    <td>________________________</td></tr>
				<tr><td colspan="1" align="right">Delivery Date (after receipt of order):</td>
				    <td>_____________</td></tr>	
				<tr><td colspan="1" align="right">Comments:</td>
					<td>___________________________________________________</td></tr>		
				<tr><td colspan="1" align="right"></td>
				    <td>___________________________________________________</td></tr>	
				<tr><td colspan="1" align="right"></td>
				    <td>___________________________________________________</td></tr>	
				<tr><td colspan="1" align="right"></td>
				    <td>___________________________________________________</td></tr>	
					
							
				
		</table>
		
	</td></tr>	
	
	<tr><td height="20"></td></tr>
	
	<tr><td>_____________________________________________________________________</td></tr>
	<tr><td>(Name and Signature of Person completing this Request)</td></tr>
	
	<cfoutput>
	<tr><td><font color="0080FF"><b>#Vendor.OrgUnitName# #Vendor.OrgUnitCode#</td></tr>
	</cfoutput>
	<tr><td>(Company Name and UN Vendor Id)</td></tr>
	
	<tr><td>Date : _________________</td></tr>
		
	

</table>
