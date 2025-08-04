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
 
<cfquery name="Lines" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     IP.InvoiceId, 
	           I.InvoiceNo, 
			   I.DocumentDate,
			   I.ActionStatus, 
			    (SELECT Objectid 
				   FROM   Organization.dbo.OrganizationObject 
				   WHERE  ObjectKeyValue4 = I.Invoiceid) as WorkflowId,
			   I.Description, 
			   I.DocumentCurrency, 
			   IP.AmountMatched
    FROM       InvoicePurchase IP INNER JOIN
               Invoice I ON IP.InvoiceId = I.InvoiceId
    WHERE      IP.RequisitionNo = '#URL.ID#'
	 AND       I.ActionStatus != '9'
	ORDER BY DocumentDate
</cfquery>  

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" class="navigation_table">
      
    <TR class="labelit" bgcolor="white">
	   <td height="16" align="center" width="30"><cf_tl id="No."></td>
	   <td width="40%"><cf_tl id="Description"></td>
	   <td width="120"><cf_tl id="InvoiceNo"></td>
       <td width="80"><cf_tl id="Date"></td>
	   <td width="80"><cf_tl id="Status"></td>
       <td width="10%" align="right"><cf_tl id="Amount"></td>	 
	  
     </TR> 
	 	  
	 <tr><td height="1" colspan="6" class="line"></td></tr>  
						
		<cfoutput query="Lines">
				
			<tr class="labelit line navigation_row">						
				<td height="17" align="center">#CurrentRow#.</td>
				<td style="padding-left:2px"><a href="javascript:invoiceedit('#invoiceid#');"><font color="0080C0">#Description#</a></td>
			    <td style="padding-left:2px">#InvoiceNo#</td>
				<td style="padding-left:2px">#DateFormat(DocumentDate,CLIENT.DateFormatShow)#</td>
				<td style="padding-left:2px"><cfif ActionStatus gte "1">Posted<cfelseif ActionStatus eq "0" and WorkFlowid neq ""><font color="green">In Process<cfelse><font color="gray">On Hold</cfif></td>
				<td style="padding-left:2px" align="right" bgcolor="DAFCF9">#NumberFormat(AmountMatched,",__.__")#</td>			
			</tr>			
									
		</cfoutput>
				
</table>

<cfset ajaxonload("doHighlight")>