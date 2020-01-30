<cfoutput>
	<cfquery name="SaleDetail" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 		TOP 3 
					IT.TransactionDate,
					IT.ItemNo, 
					I.ItemDescription,
					ABS(IT.TransactionQuantity)as TransactionQuantity, 
					Iuom.UoMDescription, 
					IT.TransactionCostPrice, 
					IT.TransactionCostPrice, 
					IT.TransactionId, 
					CAT.CategoryName
					,ISNULL((
					   SELECT SUM(TL.AmountDebit - TL.AmountCredit)
					   FROM   Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as TH ON TL.Journal = TH.Journal
					   AND    TL.JournalSerialNo = TH.JournalSerialNo
					   AND    TH.ReferenceId =IT.TransactionId
					   AND    TL.ReferenceNo =IT.ItemNo
					   WHERE  TL.Reference ='COGS'					   
					),0) as AmountCOGS
					
		FROM 		Materials.dbo.ItemTransaction as IT INNER JOIN Materials.dbo.WarehouseBatch as WB ON WB.BatchNo = IT.TransactionBatchNo
					INNER JOIN Materials.dbo.Item as I	ON I.ItemNo = IT.ItemNo
					INNER JOIN (SELECT Category, Description as CategoryName FROM Materials.dbo.REf_Category) as CAT ON CAT.Category = IT.ItemCategory
					LEFT OUTER JOIN Materials.dbo.ItemUoM as Iuom ON Iuom.ItemNo = IT.ItemNo AND Iuom.UoM =IT.TransactionUoM
					INNER JOIN Materials.dbo.ItemTransactionBeneficiary ITB ON 
						ITB.TransactionId = IT.TransactionId
						
		WHERE 		ITB.BeneficiaryId = '#url.BeneficiaryId#' 
		ORDER BY IT.TransactionDate DESC 
	</cfquery>			
	
<cfif SaleDetail.recordcount eq "0">

	  <tr class="labelmedium">
	  	 <td width="2%"></td>
	     <td style="padding-left:16px"><cf_tl id="This process does not have any details associated"></td>
	     <td width="2%"></td>
 	  </tr>

<cfelse>
	
			<tr bgcolor="ffffaf" class="labelmedium line" style="border-top:1px solid silver">
				<td width="2%"></td>
				<td style="padding-left:3px" width="20%"><cf_tl id="TransactionDate"></td>
				<td style="padding-left:3px" width="5%"><cf_tl id="ItemNo"></td>
				<td style="min-width:100px" width="40%"><cf_tl id="Item Description"></td>
				<td width="2%"></td>
			</tr>		
							
			<cfloop query="SaleDetail">
				<tr class="line labelmedium navigation_row">
					<td width="2%"></td>
					<td style="padding-left:3px">#dateformat(SaleDetail.TransactionDate,"DDDD MMM YY")# @ #timeformat(SaleDetail.TransactionDate,"HH:MM")#</td>
					<td style="padding-left:3px">#SaleDetail.ItemNo#</td>
					<td>#SaleDetail.ItemDescription#</td>
					<td width="2%"></td>
				</tr>
				
			</cfloop>

</cfif>

</cfoutput>