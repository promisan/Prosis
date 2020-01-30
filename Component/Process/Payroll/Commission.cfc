
<!---  Name: /Component/Process/Procurement/PurchaseLine.cfc
       Description: Purchase Line procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Payroll Routines">
	
	<cffunction name="getCommission"
             access="public"
             returntype="string"
             displayname="getCommission">
		
		<cfargument name="PersonNo"    type="string" required="true"   default="">	
		<cfargument name="Module"      type="string" required="false"  default="WorkOrder">	
		<cfargument name="Effective"   type="string" required="true"  default="">	
		<cfargument name="Expiration"  type="string" required="true"  default="">	
		<cfargument name="Currency"    type="string" required="true"  default="#application.basecurrency#">	
		
		<!--- workorder
		
		a. Define all workorders that belong to this person
		b. Then define which of this workorder workorders that we invoiced have received a settlement recorded in the transactiondate 
		c. return the total as the basis for commission to be applied to the entitlement
				
		--->		
		
		SELECT        H.Journal, H.JournalSerialNo, H.TransactionDate, H.Reference, H.ReferenceName, H.DocumentCurrency, H.DocumentAmount, L.Journal AS SettlmentJournal, 
                         L.JournalSerialNo AS SettlementJournalSerialNo, L.AccountPeriod, L.TransactionDate AS SettlementDate, L.TransactionPeriod, L.Reference AS LineReference, 
                         L.Currency, L.AmountDebit, L.AmountCredit
FROM            TransactionHeader AS H LEFT OUTER JOIN
                         TransactionLine AS L ON H.Journal = L.ParentJournal AND H.JournalSerialNo = L.ParentJournalSerialNo
WHERE        (H.ReferenceId IN
                             (SELECT        WorkOrderId
                               FROM            WorkOrder.dbo.WorkOrder)) AND (H.TransactionSource = 'WorkOrderSeries') AND (L.TransactionSerialNo = '0')
ORDER BY H.Journal, H.JournalSerialNo
					
		 
   </cffunction>		
	
</cfcomponent>	 