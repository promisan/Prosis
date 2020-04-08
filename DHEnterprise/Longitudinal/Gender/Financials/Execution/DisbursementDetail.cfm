<cfquery name="getDetailData" 
	datasource="martStaffing">	
		SELECT  DocumentType, 
				DocumentNo, 
				ParentDocumentNo, 
				DocumentMemo, 
				FiscalYear, 
				PostingPeriod, 
				DatePosting, 
				GLAccount, 
				BaseCurrency, 
				ROUND(BaseAmount, 2) as BaseAmount
		FROM    NYVM1618.EnterpriseHub.dbo.FinanceTransaction AS F 
		WHERE  F.GLAccount <> '78201010'  
		AND F.OrgUnitDonorName IS NOT NULL
		AND (F.TransactionClass = 'Actual') 
		<cfif trim(url.fund) neq "">
		AND (F.CBFund = '#url.fund#')
		</cfif>
		AND F.Mission = '#url.mission#'
		AND F.OrgUnitDonorName = '#url.donor#'
		AND (F.CBWBSe LIKE '#url.wbse#%') 
</cfquery>

<table class="detailContentExecution table table-striped table-bordered table-hover clsNoPrint" style="width:100%;">
	<thead>
		<tr>
			<th><cf_tl id="Type"></th>			
			<th><cf_tl id="Document"></th>
			<th style="text-align:center;"><cf_tl id="Posted"></th>
			<th><cf_tl id="Parent"></th>
			<!---
			<th><cf_tl id="Account"></th>
			--->
			<th><cf_tl id="Memo"></th>
			<!---
			<th style="text-align:center;"><cf_tl id="Year"></th>
			<th style="text-align:center;"><cf_tl id="Period"></th>
			--->			
			<th style="text-align:right;"><cfoutput>#getDetailData.BaseCurrency#</cfoutput></th>
		</tr>
	</thead>
	
	<tbody>
		<cfset vAmount = 0>
		<cfoutput query="getDetailData">
			<tr>
				<td>#DocumentType#</td>
				<td>#DocumentNo#</td>
				<td style="text-align:center;">#dateFormat(DatePosting, client.dateFormatShow)#</td>
				<td>#ParentDocumentNo#</td>				
				<!--- <td>#GLAccount#</td> --->
				<td style="font-size:90%;">#trim(DocumentMemo)#</td>
				<!--- 
				<td style="text-align:center;">#FiscalYear#</td>
				<td style="text-align:center;">#PostingPeriod#</td>
				--->				
				<td style="text-align:right;">#numberFormat(BaseAmount, ",")#</td>
			</tr>
			<cfset vAmount = vAmount + BaseAmount>
		</cfoutput>
	</tbody>
	<cfoutput>
		<tfoot>
			<tr style="background-color:##F0F0F0;">
				<td></td>
				<td></td>
				<!--- 
				<td></td>
				--->
				<td></td>
				<td></td>
				<!---
				<td></td>
				<td></td>
				--->
				<td><cf_tl id="Total"></td>				
				<td style="text-align:right;">#numberFormat(vAmount, ",")#</td>
			</tr>	
		</tfoot>
	</cfoutput>
</table>

<cfset ajaxOnLoad("function(){ $('.detailContentExecution').DataTable(); }")>