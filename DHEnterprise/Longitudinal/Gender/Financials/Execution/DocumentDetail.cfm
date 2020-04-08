<cfquery name="getDetailData" 
	datasource="martStaffing">	
		SELECT 	*
		FROM 	(	
					SELECT  F.DocumentNo, F.GLAccount, R.Description, 
							ROUND(SUM(F.BaseAmount), 0) AS Commitment,
					                          ISNULL((SELECT     ROUND(SUM(BaseAmount), 0) AS Expr1
					                            FROM          NYVM1618.EnterpriseHub.dbo.FinanceTransaction
					                            WHERE      (ParentDocumentNo = F.DocumentNo) AND (GLAccount = F.GLAccount)), 0) AS Actuals, 
					        MIN(FinanceDocument.InitialDatePosting) AS InitialDatePosting
					FROM          NYVM1618.EnterpriseHub.dbo.FinanceTransaction AS F INNER JOIN
					                      NYVM1618.EnterpriseHub.dbo.FinanceDocument ON F.DocumentNo = FinanceDocument.DocumentNo AND F.DocumentType = FinanceDocument.DocumentType INNER JOIN
					                      NYVM1618.EnterpriseHub.dbo.Ref_GLAccount AS R ON F.GLAccount = R.GLAccount
					WHERE  F.GLAccount <> '78201010'  
					AND F.OrgUnitDonorName IS NOT NULL
					AND (F.TransactionClass = 'Commitment') 
					<cfif trim(url.fund) neq "">
					AND (F.CBFund = '#url.fund#')
					</cfif>
					AND F.Mission = '#url.mission#'
					AND F.OrgUnitDonorName = '#url.donor#'
					AND (F.CBWBSe LIKE '#url.wbse#%') 
					GROUP BY F.DocumentNo, F.GLAccount, R.Description
				) as Data
		WHERE 	ABS(Actuals) + ABS(Commitment) != 0
		ORDER BY DocumentNo, GLAccount
</cfquery>

<table class="detailContentExecution table table-striped table-bordered table-hover clsNoPrint" style="width:100%; ">
	<thead>
		<tr>
			<th><cf_tl id="Document"></th>
			<th><cf_tl id="Account"></th>
			<th><cf_tl id="Description"></th>
			<th style="text-align:right;"><cf_tl id="Committed"></th>
			<th style="text-align:right;"><cf_tl id="Disbursed"></th>
			<th style="text-align:right;"><cf_tl id="Posted"></th>
		</tr>
	</thead>
	<tbody>
		<cfset vCommitment = 0>
		<cfset vActuals = 0>
		<cfoutput query="getDetailData">
			<tr>
				<td>#DocumentNo#</td>
				<td>#GLAccount#</td>
				<td>#Description#</td>
				<td style="text-align:right;">#numberFormat(Commitment, ",")#</td>
				<td style="text-align:right;">#numberFormat(Actuals, ",")#</td>
				<td style="text-align:right;">#dateFormat(InitialDatePosting, client.dateFormatShow)#</td>
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
				<td>Total</td>
				<td style="text-align:right;">#numberFormat(vCommitment, ",")#</td>
				<td style="text-align:right;">#numberFormat(vActuals, ",")#</td>
				<td style="text-align:right;"></td>
			</tr>	
		</tfoot>
	</cfoutput>
</table>

<cfset ajaxOnLoad("function(){ $('.detailContentExecution').DataTable(); }")>