<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
		
<cfparam name="URL.Mode" default="cart">
<!--- show all items by service here --->
		
<cfquery name="Cart" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    C.ServiceItemUnit, 
             C.Reference, 
			 C.DateEffective, 
			 C.DateExpiration, 
			 C.Currency, 
			 C.Amount, 
			 C.Remarks, 
			 C.ActionStatus, 
			 C.Mission, 
			 C.ServiceItem, 
             C.CartId, 
			 S.Description AS ServiceItemDescription, 
			 U.UnitDescription
   FROM      Cart AS C INNER JOIN
             ServiceItem AS S ON C.ServiceItem = S.Code INNER JOIN
             ServiceItemUnit AS U ON C.ServiceItem = U.ServiceItem AND C.ServiceItemUnit = U.Unit
	WHERE    C.OfficerUserId = '#SESSION.acc#'
	ORDER BY S.Listingorder
</cfquery>

<table width="99%" border="0" cellspacing="0" cellpadding="2" align="center">
	
<cfoutput query="Cart" group="ServiceItem">

	<tr><td height="25" colspan="9">&nbsp;<font color="804040">#ServiceItemDescription#</font></td></tr>
	<tr><td height="1" bgcolor="silver" colspan="9"></td></tr>
	
	<TR>
		<TD>&nbsp;&nbsp;&nbsp;</TD>
		<TD><cf_tl id="Unit"></TD>
		<TD><cf_tl id="Reference"></TD>
		<TD><cf_tl id="Currency"></TD>
		<TD align="right"><cf_tl id="Amount"></TD>
		<TD></TD>
	</TR>
	<tr><td height="1" class="line" colspan="9"></td></tr>
	
	<cfset total = 0>
	
	<cfoutput>
			
		<!--- cart info --->		
	   				
		<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f6f6f6'))#">
		<td align="center"></td>
		<TD width="40%">#UnitDescription#</TD>
		<td width="90">#Reference#</td>	
		<td width="60">#Currency#</td>
		<td align="right" style="padding-left:3px">#NumberFormat(Amount,'__,____.__')#</td>
		<td width="35" align="center" style="padding-left:3px">
		   <a href="javascript:cartpurge('#cartid#')">
		       <img src="#SESSION.root#/images/delete5.gif" alt="Purge" name="Cancel" id="Cancel" width="12" height="12" border="0" align="middle">
		   </a>
	    </td>
		<cfset total = total + (amount)>
		</TR>
		<tr><td colspan="9" bgcolor="E5E5E5"></td></tr>
		
	</cfoutput>		
		
	<tr>
		<td colspan="4"></td>
	    <td align="right" valign="top">------------</td>
		<td align="left">+</td>
	</tr>
	<tr>
		<td colspan="2"></td>
		<td colspan="2" align="right"><b>Total:</b></td>
	    <td colspan="1" align="right"><b>#NumberFormat(total,'__,____.__')#</b></td>
	</tr>
		
</cfoutput>

</table>

<cfif url.mode neq "CheckOut">

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="6688AA">
	<tr><td height="4" colspan="4"></td></tr>
	<tr><td height="1" colspan="4" bgcolor="silver"></td></tr>
	<tr><td height="3" colspan="4" align="right"></td></tr>
	<tr><td colspan="4" align="center">
	<cfif cart.recordcount neq "0">
		<cfoutput>
		    <img src="#SESSION.root#/Images/Cart/Cancel.png" alt="Cancel Cart" style="cursor:hand" border="0" onClick="cancelcart()">
		    <img src="#SESSION.root#/Images/Cart/Continue.png" alt="Continue" style="cursor:hand" border="0" onClick="go.click()">
			<img src="#SESSION.root#/Images/Cart/Checkout.png" alt="Continue" style="cursor:hand" border="0" onClick="checkout()">		
		</cfoutput>	
	</cfif>
	<tr>
</table>

</cfif>