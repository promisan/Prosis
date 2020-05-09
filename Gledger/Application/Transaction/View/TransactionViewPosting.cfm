

<cfquery name="Param"
		datasource="AppsSystem"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
	SELECT *
	FROM     Parameter
</cfquery>

<cfquery name="Transaction"
		datasource="AppsLedger"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
	SELECT   H.*,
	P.ActionStatus as AccountStatus
	FROM     TransactionHeader H, Period P
	WHERE    H.Journal         = '#URL.Journal#'
AND      H.JournalSerialNo = '#URL.JournalSerialNo#'
AND      H.AccountPeriod = P.AccountPeriod
ORDER BY H. TransactionDate
</cfquery>

<cfquery name="JournalList"
		datasource="AppsLedger"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
	SELECT *
	FROM     Journal
	WHERE    Journal         = '#URL.Journal#'
</cfquery>

<cf_verifyOperational
		datasource= "appsLedger"
		module    = "Procurement"
		Warning   = "No">

<cfset proc = operational>

<!--- -------------------------------------------------------------------------------------------------------------------------------- --->
<!---

	Purpose : retrieve the journal lines of the above transactions and all its relevant children (like settledment, reconcile  etc)
		or related transaction line for receipts and assets but summary the serialNo 0 amounts as these amounts will be repeated in the transaction
		to have a proper matching to the children. We enforce the sorting by giving the current transaction lines a sorting = 1,
		then we sort by transaction date followed by transaction header to ensure detailes from the sme transacfion are show in conjunction

Armin 10/4/2013: Very important query as it combines child/parent transactions. Example:

1. 	Purchases
		Invoices Received
2. 	Inventory
		Purchases
3. 	Invoices Received
			Invoices Paid
4.	Invoice Paid
			Cash account

--->

<!--- -------------------------------------------------------------------------------------------------------------------------------- --->

<!--- item as supplies --->

<cfif proc eq "1" and (JournalList.TransactionCategory is "Payables" or JournalList.TransactionCategory is "DirectPayment")>

	<cfquery name="presetsupply"
			datasource="AppsLedger"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT  D.TransactionLineId
			FROM    TransactionLine AS L INNER JOIN
					Purchase.dbo.PurchaseLineReceipt AS P ON L.ReferenceId = P.ReceiptId INNER JOIN
					TransactionLine AS D ON P.ReceiptId = D.ReferenceId
			WHERE   L.Journal         = '#Transaction.Journal#'
			AND     L.JournalSerialNo = '#Transaction.JournalSerialNo#'
			AND     L.Reference = 'Receipt'
			AND     D.Reference = 'Warehouse'
	</cfquery>

	<!--- item as assets --->

	<cfquery name="presetasset"
			datasource="AppsLedger"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT  D.TransactionLineId
			FROM    TransactionLine AS L INNER JOIN
					Purchase.dbo.PurchaseLineReceipt AS P ON L.ReferenceId = P.ReceiptId INNER JOIN
					Materials.dbo.AssetItem AS A ON P.ReceiptId = A.ReceiptId INNER JOIN
					TransactionLine AS D ON A.AssetId = D.ReferenceId
			WHERE   L.Journal         = '#Transaction.Journal#'
			AND     L.JournalSerialNo = '#Transaction.JournalSerialNo#'
			AND     L.Reference = 'Receipt'
			AND     D.Reference = 'Receipt'
	</cfquery>

</cfif>

<!--- not sure what this preset was for, but it ran very slow in Salama --->

<cfif proc eq "1" and JournalList.TransactionCategory eq "Receivables" and Transaction.TransactionSource neq "WorkOrderSeries">

		<cfquery name="presetunknown"
			datasource="AppsLedger"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT    SL.TransactionLineId
			FROM      TransactionHeader AS SH INNER JOIN
			  		  TransactionLine AS SL ON SH.Journal = SL.Journal AND SH.JournalSerialNo = SL.JournalSerialNo
			WHERE     SH.TransactionSourceId = '#Transaction.TransactionSourceId#'			
		</cfquery>

</cfif>

<cf_verifyOperational
		datasource= "appsLedger"
		module    = "WorkOrder"
		Warning   = "No">

<cfset work = operational>

<cfif work eq "1" and JournalList.TransactionCategory is "Receivables">
	
	<cfquery name="presetsale"
			datasource="AppsLedger"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">

			SELECT      L.TransactionLineId
			FROM        Materials.dbo.ItemTransactionShipping AS TS INNER JOIN
						Materials.dbo.ItemTransaction AS T ON TS.TransactionId = T.TransactionId INNER JOIN
						Accounting.dbo.TransactionLine AS L ON T.TransactionId = L.ReferenceId
			WHERE       TS.Journal         = '#Transaction.Journal#'
			AND         TS.JournalSerialNo = '#Transaction.JournalSerialNo#'
	
			UNION
	
			SELECT      L.TransactionLineId
			FROM        Materials.dbo.ItemTransactionShipping TS INNER JOIN
						Materials.dbo.ItemTransaction T ON TS.TransactionId = T.TransactionId INNER JOIN
						TransactionHeader H ON T.TransactionId = H.ReferenceId INNER JOIN
						TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
			WHERE       TS.Journal         = '#Transaction.Journal#'
			AND         TS.JournalSerialNo = '#Transaction.JournalSerialNo#'

	</cfquery>

</cfif>

<cfquery name="Lines"
		datasource="AppsLedger"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		
		SELECT  H.Created,
		CASE H.TransactionId WHEN '#Transaction.TransactionId#' THEN '0' ELSE '1' END as Sorting,
			H.TransactionSource,
			H.Mission,
			H.OrgUnitOwner,
			CASE T.Reference
				WHEN 'Off-set Receivable' THEN H.JournalTransactionNo+'-'+CAST(T.JournalSerialNo as varchar)
				WHEN 'Receipt on Receivable' THEN H.JournalTransactionNo+'-'+CAST(T.JournalSerialNo as varchar)
				ELSE H.JournalTransactionNo END AS JournalTransactionNo,
			H.ActionStatus,
			H.RecordStatus,
			H.TransactionId,
			H.TransactionPeriod as TransactionPeriodHeader,
			T.TransactionDate,
			T.TransactionPeriod as TransactionPeriodLine,
			G.Description as GLDescription,
			G.AccountLabel,
			GP.Description as GroupDescription,
			G.ForceProgram,
			G.AccountClass,
			T.TransactionType,
			T.Reference,
			T.ReferenceId,
			T.ReferenceIdParam,
			T.ReferenceName,
			T.ReferenceNo,
			T.GLAccount,
			T.AccountPeriod,
			T.Journal,
			T.JournalSerialNo,
			T.TransactionSerialNo,
			T.OrgUnit,
			T.ProgramCode,
			T.ProgramCodeProvider,
			T.Fund,
			T.ObjectCode,
			T.ContributionLineId,
			<!--- 7/13/2018 adjusted
			T.TransactionCurrency as Currency,
			--->
			T.Currency,
			T.ParentJournal,
			T.ParentJournalSerialNo,
			T.TransactionCurrency,
			T.WarehouseItemNo,
			T.Memo,
			P.ActionStatus as PeriodStatus,
		
			(SELECT TOP 1 ObjectId
			 FROM   Organization.dbo.OrganizationObject
			 WHERE  ObjectkeyValue4 = H.TransactionId
			 AND    Operational = 1 ) as WorkflowId,
		
			SUM(T.TransactionAmount) as DocumentAmount,
			SUM(T.AmountDebit)       as AmountDebit,
			SUM(T.AmountCredit)      as AmountCredit,
			SUM(T.AmountBaseDebit)   as AmountBaseDebit,
			SUM(T.AmountBaseCredit)  as AmountBaseCredit
		
			FROM    TransactionHeader H,
					TransactionLine T,
					Ref_Account G,
					Ref_AccountGroup GP,
					Period P
			WHERE   H.Mission = '#Transaction.mission#'
		
		<!---
		AND     H.Journal = '#Transaction.Journal#'
		--->
		
			AND     (T.AmountDebit <> 0 or T.AmountCredit <> 0)		
			AND     T.Journal         = H.Journal
			AND     T.JournalSerialNo = H.JournalSerialNo
			AND     (

				<!--- this line --->
			        (T.Journal = '#Transaction.Journal#'      AND T.JournalSerialNo = '#Transaction.JournalSerialNo#')
		
					OR
		
				   <!--- children --->
				   (T.ParentJournal = '#Transaction.Journal#' AND T.ParentJournalSerialNo = '#Transaction.JournalSerialNo#')
		
					<cfif operational eq "1" and (JournalList.TransactionCategory is "Payables" or JournalList.TransactionCategory is "DirectPayment")>	
					
					<!--- warehouse receipt details that are booked separately usually before the invoice is posted as an RI and are related to the
					invoice association to the receipt query was tuned 14/10/2012,
					14/10/2012 : tuning the query resulted in a performance gain --->
					
					<!--- L = posting of the invoice, and we related back to the RI through InvoiceIdMatched to the posted receipts  --->
					
							<cfif presetSupply.recordcount neq "0">
								OR 	T.TransactionLineId IN  ( #quotedvaluelist(presetSupply.TransactionLineId)# )
							</cfif>
					
							<cfif presetAsset.recordcount neq "0">
								OR T.TransactionLineId IN  ( #quotedvaluelist(presetAsset.TransactionLineId)# )
							</cfif>
					
					</cfif>
		
					<cfif proc eq "1" and JournalList.TransactionCategory eq "Receivables" and Transaction.TransactionSource neq "WorkOrderSeries">
						
						<!--- salama issue--->
						<cfif Transaction.TransactionSourceId neq "">							
							OR T.TransactionLineId IN  ( #quotedvaluelist(presetUnknown.TransactionLineId)# )																					
						</cfif>
				
					</cfif>
					
					<cfif work eq "1" and JournalList.TransactionCategory is "Receivables">
		
						<!--- condition adjusted on 4/9/2016, based on the fact that Fomtex needed to see COGS bookings for a sale					
						    <cfif work eq "1" and JournalList.TransactionCategory is "Receivables" and Transaction.TransactionSource neq "WorkOrderSeries">					
						--->				
				
						<cfif presetSale.recordcount neq "0">
							OR T.TransactionLineId IN  ( #quotedvaluelist(presetSale.TransactionLineId)# )
						</cfif>
				
					</cfif>				
		
					)
		
					AND      T.GLAccount     = G.GLAccount
					AND      H.AccountPeriod = P.AccountPeriod
					AND      G.AccountGroup  = GP.AccountGroup
		
			GROUP BY H.Created,
						H.TransactionSource,
						H.Mission,
						H.OrgUnitOwner,
						H.JournalTransactionNo,
						H.ActionStatus,
						H.RecordStatus,
						H.TransactionId,
						H.TransactionPeriod,
						T.TransactionDate,
						T.TransactionPeriod,
						G.Description,
						G.AccountLabel,
						T.ReferenceName,
						T.ReferenceNo,
						GP.Description,
						G.ForceProgram,
						G.AccountClass,
						T.TransactionCurrency,
						T.TransactionType,
						T.Reference,
						T.ReferenceId,
						T.ReferenceIdParam,
						T.GLAccount,
						T.AccountPeriod,
						T.Journal,
						T.JournalSerialNo,
						T.TransactionSerialNo,
						T.OrgUnit,
						P.ActionStatus,
						T.ProgramCode,
						T.ProgramCodeProvider,
						T.Fund,
						T.ObjectCode,
						T.ContributionLineId,
						T.Currency,
						T.Memo,
						T.WarehouseItemNo,
						T.ParentJournal,
						T.ParentJournalSerialNo
					
					<!--- hanno 29/7 adjusted the sorting --->
					
						ORDER BY Sorting,
						T.TransactionDate,
						H.JournalTransactionNo,
						H.Created,
						T.ParentJournal,
						T.ParentJournalSerialNo,
						T.GLAccount,
						T.TransactionSerialNo

</cfquery>

<!--- prepare a summary based on the user selection --->

<cfif url.summary eq "1">

	<cfquery name="Lines" dbtype="query">
		SELECT    Sorting,
				  Journal,
				  MAX(TransactionId)   as TransactionId,     <!--- also this one we roll up --->
				  MAX(JournalSerialNo) as JournalSerialNo,  <!--- we need to lump up stock transactions as otherwise the are repeated by posting --->
				  ActionStatus,
				  RecordStatus,
				  WorkFlowId,
				  Mission,
				  OrgUnitOwner,
				  ParentJournal,
				  ParentJournalSerialNo,
				  TransactionDate,
				  TransactionPeriodHeader,
				  GLDescription,
				  AccountLabel,
				  AccountClass,
				  AccountPeriod,
				  TransactionPeriodHeader,
				  TransactionPeriodLine,
				  Reference,
				  PeriodStatus,
				  MAX(TransactionSerialNo) as TransactionSerialNo,
				  TransactionCurrency,
				  TransactionSource,
				  SUM(DocumentAmount) as DocumentAmount,
				  Currency,
				  MAX(Created) as Created,
				  SUM(AmountDebit) as AmountDebit,
				  SUM(AmountCredit) as AmountCredit,
				  SUM(AmountBaseDebit) as AmountBaseDebit,
				  SUM(AmountBaseCredit) as AmountBaseCredit
		FROM      Lines
		GROUP BY  Sorting,
				  Journal,
   		   <!--- JournalSerialNo,	 --->
			 	  ActionStatus,
				  RecordStatus,
				  WorkFlowId,
				  Mission,
				  OrgUnitOwner,
				  PeriodStatus,
				  TransactionDate,
				  TransactionPeriodHeader,
				  JournalTransactionNo,
				  ParentJournal,
				  ParentJournalSerialNo,
				  TransactionCurrency,
				  TransactionSource,
				  GLAccount,
				  GLDescription,
				  AccountLabel,
				  AccountClass,
				  AccountPeriod,
				  TransactionPeriodHeader,
				  TransactionPeriodLine,
				  Reference,
				  Currency
		 ORDER BY Sorting,				  
				  TransactionDate,
				  TransactionPeriodHeader,
				  JournalTransactionNo,
				  TransactionSource,
				  ParentJournal,
				  ParentJournalSerialNo,
				  GLAccount			
	</cfquery>	

</cfif>

<table width="100%"	  
	   class="navigation_table"
	   align="center">

<cfset st = "0">
<cfset cnt = 0>
<cfset pjournal = "">
<cfset pjournalserialNo = "">

<cfoutput query="Lines" group="Sorting">

<!--- first we show the lines of this trasaction itself starting with 0 --->

	<cfoutput group="JournalTransactionNo">

		<cfoutput group="TransactionSource">

<!--- we group the output Header.JournalTransactionNo and then by transaction source :a dded by Hanno for the sales COGS presentation (BCN) --->

<!--- check if this object has a workflow --->

<cfif TransactionSource eq "AccountSeries">			
<!--- always a workflow  <cfif TransactionSource eq "AccountSeries" or TransactionSource eq "ReconcileSeries"> --->
				<cfset workflowshow = "1">
				<cfelseif Workflowid neq "">
<!--- Attention 26/5/2013 : if you want workflow for other series like sales series or purchase series
ensure that upon transaction creation the workflow is generated, then it will work as well
a workflow created and also status = 0 is applies, then it will be picked up here--->
				<cfset workflowshow = "1">
			<cfelse>
				<cfset workflowshow = "0">
			</cfif>

			<cfif sorting eq "0">

				<cfset cnt = 0>

				<!--- transaction of the header shown --->

				<tr>

				<cfquery name="Jrn"
					datasource="AppsLedger"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Journal
						WHERE  Journal = '#Journal#'
				</cfquery>

				<td colspan="14" style="padding-left:3px" class="clsNoPrint">
				<!--- check if we may edit this transaction --->
			     <cfinclude template="TransactionViewAccess.cfm">
				</td>

				</tr>

				<tr class="labelmedium line fixrow" style="height:20px">

				<TD style="min-width:35;padding-right:4px" height="20" align="center">

				<cfif workflowshow eq "1">

					<cfset cl = "regular">

					<cfif actionStatus eq "1">

						<img src="#SESSION.root#/Images/icon_expand.gif" alt=""
							id="#JournalTransactionNo#Exp" border="0" class="regular"
							align="absmiddle" style="cursor: pointer;"
							onClick="more('#JournalTransactionNo#')">

							<img src="#SESSION.root#/Images/icon_collapse.gif"
							id="#JournalTransactionNo#Min" alt="" border="0"
							align="absmiddle" class="hide" style="cursor: pointer;"
							onClick="more('#JournalTransactionNo#')">

						<cfset cl = "hide">

					<cfelse>

						<img src="#SESSION.root#/Images/icon_expand.gif" alt=""
							id="#JournalTransactionNo#Exp" border="0" class="hide"
							align="absmiddle" style="cursor: pointer;"
							onClick="more('#JournalTransactionNo#')">

							<img src="#SESSION.root#/Images/icon_collapse.gif"
							id="#JournalTransactionNo#Min" alt="" border="0"
							align="absmiddle" class="regular" style="cursor: pointer;"
							onClick="more('#JournalTransactionNo#')">

						<cfset cl = "regular">

					</cfif>

				</cfif>

				</td>
				<TD style="min-width:55;padding-right:4px"><cf_tl id="Period"></TD>
				<TD style="min-width:70;padding-right:4px"><cf_tl id="Date"></TD>
				<TD style="min-width:70;padding-right:4px"><cf_tl id="Posted"></TD>
				<TD style="width:30%;min-width:100;padding-right:4px"><cf_tl id="Reference"></TD>
				<TD style="width:50%;min-width:260;padding-right:4px"><cf_tl id="GLAccount"></TD>
				<TD style="min-width:110;padding-right:4px" colspan="2"><cf_tl id="Document"></TD>
				<TD align="right"></TD>

				<TD style="min-width:88" align="right"><cf_tl id="Debit"></TD>
				<TD style="min-width:88" align="right"><cf_tl id="Credit"></TD>
				<cfif access neq "READ">
					<TD style="min-width:88" align="right">in #param.BaseCurrency#</TD>
				<TD style="min-width:88" align="right">in #param.BaseCurrency#</TD>
					<TD style="min-width:10" align="right"></TD>
				</cfif>
				</tr>

			<cfelse>

<!--- related transactions to this transaction --->

				<cfset cnt = 0>

					<tr class="line">

					<cfquery name="Jrn"
							datasource="AppsLedger"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							SELECT *
							FROM   Journal
							WHERE  Journal = '#Journal#'
					</cfquery>

					<TD class="line" style="height:30" align="center">

					<cfif TransactionSource eq "AccountSeries">

						<cfset cl = "regular">

						<cfif actionStatus eq "1">

							<img src="#SESSION.root#/Images/icon_expand.gif" alt=""
								id="#JournalTransactionNo#Exp" name="#JournalTransactionNo#Exp" border="0" class="show"
																			 align="absmiddle" style="cursor: pointer;"
								onClick="more('#JournalTransactionNo#')">

								<img src="#SESSION.root#/Images/icon_collapse.gif"
								id="#JournalTransactionNo#Min" name="#JournalTransactionNo#Min" alt="" border="0"
																								align="absmiddle" class="hide" style="cursor: pointer;"
								onClick="more('#JournalTransactionNo#')">

							<cfset cl = "hide">

						<cfelse>

							<img src="#SESSION.root#/Images/icon_expand.gif"								
								id="#JournalTransactionNo#Exp" name="#JournalTransactionNo#Max"
								border="0"
								class="hide"
								align="absmiddle" style="cursor: pointer;"
								onClick="more('#JournalTransactionNo#')">

							<img src="#SESSION.root#/Images/icon_collapse.gif"
								id="#JournalTransactionNo#Min" name="#JournalTransactionNo#Min"								
								border="0"
								align="absmiddle"
								class="regular"
								style="cursor: pointer;"
								onClick="more('#JournalTransactionNo#')">

							<cfset cl = "regular">

						</cfif>

					</cfif>

					</TD>

					<td colspan="13" class="line">

					<table cellspacing="0" cellpadding="0">

					<cfquery name="Org"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Organization
							WHERE  OrgUnit = '#OrgUnitOwner#'
					</cfquery>

					<cfif ParentJournal neq "">

						<tr>
							<td colspan="2" class="labelmedium"><font color="808080">
							<cf_tl id="Subsequent transaction">:</font>
							<a href="javascript:ShowTransaction('#journal#','#journalserialNo#','1')"><cfif org.orgunitname neq "">#Org.OrgunitName#:</cfif> #Jrn.Description# #JournalTransactionNo# </a>
						</td>

						<cfelse>

						<tr>
						<td colspan="2" class="labelmedium"><font color="808080">
						<cf_tl id="Associated stock posting">:</font>
						<cfif org.orgunitname neq "">#Org.OrgunitName#:</cfif> #Jrn.Description# #JournalTransactionNo#
						</td>

					</cfif>

					<cfset icon = "icon">
					<td style="padding-left:10px">
					
					<cfif transactionsource neq "PurchaseSeries">
						<cfinclude template="TransactionViewAccess.cfm">
					</cfif>
					
					</td>
					</tr>

					</table>

					</td>

					</tr>

			</cfif>

				</TR>

			<cfoutput group="ParentJournal">

				<cfquery name="Jrn"
						datasource="AppsLedger"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT  *
						FROM    Journal
						WHERE   Journal = '#ParentJournal#'
				</cfquery>

				<cfoutput group="ParentJournalSerialNo">

					<cfoutput>

						<cfif transactionserialno eq "0">
							<cfset color = "DFFFFF">
						<cfelse>
							<cfset color = "ffffff">
						</cfif>

<!--- lines --->
						<cfinclude template="TransactionViewPostingLine.cfm">

<!--- show associations --->
						<cfparam name="referenceid" default="">

						<cfif referenceid neq "" and referenceid neq "00000000-0000-0000-0000-000000000000"
						and TransactionSource neq "PurchaseSeries" and TransactionSource neq "SalesSeries" and TransactionSource neq "WorkOrderSeries">

<!--- -------------------------------------------------------------------------------------------------- --->
<!--- retrieve related lines : not clear at this point which is the information shown : asset lines ???? --->

							<cfquery name="Link"
									datasource="AppsLedger"
									username="#SESSION.login#"
									password="#SESSION.dbpw#">
									SELECT  H.ActionStatus,
											T.*,
											T.TransactionAmount as DocumentAmount,
											R.Description as GLDescription
									FROM    TransactionHeader H, TransactionLine T, Ref_Account R
									WHERE   T.ReferenceId      = '#ReferenceId#'
									<cfif   ReferenceIdParam neq "">
									AND     T.ReferenceIdParam = '#ReferenceIdParam#'
									</cfif>
									AND     T.GLAccount       = R.GLAccount
									AND     T.Journal         = H.Journal
									AND     T.JournalSerialNo = H.JournalSerialNo
									AND     T.Journal         != '#Journal#'
									AND     T.JournalSerialNo != '#JournalSerialNo#'
							</cfquery>

							<cfif link.recordcount gt "0">

								<cfset mission      = mission>
								<cfset orgunitowner = orgunitowner>
								<cfset color = "ffffdf">
								<cfloop query="link">
									<cfinclude template="TransactionViewPostingLine.cfm">
								</cfloop>

							</cfif>

							<cfelseif Transaction.TransactionSourceId neq ""
							and Transaction.TransactionSourceId neq "00000000-0000-0000-0000-000000000000"
							and TransactionSource eq "SalesSeries"
							and TransactionSerialNo eq "0">

							<cfparam name="traidset" default="">

							<cfif traidset eq "">
								<cfset traidset = "'#transactionid#'">
							<cfelse>
								<cfset traidset = "#traidset#,'#transactionid#'">
							</cfif>

<!--- get the settlement transaction details --->

							<cfquery name="Link"
									datasource="AppsLedger"
									username="#SESSION.login#"
									password="#SESSION.dbpw#">
									SELECT T.*, H.ActionStatus,
									T.TransactionAmount as DocumentAmount,
									R.Description as GLDescription
									FROM    TransactionHeader H, TransactionLine T, Ref_Account R
									WHERE   H.Journal         = T.Journal
									AND     H.JournalSerialNo = T.JournalSerialNo
									AND     H.TransactionSourceId  = '#Transaction.TransactionSourceId#'
								AND     T.GLAccount       = R.GLAccount
								AND     H.TransactionSource = 'SalesSeries'
								AND     T.Journal         != '#Journal#'
								AND     T.JournalSerialNo != '#JournalSerialNo#'

<!--- added by hanno 2/3/2016 in order not to show too much in the screen as subsequent transactions are already shown --->
									AND     (T.ParentJournal = '' or T.ParentJournal is NULL)
<!--- -------------------------------------------------------------------------- --->

									AND     H.TransactionId NOT IN (#preservesinglequotes(traidset)#)
							</cfquery>


							<cfif link.recordcount gt "0">
								<cfset mission      = "#mission#">
								<cfset orgunitowner = "#orgunitowner#">
								<cfset color = "ffffdf">
								<cfloop query="link">
									<cfinclude template="TransactionViewPostingLine.cfm">
								</cfloop>
							</cfif>

						</cfif>

						<cfset box  = "_#journal#_#journalserialno#_#transactionserialno#">
						<cfset box  = replace(box,"-","_","All")>
						<cfset link = "journal=#journal#&journalserialno=#journalserialno#&transactionserialno=#transactionserialno#&box=#box#">

<!--- 5/5/2009 : Hanno --->
<!--- do not allow editing of attributes if the  transaction is distributed --->

						<cfquery name="CheckDis"
								datasource="AppsLedger"
								username="#SESSION.login#"
								password="#SESSION.dbpw#">
								SELECT   *
								FROM     TransactionLine L
								WHERE    Journal             = '#journal#'
								AND      JournalSerialNo     = '#Journalserialno#'
								AND      TransactionSerialNo = '#transactionSerialNo#'
								AND    ( TransactionLineId IN (SELECT ParentLineId
															   FROM   TransactionLine
															   WHERE  ParentLineId = L.TransactionLineId)
											OR ParentLineId is not NULL	)

						</cfquery>

						<cfif url.summary eq "9">

<!--- ---------------------------------------------------------------- --->
<!--- show additional details of the line, whcih can be edited as well --->
<!--- ---------------------------------------------------------------- --->

								<tr id="detail#currentrow#" class="navigation_row_child">

								<td></td>
								<td></td>
								<td colspan="12">
								<cfinclude template="TransactionViewPostingLineDetail.cfm">
								</td>
								</tr>

						</cfif>

					</cfoutput>

					<cfif ParentJournal neq "" and ParentJournalSerialNo neq Transaction.JournalSerialNo>
<!----to show the reference for the parent transaction rfuentes 2017-06-08  ----->
						<cfquery name="getParentDocument"
								datasource="AppsLedger"
								username="#SESSION.login#"
								password="#SESSION.dbpw#">
								SELECT   ISNULL(TransactionReference,JournalTransactionNo) as DocumentReference
								FROM     Accounting.dbo.TransactionHeader
								WHERE    Journal             = '#parentJournal#'
							AND    JournalSerialNo     = '#parentJournalserialno#'
						</cfquery>

							<tr bgcolor="fafafa">
							<td height="24" class="labelit" style="padding-left:20px;padding-top:0px" colspan="3"><cf_tl id="Source">:</td>
							<td colspan="9" class="labelmedium">
	
									<a href="javascript:ShowTransaction('#parentjournal#','#parentjournalserialNo#','1')">
							<font color="0080C0">#Jrn.Description# (#parentJournal#- #parentJournalserialno# {#getParentDocument.DocumentReference#})</font>
							</a>
							</td>
							</tr>

					</cfif>

				</cfoutput>

			</cfoutput>

			<cfif workflowshow eq "1">

<!--- transaction has a workflow associated in principle --->

				<cfif transactionid neq "">
<!--- if the workflow is not created yet for some reason, we assign it here the correct id --->
					<cfset wfid = transactionid>
				<cfelse>
					<cfset wfid = workflowid>
				</cfif>

				<cfif wfid neq "">

					<tr id="#JournalTransactionNo#" class="#cl#">

					<td width="100%" colspan="14">

					<!--- embedded workflow which is defined on the header --->

						<cfset wflnk = "TransactionViewDetailWorkflow.cfm">

						<input type="hidden"
							name="workflowlink_#wfid#"
							id="workflowlink_#wfid#"
							value="#wflnk#">

							<input type="hidden"
							id="workflowlinkprocess_#wfid#"
							onclick="processline('#wfid#')">

						<cfdiv id="#wfid#"  bind="url:#wflnk#?ajaxid=#wfid#"/>

						</td>

						</tr>

				</cfif>

			</cfif>

		</cfoutput>

	</cfoutput>

</CFOUTPUT>

</table>

<cfset ajaxonload("doHighlight")>