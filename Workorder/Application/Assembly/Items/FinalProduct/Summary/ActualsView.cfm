
<table width="100%" cellspacing="4" cellpadding="4">

	<tr><td height="10"></td></tr>
	<tr><td colspan="2" style="font-size:34px" class="labellarge"><cf_tl id="Actuals"></td></tr>
	
	<tr>	  
	   <td colspan="2" class="line"></td>
	</tr>

	<tr><td height="6"></td></tr>
	
	<tr><td colspan="2" class="labelit">
			
	<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine
		 WHERE   WorkOrderId   = '#url.workorderid#'	
		 AND     WorkOrderLine = '#url.workorderline#'
	</cfquery>
	
	<cf_exchangeRate 
        CurrencyFrom = "#workorder.currency#" 
        CurrencyTo   = "#application.BaseCurrency#"
		EffectiveDate= "#dateformat(workorder.orderdate,client.dateformatshow)#">
	
	<!---
	<cfoutput>#get.workorderlineid#</cfoutput>
	--->
			
	<cfquery name="Sale" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     T.ItemCategory, 
		           SUM(TS.SalesAmount) AS SalesAmount, 
				   SUM(TS.SalesTax) AS SalesTax, 
				   SUM(TS.SalesTotal) AS Receivable
	    FROM       ItemTransaction T INNER JOIN
	               ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId	
		WHERE      T.WorkOrderId   = '#url.workorderid#'
		AND        T.WorkOrderLine = '#url.workorderline#'
		AND        T.TransactionType = '2'
		GROUP BY   T.ItemCategory		
	</cfquery>
	
	
	<cfquery name="total" dbtype="query">
		SELECT SUM(SalesAmount) as Amount,
			   SUM(SalesTax) AS Tax 
		FROM   Sale
	</cfquery>
	
	<table width="100%" class="navigation_table">
	
	<tr><td class="labellarge"><b> <cf_tl id="Sale"></td>
	    <td class="labelmedium" align="right"></td>
	</tr>
	
	<tr><td style="padding-left:10px" width="90%" class="labelmedium"> <cf_tl id="Goods shipped"></td>
	    <td class="labelmedium" align="right">
		<table cellspacing="0" cellpadding="0">
		<cfoutput>
		<tr>	
		<td class="labelit" style="min-width:100px;padding-right:10px">(#numberformat(total.tax,",.__")#)</td>	
		<td class="labelmedium">#numberformat(total.amount,",.__")#</td>
		</tr>
		</cfoutput>
		</table>
		
		</td>
	</tr>
	
	<cfoutput query="sale">
	<tr class="navigation_row labelit"><td style="padding-left:40px" class="labelit">#ItemCategory#</td>
	     <td align="right" style="padding-right:40px">#numberformat(SalesAmount,",__.__")#</td>
	</tr>
	</cfoutput>	
	
	</table>
	
	</td>
	
	</tr>
	
	<tr><td height="4"></td></tr>
	<tr>
		   <td class="line"></td>
		   <td class="line"></td>
		</tr>
	
	<tr><td style="padding-left:10px;padding-top:3px" width="90%" valign="top" class="labelmedium"><cf_tl id="Billed"></td>
	    <td class="labelmedium" align="right" style="padding-right:1px">
		
		<cfquery name="Billed" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
		    SELECT   ISNULL(ROUND(SUM(TS.SalesTotal),2),0) as Amount,
					 ISNULL(ROUND(SUM(TS.SalesTax),2),0) as TaxAmount,
					 ISNULL(ROUND(SUM(TS.SalesAmount),2),0) as SaleAmount 
            FROM     Materials.dbo.ItemTransactionShipping AS TS INNER JOIN
                     Materials.dbo.ItemTransaction AS T ON TS.TransactionId = T.TransactionId
            WHERE    T.WorkOrderId   = '#url.workorderid#' 
	        AND      T.WorkOrderLine = '#url.workorderline#'
		    AND      TS.InvoiceId IN (
				                           SELECT   TransactionId
                                           FROM     Accounting.dbo.TransactionHeader
                                           WHERE    TransactionId = TS.InvoiceId 
										   AND      RecordStatus <> '9' 
										   AND      ActionStatus IN ('0','1')
										   ) 
			AND      T.TransactionType = '2'
			
		</cfquery>
		
		<!--- this is the amount billed in total for this workorder 
								 
		<cfquery name="Billed" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    L.Currency,L.Reference, ISNULL(SUM(AmountCredit-AmountDebit), 0) AS Total
			FROM      TransactionHeader H, TransactionLine L
			WHERE     H.Journal = L.Journal
			AND       H.JournalSerialNo = L.JournalSerialNo
			AND       H.ReferenceId = '#url.workorderid#'
			AND       H.ActionStatus != '9' AND H.RecordStatus != '9'
			AND       L.TransactionSerialNo != '0'
			GROUP BY  L.Currency, L.Reference	
		</cfquery>  
		
		--->
		
		<cfoutput>  
		
		<cfset sal = 0> 
		
		<cfif billed.recordcount eq "0">
		
			#numberformat(0,",__.__")#
		
		<cfelse>
										
				 <table width="100%" cellspacing="0" cellpadding="0">
					<cfloop query="billed">
					 					 
					 <cfset sal = sal + billed.saleamount>
					 
					 <tr class="labelit">
					 <td align="right"style="height:14px;padding-left:4px"><cf_tl id="Tax"></td>
					 <td align="right" style="width:190;height:14px;padding-left:4px"><cf_tl id="Income"><cf_space spaces="23"></td>
					 </tr>	
					 
					 <tr>
					 <td class="labelit" align="right" style="height:14px;padding-left:4px">#numberformat(Billed.TaxAmount,",__.__")#</td>
					 <td class="labelmedium" align="right" style="height:14px;padding-left:4px">#numberformat(Billed.SaleAmount,",__.__")#</td>
					 </tr>				 
					</cfloop>
				 </table>
								
		</cfif>		
		
		</cfoutput> 		
		
		</td>
	</tr>	
		
	<tr><td height="15"></td></tr>
	
	<tr><td class="labellarge"><b><cf_tl id="Costing"></td>
	    <td class="labelmedium" align="right"></td>
	</tr>
	
	<tr><td colspan="2">
		
			<cfquery name="Transaction" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
						
			SELECT        TL.TransactionPeriod, TL.GLAccount, R.Description, TL.Memo, 
			               SUM(TL.AmountDebit - TL.AmountCredit) AS Amount, T.TransactionType
			FROM            TransactionHeader AS H INNER JOIN
			                         TransactionLine AS TL ON H.Journal = TL.Journal AND H.JournalSerialNo = TL.JournalSerialNo INNER JOIN
			                         Ref_Account AS R ON TL.GLAccount = R.GLAccount INNER JOIN
			                         Materials.dbo.ItemTransaction AS T ON H.ReferenceId = T.TransactionId
			WHERE        (TL.WorkOrderLineId = '#get.WorkOrderLineId#') 
						AND (TL.GLAccount IN
			                             (SELECT        GLAccount
			                               FROM            Ref_Account
			                               WHERE        (AccountClass = 'Result')))
						/**/
			GROUP BY T.TransactionType, TL.TransactionPeriod, TL.GLAccount, R.Description, TL.Memo 
			ORDER BY T.TransactionType			
			
			</cfquery>
			
			<cfset cst = 0> 
										
			<table width="100%" class="navigation_table">
				<cfoutput query="transaction" group="TransactionType">
				
				<TR><td style="padding-left:10px" colspan="4" width="90%" class="labelmedium">
					<cfif transactiontype eq "8" or transactiontype eq "6">
						<cf_tl id="Earmarking Transfers">
					<cfelseif transactiontype eq "3">
						<cf_tl id="Returned">	
					<cfelseif transactiontype eq "4">
						<cf_tl id="Disposal">		
					<cfelse>
						<cf_tl id="Cost of Goods shipped">  					
					</cfif>
					</TD>
				</TR>		
				
				<cfif transactiontype eq "8" or transactiontype eq "6">
					<cfset cl = "d0d0d0">
				<cfelse>
					<cfset cl = "">
				</cfif>				
				
					<cfoutput>
					<tr style="background-color:#cl#" class="labelit navigation_row">					
						<td style="padding-left:20px">#TransactionPeriod#</td>
						<td>#glaccount#</td>	
						<td>#Description#</td>	
						<td align="right">
						<cfif transactiontype eq "8" or transactiontype eq "6">
										
						    #numberformat(amount*-1,',__.__')#
						
						<cfelse>
							<cfset cst = cst + amount>
							#numberformat(amount,',__.__')#
						</cfif>
						</td>	
					</tr>
					</cfoutput>
				</cfoutput>
			</table>
			
		</td>
	</tr>
	
	<!--- only if this is a production workorder 	
	
	<tr><td style="padding-left:10px" width="90%" class="labelmedium"><cf_tl id="Production"></td>
	    <td class="labelmedium" align="right"></td>
	</tr>
	
		<tr><td style="padding-left:20px" width="90%" class="labelit"><cf_tl id="Issued to Production"></td>
		    <td class="labelmedium" align="right"></td>
		</tr>
		<tr><td style="padding-left:20px" width="90%" class="labelit"><cf_tl id="Final Product Offset"></td>
		    <td class="labelmedium" align="right"></td>
		</tr>	
		
	<tr><td style="padding-left:10px" width="90%" class="labelmedium"><cf_tl id="Internal Exchanges"></td>
	    <td class="labelmedium" align="right"></td>
	</tr>
	
	--->	
	
	
	<cfoutput>
	
	<tr><td height="15"></td></tr>

	<tr><td class="labellarge"><b><cf_tl id="Gross Margin"></td>
	    <td class="labellarge" align="right">
		
		<cfif sal-cst gt 0>
		#numberformat(sal-cst,",__.__")#
		<cfelse>
		<font color="FF0000">
		(#numberformat(sal-cst,",__.__")#)
		</cfif>
		
		</td>
	</tr>
	
	
	<tr><td style="padding-left:10px" width="90%" class="labelmedium"><cf_tl id="Other associated Costs"></td>
	    <td class="labelmedium" align="right"></td>
	</tr>
	
	<tr><td></td></tr>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>
	<tr><td></td></tr>
	
	<tr><td class="labellarge"><b><cf_tl id="Calculated Net Margin"></td>
	    <td class="labellarge" align="right">
				
		<cfif sal-cst gt 0>
		#numberformat(sal-cst,",__.__")#
		<cfelse>
		<font color="FF0000">
		(#numberformat(sal-cst,",__.__")#)
		</cfif>
		
		
		</td>
	</tr>
	
	</cfoutput>
	
	<tr>
	   <td></td>
	   <td class="line"></td>
	</tr>
			
</table>

<cfset ajaxonload("doHighlight")>	