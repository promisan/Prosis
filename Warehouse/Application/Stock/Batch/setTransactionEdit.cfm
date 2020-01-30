
<cfquery name="get"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     ItemTransaction I
WHERE    I.TransactionId  = '#URL.TransactionId#'
</cfquery>

<cfparam name="url.field" default="quantity">

<cfoutput>

	<table>
	
		<tr>
		
		<cfswitch expression="#url.field#">
		
		   <cfcase value="quantity">
		 
			<td width="90%" align="right">
				
				<input type="text" 
				    name="#url.field##url.transactionid#" 
					id="#url.field##url.transactionid#"
					value="#-1*get.TransactionQuantity#" 
					style="text-align:right;width:80"
					class="regularxl">
										
			</td>
			<td style="padding-left:4px">
			
			<cfif get.TransactionType neq "2">
			
				<!--- full refrresh --->
				 <img src="#SESSION.root#/images/save.png" height="20" width="20" alt="" border="0" 
			     onclick="ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setTransactionEditSubmit.cfm?systemfunctionid=#url.systemfunctionid#&batchno=#get.TransactionBatchNo#&transactionid=#transactionid#&field=#url.field#&value='+document.getElementById('#url.field##url.transactionid#').value,'main')">							
				 			
			<cfelse>
			
				<table>
				
				<tr>
				<td>
			
		       <img src="#SESSION.root#/images/save.png" height="20" width="20" alt="" border="0" 
			    onclick="ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setTransactionEditSubmit.cfm?systemfunctionid=#url.systemfunctionid#&batchno=#get.TransactionBatchNo#&transactionid=#transactionid#&field=#url.field#&value='+document.getElementById('#url.field##url.transactionid#').value,'#url.field#_#url.transactionid#')">							
				
				</td>
				
				<td style="padding-left:2px">
				
			   <img src="#SESSION.root#/images/delete5.gif" height="20" width="20" alt="" border="0" 
			    onclick="if (confirm('Are you sure to void this transaction permanently ?')) { ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setTransactionEditSubmit.cfm?systemfunctionid=#url.systemfunctionid#&batchno=#get.TransactionBatchNo#&transactionid=#transactionid#&field=#url.field#&value=void','#url.field#_#url.transactionid#') }">							
				
				</td></tr>
				</table>
			
				
			</cfif>  
				
			</td>		
			
			</cfcase>
			
			<cfcase value="reference">
			
				<td>
					
					<input type="text" 			   
						id="#url.field##url.transactionid#"
						value="#get.TransactionReference#" 
						style="text-align:center;height:100%;width:100%;"
						class="regularxl">
						
				</td>
				
				<td style="padding-left:5px;padding-right:4px">		
				
			       <img src="#SESSION.root#/images/save.png" height="12" width="12" alt="" border="0" 
				    onclick="ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/batch/setTransactionEditSubmit.cfm?systemfunctionid=#url.systemfunctionid#&batchno=#get.TransactionBatchNo#&transactionid=#transactionid#&field=#url.field#&value='+document.getElementById('#url.field##url.transactionid#').value,'#url.field#_#url.transactionid#')">							
							
				</td>		
				
			</cfcase>
			
		</cfswitch>	
		
		</tr>
		
	</table>

</cfoutput>