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
<cfparam name="url.actionStatus" default="1">

<cfquery name="getTransactions" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	  
	  SELECT *,  
	  
	  		(SELECT Description 
			 FROM   WarehouseLocation 
			 WHERE  Warehouse = B.Warehouse 
			 AND    Location = B.Location) as LocationDescription,		
			 
			(SELECT count(*) 
		     FROM ItemTransaction WHERE TransactionBatchNo = B.BatchNo) as Lines	    
	  
	  FROM   WarehouseBatch B, Ref_TransactionType R
	  WHERE  B.TransactionType = R.TransactionType
	  AND    BatchNo IN (
	  
			  SELECT     DISTINCT TransactionBatchNo
						 
			  FROM       ItemTransaction T
		
		      <!--- selected mission / warehouse --->			   
			  WHERE      T.Mission     = '#url.mission#'
			  AND        T.Warehouse   = '#url.warehouse#'				 
					  
			  <!--- status --->
			  AND        T.ActionStatus = '#url.actionStatus#'
			  
			  <!--- only transactions for external --->
			  AND        T.BillingMode = 'External'
			  
			  AND        T.Location  IN (SELECT Location 
	                                    FROM    WarehouseLocation 
										WHERE   Warehouse       = '#url.warehouse#'
										AND     Location        = T.Location
										<!--- AND     OrgUnitOperator = '#url.orgunit#' --->)
			  
			  <!--- destination asset item or transfer --->
			  
			  <cfif url.category eq "Transfer">
			  
			 	  AND		 (T.TransactionType = '8' AND T.TransactionQuantity < 0)
			  
			  <cfelse>
			  
				  AND        T.TransactionType = '2'
				  
				  <!--- removed by hanno to show by batch 
				  
				  AND        T.AssetId IN (SELECT   AssetId
				                           FROM     AssetItem 
										   WHERE    AssetId = T.AssetId
										   AND      ItemNo IN (SELECT ItemNo 
										                       FROM   Item 
															   WHERE  Category = '#url.category#')
										   )  
										   
										   --->
									   
			  </cfif>	
			  
			  			  
			  <!--- not billed yet --->
	  		  AND       T.TransactionId IN
	                             (
								  SELECT   TransactionId
	                              FROM     ItemTransactionShipping S
	                              WHERE    TransactionId = T.TransactionId 
								  AND      (
								            InvoiceId IS NULL OR 
											InvoiceId NOT IN (SELECT InvoiceId 
											                  FROM   Purchase.dbo.Invoice WHERE InvoiceId = S.InvoiceId)
										    )
								 )		
								 												  	  
											  
			)	  
	  
</cfquery>			


<table width="97%" cellspacing="0" cellpadding="0" style="border:1px dotted silver">

	<tr>
	    <td width="3%" height="17"></td>
		<TD width="80" class="labelit"><cf_tl id="Batch"></TD>
	    <TD width="120" class="labelit"><cf_tl id="Transaction"></TD>
		<TD width="100" class="labelit"><cf_tl id="Date"></TD>
		<TD width="120" class="labelit"><cf_tl id="Location"></TD>
		<TD width="20%" class="labelit"><cf_tl id="Memo"></TD>		
	    <TD width="20%" class="labelit"><cf_tl id="Officer"></TD>
		<td width="100" class="labelit" align="right" style="padding-right:20px"><cf_tl id="Lines"></td>		
	</TR>
	
			
	<cfoutput query="getTransactions">
	
		  <tr><td colspan="9" style="border-top:1px dotted silver"></td></tr>
	
	      <tr style="cursor : pointer;"
				onmouseover="if (this.className=='regular') {this.className='highlight4'}"
				onmouseout="if (this.className=='highlight4') {this.className='regular'}">
		    	
				<td align="center" class="labelsmall" height="15">#currentrow#</td>
				
				<TD>

					<table cellspacing="0" cellpadding="0">
						<tr>
						
						<td style="padding-right:6px;padding-left:4px">
							 <img src="#SESSION.root#/Images/contract.gif" name="img0_#currentrow#" 
								  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
								  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/contract.gif'"
								  style="cursor: pointer;" 
								  alt="Open Batch Transaction" 
								  width="11" height="12" border="0" align="absmiddle" 
								  onClick="batch('#BatchNo#','#url.mission#','process','#url.systemfunctionid#','#url.box#')">
						 </td>
						 <td width="6"></td>
						 <td class="labelit">#BatchNo#</td>
						 
						</tr>
						  
					</table>
				
				</TD>
				<TD class="labelit">#Description#</TD>
				<td class="labelit">#LocationDescription#</td>
				<TD class="labelit" align="center">#dateformat(TransactionDate,CLIENT.DateFormatShow)#</TD>
				<TD class="labelit">#BatchDescription#</TD>				
				<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
			    <td class="labelit" align="right" style="padding-right:20px">#lines#</td>	
												
			</TR>				
				
	</cfoutput>

</table>