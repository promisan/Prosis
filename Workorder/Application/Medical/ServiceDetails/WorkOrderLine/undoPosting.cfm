
<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   WorkOrder W, 
		       WorkOrderLine WL,
			   Customer C
		WHERE  W.WorkOrderId   = WL.WorkOrderId
		AND    WorkOrderLineId = '#url.workorderlineid#'				
		AND    C.CustomerId = W.CustomerId
</cfquery>	

<cfquery name="Journal" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   Journal, JournalSerialNo, Created
		FROM     TransactionHeader
		
		WHERE    TransactionSourceId = '#url.WorkOrderLineId#' 		
		AND      Journal         = '#Journal#'
		AND      JournalSerialNo = '#JournalSerialNo#'		
				
		UNION ALL
		
		SELECT   Journal, JournalSerialNo, Created
		FROM     TransactionHeader H
		WHERE    EXISTS (SELECT 'X'
		                 FROM   Transactionline J
						 WHERE  J.Journal                = H.Journal
						 AND    J.JournalSerialNo        = H.JournalSerialNo
						 AND    J.ParentJournal         = '#Journal#'
						 AND    J.ParentJournalSerialNo = '#JournalSerialNo#' )
									
		ORDER BY Created DESC 	
		
</cfquery>		

<cftransaction>

	<!--- undo COGS transaction made for this workorder line --->
		
	<cfinvoke component = "Service.Process.Materials.POS"  
		   method           = "purgeTransaction" 
		   mode             = "void"
		   status           = "9"
		   batchid          = "#url.workorderlineid#"
		   Journal			= "#url.Journal#"
		   JournalSNo	    = "#url.JournalSerialNo#"
		   >				   
	
	<!--- ----- remove billing made for this workorder line ----- --->

	<cfloop query="Journal">
		
		<cfquery name="clear" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM Accounting.dbo.TransactionLine
				WHERE  ReferenceId     = '#url.workorderLineid#'
				AND    Journal         = '#Journal#'
				AND    JournalSerialNo = '#JournalSerialNo#'		
		</cfquery>	
	
		<cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT ISNULL(SUM(TransactionAmount),0) as Total
				FROM   Accounting.dbo.TransactionLine
				WHERE  Journal = '#Journal#'
				AND    JournalSerialNo = '#JournalSerialNo#'		
				AND    TransactionSerialNo = '0'
	    </cfquery>	
	
		<cfif get.Total eq "0">
	
			<cfquery name="removeheader" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM Accounting.dbo.TransactionHeader
				WHERE  Journal = '#Journal#'
				AND    JournalSerialNo = '#JournalSerialNo#'		
			</cfquery>	
			
		<cfelse>
		
			<cfquery name="reset" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Accounting.dbo.TransactionHeader
				SET    DocumentAmount    = '#get.Total#', 
			           Amount            = '#get.Total#', 
					   AmountOutstanding = '#get.Total#'				
				WHERE  Journal = '#Journal#'
				AND    JournalSerialNo = '#JournalSerialNo#'		
			</cfquery>	
			
			<!--- recalculated amoun t outstanding --->
						
		</cfif>
	
	</cfloop>
	
	<cfquery name="close" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			UPDATE  WorkOrder.dbo.WorkOrderLine  
			SET     ActionStatus = '1'
			WHERE   WorkOrderLineId = '#url.workorderlineid#'					
				
	</cfquery>	

</cftransaction>

<script>
 history.go()
</script>

<!--- reload the screen --->
	