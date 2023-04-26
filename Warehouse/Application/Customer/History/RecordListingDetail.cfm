
<cfparam name="URL.mode" default="regular"> 

	<cfquery name="SaleDetail" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 		
					IT.ItemNo, I.ItemDescription, I.ItemNoExternal, ABS(IT.TransactionQuantity)as TransactionQuantity, Iuom.UoMDescription, 
					IT.TransactionCostPrice, IT.TransactionCostPrice, IT.TransactionId, CAT.CategoryName
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
		WHERE 		WB.BatchId = '#url.drillid#' 
	</cfquery>			
	
<cfif SaleDetail.recordcount eq "0">

	<table width="100%">
	  <tr class="labelmedium">
	     <td style="padding-left:16px"><cf_tl id="This process does not have any details associated"></td>
 	  </tr>
    </table>

<cfelse>
	
		<table width="100%" align="center" class="navigation_table formpadding">
			<tr bgcolor="ffffaf" class="labelmedium line" style="border-top:1px solid silver">
				<td style="padding-left:3px" width="5%"><cf_tl id="ItemNo"></td>
				<td style="min-width:100px" width="40%"><cf_tl id="Item Description"></td>
				<td style="min-width:70px" width="10%"><cf_tl id="Code"></td>
				<td style="min-width:150px" width="20%"><cf_tl id="Category"></td>
				<td style="min-width:100px" align="center"><cf_tl id="UoM"></td>
				<td style="min-width:100px" align="center"><cf_tl id="Quantity"></td>							
				<td style="min-width:100px" align="center"><cf_tl id="Cost"></td>
			</tr>		
							
			<cfoutput query="SaleDetail">
				<tr class="line labelmedium navigation_row">
					<td style="padding-left:3px">#ItemNo#</td>
					<td class="fixlength">#ItemDescription#</td>
					<td>#ItemNoExternal#</td>
					<td>#CategoryName#</td>
					<td align="center">#UoMDescription#</td>		
					<td align="center">#NumberFormat(TransactionQuantity,"_,.__")#</td>							
					<td align="center">#NumberFormat(AmountCOGS,"_,.__")#</td>
				</tr>
			</cfoutput>
		</table>	
</cfif>

<cfset ajaxonload("doHighlight")>