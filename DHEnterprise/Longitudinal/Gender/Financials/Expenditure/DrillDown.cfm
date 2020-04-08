
<cfquery name="getData" 
	datasource="appsOrganization">
		SELECT	DocumentNo, 
				DocumentType, 
				ParentDocumentNo, 
				DocumentDate, 
				Fund, 
				Memo, 
				GLAccount, 
				AmountBase
		FROM 	NYVM1617.MartFinance.dbo.vwContributionContent
		WHERE   YEAR(DatePosting) = '#url.yr#' 
	    AND     YEAR(DateDue) <= '#url.yr#'
		AND 	OrgUnitDonor = '#url.orgunit#'
		<cfif url.pFund neq ""> 
			AND      Fund = '#url.pFund#'
		</cfif>
		AND 	AmountBase < 0
</cfquery>

<div style="padding-top:50px;" class="table-responsive">
	<table class="detailContentFinancials table table-striped table-bordered table-hover">
		<thead>
			<tr>
				<th><cf_tl id="No"></th>
				<th><cf_tl id="Type"></th>
				<th><cf_tl id="Parent Document"></th>
				<th><cf_tl id="Date"></th>
				<th><cf_tl id="Fund"></th>
				<th><cf_tl id="Memo"></th>
				<th><cf_tl id="Account"></th>
				<th style="text-align:right; padding-right:3px;"><cf_tl id="Amount"></th>
			</tr>
		</thead>
		<tbody>
			<cfset vTotal = 0>
			<cfoutput query="getData">
				<tr>
					<td>
						#DocumentNo#
					</td>
					<td>#DocumentType#</td>
					<td><cfif documentNo neq ParentDocumentNo>#ParentDocumentNo#</cfif></td>
					<td>#dateFormat(DocumentDate, client.dateFormatShow)#</td>
					<td>#Fund#</td>
					<td>#Memo#</td>
					<td>#GLAccount#</td>
					<td style="text-align:right; padding-right:3px;">#numberformat(AmountBase*-1, ",.__")#</td>
					<cfset vTotal = vTotal + AmountBase*-1>
				</tr>
			</cfoutput>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="7" style="font-weight:bold;"><cf_tl id="Total"></td>
				<td style="text-align:right; padding-right:3px; font-weight:bold;"><cfoutput>#numberformat(vTotal, ",.__")#</cfoutput></td>
			</tr>
		</tfoot>
	</table>
</div>

<cfset ajaxOnLoad("function(){ $('.detailContentFinancials').DataTable({ responsive:true }); }")>