
<!--- jn type --->
<cf_insertJournalType  JournalType="General" Description="General">

<!--- Transaction source --->
<cf_insertTransactionSource   Code="AccountSeries"    EditMode="1" Description="Direct entries accounting module">
<cf_insertTransactionSource   Code="AssetSeries"      EditMode="0" Description="Posting from asset module">
<cf_insertTransactionSource   Code="ExchangeRate"     EditMode="0" Description="Batch revaluating exchange rate">
<cf_insertTransactionSource   Code="Opening"          EditMode="0" Description="Batch preparing opening balances">
<cf_insertTransactionSource   Code="PayrollSeries"    EditMode="0" Description="Posting from payroll">
<cf_insertTransactionSource   Code="PurchaseSeries"   EditMode="0" Description="Invoice and advances">
<cf_insertTransactionSource   Code="ReceiptSeries"    EditMode="1" Description="Costs related to receipt processing">
<cf_insertTransactionSource   Code="SalesSeries"      EditMode="0" Description="Sales and POS bookings">
<cf_insertTransactionSource   Code="WarehouseSeries"  EditMode="0" Description="Warehouse stock transactions">
<cf_insertTransactionSource   Code="WorkorderSeries"  EditMode="1" Description="Direct entries for workorder">
<cf_insertTransactionSource   Code="ReconcileSeries"  EditMode="1" Description="Transaction through reconcile">
<cf_insertTransactionSource   Code="WorkflowSeries"   EditMode="1" Description="Transaction controlled thrugh workflow">
<!--- ----------------------------------------------------- --->
<!--- actual situation transaction source, provision for UN --->
<!--- ----------------------------------------------------- --->

<cfquery name="TransactionSource" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO Ref_TransactionSource
                      (Code,EditMode)
	SELECT   DISTINCT TransactionSource, 0
	FROM     TransactionHeader
	WHERE    TransactionSource NOT IN  (SELECT Code FROM  Ref_TransactionSource)
</cfquery>	

<!--- ----------------------------------------------------- --->
<!--- ----------------------------------------------------- --->
<!--- ----------------------------------------------------- --->

<!--- gl category --->
<cf_insertGLCategory   GLCategory="Actuals"  Description="Day-to-day transactions">
<cf_insertGLCategory   GLCategory="Budget"   Description="Budget transactions">
<cf_insertGLCategory   GLCategory="Forecast" Description="Forecast transactions">

<!--- TransactionCategory --->
<cf_insertTransactionCategory   TransactionCategory="Banking"       Description="Bank Transaction">
<cf_insertTransactionCategory   TransactionCategory="DirectPayment" Description="DirectPayment">
<cf_insertTransactionCategory   TransactionCategory="Inventory"     Description="Inventory">
<cf_insertTransactionCategory   TransactionCategory="Memorial"      Description="Memorial">
<cf_insertTransactionCategory   TransactionCategory="Interoffice"   Description="Interoffice">
<cf_insertTransactionCategory   TransactionCategory="Payables"      Description="Incoming Invoices">
<cf_insertTransactionCategory   TransactionCategory="Payment"       Description="Payment">
<cf_insertTransactionCategory   TransactionCategory="Receipt"       Description="Settlement">
<cf_insertTransactionCategory   TransactionCategory="Receivables"   Description="Income/Sales">
<cf_insertTransactionCategory   TransactionCategory="Advances"      Description="Advances">

<!--- TransactionType --->
<cf_insertTransactionType   TransactionCategory="Banking"     TransactionType="Customer, Payment from">
<cf_insertTransactionType   TransactionCategory="Banking"     TransactionType="Vendor, Payment to">
<cf_insertTransactionType   TransactionCategory="Memorial"    TransactionType="Distribution">
<cf_insertTransactionType   TransactionCategory="Receivables" TransactionType="Customer, Sales to">
<cf_insertTransactionType   TransactionCategory="Advances"    TransactionType="Standard">

<!--- account --->
<cf_insertDefaultAccount   Area="Capital"             Description="Capital Account : CLOSING"           Operational="1">
<cf_insertDefaultAccount   Area="Discount"            Description="Invoice Discount Taken"              Operational="1">
<cf_insertDefaultAccount   Area="ExchangeDifference"  Description="Monetary Account Revaluation Result" Operational="1">
<cf_insertDefaultAccount   Area="InvoiceTax"          Description="Default Invoice Tax Account"         Operational="1">
<cf_insertDefaultAccount   Area="Correction"          Description="Asset/Materials Correction Account"  Operational="1">
<cf_insertDefaultAccount   Area="StaffAdvance"        Description="Staff advance account"               Operational="1">

<!--- disabled 25/12/2009 --->
<cf_insertDefaultAccount   Area="Distribution"        Description=""    Operational="0">
<cf_insertDefaultAccount   Area="Profit and Loss"     Description=""    Operational="0">
<cf_insertDefaultAccount   Area="Invoice Supply"      Description=""    Operational="0" >
<cf_insertDefaultAccount   Area="Invoice Asset"       Description=""    Operational="0">
<cf_insertDefaultAccount   Area="Invoice Other"       Description=""    Operational="0">

<!--- journal --->
<cf_insertDefaultJournal   Area="Asset"            SystemModule="Warehouse"   Description="Asset Depreciations">
<cf_insertDefaultJournal   Area="Warehouse"        SystemModule="Warehouse"   Description="Supplies Receipts and Usage">
<cf_insertDefaultJournal   Area="Services"         SystemModule="WorkOrder"   Description="Distribution of service costs">
<cf_insertDefaultJournal   Area="Contract"         SystemModule="Accounting"  Description="Contract Postings">
<cf_insertDefaultJournal   Area="Payroll"          SystemModule="Payroll"     Description="Payroll Postings">
<cf_insertDefaultJournal   Area="Procurement"      SystemModule="Procurement" Description="Invoice Payable">
<cf_insertDefaultJournal   Area="Employee"         SystemModule="Procurement" Description="Invoice Employee">
<cf_insertDefaultJournal   Area="WorkOrder"        SystemModule="WorkOrder"   Description="Invoice Receiable">
<cf_insertDefaultJournal   Area="Advance"          SystemModule="Procurement" Description="Purchase Advances">
<cf_insertDefaultJournal   Area="Receipt"          SystemModule="Procurement" Description="Purchase Receipt Costs">
<cf_insertDefaultJournal   Area="Opening"          SystemModule="Accounting"  Description="Opening Balance">
<cf_insertDefaultJournal   Area="Distribution"     SystemModule="Accounting"  Description="Distribution Transaction">
<cf_insertDefaultJournal   Area="ExchangeRate"     SystemModule="Accounting"  Description="Exchange Rate Revalidations">
<cf_insertDefaultJournal   Area="Contribution"     SystemModule="Program"     Description="Contribution Assignment">
<cf_insertDefaultJournal   Area="SupportCost"      SystemModule="Program"     Description="Program Support Costs">

<!--- fields --->
<cf_insertSystemField   Field="CostCenter"        Section="Detail" Description="Cost center">
<cf_insertSystemField   Field="Description"       Section="Detail" Description="Description">
<cf_insertSystemField   Field="Memo"              Section="Detail" Description="Memo">
<cf_insertSystemField   Field="Program"           Section="Detail" Description="Program">
<cf_insertSystemField   Field="Source"            Section="Header" Description="Unit that provided the document">
<cf_insertSystemField   Field="SourceDate"        Section="Header" Description="Document Date">
<cf_insertSystemField   Field="SourceDescription" Section="Header" Description="Document Description">
<cf_insertSystemField   Field="SourceNo"          Section="Header" Description="Document No">
<cf_insertSystemField   Field="TransactionDate"   Section="Header" Description="Transaction Date">
<cf_insertSystemField   Field="TransactionNo"     Section="Header" Description="Internal Transaction No">

<!--- invoice conversion table --->

<cf_verifyOperational module = "Procurement" Warning   = "No">

<cfif operational eq "1">
	
	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Accounting.dbo.Ref_AccountReceipt
	(Fund, ObjectCode)
	SELECT DISTINCT RF.Fund, RF.ObjectCode
	FROM      RequisitionLineFunding RF INNER JOIN
	          PurchaseLine PL ON RF.RequisitionNo = PL.RequisitionNo LEFT OUTER JOIN
	          Accounting.dbo.Ref_AccountReceipt C ON RF.ObjectCode = C.ObjectCode AND RF.Fund = C.Fund 
	WHERE RF.Fund is not NULL		  
	GROUP BY RF.Fund, RF.ObjectCode, C.Created
	HAVING      (C.Created IS NULL)
	</cfquery>

</cfif>



