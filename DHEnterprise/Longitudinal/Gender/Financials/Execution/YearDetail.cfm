<cfquery name="getDetailData" 
	datasource="martStaffing">
		SELECT     OrgUnitDonorName, YEAR(DatePosting) AS year, LEFT(CBWBSe, 12) AS CBWBSe, CBWBSeName, CBGrant AS CBGrantIncoming, 0 AS Budget,
		                          (SELECT     ISNULL(ROUND(SUM(BaseAmount), 2), 0) AS Expr1
		                            FROM          NYVM1618.EnterpriseHub.dbo.FinanceTransaction
		                            WHERE       GLAccount <> '78201010'  AND (YEAR(DatePosting) = YEAR(B.DatePosting)) AND (OrgUnitDonorName = B.OrgUnitDonorName) AND 
		                                                   (TransactionClass = 'Commitment') AND (LEFT(CBWBSe, 12) = LEFT(B.CBWBSe, 12)) <cfif trim(url.fund) neq "">AND (CBFund = '#url.fund#')</cfif> AND (Mission = '#url.mission#')) AS Obligation,
		                          (SELECT     ISNULL(ROUND(SUM(BaseAmount), 2), 0) AS Expr1
		                            FROM          NYVM1618.EnterpriseHub.dbo.FinanceTransaction AS FinanceTransaction_1
		                            WHERE       GLAccount <> '78201010'   AND (YEAR(DatePosting) = YEAR(B.DatePosting)) AND (OrgUnitDonorName = B.OrgUnitDonorName) AND 
		                                                   (TransactionClass = 'Actual') AND (LEFT(CBWBSe, 12) = LEFT(B.CBWBSe, 12)) <cfif trim(url.fund) neq "">AND (CBFund = '#url.fund#')</cfif> AND (Mission = '#url.mission#')) AS Actuals
		FROM         NYVM1618.EnterpriseHub.dbo.FinanceTransaction AS B
		WHERE      GLAccount <> '78201010'  AND (OrgUnitDonorName IS NOT NULL) 
		<cfif trim(url.fund) neq "">
			AND (CBFund = '#url.fund#') 
		</cfif>
		AND (Mission = '#url.mission#')
		AND OrgUnitDonorName = '#url.donor#'
		AND LEFT(CBWBSe, 12) = '#url.wbse#'
		GROUP BY LEFT(CBWBSe, 12), CBWBSeName, OrgUnitDonorName, CBGrant, YEAR(DatePosting)
		ORDER BY OrgUnitDonorName, CBWBSe, [year]
</cfquery>

<table class="table table-striped table-bordered table-hover table-responsive">
<cfoutput query="getDetailData">
	<tr>
		<td style="width:1%">&nbsp;</td>
		<td style="width:10%">&nbsp;</td>
		<td style="width:30%; font-size:80%;">#Year#</td>
		<td style="width:20%">&nbsp;</td>
		<td style="width:9%">&nbsp;</td>
		<td style="width:5%">&nbsp;</td>
		<td style="width:5%; font-size:80%;" align="center">#numberformat(obligation, ',')#</td>
		<td style="width:5%; font-size:80%;" align="center">#numberformat(actuals, ',')#</td>
		<td style="width:5%">&nbsp;</td>
		<td style="width:5%">&nbsp;</td>
		<td style="width:5%">&nbsp;</td>
	</tr>	
</cfoutput>
</table>