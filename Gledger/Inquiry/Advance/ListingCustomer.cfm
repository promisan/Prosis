
<!--- pending --->

Shows advances of this customer and their current balance 

This is taken from the financials.

<!--- query 

SELECT        Journal, 
              JournalSerialNo,
			   TransactionId, JournalTransactionNo, JournalBatchNo, JournalBatchDate, Mission, OrgUnitSource, OrgUnitOwner, OrgUnitTax, Description, TransactionSource, TransactionSourceNo, 
                         TransactionSourceId, TransactionReference, TransactionDate, TransactionPeriod, AccountPeriod, TransactionCategory, MatchingRequired, ReferenceOrgUnit, ReferencePersonNo, Reference, ReferenceName, ReferenceNo, 
                         ReferenceId, DocumentCurrency, DocumentAmount, DocumentAmountVerbal, DocumentDate, ExchangeRate, Currency, Amount, AmountOutstanding, ActionType, ActionTerms, ActionDescription, ActionDiscountDays, 
                         ActionDiscount, ActionDiscountDate, ActionBefore, ActionBankId, ActionAccountNo, ActionAccountName, ActionStatus, RecordStatus, RecordStatusDate, RecordStatusOfficer, PrintDocumentId, OfficerUserId, OfficerLastName, 
                         OfficerFirstName, Created
FROM            TransactionHeader
WHERE        (Journal IN
                             (SELECT        Journal
                               FROM            Journal
                               WHERE        (TransactionHeader.Mission = 'Bambino') AND (TransactionHeader.TransactionCategory = 'Advances'))) AND (AmountOutstanding > 1) AND (ActionStatus <> '9') AND (RecordStatus <> '9') AND 
                         (ReferenceId = '3708e810-902e-2bb8-2ac7-8d63066700da')
						 
--->						 