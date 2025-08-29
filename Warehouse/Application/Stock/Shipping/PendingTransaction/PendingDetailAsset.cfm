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
<cfquery name="getPending" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	  	  
	  SELECT   B.BatchNo, 
	           B.TransactionDate, 
			   B.ActionOfficerLastName, 
			   B.ActionOfficerDate, 
			   R.TransactionType as TransactionDescription,
			   COUNT(*) as Lines, 
			   SUM(T.TransactionQuantity) as Quantity  			 
			
	  FROM     ItemTransaction T, 
	           WarehouseBatch B, 
			   Ref_TransactionType R
	  WHERE    T.TransactionBatchNo = B.BatchNo
	  AND      B.TransactionType    = R.TransactionType
	  	 	
      <!--- filter selected mission / warehouse --->			   
	  AND      T.Mission     = '#url.mission#'
	  AND      T.Warehouse   = '#url.warehouse#'	
			  
	  <!--- status is approved = 1 --->
	  AND      T.ActionStatus = '#url.actionStatus#'	 
	  
	  <!--- only transactions for external billing tagged --->
	  AND      T.BillingMode = 'External'
	  
	  <!--- only valid valid location  --->
	  AND      T.Location  IN ( SELECT  Location 
                                FROM    WarehouseLocation 
								WHERE   Warehouse       = '#url.warehouse#'
								AND     Location        = T.Location
								<!--- AND     OrgUnitOperator = '#url.orgunit#' --->
								)
	  
	  <!--- issues --->  	  			  
	  AND      T.TransactionType = '2'
	 	  
	  <!--- selected category only --->
	  AND      T.AssetId IN (
	  
	                         SELECT   AssetId
	                         FROM     AssetItem 
							 WHERE    AssetId = T.AssetId
							 AND      ItemNo IN (SELECT ItemNo 
							                     FROM   Item 
												 WHERE  Category = '#url.category#')
							 )
							   
	  
	  <!--- and not billed yet --->
	  
	  AND     B.BillingStatus = '0'
	  AND     T.TransactionId IN  (
				  SELECT   TransactionId
                  FROM     ItemTransactionShipping S
                  WHERE    TransactionId = T.TransactionId 
				  AND      (
				            InvoiceId IS NULL OR 
							InvoiceId NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice WHERE InvoiceId = S.InvoiceId)
						   )
				 )		
		  	
	  <!--- for the period and supply item selected, the batch will only be for a single item in fuel operations for status 8 and 2  --->
	  
	  AND     T.ItemNo                  = '#url.itemno#'
	  AND     T.TransactionUoM          = '#url.uom#'	
	  
	  AND     YEAR(B.TransactionDate)   = '#url.year#'		
	  AND     MONTH(B.TransactionDate)  = '#url.month#'					
						
	 <!--- ------------------------------------------ --->
	 		
	  GROUP BY B.BatchNo, 
		       B.TransactionDate, 
			   B.ActionOfficerLastName, 
			   B.ActionOfficerDate, 
			   R.TransactionType
												
	  ORDER BY B.TransactionDate	
	  
</cfquery>	  
	  			
<table width="100%" cellspacing="0" cellpadding="0" align="center" style="border:1px dotted silver;">
	
	<tr>		   
		  <td class="labelit" style="padding-left:3px;padding-left:30px;">Batch No</td>
		  <td class="labelit" height="20">Submitted</td> 
		  <td class="labelit">Rec</td>
		  <td class="labelit">Confirmed</td>
		  <td class="labelit">Date</td>
		  <td class="labelit" align="right">Quantity</td>	 
		  <td></td>		 
	 </tr>
	 
	 <cfset prior = "">

	<cfoutput query="getPending">
	
		<cfif week(TransactionDate) neq Prior>
		
			<cfset prior = week(TransactionDate)>	
			<tr><td colspan="7" class="linedotted"></td></tr>
			
			<tr>
			
			   <td colspan="6" class="labellarge" style="padding-left:4px"><font size="1">wk:&nbsp;</font><b>#Prior#</td>
			   <td width="20" align="center" style="padding-left:13px;padding-right:14px">		
			   
			    <cfif access eq "GRANTED">					
								
					<input type="checkbox" 					       
						   checked 
						   onclick="if (this.checked) {$('.toggle_#url.category#_#Prior#').prop('checked', true)} else {$('.toggle_#url.category#_#Prior#').prop('checked', false)} ;">							
						   
				</cfif>	 
				 
			  </td>	
			
			</tr>
			
		</cfif>
	
		<tr><td colspan="7" class="linedotted"></td></tr>
		
		<tr bgcolor="ffffef" 
		     id="l#batchno#" 
		     onMouseOver="document.getElementById('l#batchno#').className = 'highlight2'"
             onMouseOut="document.getElementById('l#batchno#').className = 'regular'">	
			 		
			<td width="100" style="height:18px;padding-left:30px;padding-right:5px">
			  <a href="javascript:batch('#BatchNo#','#url.mission#','process','#url.systemfunctionid#','')"><font color="0080C0">#BatchNo#</a>
			</td>	
			<td width="90" >#dateformat(TransactionDate,CLIENT.DateFormatShow)#</td>
			<td width="130">#Lines#</td>
			<td width="90">#ActionOfficerLastName#</td>
			<td width="240">#dateformat(ActionOfficerDate,CLIENT.DateFormatShow)# #timeformat(ActionOfficerDate,"HH:MM")#</td>					
			<td align="right">#numberformat(-Quantity,"__,__._")#</td>
			<td width="20" align="center" style="padding-left:13px;padding-right:14px">		
						
			    <cfif access eq "GRANTED">					
					<input type="checkbox" id="selected" class="toggle_#url.category#_#Prior#" name="selected" checked value="'#batchno#'">													  
				</cfif>	  
				
			</td>	
				
		</tr>
		
	</cfoutput>

</table>