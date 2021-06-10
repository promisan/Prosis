
<cftransaction>

<cfquery name="Line" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT       *
		FROM         TransactionLine AS T
		WHERE        (Journal IN ('D4004', '40004')) AND (GLAccount <> '10602') AND
		                             ((SELECT        MAX(TransactionSerialNo) AS Expr1
		                                 FROM            TransactionLine AS TransactionLine_1
		                                 WHERE        (Journal = T.Journal) AND (JournalSerialNo = T.JournalSerialNo)) = 2)
								 
</cfquery>		

<cfloop query="Line">
	
	<cfquery name="Update" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE TransactionLine
			SET  AmountDebit  = AmountDebit+AmountDebit*0.12, AmountBaseDebit = AmountBaseDebit+AmountBaseDebit*0.12,
				 AmountCredit = AmountCredit+AmountCredit*0.12, AmountBaseCredit = AmountBaseCredit+AmountBaseCredit*0.12
			WHERE TransactionLineId = '#TransactionLineId#'	 										 
	</cfquery>	
	
	<cfif GLAccount eq "10603">
	
	<cfquery name="Update" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO TransactionLine
			
			( Journal, JournalSerialNo, TransactionSerialNo, GLAccount, ParentLineId, ReconciliationPointer, ReconciliationPointerDate, JournalTransactionNo, Memo, OrgUnit, OrgUnitProvider, Fund, 
                         ProgramCode, ActivityId, ProgramCodeProvider, ProgramPeriod, ObjectCode, ContributionLineId, WorkOrderLineId, AccountPeriod, TransactionDate, TransactionPeriod, TransactionType, Reference, ReferenceName, 
                         ReferenceNo, ReferenceQuantity, ReferenceId, ReferenceIdParam, Warehouse, WarehouseItemNo, WarehouseItemUoM, WarehouseQuantity, TransactionCurrency, TransactionAmount, TransactionTaxCode, ExchangeRate, 
                         Currency, AmountDebit, AmountCredit, ExchangeRateBase, AmountBaseDebit, AmountBaseCredit, ParentJournal, ParentJournalSerialNo, ParentTransactionId, TransactionCheckId, OfficerUserId, OfficerLastName, 
                         OfficerFirstName, Created )
			
			
			SELECT       Journal, JournalSerialNo, TransactionSerialNo, '10501', ParentLineId, ReconciliationPointer, ReconciliationPointerDate, JournalTransactionNo, Memo, OrgUnit, OrgUnitProvider, Fund, 
                         ProgramCode, ActivityId, ProgramCodeProvider, ProgramPeriod, ObjectCode, ContributionLineId, WorkOrderLineId, AccountPeriod, TransactionDate, TransactionPeriod, TransactionType, Reference, ReferenceName, 
                         ReferenceNo, ReferenceQuantity, ReferenceId, ReferenceIdParam, Warehouse, WarehouseItemNo, WarehouseItemUoM, WarehouseQuantity, TransactionCurrency, '#TransactionAmount*0.12#', TransactionTaxCode, ExchangeRate, 
                         Currency, '#TransactionAmount*0.12#', '0', ExchangeRateBase, '#TransactionAmount*0.12#', '0', ParentJournal, ParentJournalSerialNo, ParentTransactionId, TransactionCheckId, OfficerUserId, OfficerLastName, 
                         OfficerFirstName, Created
			FROM  TransactionLine			 
			WHERE TransactionLineId = '#TransactionLineId#'		
	   </cfquery>				 
	
	
	<cfelse>
	
		<cfquery name="Update" 
			datasource="AppslEDGER" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO TransactionLine
			
			( Journal, JournalSerialNo, TransactionSerialNo, GLAccount, ParentLineId, ReconciliationPointer, ReconciliationPointerDate, JournalTransactionNo, Memo, OrgUnit, OrgUnitProvider, Fund, 
                         ProgramCode, ActivityId, ProgramCodeProvider, ProgramPeriod, ObjectCode, ContributionLineId, WorkOrderLineId, AccountPeriod, TransactionDate, TransactionPeriod, TransactionType, Reference, ReferenceName, 
                         ReferenceNo, ReferenceQuantity, ReferenceId, ReferenceIdParam, Warehouse, WarehouseItemNo, WarehouseItemUoM, WarehouseQuantity, TransactionCurrency, TransactionAmount, TransactionTaxCode, ExchangeRate, 
                         Currency, AmountCredit, AmountDebit, ExchangeRateBase, AmountBaseCredit, AmountBaseDebit, ParentJournal, ParentJournalSerialNo, ParentTransactionId, TransactionCheckId, OfficerUserId, OfficerLastName, 
                         OfficerFirstName, Created )
			
			
			SELECT       Journal, JournalSerialNo, TransactionSerialNo, '20206', ParentLineId, ReconciliationPointer, ReconciliationPointerDate, JournalTransactionNo, Memo, OrgUnit, OrgUnitProvider, Fund, 
                         ProgramCode, ActivityId, ProgramCodeProvider, ProgramPeriod, ObjectCode, ContributionLineId, WorkOrderLineId, AccountPeriod, TransactionDate, TransactionPeriod, TransactionType, Reference, ReferenceName, 
                         ReferenceNo, ReferenceQuantity, ReferenceId, ReferenceIdParam, Warehouse, WarehouseItemNo, WarehouseItemUoM, WarehouseQuantity, TransactionCurrency, '#TransactionAmount*0.12#', TransactionTaxCode, ExchangeRate, 
                         Currency, '#TransactionAmount*0.12#', '0', ExchangeRateBase, '#TransactionAmount*0.12#', '0', ParentJournal, ParentJournalSerialNo, ParentTransactionId, TransactionCheckId, OfficerUserId, OfficerLastName, 
                         OfficerFirstName, Created
						 
			FROM  TransactionLine			 
			WHERE TransactionLineId = '#TransactionLineId#'		
	   </cfquery>				
	
	</cfif>
	

</cfloop>						

</cftransaction> 