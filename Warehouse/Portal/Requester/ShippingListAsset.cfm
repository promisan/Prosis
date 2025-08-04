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

<cfquery name="Result" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     I.ItemNo,
           I.Make, 
		   I.SerialNo, 
		   I.AssetBarCode,
		   I.Model, 
		   I.Description, 
		   I.DepreciationBase, 
		   I.DepreciationCumulative, 
		   Item.ItemDescription,
		   M.DateEffective as TransactionDate,
		   R.RequestId,
		   R.Reference, 
		   R.RequestDate, 
		   R.RequestedQuantity, 
           O.MovementId
FROM       AssetItemOrganization O INNER JOIN
           Request R ON O.RequestId = R.RequestId INNER JOIN
           AssetItem I ON O.AssetId = I.AssetId INNER JOIN
           AssetMovement M ON O.MovementId = M.MovementId INNER JOIN
           Item ON I.ItemNo = Item.ItemNo
WHERE      R.OfficerUserId = '#SESSION.acc#' 
AND        M.ActionStatus = '0'
ORDER BY R.Reference
</cfquery>

<cfset total = 0>
<cfset cum = 0>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="1" colspan="11" bgcolor="silver"></td></tr>
<TR style="background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Images/gradient_yellow.jpg')">
		<TD height="17">&nbsp;&nbsp;&nbsp;</TD>
		<TD width="25%"><cf_tl id="Item"></TD>
		<TD><cf_tl id="No"></TD>		
		<TD><cf_tl id="Request"></TD>
		<TD><cf_tl id="Date"></TD>
		<TD><cf_tl id="SerialNo"></TD>
		<TD><cf_tl id="Barcode"></TD>	
		<TD><cf_tl id="Make"></TD>				
		<TD align="right"><cf_tl id="Amount"></TD>
		<TD align="right"><cf_tl id="Depre."></TD>
		<TD width="20" align="right"></TD>
	</TR>
	<tr><td colspan="11" height="1" bgcolor="silver"></td></tr>
	
<cfoutput query="Result" group="RequestId">
		
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f6f6f6'))#">
	
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
		
		<TD><a href="javascript:more('#requestId#')" title="More details">#ItemDescription#</a></TD>
		<TD width="50"><a href="javascript:more('#requestId#')" title="More details">#ItemNo#</a></TD>
		<TD width="70">#Reference#</TD>	
		<td width="70">#Dateformat(RequestDate, CLIENT.DateFormatShow)#</td>
		<td width="70">#Dateformat(TransactionDate, CLIENT.DateFormatShow)#</td>
		<TD width="80"></TD>
		<TD width="60" align="right"></TD>	
		<td align="right"></td>
		<td align="right"></td>
		<td align="right" id="box#RequestId#">
		
		 <img src="#SESSION.root#/Images/contract.gif" alt="" name="img0_#currentrow#" 
					  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/contract.gif'"
					  style="cursor: pointer;" alt="" width="13" height="14" border="0" align="middle" 
					  onClick="javascript:process('#MovementId#')">		
		
		</td>
	</TR>
		
	<tr class="hide" id="b#RequestId#"><td colspan="10" id="i#RequestId#"></td></tr>
	
	<cfoutput>
	<tr>
	
		<TD height="17"></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD><img src="#SESSION.root#/images/join.gif" alt="" border="0"></TD>
		<TD>#SerialNo#</TD>
		<TD>#AssetBarcode#</TD>	
		<TD>#Make#</TD>				
		<TD align="right">#NumberFormat(depreciationbase,'__,____.__')#</TD>
		<TD align="right"><cfif depreciationcumulative neq "">#NumberFormat(depreciationcumulative,'__,____.__')#</cfif></TD>
		<TD width="40" align="right"></TD>
	
	</tr>
	
	<cfset total = total + depreciationbase>
	<cfif depreciationcumulative neq "">
		<cfset cum   = cum   + depreciationcumulative>
	</cfif>
	
	</cfoutput>
	
	
	<tr><td colspan="11" bgcolor="E5E5E5"></td></tr>
	
</cfoutput>	

<cfoutput>

	<cfif total neq "0">
	
	<tr>
	<td colspan="6"></td>
	<td colspan="2"><b>Total:</b></td>
    <td colspan="1" align="right"><b>#NumberFormat(total,'__,____.__')#</b></td>
	<td colspan="1" align="right"><b>#NumberFormat(cum,'__,____.__')#</b></td>
	<td></td>
	</tr>
	<tr><td height="5"></td></tr>
	
	</cfif>
	
</cfoutput>

<tr><td height="5"></td></tr>

</TABLE>	
