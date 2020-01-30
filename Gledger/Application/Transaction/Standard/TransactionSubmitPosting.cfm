
<!--- double check for balance again --->

<cfquery name="Total" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT SUM(AmountDebit) - SUM(AmountCredit) as Diff, 
	       SUM(AmountBaseDebit) - SUM(AmountBaseCredit) as DiffB   
	FROM userQuery.dbo.#SESSION.acc#GLedgerLine_#client.sessionNo#
</cfquery>

<cfif Total.recordcount eq 0>
    
  <script>
       alert("I'm not able to determine the lines of this transaction.\nPlease check with your administrator.");  	
	    Prosis.busy('no')  
  </script>
  
  <cfabort>

</cfif>

<cfif abs(total.diff) gte "0.001" or abs(total.diffB) gte "0.01">
    
  <script>
       alert("Your Transaction is NOT in balance!");  	
	   Prosis.busy('no') 
  </script>
  
  <cfabort>

</cfif>  

<!--- process --->	

<cfquery name="Document" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT SUM(AmountDebit) - SUM(AmountCredit) as Diff,
		       SUM(AmountBaseDebit) - SUM(AmountBaseCredit) as DiffB
		FROM   userQuery.dbo.#SESSION.acc#GLedgerLine_#client.sessionNo#
		WHERE  TransactionSerialNo = '0'   
</cfquery>

<cfif document.diff eq "">

	<cfquery name="Document" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT SUM(AmountDebit)  as Diff,
		       SUM(AmountBaseDebit) as DiffB
		FROM   UserQuery.dbo.#SESSION.acc#GLedgerLine_#client.sessionNo#		
	</cfquery>

	<cfset amt       = abs(Document.Diff)>
	<cfset amtB      = abs(Document.DiffB)>    
	<cfif TraCat is "Advances" or TraCat is "Payables" or TraCat is "Payment" or TraCat is "DirectPayment" or Tracat is "Receivables">
		<cfset matching  = 1>			
	<cfelse>
		<cfset matching  = 0>			
	</cfif>

<cfelse>

	<cfif TraCat is "Advances" or TraCat is "Payables" or TraCat is "Payment" or TraCat is "DirectPayment" or Tracat is "Receivables">
	    <cfset amt       = abs(Document.Diff)>
		<cfset amtB      = abs(Document.DiffB)>	   
		<cfset matching  = 1>		
	<cfelse>
	    <cfset amt       = abs(Document.Diff)>
		<cfset amtB      = abs(Document.DiffB)>	  
		<cfset matching  = 0>
	</cfif>

</cfif>
	
<cfquery name="GetLines" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   userQuery.dbo.#SESSION.acc#GLedgerLine_#client.sessionNo#
</cfquery>
  
<!--- define journal serialNo in case of a new Transaction = JournalSerialNo = 0 --->

<cfif HeaderSelect.JournalSerialNo is "">
	  
       <cfset trid = HeaderSelect.TransactionId>

	   <cfquery name="Set" 
	      datasource="AppsLedger" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">		
	      UPDATE Journal 
	      SET    JournalSerialNo = (JournalSerialNo + 1.0)
	      WHERE  Journal = '#URL.Journal#'
	   </cfquery>
	   
	   <cfquery name="Get" 
	      datasource="AppsLedger" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	       SELECT * 
		   FROM   Journal 
		   WHERE  Journal = '#URL.Journal#' 
	   </cfquery>
	    
   	   <cfset JourNo = Get.JournalSerialNo>	   
	    
   	   <!--- check existing --->
   
	   <cfquery name="Check" 
	   datasource="AppsLedger" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   TransactionHeader
		   WHERE  Journal         = '#url.Journal#'
		   AND    JournalSerialNo = '#journo#'
	   </cfquery>
   
	   <cfif check.recordcount gte "1">
	   
		   	<cfquery name="Check" 
			   datasource="AppsLedger" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				  SELECT   TOP 1 * 
				  FROM     TransactionHeader
				  WHERE    Journal = '#url.Journal#'
				  ORDER BY JournalSerialNo DESC
			</cfquery>
			
			<cfif Check.recordcount eq "0">
	            <cfset JourNo = "1">					
	        <cfelse>
			  	<cfset JourNo = Check.JournalSerialNo+1>					
			</cfif>		
			
			<cfquery name="Set" 
			    datasource="appsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    UPDATE   Journal 
				    SET      JournalSerialNo = '#Check.JournalSerialNo#'
				    WHERE    Journal = '#url.Journal#' 
			</cfquery>
			  
	   </cfif>     	     
	   
<cfelse>

	    <cfset trid = HeaderSelect.Transactionid>   

		<!--- not sure as to why I wanted to do this, has been disabled
		<cfinclude template="TransactionPurge.cfm">
	   --->
   		    	
		<!--- unlink the children --->
		
		<cfquery name="UnlinkChildren"
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">			
				UPDATE TransactionLine
				SET    ParentJournal         = NULL, 
				       ParentJournalSerialNo = NULL,
					   ParentTransactionId   = '#HeaderSelect.TransactionId#'
				WHERE  ParentJournal         = '#HeaderSelect.Journal#'
				AND    ParentJournalSerialNo = '#HeaderSelect.JournalSerialNo#'
		</cfquery>	
		
		<!--- -------------------------------------- --->		
		<!--- remove the item warehouse transactions --->
		<!--- -------------------------------------- --->
		
		<cfquery name="List"
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT * 
				FROM   TransactionLine
				WHERE  Journal         = '#HeaderSelect.Journal#'
				AND    JournalSerialNo = '#HeaderSelect.JournalSerialNo#'
				AND    Warehouse is not NULL and WarehouseQuantity is not NULL
		</cfquery>	
		
		<cfloop query="List">
		
			<cfquery name="CleanPriorToAdding"
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				DELETE FROM   Materials.dbo.ItemTransaction
				WHERE  ReceiptId = '#TransactionLineId#'			
			</cfquery>	
				
		</cfloop>
						
		<!--- ------------------------------- --->
		<!--- create a delete log transaction --->
		<!--- ------------------------------- --->
						
		<cfinvoke component    = "Service.Process.GLedger.Transaction"  
			   method              = "LogTransaction" 
			   Journal             = "#HeaderSelect.Journal#"
			   JournalSerialNo     = "#HeaderSelect.JournalSerialNo#"			   
			   Action              = "Delete">	  
				
				
		<!--- --------------------------------------------- --->		
		<!--- now clean the header and transaction -------- --->
		<!--- --------------------------------------------- --->	
		
		<cfquery name="ObtainActions"
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT * 
			FROM   TransactionHeaderAction
			WHERE  Journal         = '#HeaderSelect.Journal#'
			AND    JournalSerialNo = '#HeaderSelect.JournalSerialNo#'
		</cfquery>	
	
		<cfquery name="CleanPriorToAdding"
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			DELETE FROM TransactionHeader
			WHERE  Journal         = '#HeaderSelect.Journal#'
			AND    JournalSerialNo = '#HeaderSelect.JournalSerialNo#'
		</cfquery>			
	
	    <cfset JourNo = HeaderSelect.JournalSerialNo>    <!--- use the same No --->
		 
</cfif>
	
	<cfquery name="Get" 
   datasource="AppsLedger" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Journal J, Currency C
	   WHERE  Journal = '#URL.Journal#'
	   AND    J.Currency = C.Currency
	</cfquery>

	<!--- insert TransactionHeader header --->
	
	<cfset TraNo  = FORM.TransactionNo>
	   
	<cfif TransactionNo is ""> 
	     <cfset TraNo = "#URL.Journal#"&"-"&"#JourNo#">
	</cfif>	
	
	<cfparam name="Form.JournalBatchNo"   default="0">
	<cfparam name="Form.JournalBatchDate" default="">
	
	<cfset dateValue = "">
    <CF_DateConvert Value="#Form.JournalBatchDate#">
    <cfset bdte = dateValue>	
	
	<cfif HeaderSelect.TransactionSource eq "">
	    <cfset source   = "AccountSeries">
		<cfset sourceNo = "">
		<cfset sourceId = "">
	<cfelse>
		<cfset source   =  HeaderSelect.TransactionSource>
		<cfset sourceNo =  HeaderSelect.TransactionSourceNo>
		<cfset sourceId =  HeaderSelect.TransactionSourceId>
	</cfif>
		
	<!--- TransactionPeriod was added 14/3/2015 --->
	
	<cfif month(dte) gte "10">
		<cfset TransactionPeriod = "#year(dte)##month(dte)#">
	<cfelse>
		<cfset TransactionPeriod = "#year(dte)#0#month(dte)#">
	</cfif>	
	
	<!--- prevent a transactionperiod lower than the fiscal year start --->
		
	<cfquery name="Period" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		  SELECT    *
		  FROM      Accounting.dbo.Period
		  WHERE     AccountPeriod    = '#Form.AccountPeriod#' 	
	</cfquery>
		
	<cfif month(Period.PeriodDateStart) gte "10">
		<cfset  mintraper = "#year(Period.PeriodDateStart)##month(Period.PeriodDateStart)#">
	<cfelse>
		<cfset  mintraper = "#year(Period.PeriodDateStart)#0#month(Period.PeriodDateStart)#">
	</cfif>	
	
	<cfif TransactionPeriod lt mintraper>
	
		<cfset TransactionPeriod = mintraper>
	
	</cfif>
				
	<cfquery name="getWorkflow" 
	   datasource="AppsLedger" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT ObjectId 
		FROM   Organization.dbo.OrganizationObject 
		WHERE  ObjectkeyValue4 = '#trid#' 
		AND	   Operational = 1
	 </cfquery>
	 
	 <cfif Source eq "AccountSeries" or Source eq "ReconcileSeries">					  
			<!--- always a workflow --->
			<cfset workflowshow = "1">			  
	 <cfelseif getWorkflow.recordcount gte "1" or hasPriorWorkflow.recordcount gte "1">			
			<!--- Attention 26/5/2013 : if you want workflow for other series like sales series or purchase series 
			ensure that upon transaction creation the workflow is generated, then it will work as well
			a workflow created and also status = 0 is applies, then it will be picked up here--->		
	        <cfset workflowshow = "1">			  
	 <cfelse>			
	 	    <cfset workflowshow = "0">			  
	 </cfif>		
				   	  	      
	<cfquery name="InsertHeader" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO TransactionHeader
		   (Journal,
		   JournalSerialNo,
		   <cfif Form.JournalBatchNo neq "0">
		   JournalBatchNo,
		   </cfif>
		   <cfif Form.JournalBatchDate neq "">
		   JournalBatchDate,
		   </cfif>
		   TransactionId,
		   Mission,
		   OrgUnitOwner,
		   JournalTransactionNo, 
		   Description,
		   TransactionSource,
		   TransactionSourceNo,
		   <cfif sourceid neq "">	 
		   TransactionSourceId,
		   </cfif>
		   TransactionPeriod,
		   TransactionDate,
		   AccountPeriod,
		   TransactionCategory,
		   <cfif Form.Party eq "ven">
		   ReferenceOrgUnit,
		   <cfelse>
		   ReferencePersonNo,
		   </cfif>
		   ReferenceName,
		   ReferenceNo,
		   ReferenceId,
		   ActionBankId,
		   ActionBefore,
		   ActionTerms,
		   ActionDiscountDays,
		   ActionDiscount,
		   ActionDiscountDate,   	 
		   MatchingRequired,
		   DocumentDate,
		   DocumentCurrency,
		   DocumentAmount,
		   ExchangeRate,
		   Currency,
		   Amount,	   
		   ActionStatus,
		   OfficerUserId,
		   OfficerLastName,
		   OfficerFirstName)
	VALUES 
		   ('#HeaderSelect.Journal#',
		   '#JourNo#', 
		   <cfif Form.JournalBatchNo neq "0">
		   '#Form.JournalBatchNo#',
		   </cfif>
		    <cfif Form.JournalBatchDate neq "">
			#bdte#,
			</cfif>
		   '#trid#',
		   '#Mission#',
		   '#OrgUnitOwner#',
		   '#TraNo#',
		   '#FORM.Description#',
		   '#source#',
		   '#sourceno#',
		   <cfif sourceid neq "">	   
		   '#sourceid#',
		   </cfif>
		   '#transactionperiod#',
		   #dte#,
		   '#Form.AccountPeriod#',
		   '#TraCat#',
		    <cfif Form.Party eq "ven">
		   		'#FORM.ReferenceOrgUnit1#',
		   		'#FORM.ReferenceOrgUnitName1#',
		   <cfelseif Form.Party eq "cus">	
		        NULL,
				'#FORM.customername#',
		   <cfelse>
		   		'#FORM.PersonNo#',
		   		'#FORM.ReferenceName2#',
		   </cfif>	   
		   '#FORM.ReferenceNo#',
			<cfif Form.Party eq "cus">
				'#FORM.CustomerId#',				
			<cfelse>
				<cfif HeaderSelect.Referenceid neq "">
					'#HeaderSelect.Referenceid#',
				<cfelse>
					NULL,
				</cfif>
			</cfif>
		   <cfif form.actionbankId neq "">
		   '#Form.actionBankId#',
		   <cfelse>
		   NULL,
		   </cfif>
		   #dtebefore#,
		   '#FORM.ActionTerms#',
		   '#FORM.ActionDiscountDays#',
		   '#FORM.ActionDiscount#',
		   #dtediscount#,  		
		   #matching#,
		   #dtedoc#,
		   '#get.currency#',
		   '#amt#',
		   '1',
		   '#get.currency#',
		   '#amt#',	
		   <cfif workflowshow eq "1">
		   '0',
		   <cfelse>
		   '1',   
		   </cfif>
		   '#SESSION.acc#',
		   '#SESSION.last#',
		   '#SESSION.first#')
	</cfquery>
	
	<!--- ---------------------------------- --->
	<!--- ---------- retain action --------- --->
	<!--- ---------------------------------- --->
	
	<cfif HeaderSelect.JournalSerialNo neq "">
	
		<cfloop query="ObtainActions">
		
			<cfquery name="InsertAction" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO TransactionHeaderAction
			
					   (Journal,
					   JournalSerialNo,
					   ActionCode,
					   ActionMode,
					   ActionDate,
					   ActionStatus,
					   ActionMemo,
					   ActionReference1,
					   ActionReference2,
					   ActionReference3,
					   ActionReference4,
					   ActionContent,
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName,
					   Created)
					   
				  VALUES (		  		  
					   '#Journal#',
					   '#JourNo#',
					   '#ActionCode#',
					   '#ActionMode#',
					   '#ActionDate#',
					   '#ActionStatus#',
					   '#ActionMemo#',
					   '#ActionReference1#',
					   '#ActionReference2#',
					   '#ActionReference3#',
					   '#ActionReference4#',
					   '#ActionContent#',
					   '#OfficerUserId#',
					   '#OfficerLastName#',
					   '#OfficerFirstName#',
					   '#Created#')
			</cfquery>
			
			</cfloop>
		
	</cfif>
			
	<!--- ---------------------------------- --->
	<!--- ---------- custom fields --------- --->
	<!--- ---------------------------------- --->
			
	<cfquery name="CleanTopics" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  DELETE FROM TransactionHeaderTopic
	  WHERE       Journal = '#HeaderSelect.Journal#'
	  AND         JournalSerialNo = '#JourNo#'
	</cfquery>
	
	<cfquery name="GetTopics" 
		  datasource="AppsLedger" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_Topic
		  WHERE  Code IN (SELECT Topic 
                  FROM   Ref_SpeedTypeTopic 
				  WHERE  Speedtype = '#Get.Speedtype#')		 
		  AND Operational = 1		
		  AND TopicClass = 'Header'		  
	</cfquery>
				
	<cfloop query="getTopics">
	
	    <cfif ValueClass eq "List">
			
			<cfset value  = Evaluate("FORM.Topic_#Code#")>
			
			 <cfquery name="GetList" 
					  datasource="AppsLedger" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT *
					  FROM Ref_TopicList T
					  WHERE T.Code     = '#Code#'
					  AND   T.ListCode = '#value#'				  
			</cfquery>
						
			<cfif value neq "">
						
				<cfquery name="InsertTopics" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO TransactionHeaderTopic
				 		 (Journal,
						  JournalSerialNo,
						  Topic,
						  ListCode,
						  TopicValue,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#HeaderSelect.Journal#',
				          '#JourNo#',
						  '#Code#',
						  '#value#',
						  '#getList.ListValue#',
						  '#session.acc#',
						  '#session.last#',
						  '#session.first#')
				</cfquery>
			
			</cfif>
			
		<cfelse>
		
			<cfif ValueClass eq "Boolean">
			
				<cfparam name="FORM.Topic_#Code#" default="0">
				
			</cfif>
			
			<cfset value  = Evaluate("FORM.Topic_#Code#")>
			
			<cfif value neq "">
			
				<cfquery name="InsertTopics" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO TransactionHeaderTopic
				 		 ( Journal,JournalSerialNo, Topic, TopicValue )
				  VALUES ('#HeaderSelect.Journal#','#JourNo#','#Code#','#value#')
				</cfquery>	
			
			</cfif>
		
		</cfif>	
				
	</cfloop>
			
	<cfquery name="RestoreChildren"
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		UPDATE TransactionLine
		SET    ParentJournal         = '#HeaderSelect.Journal#', 
		       ParentJournalSerialNo = '#journo#'
		WHERE  ParentTransactionId   = '#trid#'
	</cfquery>	
	
	<!--- add temp line table to destination --->
	
	<!--- 5/5 check if the parent line id field is populated in the header in order
	to sync attributes this is caused by a distribution --->
	
	<cfoutput query="GetLines">	
	
		<cfif TransactionDate eq "">
			<cfset ldte = dte>
		<cfelse>
	        <CF_DateConvert Value="#dateformat(transactionDate,client.dateformatshow)#">		    
			<cfset ldte = datevalue>
		</cfif>>
	
		<cfif HeaderSelect.ParentLineId neq "">
		
				<cfquery name="ParentLine"
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT *
					FROM   TransactionLine	
					WHERE  TransactionLineId = '#HeaderSelect.ParentLineId#' 
				</cfquery>
				
				<cfset LineParentLineId  	  	= HeaderSelect.ParentLineId>
				<cfset LineOrgUnit       	  	= ParentLine.OrgUnit>
				<cfset LineFund          	  	= ParentLine.Fund>
				<cfset LineProgramCode   	  	= ParentLine.ProgramCode>
				<cfset LineProgramPeriod 	  	= ParentLine.ProgramPeriod>
				<cfset LineObject       	  	= ParentLine.ObjectCode>
				<cfset LineContributionLineid 	= ParentLine.ContributionLineId>				
								
		<cfelse>
				
				<cfset LineParentLineId  = ParentLineId>   <!--- reconcilution only --->
				<cfset LineOrgUnit       = "">
				<cfset LineFund          = "">
				<cfset LineProgramCode   = "">
				<cfset LineProgramPeriod = "">
				<cfset LineObject        = "">
				<cfset LineContributionLineid 	= "">
					
		</cfif>	
		
		<!--- create record AND LOG record --->
		
		<cfloop index="tbl" list="Line,LineLog">
					
			<cfquery name="InsertLines" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Transaction#tbl#
			   (TransactionLineId,
			   Journal,
			   JournalSerialNo,
			   TransactionSerialNo, 
			   JournalTransactionNo,	 
			   ParentLineId,
					   
			   GLAccount,
			   Memo,
			   OrgUnit,
			   ProgramCode,
			   ProgramPeriod,
			   ProgramCodeProvider,
			   ContributionLineId,
			   Fund,
			   ObjectCode,
			   
			   AccountPeriod,
			   
			   TransactionType,
			   Reference, 
			   ReferenceName,
			   ReferenceNo,
			   ReferenceId,
			   
			   Warehouse,
			   WarehouseItemNo,
			   WarehouseItemUoM,
			   WarehouseQuantity,
			   
			   ParentJournal,
			   ParentJournalSerialNo, 
			   ParentTransactionId,		 
			   
			   TransactionTaxCode, 
			   
			   TransactionCurrency,
			   TransactionAmount,
			   TransactionPeriod,
			   TransactionDate,
			   ExchangeRate,
			   Currency,
			   AmountDebit,
			   AmountCredit,
			   ExchangeRateBase,
			   AmountBaseDebit,
			   AmountBaseCredit,
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName,
			   Created)
			
			<cfif transactionserialNo eq "0">   	
					
			 VALUES 
			      ('#TransactionLineId#',
				  '#Form.Journal#',
			      '#JourNo#',
			      '#TransactionSerialNo#',
				  '#TraNo#',
				  
				  <cfif LineParentLineId neq "">
				  '#LineParentLineId#', 
				  <cfelse>
				  NULL, 
				  </cfif>
				  
				  <!--- Budget attributes --->
			      '#GlAccount#',
			      '#Memo#',
				  '#LineOrgUnit#',
			      '#LineProgramCode#',
				  '#LineProgramPeriod#',
				  '',
				  <cfif LineContributionLineId neq "">
				  '#LineContributionLineId#',
				  <cfelse>
				  NULL,
				  </cfif>
				  '#LineFund#',
				  '#LineObject#',
				  
			      '#FORM.AccountPeriod#',
				  '#TransactionType#',
			      'Contra-account',
			      'Contra-account',
				  '',
				  NULL,
				  
				  NULL,
				  NULL,
				  NULL,
				  NULL,
				  
				  <cfif ParentJournal neq "">
				 
					  '#ParentJournal#',
				      '#ParentJournalSerialNo#',   
					  '#ParentTransactionId#',
					  
				  <cfelse>
				 
					  NULL,NULL,'{00000000-0000-0000-0000-000000000000}',
				  </cfif>			  
				  
				  NULL,
			      '#TransactionCurrency#',
			      '#TransactionAmount#',
				  				  
				 <cfif LineParentLineId neq "">
				 
					  <cfif month(ParentLine.TransactionDate) gte 10>
						<cfset TraPer = "#year(ParentLine.TransactionDate)##month(ParentLine.TransactionDate)#">
					  <cfelse>
						<cfset TraPer = "#year(ParentLine.TransactionDate)#0#month(ParentLine.TransactionDate)#">
					  </cfif>	
					  
					  <!--- prevent a transactionperiod lower than the fiscal year start --->			
						
					  <cfif TraPer lt mintraper>						
						<cfset TraPer = mintraper>						
					  </cfif>
					  
					  '#TraPer#',			  
				      '#ParentLine.TransactionDate#',
				  
				  <cfelse>
				 				 				  
					  <cfif month(dte) gte 10>
						<cfset TraPer = "#year(dte)##month(dte)#">
					  <cfelse>
						<cfset TraPer = "#year(dte)#0#month(dte)#">
					  </cfif>	
					  
					  <cfif TraPer lt mintraper>						
						<cfset TraPer = mintraper>						
					  </cfif>
					  
					  '#TraPer#',					  
					  #dte#,
				  
				  </cfif>
				  
			      '#ExchangeRate#',
			      '#Currency#',
			      '#AmountDebit#',
			      '#AmountCredit#',
			      '#ExchangeRateBase#',
			      '#AmountBaseDebit#',
			      '#AmountBaseCredit#',
			      '#SESSION.acc#',
			      '#SESSION.last#',
			      '#SESSION.first#',
				  getDate())
			
			<cfelse>
			
			VALUES 
			
			   ('#TransactionLineId#',
			   '#Form.Journal#',
			   '#JourNo#',
			   '#TransactionSerialNo#',
			   '#TraNo#',
			   
			   <cfif ParentLineId neq "">
			       '#ParentLineId#',
			   <cfelse>
				   NULL,	   
			   </cfif>
			   
			   <!--- Budget attributes --->
			   '#GlAccount#',
			   '#Memo#',
			   '#OrgUnit#',
			   '#ProgramCode#',
			   '#LineProgramPeriod#',
			   '#ProgramCodeProvider#',
			   <cfif contributionLineid eq "">
			   		NULL,
			   <cfelse>
				   '#ContributionLineId#',
			   </cfif>
			   '#Fund#',
			   '#ObjectCode#',		   
			   
			   '#Form.AccountPeriod#',
			   '#TransactionType#',
			   '#Reference#', 
			   '#ReferenceName#',
			   '#ReferenceNo#',
			   <cfif ReferenceId neq "">
			   '#ReferenceId#',
			   <cfelse>
			   NULL,
			   </cfif>
			   
			   '#Warehouse#',
			   '#WarehouseItemNo#',
			   '#WarehouseItemUoM#',
			   '#WarehouseQuantity#',		   
			   
			   <cfif ParentJournal neq ""> 
			   '#ParentJournal#',
			   '#ParentJournalSerialNo#',  
			   '#ParentTransactionId#',  
			   <cfelse>
			    NULL,
				NULL,
				'{00000000-0000-0000-0000-000000000000}',   
			   </cfif>		
			   
			   '#TransactionTaxCode#',  
			   '#TransactionCurrency#',
			   '#TransactionAmount#',
			   
			    <cfif month(ldte) gte 10>
					<cfset TraPer = "#year(ldte)##month(ldte)#">
				<cfelse>
					<cfset TraPer = "#year(ldte)#0#month(ldte)#">
				</cfif>	
			   
			   '#TraPer#',			   
			   #ldte#,
			   '#ExchangeRate#',
			   '#Currency#',
			   '#AmountDebit#',
			   '#AmountCredit#',
			   '#ExchangeRateBase#',
			   '#AmountBaseDebit#',
			   '#AmountBaseCredit#',
			   <cfif OfficerUserId neq "">
				   '#OfficerUserId#',
				   '#OfficerLastName#',
				   '#OfficerFirstName#',
				   '#created#'
			   <cfelse>
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#',
				   getDate()
			   </cfif>
			   )
			   
			</cfif>
			   
			</cfquery>
		
		</cfloop>
				
		<!--- ----------------------------- --->		
		<!--- record the warehouse receipts --->
		<!--- ----------------------------- --->
		
		<cfif transactiontype eq "item" and warehouse neq "" and warehouseitemNo neq "">
						
			<cfquery name="Item" 
			   datasource="AppsLedger" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT *
			   FROM   Materials.dbo.Item I, 
			          Materials.dbo.ItemUoM U
			   WHERE  I.ItemNo = U.ItemNo
			   AND    I.ItemNo   = '#WarehouseItemNo#'
			   AND    U.UoM      = '#WarehouseItemUoM#'
			</cfquery>
			
			<cfif Item.ItemClass eq "Service">
			
			  <!--- no posting --->
			
			<cfelse>
			
					<cfif Item.recordcount eq "0">
					
						  	 <cf_alert message = "Problem Item/UoM does no longer exist">
							 <cfabort>
						 					
					<cfelse>
				    							
						<cfquery name="GLStock" 
						   datasource="AppsLedger" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   SELECT * 
						   FROM   Materials.dbo.Ref_CategoryGLedger 
						   WHERE  Area     = 'Stock'
						   AND    Category = '#Item.Category#'
						   AND    GLAccount IN (SELECT GLAccount 
						                       FROM Accounting.dbo.Ref_Account) 
						</cfquery>
						
						<cfif GLStock.recordcount eq "0">
						    
						  	 <cf_alert message = "-Stock- GL account for #Item.Category# does not exist">
							 <cfabort>
						
						</cfif>												
						
						<cfquery name="GLPrice" 
						   datasource="AppsLedger" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   SELECT * 
						   FROM   Materials.dbo.Ref_CategoryGLedger 
						   WHERE  Area     = 'PriceChange'
						   AND    Category = '#Item.Category#'
						   AND   GLAccount IN (SELECT GLAccount 
						                       FROM Accounting.dbo.Ref_Account)
						</cfquery>
						
						<cfif GLPrice.recordcount eq "0">
						    
						  	 <cf_alert message = "-Price change- GL account for #Item.Category# does not exist">
							 <cfabort>
						
						</cfif>		
						
						<cfquery name="GLReceipt" 
						   datasource="AppsLedger" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   SELECT * 
						   FROM   Materials.dbo.Ref_CategoryGLedger 
						   WHERE  Area     = 'Receipt'
						   AND    Category = '#Item.Category#'
						    AND   GLAccount IN (SELECT GLAccount 
						                       FROM Accounting.dbo.Ref_Account)
						</cfquery>
						
						<cfif GLReceipt.recordcount eq "0">
						    
						  	 <cf_alert message = "-Receipt- GL account for #Item.Category# does not exist">
							 <cfabort>
						
						</cfif>					
											
						<!--- register a stock and GL transaction --->						
						<cfif amountDebit gt 0>
							<cfset price = AmountDebit/WarehouseQuantity>		
						<cfelse>
						    <cfset price = AmountCredit/WarehouseQuantity>
						</cfif>	
						
						<!--- the transaction valuation is in principle the curr/
						                                     price you paid --->		
						<cfset curr  = currency>			
						<cfset cost  = price>
												
						<!--- apply a different cost price in case of warehouse items --->
						
						<!--- Item.ItemClass eq "Supply --->
																		
						<cfif Item.ValuationCode eq "Manual">	
						    <!--- activate only the standard costing here --->	
							<cfset curr = APPLICATION.BaseCurrency>				
							<cfset cost = Item.StandardCost>	
																																									
						</cfif>	
																	
						<cf_StockTransact 
				            DataSource          = "AppsLedger" 
				            TransactionType     = "1"
							TransactionSource   = "AccountSeries"
							ItemNo              = "#WarehouseItemNo#" 
							Warehouse           = "#Warehouse#" 
							Mission             = "#Mission#"
							TransactionUoM      = "#WarehouseItemUoM#"
							TransactionCategory = "Receipt"
							TransactionCurrency = "#curr#"
							TransactionCostPrice= "#cost#"							
							TransactionQuantity = "#WarehouseQuantity#"
							TransactionDate     = "#dateFormat(now(), CLIENT.DateFormatShow)#"
							ReceiptId           = "#TransactionLineId#"
							ReceiptCostPrice    = "#cost#"
							ReceiptCurrency     = "#currency#"
							ReceiptPrice        = "#price#"
							ReferenceId         = "#TransactionLineId#"							
							Remarks             = "Receipt"
							GLTransactionNo     = "#TraNo#"
							GLCurrency          = "#Currency#"
							GLAccountDebit      = "#GLStock.GLAccount#"
							GLAccountDiff       = "#GLPrice.GLAccount#"
							GLAccountCredit     = "#GLReceipt.GLAccount#">
							
					</cfif>		
					
				</cfif>	
					
		</cfif>
		
		
		<!--- 03/10/2008 
		if the transaction header is driven by parent transaction as part of distribution trigger, 
		make always sure the created lines lines also have the parent --->
		
		<cfif HeaderSelect.ParentJournal neq "">
		
		 	<cfquery name="DefineResult" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    UPDATE TransactionLine
				SET    ParentJournal         = '#HeaderSelect.ParentJournal#',
				       ParentJournalSerialNo = '#HeaderSelect.ParentJournalSerialNo#',
					   ParentTransactionId   = '#HeaderSelect.ParentTransactionId#'			
				WHERE  TransactionLineId     = '#TransactionLineId#'	
				<!--- added condition to prevent overwrite if the parent alreadyy exists --->
				AND    ParentJournal is NULL    
			</cfquery>   
				
		</cfif>		
				
		<!--- part of edit transaction --->
	
		<cfif ParentJournal neq ""> 
			
			<!--- update outstanding --->
			
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
			
		</cfif>
	
	</cfoutput>
	
	<!--- define the correct matching balance --->
		
	<cfif matching eq "1">
				
		<cfquery name="SelectLines" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT  max(GLAccount) as GLAccount,
			        sum(AmountDebit-AmountCredit) as Total 
			FROM    TransactionLine
			WHERE   Journal          = '#HeaderSelect.Journal#'		    
			AND     JournalSerialNo  = '#journo#'   
			AND     TransactionSerialNo = 0 
			<!--- this is the transaction base --->
		</cfquery> 
		
		<cfif SelectLines.Total neq "">  
		
			<cfquery name="Associated" 
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    SELECT sum((AmountCredit*ExchangeRate)-(AmountDebit*ExchangeRate)) as Total 
				FROM   TransactionLine
				WHERE  ParentJournal          = '#HeaderSelect.Journal#'		    
				AND    ParentJournalSerialNo  = '#journo#'   
				AND    GLAccount = '#SelectLines.GLAccount#'			
				<!--- this is the transaction base --->
			</cfquery>   
			
			<cfif SelectLines.total gte 0>
			
			    <cfif Associated.total eq "">
					<cfset out = SelectLines.total>
				<cfelse>
					<cfset out = SelectLines.total - Associated.Total>
				</cfif>
			
			<cfelse>
			
				<cfif Associated.total eq "">
					<cfset out = SelectLines.total*-1>
				<cfelse>
					<cfset out = (SelectLines.total*-1) + Associated.Total>
				</cfif>
			
			</cfif>
			
			<cfif out lte -1>
			   <script language="JavaScript">
			    alert("Problem, your new balance would run below 0, this is not allowed!")
			   </script>
			   <cfabort>
			</cfif>
			
			<cfquery name="Update" 
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    UPDATE TransactionHeader
				SET    AmountOutstanding   = ROUND(#out#,2)
				WHERE  Journal             = '#HeaderSelect.Journal#'		    
				AND    JournalSerialNo     = '#journo#'   			
			</cfquery>  	
					
			<!--- safe guard only --->
							
			<cfquery name="Outstanding" 
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    UPDATE TransactionHeader 
			    SET    AmountOutstanding = 0		   
			    WHERE  Journal         = '#HeaderSelect.Journal#'
				AND    JournalSerialNo = '#journo#'   
				AND    AmountOutstanding > -0.05 and AmountOutstanding < 0.05 
			</cfquery>	
			
		</cfif>	
			
	</cfif>  

