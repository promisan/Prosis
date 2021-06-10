
<cfparam name="Attributes.DataSource"               default="AppsLedger">

<cfquery name="Journal" 
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT    *
		FROM      Accounting.dbo.Journal
		WHERE     Journal     = '#Attributes.Journal#' 
	</cfquery>

<cfparam name="Attributes.TransactionDate"          default="#DateFormat(now(), CLIENT.DateFormatShow)#">
<cfparam name="Attributes.TransactionPeriod"        default="">
<cfparam name="Attributes.CurrencyDate"             default="#DateFormat(now(), CLIENT.DateFormatShow)#">
<cfparam name="Attributes.Journal"                  default="">
<cfparam name="Attributes.JournalTransactionNo"     default="">
<cfparam name="Attributes.Currency"                 default="#Journal.Currency#">
<cfparam name="Attributes.AmountCurrency"           default="#Attributes.currency#">

<cfparam name="Attributes.ExchangeRate"             default="">
<cfparam name="Attributes.BaseExchangeRate"         default="">
<cfparam name="Attributes.AccountPeriod"            default="">
<cfparam name="Attributes.ParentJournal"            default="">
<cfparam name="Attributes.ParentJournalSerialNo"    default="">
<cfparam name="Attributes.ParentLineId"             default="">
<cfparam name="Attributes.LogTransaction"           default="Yes">

<cfif attributes.ParentJournal neq "">
	
	<cfquery name="get" 
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT    *
		FROM      Accounting.dbo.TransactionHeader
		WHERE     Journal         = '#Attributes.ParentJournal#' 
		AND       JournalSerialNo = '#Attributes.ParentJournalSerialNo#' 
	</cfquery>
	
	<cfparam name="Attributes.ParentTransactionId"      default="#get.TransactionId#">

</cfif>

<cfparam name="Attributes.ParentTransactionId"      default="">
<cfparam name="Attributes.DocumentCurrency"         default="#attributes.currency#">

<cf_verifyOperational 
         datasource= "#Attributes.DataSource#"
         module    = "Accounting" 
		 Warning   = "No">
		 
<cfif Operational eq "1"> 
	
	<!--- convert to journal currency --->
	
	<cfquery name="Journal" 
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT    *
		FROM      Accounting.dbo.Journal
		WHERE     Journal     = '#Attributes.Journal#' 
	</cfquery>
	
	<cfset accountPeriod = attributes.AccountPeriod>
	
	<cfif accountperiod eq "">
	
		<cfquery name="Mission" 
		    datasource="#Attributes.DataSource#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT    *
			FROM      Organization.dbo.Ref_MissionPeriod
			WHERE     Mission = '#Journal.Mission#' 	
			ORDER BY DefaultPeriod DESC 
		</cfquery>
		
		<cfset AccountPeriod = Mission.AccountPeriod>
		
	</cfif>	
	
	<cfquery name="Period" 
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT    *
		FROM      Accounting.dbo.Period
		WHERE     AccountPeriod    = '#AccountPeriod#' 	
	</cfquery>
		 		
	<cfif Period.actionstatus eq "1">
	
		<!--- we take default --->
		
		<cfquery name="Parameter" 
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT    *
		    FROM      Accounting.dbo.Ref_ParameterMission
			WHERE     Mission = '#Journal.Mission#'
		</cfquery>	
		
		<cfset AccountPeriod = parameter.CurrentAccountPeriod>
		
		<cfquery name="Period" 
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT    *
			FROM      Accounting.dbo.Period
			WHERE     AccountPeriod    = '#AccountPeriod#' 	
	    </cfquery>
		
	</cfif>
		   		
	<cfif AccountPeriod eq "" or Period.ActionStatus is "1">			
							
		<cf_message  message = "GL Accounting Period can not be determined or is closed (#attributes.Journal#-#AccountPeriod#). Operation not allowed."
		  return = "back">
		<cfabort>
	  
	</cfif>  
	
	<CF_DateConvert Value="#Attributes.CurrencyDate#">
	<cfset cdt = dateValue>
		
	<cfquery name="JournalCurr" 
	     datasource="#Attributes.DataSource#" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT   TOP 1 *
	     FROM     Accounting.dbo.CurrencyExchange
	     WHERE    Currency = '#Journal.Currency#'
	     AND      EffectiveDate <= #cdt#
	     ORDER BY EffectiveDate DESC
	</cfquery>
	
	<cfif attributes.amountCurrency neq attributes.currency>
							
		<cfquery name="DocumentCurr" 
		     datasource="#Attributes.DataSource#" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   TOP 1 *
		     FROM     Accounting.dbo.CurrencyExchange
			 WHERE    Currency  = '#Attributes.AmountCurrency#'
			  AND     EffectiveDate <= #cdt#
			 ORDER BY EffectiveDate DESC
		</cfquery>
	
	<cfelse>
	
		<cfquery name="DocumentCurr" 
		     datasource="#Attributes.DataSource#" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   TOP 1 *
		     FROM     Accounting.dbo.CurrencyExchange
			 WHERE    Currency  = '#Attributes.Currency#'
			  AND     EffectiveDate <= #cdt#
			 ORDER BY EffectiveDate DESC
		</cfquery>
	
	</cfif>
	   		
	<cfif JournalCurr.recordcount eq "0" or DocumentCurr.recordcount eq "0">
									
		<cf_message message = "Exchange rate has not been recorded. Operation not allowed."
		  return = "back">
		<cfabort>
	  
	</cfif>  
	
	<cfif attributes.exchangeRate eq "">	
		<cfset exc = DocumentCurr.ExchangeRate/JournalCurr.ExchangeRate>
	<cfelse>
		<cfset exc = attributes.exchangeRate>
	</cfif>	
		
	<cfset dateValue = "">
	
	<CF_DateConvert Value="#Attributes.TransactionDate#">	
	<cfset dte = dateValue>
		
	<cfif month(dte) gte "10">
		<cfset TransactionPeriod = "#year(dte)##month(dte)#">
	<cfelse>
		<cfset TransactionPeriod = "#year(dte)#0#month(dte)#">
	</cfif>	
	
	<cfif attributes.transactionPeriod neq "">
		<cfset transactionPeriod = attributes.TransactionPeriod>	
	</cfif>
	
	<!--- prevent a transactionperiod lower than the fiscal year start --->
		
	<cfquery name="Period" 
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		  SELECT    *
		  FROM      Accounting.dbo.Period
		  WHERE     AccountPeriod    = '#AccountPeriod#' 	
	</cfquery>
		
	<cfif month(Period.PeriodDateStart) gte "10">
		<cfset  mintraper = "#year(Period.PeriodDateStart)##month(Period.PeriodDateStart)#">
	<cfelse>
		<cfset  mintraper = "#year(Period.PeriodDateStart)#0#month(Period.PeriodDateStart)#">
	</cfif>	
	
	<cfif transactionPeriod lt mintraper>
	
		<cfset transactionPeriod = mintraper>
	
	</cfif>
		
	<!--- general ledger transaction lines --->
	
		<cfloop index="Ln" from="1" to="#Attributes.Lines#" step="1">
	  
	    <cfset serialNo          =  evaluate("Attributes.TransactionSerialNo#Ln#")>

	    <cfparam name="Attributes.warehouseItemNo#Ln#" default="0000">
	    <cfset warehouseItemNo          =  evaluate("Attributes.warehouseItemNo#Ln#")>
				
		<cfif Attributes.JournalTransactionNo eq "">
		   <cfset JournalTransactionNo = "#attributes.Journal#-#attributes.JournalNo#">
		<cfelse>
		   <cfset JournalTransactionNo = "#attributes.JournalTransactionNo#"> 
		</cfif>
		
		<cfparam name="Attributes.GlAccount#Ln#" default="">
		<cfset glaccount         =  evaluate("Attributes.GLAccount#Ln#")>
		<cfset class             =  evaluate("Attributes.Class#Ln#")>
		<cfset amount            =  evaluate("Attributes.Amount#Ln#")>
		
		
		<cfparam name="Attributes.TransactionAmount#Ln#" default="#amount#">
		<cfset transactionamount =  evaluate("Attributes.TransactionAmount#Ln#")>
				
		<cfparam name="Attributes.TransactionTaxCode#Ln#" default="00">
		<cfset taxcode    =  evaluate("Attributes.TransactionTaxCode#Ln#")>
				
		<cfset transactiontype   =  evaluate("Attributes.TransactionType#Ln#")>
		
		<cfparam name="Attributes.Description#Ln#" default="">
		<cfset description       =  evaluate("Attributes.Description"&#Ln#)>
			
		<cfif len(Description) gt "200">
		 	<cfset des = left(Description,  200)>
		<cfelse>
			<cfset des = Description> 
		</cfif>
				
		<!--- optional --->
		<cfparam name="Attributes.Fund#Ln#" default="">
		<cfset fund               =  evaluate("Attributes.Fund"&#Ln#)>
		<cfparam name="Attributes.ObjectCode#Ln#" default="">
		<cfset object             =  evaluate("Attributes.ObjectCode"&#Ln#)>
		<cfparam name="Attributes.CostCenter#Ln#" default="">
		<cfset orgunit            =  evaluate("Attributes.CostCenter"&#Ln#)>
		<cfparam name="Attributes.ProgramCode#Ln#" default="">
		<cfset ProgramCode        =  evaluate("Attributes.ProgramCode"&#Ln#)>
		<cfparam name="Attributes.ActivityId#Ln#" default="">
		<cfset ActivityId         =  evaluate("Attributes.ActivityId"&#Ln#)>
		
		<cfparam name="Attributes.ContributionLineId#Ln#" default="">
		<cfset ContributionLineId =  evaluate("Attributes.ContributionLineId"&#Ln#)>
		
		<cfparam name="Attributes.WorkOrderLineId#Ln#" default="">
		<cfset WorkOrderLineId =  evaluate("Attributes.WorkOrderLineId"&#Ln#)>
		
		<cfparam name="Attributes.ProgramPeriod#Ln#" default="">
		<cfset ProgramPeriod      =  evaluate("Attributes.ProgramPeriod"&#Ln#)>
		<cfparam name="Attributes.Reference#Ln#" default="">
		<cfset reference          =  evaluate("Attributes.Reference"&#Ln#)>
		<cfparam name="Attributes.ReferenceQuantity#Ln#" default="">
		<cfset referenceQuantity  =  evaluate("Attributes.ReferenceQuantity"&#Ln#)>
		<cfparam name="Attributes.ReferenceName#Ln#" default="">
		<cfset referenceName      =  evaluate("Attributes.ReferenceName"&#Ln#)>
			
		<cfif len(ReferenceName) gt "100">
		 <cfset rn = left(ReferenceName,  100)>
		<cfelse>
		 <cfset rn = ReferenceName> 
		</cfif>
		
		<cfparam name="Attributes.ReferenceNo#Ln#" default="">
		<cfset referenceNo      =  evaluate("Attributes.ReferenceNo"&#Ln#)>
		<cfparam name="Attributes.ReferenceId#Ln#" default="{00000000-0000-0000-0000-000000000000}">
		<cfset referenceId      =  evaluate("Attributes.ReferenceId"&#Ln#)>
		<cfparam name="Attributes.ReferenceIdParam#Ln#" default="">
		<cfset referenceIdParam =  evaluate("Attributes.ReferenceIdParam"&#Ln#)>
		
		<cfif attributes.BaseExchangeRate eq "">			    
		     <cfset bseexc = DocumentCurr.ExchangeRate>		 	
		<cfelse>		
			 <cfset bseexc = attributes.BaseExchangeRate>				
		</cfif>
			
		<cfif Amount neq "0" or serialNo eq "0">
		
			<cfif Class eq "Debit">
			
				<cfif Amount gte 0>
		
					 <cfset amtC   = 0>
					 <cfset amtCB  = 0>
					 <cfif attributes.amountCurrency neq attributes.currency>
						 <cfset amtD   = Amount/exc>
					 <cfelse>
					 	 <cfset amtD   = Amount>	 
					 </cfif>
					 <cfset amtD   = round(amtD*100)/100>
					 <cfset amtDB  = Amount/bseexc>
					 <cfset amtDB  = round(amtDB*1000)/1000>
				 
				<cfelse>
				
					 <cfset amtD   = 0>
					 <cfset amtDB  = 0>
					 <cfif attributes.amountCurrency neq attributes.currency>
						 <cfset amtC   = -Amount/exc>
					 <cfelse>
					     <cfset amtC   = -Amount>
					 </cfif>	 
					 <cfset amtC   = round(amtC*100)/100>
					 <cfset amtCB  = -Amount/bseexc>
					 <cfset amtCB  = round(amtCB*1000)/1000>				
				
				</cfif> 
			
			<cfelse>
			
				<cfif Amount gte 0>
			
				 <cfif attributes.amountCurrency neq attributes.currency>
					 <cfset amtC   = Amount/exc>
				 <cfelse>
				     <cfset amtC   = Amount>
				 </cfif>						 
				
				 <cfset amtC   = round(amtC*100)/100>
				 <cfset amtCB  = Amount/bseexc>
				 <cfset amtCB  = round(amtCB*1000)/1000>
				 <cfset amtD   = 0>
				 <cfset amtDB  = 0>
				 
				<cfelse>
				
				<cfif attributes.amountCurrency neq attributes.currency>
					 <cfset amtD   = -Amount/exc>
				<cfelse>
				 	 <cfset amtD   = -Amount>	 
				</cfif> 				
				
				 <cfset amtD   = round(amtD*100)/100>
				 <cfset amtDB  = -Amount/bseexc>
				 <cfset amtDB  = round(amtDB*1000)/1000>
				 <cfset amtC   = 0>
				 <cfset amtCB  = 0>
				
				</cfif> 
			
			</cfif>		
									
				<cfquery name="InsertLine" 
				    datasource="#Attributes.DataSource#" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
								
				    INSERT INTO  Accounting.dbo.TransactionLine (
					  Journal, 
				      JournalSerialNo,
				      TransactionSerialNo, 
					  <cfif attributes.parentlineId neq "">
					  ParentLineId,
					  </cfif>
				      JournalTransactionNo,
				      GLAccount,
				      Memo,
				      OrgUnit,
					  Fund,
					  ObjectCode,
					  ProgramCode,
					  ActivityId,
					  ProgramPeriod,				  
					  ContributionLineId,
					  WorkOrderLineId,
				      AccountPeriod,
				      TransactionType, 
					  TransactionPeriod,
					  TransactionDate,
					  TransactionCurrency,
					  TransactionAmount,
					  TransactionTaxCode,
				      Reference, 
					  ReferenceName,
					  ReferenceNo,
					  ReferenceQuantity,
					  warehouseItemNo,		
					  <cfif referenceid neq "">
					  	ReferenceId,
						<cfif referenceidparam neq "">
							ReferenceIdParam,
						</cfif>
					  </cfif>
					  ExchangeRate,
				      Currency,
				      AmountDebit,
				      AmountCredit,
				      ExchangeRateBase,
				      AmountBaseDebit,
				      AmountBaseCredit,
					  <cfif attributes.ParentJournal neq "">
						  ParentJournal,
						  ParentJournalSerialNo,
					  </cfif>
					  <cfif attributes.ParentTransactionId neq "">
						  ParentTransactionId,
					  </cfif>
				      OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
				   VALUES (
					  '#Attributes.Journal#',
				      '#Attributes.JournalNo#',
				      '#SerialNo#',
					  <cfif attributes.parentlineId neq "">
					  '#attributes.ParentLineId#',
					  </cfif>
				      '#JournalTransactionNo#',
				      '#GlAccount#',
				      '#des#',
				      '#OrgUnit#',
					  '#fund#',
					  '#object#',
					  '#ProgramCode#',
					  <cfif ActivityId eq "">
						  NULL,
					  <cfelse>
						  '#ActivityId#',
					  </cfif>
					  '#ProgramPeriod#',
					  <cfif contributionLineId eq "">
					  NULL,
					  <cfelse>
					  '#ContributionLineId#',
					  </cfif>
					  <cfif workorderlineid eq "">
					  NULL,
					  <cfelse>
					  '#WorkOrderLineId#',
					  </cfif>
				      '#AccountPeriod#',
				      '#TransactionType#',
					  '#TransactionPeriod#',
					  #dte#,
					  '#Attributes.DocumentCurrency#',
					  '#transactionamount#',
					  '#taxcode#',
				      '#Reference#',
					  '#rn#',
					  '#ReferenceNo#',
					  <cfif ReferenceQuantity neq "">
					  '#ReferenceQuantity#',
					  <cfelse>
					  NULL,
					  </cfif>
					  '#warehouseItemNo#',			
					  <cfif referenceid neq "">
					  	'#ReferenceId#',
						<cfif referenceidparam neq "">
							'#ReferenceIdParam#',
						</cfif>
					  </cfif>
					  '#exc#',
					  '#Journal.Currency#',
					  '#amtD#',
					  '#amtC#',
					  '#bseexc#',
				      '#amtDB#',
					  '#AmtCB#',
					  <cfif attributes.ParentJournal neq "">
						  '#attributes.ParentJournal#',
						  '#attributes.ParentJournalSerialNo#',
					  </cfif>
					  <cfif attributes.ParentTransactionId neq "">
						  '#attributes.ParentTransactionId#',
					  </cfif>
				      '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
				   </cfquery>
			   
			   <!--- -------------------------------------- --->
			   <!--- NEW - insert a archive logfile as well --->
			   <!--- -------------------------------------- --->
			   
			   <cfif attributes.LogTransaction eq "Yes">	
			   
				   <cfquery name="InsertLine" 
				    datasource="#Attributes.DataSource#" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    INSERT INTO  Accounting.dbo.TransactionLineLog
					
				      (LogAction,
					  Journal, 
				      JournalSerialNo,
				      TransactionSerialNo, 
					  <cfif attributes.parentlineId neq "">
					  ParentLineId,
					  </cfif>
				      JournalTransactionNo,
				      GLAccount,
				      Memo,
				      OrgUnit,
					  Fund,
					  ObjectCode,
					  ProgramCode,
					  ProgramPeriod,
					  ContributionLineId,
					  WorkOrderLineId,
				      AccountPeriod,				 
				      TransactionType, 
					  TransactionDate,
					  TransactionCurrency,
					  TransactionAmount,
				      Reference, 
					  ReferenceName,
					  ReferenceNo,		
					  ReferenceQuantity,	
					  <cfif referenceid neq "">
					  	ReferenceId,
						<cfif referenceidparam neq "">
							ReferenceIdParam,
						</cfif>
					  </cfif>
					  ExchangeRate,
				      Currency,
				      AmountDebit,
				      AmountCredit,
				      ExchangeRateBase,
				      AmountBaseDebit,
				      AmountBaseCredit,
				      OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
					  
				   VALUES (
					  'Insert',
					  '#Attributes.Journal#',
				      '#Attributes.JournalNo#',
				      '#SerialNo#',
					  <cfif attributes.parentlineId neq "">
					  '#attributes.ParentLineId#',
					  </cfif>
				      '#JournalTransactionNo#',
				      '#GlAccount#',
				      '#des#',
				      '#OrgUnit#',
					  '#Fund#',
					  '#Object#',
					  '#ProgramCode#',				  
					  '#ProgramPeriod#',				  
					  <cfif contributionLineId eq "">NULL,<cfelse>'#ContributionLineId#',</cfif>
					  <cfif workorderlineid eq "">NULL,<cfelse>'#WorkOrderLineId#',</cfif>
				      '#AccountPeriod#',
				      '#TransactionType#',
					  #dte#,
					  '#Attributes.DocumentCurrency#',
					  '#transactionamount#',
				      '#Reference#',
					  '#rn#',
					  '#ReferenceNo#',		
					   <cfif ReferenceQuantity neq "">
					  '#ReferenceQuantity#',
					  <cfelse>
					  NULL,
					  </cfif>
					  <cfif referenceid neq "">
					  	'#ReferenceId#',
						<cfif referenceidparam neq "">
							'#ReferenceIdParam#',
						</cfif>
					  </cfif>
					  '#exc#',
					  '#Journal.Currency#',
					  '#amtD#',
					  '#amtC#',
					  '#bseexc#',
				      '#amtDB#',
					  '#AmtCB#',
				      '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
					  
				   </cfquery>		   			   
			   
			   </cfif>
			   
		  </cfif>	   
			
		</cfloop>

</cfif>	
	