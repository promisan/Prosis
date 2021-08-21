
<!--- unlock --->

<cftransaction>

<cfquery name="schedulePeriod" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   SalarySchedulePeriod
	WHERE  CalculationId = '#URL.ID#'	
</cfquery>

<cfquery name="Last" 
	datasource="appsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     CalculationLog	
	ORDER BY Created DESC
</cfquery>

<cfif last.recordcount eq "0">
   <cfset nextprocess = 1>
<cfelse>
   <cfset nextprocess = last.ProcessNo + 1>   
</cfif>

<!--- create log container --->
	
<cfquery name="InsertProcessBatch"
 datasource="AppsPayroll" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	INSERT INTO CalculationLog
		(ProcessNo,
		 ProcessClass,
		 ProcessBatchId,	
		 Mission,
		 SalarySchedule,
		 PayrollStart,	
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
	VALUES
		('#nextprocess#',
		 'unlock',
		 '#url.id#',		
		 '#SchedulePeriod.Mission#',
		 '#SchedulePeriod.SalarySchedule#',
		 '#SchedulePeriod.PayrollStart#',		
		 '#SESSION.acc#',
		 '#SESSION.last#',
		 '#SESSION.first#')			
</cfquery>

<cf_verifyOperational 
  datasource= "appsPayroll"
  module    = "Procurement" 
  Warning   = "No">
  
<cfif operational eq "1" and schedulePeriod.reference neq "">
	
	<cfquery name="Reset" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Purchase.dbo.RequisitionLine
		WHERE Reference IN ('#schedulePeriod.Reference#','#schedulePeriod.ReferenceFinal#') 
	</cfquery>
	
	<!--- this deletes also the PurchaseLines --->
		
	<cfquery name="Reset" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Purchase.dbo.Requisition
		WHERE Reference IN ('#schedulePeriod.Reference#','#schedulePeriod.ReferenceFinal#')	
	</cfquery>

</cfif>

<cf_verifyOperational 
	  datasource= "appsPayroll"
	  module    = "Accounting" 
	  Warning   = "No">	  
			
<cfif operational eq "1">

	<!--- we get the last one first --->
	
	<cfquery name="get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 * 
		FROM     Accounting.dbo.TransactionHeader
		WHERE    ReferenceId = '#schedulePeriod.CalculationId#'			
		ORDER BY Created DESC		 
	</cfquery>	  
			
	<cfif get.TransactionId neq "">	
	
		<!--- reset payables, 
		
		hanno 29/7/2021 : it can be that a payables is already processed 
		in the current situation it will not allow to proceed and will through an error --->
		
		<cftry>
		
			<cfquery name="Reset" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE Accounting.dbo.TransactionHeader
				FROM   Accounting.dbo.TransactionHeader H INNER JOIN Accounting.dbo.TransactionLine L
				       ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
				WHERE  ParentJournal         = '#get.Journal#'
				AND    ParentJournalSerialNo = '#get.JournalSerialNo#'								
			</cfquery>
		
		<cfcatch>
		
			<script>
			   alert('One or more payroll transactions were already paid. Operation not supported. Please contact your administrator.')
			</script>
			<cfabort>
		
		</cfcatch>
		
		</cftry>
							
		<cfquery name="Reset" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Accounting.dbo.TransactionHeader
			WHERE    Journal         = '#get.Journal#'
			AND      JournalSerialNo = '#get.JournalSerialNo#' 			
		</cfquery>
		
		<!--- NOT needed but a safe guard --->
		<cfquery name="ResetSafeGuard" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Accounting.dbo.TransactionHeader			
			WHERE    TransactionSourceId = '#schedulePeriod.CalculationId#'	
			<!--- should delete also the children --->
		</cfquery>
				
		<cfif get.ReferenceNo eq "Initial">
				
			<cfquery name="Reset" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE SalarySchedulePeriod
				SET    CalculationStatus = '1', 
				       Reference         = NULL,
					   ReferenceFinal    = NULL		   
				WHERE  CalculationId     = '#URL.ID#'
			</cfquery>
		
		<cfelse>
				
			<cfquery name="Reset" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE SalarySchedulePeriod
				SET    CalculationStatus = '2', 		     
					   ReferenceFinal    = NULL		   
				WHERE  CalculationId     = '#URL.ID#'
			</cfquery>
				
		</cfif>
		
	<cfelse>
	
		<!--- no transaction is found for this id, not sure if
		it is a good idea to undo this, 6/21/2017 --->
	
		<cfif get.ReferenceNo eq "Initial">
				
			<cfquery name="Reset" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE SalarySchedulePeriod
				SET    CalculationStatus = '1', 
				       Reference         = NULL,
					   ReferenceFinal    = NULL		   
				WHERE  CalculationId     = '#URL.ID#'
			</cfquery>
		
		<cfelse>
				
			<cfquery name="Reset" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE SalarySchedulePeriod
				SET    CalculationStatus = '2', 		     
					   ReferenceFinal    = NULL		   
				WHERE  CalculationId     = '#URL.ID#'
			</cfquery>
				
		</cfif>		
		
	</cfif>	
			
</cfif>  	
					
</cftransaction>

<cf_CalculationLockProgressInsert
    ProcessNo      = "#nextprocess#"
   	ProcessBatchId = "#url.id#"	
	ActionStatus   = "2"	
	StepStatus	   = "1"
	Description    = "Completed">	

<cfif get.ReferenceNo eq "Initial">

<cfoutput>&nbsp;
	 <a href="javascript:lock('#url.id#','2')" title="Lock and Record Settlement and Obligation">
	 <font color="0080C0"><cf_tl id="Post Settlement"></font>
	 </a>
</cfoutput> 

<cfelse>

<cfoutput>&nbsp;
	 <a href="javascript:lock('#url.id#','3')" title="Lock and Record Settlement and Obligation">
	 <font color="0080C0"><cf_tl id="Post Final Settlement"></font>
	 </a>
</cfoutput> 

</cfif>

<cfoutput>

<script>
	document.getElementById('undo_#url.id#').className = "hide"
	alert('Posting has been reverted.\n\nYou may post again when you are ready to do so.')
</script>

</cfoutput>