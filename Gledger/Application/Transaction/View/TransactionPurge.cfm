
<cf_systemscript>

<cfquery name="Header"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *  
	FROM TransactionHeader
	WHERE Journal = '#URL.journal#'
	AND   JournalSerialNo = '#url.JournalSerialNo#' 
</cfquery>

<cfquery name="Lines"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT ParentJournal, ParentJournalSerialNo
	FROM   TransactionLine
	WHERE  Journal = '#URL.journal#'
	AND    JournalSerialNo = '#url.JournalSerialNo#' 
</cfquery>

<cftransaction>

	<!--- Batch Settlement --->
	<cfif Header.TransactionSource eq "SalesSeries">
		<cfquery name="qCheckBatchSettlement"
				datasource="AppsLedger"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			SELECT *
			FROM   Materials.dbo.WarehouseBatchSettlement
			WHERE  BatchNo = '#Header.JournalTransactionNo#'
			AND    SettleSerialNo = '#Header.ReferenceNo#'
		</cfquery>

		<cfif qCheckBatchSettlement.recordcount eq 1>
			<cfquery name="qDeleteBatchSettlement"
					datasource="AppsLedger"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
				DELETE FROM Materials.dbo.WarehouseBatchSettlement
				WHERE  BatchNo = '#Header.JournalTransactionNo#'
				AND    SettleSerialNo = '#Header.ReferenceNo#'
			</cfquery>
		</cfif>
	</cfif>

		<!--- -------------------------------------- --->		
		<!--- remove the item warehouse transactions --->
		<!--- -------------------------------------- --->

	    <cfquery name="List"
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT * FROM TransactionLine
			WHERE  Journal         = '#url.Journal#'
			AND    JournalSerialNo = '#url.JournalSerialNo#'
			AND    Warehouse is not NULL and WarehouseQuantity is not NULL
		</cfquery>	
		
		<cfloop query="List">
				
		<cfquery name="Check"
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT * 
			FROM   Materials.dbo.ItemTransactionValuation
			WHERE  TransactionId IN (SELECT TransactionId 
			                         FROM   Materials.dbo.ItemTransaction 
									 WHERE  ReceiptId = '#TransactionLineId#')
		</cfquery>	
		
		<cfif check.recordcount gte "1">
			<cf_tl id="Stock receipt may no longer be removed as it has been used already" var="1">
			<cfoutput>
			<script>
				 alert("#lt_text#")
			</script>
			</cfoutput>		
			<cfabort>

		
		</cfif>
	
		<cfquery name="CleanPriorToAdding"
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			DELETE FROM Materials.dbo.ItemTransaction
			WHERE  ReceiptId = '#TransactionLineId#'			
		</cfquery>	
						
	   </cfloop>

<!--- remove underlying transactions that are triggered through the lines of this transaction first --->

<cfquery name="ParentLines"
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT DISTINCT Journal, JournalSerialNo
		FROM TransactionLine
		WHERE ParentJournal          = '#Header.Journal#'
		AND   ParentJournalSerialNo  = '#Header.JournalSerialNo#'   
</cfquery>	

<cfloop query="ParentLines">
				
		<!--- ------------------------------- --->
		<!--- create a delete log transaction --->
		<!--- ------------------------------- --->
		
		<cfinvoke component    = "Service.Process.GLedger.Transaction"  
			   method              = "LogTransaction" 
			   Journal             = "#ParentLines.Journal#"
			   JournalSerialNo     = "#ParentLines.JournalSerialNo#"			   
			   Action              = "Delete">	  
					
		<!--- ----------------------- --->
		<!--- delete header and lines --->
		<!--- ----------------------- --->
		
		<cfquery name="DeleteParent"
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		DELETE FROM TransactionHeader
		WHERE Journal          = '#ParentLines.Journal#'
		AND   JournalSerialNo  = '#ParentLines.JournalSerialNo#'   
		</cfquery>			

</cfloop>

<!--- ------------------------------- --->
<!--- create a delete log transaction --->
<!--- ------------------------------- --->

<cfinvoke component    = "Service.Process.GLedger.Transaction"  
			   method              = "LogTransaction" 
			   Journal             = "#Header.Journal#"
			   JournalSerialNo     = "#Header.JournalSerialNo#"			   
			   Action              = "Delete">	  
					

<!--- ----------------------- --->
<!--- delete header and lines --->
<!--- ----------------------- --->	

<cfquery name="Clean"
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		DELETE FROM TransactionHeader
		WHERE Journal        = '#Header.Journal#'
		AND  JournalSerialNo = '#Header.JournalSerialNo#' 
</cfquery>	

<cfloop query="Lines">

	<cfquery name="DefineResult" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT SUM(TransactionAmount) as Amount
		  FROM   TransactionLine
		  WHERE  ParentJournal         = '#ParentJournal#' 
		   AND   ParentJournalSerialNo = '#ParentJournalSerialNo#' 
		   AND   ParentLineId is not NULL 
	</cfquery>  
	
	<cfif DefineResult.amount eq "">
	    <cfset am = 0>
	<cfelse>
	    <cfset am = DefineResult.amount>  
	</cfif> 
							      
    <cfquery name="Outstanding" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    UPDATE TransactionHeader 
    SET    AmountOutstanding = ROUND(Amount - '#am#',2)	   
    WHERE  Journal = '#ParentJournal#'
    AND    JournalSerialNo = '#ParentJournalSerialNo#' 
	</cfquery>
			
</cfloop>	

</cftransaction>

<cfoutput>
<script>
    ptoken.location('TransactionView.cfm?journal=#url.jrn#&journalserialno=#url.ser#&mode=1')
</script>
</cfoutput>
