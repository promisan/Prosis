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

<cfquery name="getTransactions"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

	     SELECT    T.TransactionId, 
		           T.Mission, 
				   T.Warehouse, 
				   T.TransactionType, 
				   R.Description, 
				   R.TransactionClass,
				   T.TransactionDate, 
				   T.ItemNo, 
				   T.ItemDescription, 
				   T.ItemCategory, 
				   T.ItemPrecision,
	               T.Location, 			   
				   ( SELECT Description 
				     FROM   WarehouseLocation L 
					 WHERE  L.Warehouse = T.Warehouse AND L.Location = T.Location) as LocationDescription,	
				   T.TransactionQuantity, 
				   T.TransactionUoM, 
				   I.UOMDescription, 
				   T.TransactionUoMMultiplier, 
				   T.TransactionQuantityBase, 
				   T.TransactionCostPrice, 
	               T.TransactionValue, 
				   T.TransactionBatchNo, 
				   T.AssetId,
				   		 
				   T.RequestId, 
				   T.OrgUnit, 
				   T.OrgUnitCode, 
				   T.OrgUnitName, 
				   T.Remarks, 
				   T.ActionStatus,	
				   T.Created
				   
		FROM       ItemTransaction T INNER JOIN
	               Ref_TransactionType R ON T.TransactionType = R.TransactionType INNER JOIN
	               ItemUoM I ON T.ItemNo = I.ItemNo AND T.TransactionUoM = I.UoM 
		WHERE      T.AssetId = '#assetid#'
		AND        TransactionDate >= '#dateformat(dte,client.dateSQL)#' 
	    AND        TransactionDate < '#dateformat(dte+1,client.dateSQL)#'
		ORDER BY   T.Created
			   
</cfquery>	

<table width = "98%" 
       align = "center"       
       border= "0"
       cellspacing="0"
	   cellpadding="0">	
	   					
    <TR>
	<td height="100%" colspan="2" valign="top" style="padding-right:3px">
	  
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		
		<cfoutput>
		
		<tr>
		 <td width="3%" height="17"></td>  
		 			
			<TD width="20%"><cf_tl id="Facility"></TD>
			<TD width="25%" colspan="2"><cf_tl id="Product"></TD>					  				
			<TD width="15%"><cf_tl id="Location"></TD>
			<TD width="90"><cf_tl id="Date"></TD>
			<!---
			<TD width="15%">Unit</TD>			
			--->
		    <TD align="right"><cf_tl id="Quantity"></TD>
			<TD align="right"><cf_tl id="UoM"></TD>
			<td align="right"><cf_tl id="Value"></td>
			
		</tr>
		
		</cfoutput>
		
		<tr><td height="1" colspan="11" style="border-top:1px dotted silver"></td></tr>
																			
			<cfoutput query="getTransactions"> 
							
				  <cf_precision number="#ItemPrecision#">
												
						<tr id="r#currentrow#" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('FFFFFF'))#"
						    class="regular"	height="20"	style="cursor : pointer;"
							onmouseover="if (this.className=='regular') {this.className='highlight1'}"
							onmouseout="if (this.className=='highlight1') {this.className='regular'}">
														
						<td id="status_#transactionid#" style="padding-left:4px">								
						</td>
						
						<td>
						
						<cfquery name="Warehouse"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   *
								FROM     Warehouse 
								WHERE    Warehouse       = '#warehouse#'									
							</cfquery>
							
							#Warehouse.WarehouseName#
						
						</td>	
						
						<TD colspan="2">
						<a href="javascript:batchtransaction('#transactionid#','','inquiry')"><font color="6688aa">#ItemNo# #ItemDescription#</a></font>
						</TD>
						
						<TD>
						
						    <cfif TransactionClass eq "Transfer" and transactionQuantity gt "0"><font color="808080"><cf_tl id="To">&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;</font>
							<cfelseif TransactionClass eq "Transfer" and transactionQuantity lt "0"><font color="808080"><cf_tl id="From">:&nbsp;</font>								
							</cfif>
							#LocationDescription#
						
						</TD>
											
					<TD>#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</TD>
					<!---
					<TD>#OrgUnitName#</TD>
					--->
					<td align="right" width="8%" id="qty_#transactionid#">
					
					    <table width="100%" cellspacing="0" cellpadding="0">
						<tr>
						<td width="90%" align="right">
					
					    <cf_space spaces="20">
						<cfif TransactionQuantity lt "0" and transactiontype neq "2">
							<font color="FF0000">
						</cfif>
						<cfif transactiontype eq "2">
						#NumberFormat(-TransactionQuantity,'#pformat#')#
						<cfelse>
						#NumberFormat(TransactionQuantity,'#pformat#')#
						</cfif>
						
						</td>						
						
						</tr>
						</table>
						
					</td>	
					<td align="right" width="6%">#UoMDescription#</td>	
					<td align="right" width="8%" style="padding-right:4px">
					<cf_space spaces="20">
					<cfif transactiontype eq "2">
						#NumberFormat(-TransactionValue,'_____,__.__')#
						<cfelse>
						#NumberFormat(TransactionValue,'_____,__.__')#
						</cfif>												
					</td>	
					</TR>	
																							 									
				</CFOUTPUT>
				
				</TABLE>
						
		</td>
	</tr>
		
</table>