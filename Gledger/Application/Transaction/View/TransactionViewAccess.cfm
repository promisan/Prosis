<cfparam name="url.print" default="0">

<cfoutput>

<cfif ActionStatus eq "1" and 
    (TransactionSource eq "SalesSeries" or TransactionSource eq "ReceiptSeries" or TransactionSource eq "PurchaseSeries")>

	<!--- we check if this transaction is already a parent transaction and THEN we need to first remove the successive child like a settlement --->
	
	<cfquery name="Check" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     TransactionLine
		WHERE    ParentJournal         = '#journal#' 
		AND      ParentJournalSerialNo = '#journalserialno#'
	</cfquery>
		
	<cfif check.recordcount eq "0">		
		<cfset allowedit = "1">	
	<cfelse>	
		<cfset allowedit = "0">	
	</cfif>

<cfelse>

	<cfset allowedit = "0">

</cfif>

 
 <cfif TransactionSource eq "AccountSeries" 
      or TransactionSource eq "ReconcileSeries"  
	  or TransactionSource eq "SalesSeries"	 
	  or TransactionSource eq "ReceiptSeries"
	  or TransactionSource eq "PurchaseSeries">  	  
	  
	  <!--- if the transaction from purchaseseries or salesseries has status = 1, 
	     no workflow is triggered --->
					
 	  <cfinvoke component="Service.Access"  
	      method    = "journal"  
		  journal   = "#URL.Journal#" 
		  orgunit   = "#Transaction.OrgUnitOwner#"
		  returnvariable="access">	
		  
		 
		  		 		 			
      <cfif (ActionStatus eq "0" or allowEdit eq "1") 
	     and (Access eq "ALL" or Access eq "EDIT") 
		 and (PeriodStatus eq "0" or getAdministrator("*") eq "1") 
		 and url.mode neq "Print">
	  	  	  	   			  
	  		<!--- --only the last record can be deleted-- --->			
			<!--- check if transaction itself has a child --->
			
				<cfif url.print neq 1>
				
					<table cellspacing="0" cellpadding="0" class="formpadding formspacing">
					
						<tr>
															
						 <td style="padding-top:1px"><cf_img icon="edit" onclick="EditTransaction('#Journal#','#JournalSerialNo#')"></td>
						 <td style="padding-left:4px" class="labelmedium2"><a href="javascript:EditTransaction('#Journal#','#JournalSerialNo#')">
						      <cf_tl id="Amend">
							 </a>
						 </td>
						 <td style="padding-left:5px;padding-right:5px">|</td>
																
						<cfif pJournal neq journal and pJournalSerialNo neq JournalSerialNo>
												
							<cfset pJournal         = Journal>
							<cfset pJournalSerialNo = JournalSerialNo>
														
							<!--- check if this transaction has any children --->
						
							<cfquery name="Children" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT *
							FROM   TransactionLine
							WHERE  ParentJournal         = '#Journal#'
							AND    ParentJournalSerialNo = '#JournalSerialNo#'
							</cfquery>
							
							<cf_wfActive entityCode = "GLTransaction" ObjectKeyValue4= "#TransactionId#">	
																																													
					  		<cfif Children.recordcount eq "0" 
							      and (actionStatus eq "0" or (actionStatus eq "1" and wfexist eq "0"))
								  and (TransactionSource eq "AccountSeries"
											or TransactionSource eq "ReceiptSeries"
											or TransactionSource eq "PurchaseSeries"
											or TransactionSource eq "ReconcileSeries"
											or TransactionSource eq "SalesSeries")>
							
							 <td style="padding-left:4px;padding-top:3px"><cf_img icon="delete" onclick="del('#Journal#','#JournalSerialNo#')"></td>
							 <td style="padding-left:4px" class="labelmedium2"><a href="javascript:del('#Journal#','#JournalSerialNo#')">
							      <cf_tl id="Delete">
								  </a>
							  </td>					 
							   
							</cfif>  
							
						</cfif>	 
						
						</tr>
					
					</table>
				
				</cfif>
			   		   
	   </cfif>
		
   <cfelse>		
  
     
   		<cfif actionStatus eq "0" or (getAdministrator("*") eq "1" and TransactionSource eq "AccountSeries")>
						   
   		   <cfinvoke component="Service.Access"  
	          method="journal"  
			  journal="#URL.Journal#" 
			  orgunit="#Transaction.OrgUnitOwner#"
			  returnvariable="access">
  	  
		      <cfif Access eq "ALL" and PeriodStatus eq "0">
			  				  				  
			  		<!--- only the last record can be deleted --->
					
					<!--- check if transaction has a child --->
					
					<cfif pJournal neq journal and pJournalSerialNo neq JournalSerialNo>
					
						<cfset pJournal = Journal>
						<cfset pJournalSerialNo = JournalSerialNo>
					
						<cfquery name="Check" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   TransactionLine
							WHERE  ParentJournal         = '#Journal#'
							AND    ParentJournalSerialNo = '#JournalSerialNo#'
						</cfquery>					
									
				  		<cfif check.recordcount eq "0">   		
						 
						 <table cellspacing="0" cellpadding="0" class="formpadding">
						 
						 <tr class="line">
												
						 <td style="padding-left:4px" class="labelit">
						 <input type="button" class="button10g" style="width:120;height:25" onClick="EditTransaction('#Journal#','#JournalSerialNo#')" value="Amend">						
						 </td>
						 
						 <td style="padding-left:2px">												 
						 <input type="button" class="button10g" style="width:120;height:25" onClick="del('#Journal#','#JournalSerialNo#')" value="Delete">
						 </td>
						 </tr>
						 </table>
										 						 					   
	     	    		</cfif>		
					
					</cfif>			
			   
			   </cfif>
			   
		<cfelseif TransactionSource eq "EventSeries">	  
		
			<cfinvoke component="Service.Access"  
	          method="journal"  
			  journal="#URL.Journal#" 
			  orgunit="#Transaction.OrgUnitOwner#"
			  returnvariable="access">
  	  
		      <cfif Access eq "ALL" and PeriodStatus eq "0">
			  
			           <cfquery name="Check" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Event
							WHERE  EventId = '#Transaction.TransactionSourceId#'							
						</cfquery>					
									
				  		<cfif check.recordcount eq "0">   		
						 
						 <table cellspacing="0" cellpadding="0" class="formpadding">
						 
						 <tr class="line">
												
						 <td style="padding-left:4px" class="labelit">
						 <input type="button" class="button10g" style="width:120;height:25" onClick="EditTransaction('#Journal#','#JournalSerialNo#')" value="Amend">						
						 </td>
						 
						 <td style="padding-left:2px">												 
						 <input type="button" class="button10g" style="width:120;height:25" onClick="del('#Journal#','#JournalSerialNo#')" value="Delete">
						 </td>
						 </tr>
						 </table>
										 						 					   
	     	    		</cfif>		  
			  
			  			  
			  </cfif> 
			   
		<cfelse>
		
			  <cfinvoke component="Service.Access"  
	          method="journal"  
			  journal="#URL.Journal#" 
			  orgunit="#Transaction.OrgUnitOwner#"
			  returnvariable="access">	   
			   
		</cfif>	   	   
		
   </cfif>	
   
</cfoutput>      