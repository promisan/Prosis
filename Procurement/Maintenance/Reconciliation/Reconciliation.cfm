<html>
<head>
<title>Reconciliation</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<cfquery name="All" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
Select * from xReconciliation
</cfquery>

<cfloop query="All">
	<Cfset gotrue=1>
	<cftransaction>

	<cftry>

	<cfquery name="check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select * from stReconciliation
	where reconciliationNo='#All.ReconciliationNo#'
	</cfquery>
	
	<cfif #check.recordcount# eq 0>

		<cfquery name="Insert1" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		Insert into stReconciliation (reconciliationNo)
		values('#All.ReconciliationNo#')
		</cfquery>			
	</cfif>
		
	<cfquery name="Update1" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Update Invoice
	set ReconciliationNo='#All.ReconciliationNo#'
	where TransactionNo='#All.NOVA#'
	</cfquery>	

	<cfquery name="check2" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select * from stReconciliationIMIS
	where reconciliationNo='#All.ReconciliationNo#'
	and TransactionSerialNo='#All.IMIS#'
	</cfquery>

	<cfif #check2.recordcount# eq 0>
		<cfquery name="Insert2" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		Insert into stReconciliationImis (reconciliationNo,TransactionSerialNo)
		values('#All.ReconciliationNo#','#All.IMIS#')
		</cfquery>	
	</cfif>
	<cfcatch>
		<cfset gotrue=0>
		<cftransaction action="rollback">
	</cfcatch>
	</cftry>
	<cfif gotrue eq 1>
		<cftransaction action="commit">
	</cfif>	
	</cftransaction>
		   
</cfloop>



<body>



</body>


</html>
