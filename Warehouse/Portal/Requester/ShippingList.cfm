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

<!--- Check pending clearance --->

<cfquery name="Parameter" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Result" 
datasource = "AppsMaterials" 
username   = "#SESSION.login#" 
password   = "#SESSION.dbpw#">

	SELECT     IT.TransactionId,
	           IT.Warehouse, 
	           IT.ItemDescription, 
			   IT.TransactionQuantity, 
			   IT.TransactionDate,
			   IT.ItemNo,
			   IT.ItemDescription,
			   U.UoMDescription, 
			   IT.TransactionCostPrice, 
			   IT.TransactionValue, 
			   IT.Location, 
			   S.ActionStatus, 
			   S.ConfirmationDate,
			   IT.OfficerUserId, 
	           IT.OfficerLastName, 
			   IT.OfficerFirstName, 
			   R.RequestId,
			   R.Reference, 
			   R.RequestDate,
			   R.RequestedQuantity, 
			   Item.ItemClass
	FROM       ItemTransaction IT INNER JOIN
	           ItemTransactionShipping S ON IT.TransactionId = S.TransactionId INNER JOIN
	           ItemUoM U ON IT.ItemNo = U.ItemNo AND IT.TransactionUoM = U.UoM INNER JOIN
	           Request R ON IT.RequestId = R.RequestId INNER JOIN
	           Item ON IT.ItemNo = Item.ItemNo INNER JOIN
	           RequestHeader H ON R.Reference = H.Reference 
	WHERE      1=1
	
	<cfif Parameter.UnitConfirmation eq "1">
	AND 		(
	            R.OfficerUserId = '#SESSION.acc#' 
				OR
				H.OrgUnit IN (SELECT OrgUnit 
				              FROM   Organization.dbo.OrganizationAuthorization 
							  WHERE  UserAccount = '#SESSION.acc#'
							  AND    Role = 'ReqClear')   
				)			      
	<cfelse>
	AND 		R.OfficerUserId = '#SESSION.acc#'
	</cfif>
	
	AND        (S.ActionStatus = '0'  or (S.ActionStatus = '2' AND S.ConfirmationDate > getDate()-1))  <!--- we keep it visible one day --->
	ORDER BY   R.Reference, R.RequestDate
	
</cfquery>

<cfset total = 0>

<cf_divscroll>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<TR>
		<TD height="17">&nbsp;&nbsp;&nbsp;</TD>		
		<TD width="25%"><cf_tl id="Item"></TD>
		<TD><cf_tl id="No"></TD>
		<TD><cf_tl id="Request"></TD>
		<TD><cf_tl id="Date"></TD>
		<TD><cf_tl id="Picked"></TD>
		<TD><cf_tl id="UoM"></TD>
		<TD align="right"><cf_tl id="Qty"></TD>				
		<TD align="right"><cf_tl id="Price"></TD>
		<TD align="right"><cf_tl id="Amount"></TD>
		<TD width="120" align="right"><cf_tl id="Confirmation"></TD>
	</TR>
	<tr><td colspan="11" height="1" bgcolor="silver"></td></tr>
	
	<cfoutput>
	<tr>
		<td colspan="11" height="23" valign="middle" style="padding-left:10px"><img src="#SESSION.root#/images/status_complete.gif" alt="" align="absmiddle" border="0"></td>
	</tr>
</cfoutput>	

<cfset prior = "">

<cfoutput query="Result">
	
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f6f6f6'))#">
	
	<cfif prior neq requestid>
	
		<td align="center" height="20" width="40">
			
				<img src="#SESSION.root#/Images/icon_expand.gif" alt="More details" 
					id="#requestid#Exp" border="0" class="show" 
					align="absmiddle" style="cursor: pointer;" 
					onClick="more('#requestId#')">
					
					<img src="#SESSION.root#/Images/icon_collapse.gif" 
					id="#requestid#Min" alt="More details" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;" 
					onClick="more('#requestid#')">
		</td>	
			
		<td><a href="javascript:more('#requestId#')" title="More details">#ItemDescription#</a></td>	
		<td width="50"><a href="javascript:more('#requestId#')" title="More details">#ItemNo#</a></td>
		<TD width="70">#Reference#</TD>	
		<td width="70">#Dateformat(RequestDate, CLIENT.DateFormatShow)#</td>
	
	<cfelse>
	
		<td colspan="5" height="20"></td>
		
	</cfif>
	
	<cfset prior = requestid>
	
	<td width="70">#Dateformat(TransactionDate, CLIENT.DateFormatShow)#</td>
	<TD width="80">#UoMDescription#</TD>
	<TD width="60" align="right">#TransactionQuantity*-1#</TD>	
	<td align="right">#NumberFormat(TransactionCostPrice,'__,____.__')#</td>
	<td align="right">#NumberFormat(TransactionValue*-1,'__,____.__')#</td>
	<td align="right" id="box#TransactionId#">
				
		<cfif actionstatus eq "0">	
		
			 <a href="javascript:ColdFusion.navigate('Requester/ShippingListConfirm.cfm?status=2&id=#transactionid#','box#TransactionId#')">
				<font color="6688aa"><cf_tl id="Confirm"></font>
			 </a>
		 
		 <cfelse>
		 
			 <table cellspacing="0" cellpadding="0">
				<tr><td>
				
					 <img src="#SESSION.root#/images/print_small5.gif" 
							    align="absmiddle" 
								style="cursor: pointer;"
								alt="Print Requisition" 
								border="0" 
								onclick="mail3('print','#Reference#')">	
					</td>
					<td>&nbsp;</td>
					<td>
				
					 <a href="javascript:ColdFusion.navigate('Requester/ShippingListConfirm.cfm?status=0&id=#transactionid#','box#TransactionId#')">
					 <font color="6688aa"><cf_tl id="Reset"> #Dateformat(now(),CLIENT.DateFormatShow)#</font>
					</a>
				
				</td> 
				
				</tr>
			 </table>
 		 
		 </cfif>
		   
    </td>
	
	<cfset total = total - TransactionValue>
	
	</TR>
	
	<tr class="hide" id="b#RequestId#">
		<td colspan="11" style="padding:3px" id="i#RequestId#"></td>
	</tr>
	
	<tr><td colspan="11" bgcolor="E5E5E5"></td></tr>
	
</cfoutput>

<cfoutput>

	<cfif total neq "0">

	<tr>
	  <td colspan="9"></td>
      <td align="right"></td>
	  <td align="left"></td>
	</tr>
	
	<tr>
		<td colspan="7"></td>
		<td colspan="2" align="right"><cf_tl id="Total">:</b></td>
    	<td colspan="1" align="right"><b>#NumberFormat(total,'__,____.__')#</b></td>
	</tr>
	
	<tr><td height="5"></td></tr>
	
	</cfif>
	
</cfoutput>

<tr><td height="5"></td></tr>

<cfinclude template="ShippingListAsset.cfm">


</TABLE>	
</cf_divscroll>