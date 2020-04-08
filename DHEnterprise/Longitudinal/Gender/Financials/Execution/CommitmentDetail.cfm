<cfquery name="getDetailData" 
	datasource="martStaffing">	
		SELECT 	*
		FROM 	(	
					SELECT   F.DocumentNo, F.GLAccount, R.Description, MAX(DocumentMemo) as DocumentMemo,
							 ROUND(SUM(F.BaseAmount), 0) AS Commitment,
					                          ISNULL((SELECT   ROUND(SUM(BaseAmount), 0) AS Expr1
					                                  FROM     NYVM1618.EnterpriseHub.dbo.FinanceTransaction
					                                  WHERE    ParentDocumentNo = F.DocumentNo 
													  AND      GLAccount = F.GLAccount), 0) AS Actuals, 
					         MIN(FinanceDocument.InitialDatePosting) AS InitialDatePosting
					FROM     NYVM1618.EnterpriseHub.dbo.FinanceTransaction AS F INNER JOIN
					         NYVM1618.EnterpriseHub.dbo.FinanceDocument ON F.DocumentNo = FinanceDocument.DocumentNo AND F.DocumentType = FinanceDocument.DocumentType INNER JOIN
					         NYVM1618.EnterpriseHub.dbo.Ref_GLAccount AS R ON F.GLAccount = R.GLAccount
					WHERE    F.GLAccount <> '78201010'  
					AND      F.OrgUnitDonorName IS NOT NULL
					AND      F.TransactionClass = 'Commitment' 
					<cfif trim(url.fund) neq "">
					AND      F.CBFund     = '#url.fund#'
					</cfif>
					AND      F.Mission    = '#url.mission#'
					AND      F.OrgUnitDonorName = '#url.donor#'
					AND      F.CBWBSe LIKE '#url.wbse#%' 
					GROUP BY F.DocumentNo, F.GLAccount, R.Description
				) as Data
		WHERE 	ABS(Actuals) + ABS(Commitment) != 0
		ORDER BY DocumentNo, GLAccount
</cfquery>

<table class="detailContentExecution table table-striped table-bordered table-hover clsNoPrint" style="width:100%; ">
	<thead>
		<tr>
			<th><cf_tl id="Document"></th>
			<th style="text-align:right;"><cf_tl id="Posted"></th>
			<th><cf_tl id="Account"></th>
			<th><cf_tl id="Description"></th>
			<th style="text-align:right;"><cf_tl id="Disbursed"></th>
			<th style="text-align:right;"><cf_tl id="Committed"></th>		
		</tr>
	</thead>
	<tbody>
		<cfset vCommitment = 0>
		<cfset vActuals = 0>
		<cfoutput query="getDetailData">
			<tr>
				<td>#DocumentNo#</td>
				<td style="text-align:right;">#dateFormat(InitialDatePosting, client.dateFormatShow)#</td>
				<td>#GLAccount#</td>
				<td>#trim(DocumentMemo)#</td>
				<td style="text-align:right;">#numberFormat(Actuals, ",")#</td>
				<td style="text-align:right;">#numberFormat(Commitment, ",")#</td>				
				
			</tr>	
			<cfset vCommitment = vCommitment + Commitment>
			<cfset vActuals = vActuals + Actuals>
		</cfoutput>
	</tbody>
	<cfoutput>
		<tfoot>
			<tr style="background-color:##F0F0F0;">
				<td></td>
				<td></td>
				<td style="text-align:right;"></td>
				<td>Total</td>				
				<td style="text-align:right;">#numberFormat(vActuals, ",")#</td>
				<td style="text-align:right;">#numberFormat(vCommitment, ",")#</td>
			</tr>	
		</tfoot>
	</cfoutput>
</table>

<cfset ajaxOnLoad("function(){ $('.detailContentExecution').DataTable(); }")>