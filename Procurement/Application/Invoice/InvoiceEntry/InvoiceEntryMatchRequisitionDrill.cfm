<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="Invoice" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
	SELECT   I.InvoiceId,
	         I.Mission, 
			 I.InvoiceNo, 
			 IP.AmountMatched, 
			 I.OfficerUserId, 
			 I.OfficerLastName, 
			 I.OfficerFirstName, 
			 I.Created, 
			 ( 	 SELECT ObjectKeyValue4 
				  FROM   Organization.dbo.OrganizationObject
	      		  WHERE  EntityCode    = 'ProcInvoice'
				  AND    ObjectKeyValue4 = I.InvoiceId ) as Posted,
			 I.ActionStatus
	FROM     InvoicePurchase IP INNER JOIN Invoice I ON IP.InvoiceId = I.InvoiceId
	WHERE    IP.RequisitionNo = '#url.requisitionno#' 
	AND      I.ActionStatus != '9'
	ORDER BY I.Created 
</cfquery>

<table class="navigation_table" cellpadding="0" width="98%" align="center" style="border-top:1px dotted silver;padding:3px" bgcolor="ffffff">

	<cfoutput query="Invoice">
		<tr class="labelit linedotted navigation_row">
			<td width="30" style="padding-left:3px;padding-top:2px"><cf_img icon="open" navigation="Yes" onclick="invoiceedit('#invoiceid#')"></td>
			<td width="18%">#InvoiceNo#</td>
			<td width="25%">#OfficerLastName#</td>
			<td width="15%">#dateformat(Created,CLIENT.DateFormatShow)#</td>
			<td width="10%"><cfif Posted neq ""><cf_tl id="Posted"><cfelse><font color="FF0000"><cf_tl id="In Process"></cfif></td>
			<td width="25%" style="padding-right:3px" align="right">#NumberFormat(AmountMatched,"__,__.__")#</td>
		</tr>	
	</cfoutput>
	
</table>