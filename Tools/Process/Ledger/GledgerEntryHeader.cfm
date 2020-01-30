
<cfparam name="Attributes.DataSource"               default="AppsLedger">
<cfparam name="Attributes.Journal"                  default="">

<cfparam name="Attributes.OrgUnitOwner"             default="0">
<cfparam name="Attributes.OrgUnitTax"               default="0">
<cfparam name="Attributes.AccountPeriod"            default="">
<cfparam name="Attributes.JournalBatchNo"           default="">
<cfparam name="Attributes.Description"              default="">
<cfparam name="Attributes.TransactionBatchNo"       default="">
<cfparam name="Attributes.ReferenceOrgUnit"         default="">
<cfparam name="Attributes.ReferencePersonNo"        default="">
<cfparam name="Attributes.Reference"                default="">
<cfparam name="Attributes.Reference"                default="">
<cfparam name="Attributes.ReferenceId"              default="">
<cfparam name="Attributes.ReferenceName"            default="">
<cfparam name="Attributes.ReferenceNo"              default="">
<cfparam name="Attributes.ActionId"                 default="">
<cfparam name="Attributes.ActionStatus"             default="0">
<cfparam name="Attributes.ActionCode"               default="">

<!--- refers to when the action was posted for finacial purposes --->
<cfparam name="Attributes.TransactionDate"          default="#DateFormat(now(), CLIENT.DateFormatShow)#">

<cfset dateValue = "">
<CF_DateConvert Value="#Attributes.TransactionDate#">
<cfset dte = dateValue>

	
<!--- TransactionPeriod was added 14/3/2015 and default to the year/month of the transaction date --->
	
<cfif month(dte) gte "10">
	<cfset TransactionPeriod = "#year(dte)##month(dte)#">
<cfelse>
	<cfset TransactionPeriod = "#year(dte)#0#month(dte)#">
</cfif>	

<cfparam name="Attributes.TransactionPeriod"        default="#TransactionPeriod#">

<cfparam name="Attributes.JournalTransactionNo"     default="">
<cfparam name="Attributes.JournalBatchDate"         default="">

<cfparam name="Attributes.TransactionSource"        default="AccountSeries">
<cfparam name="Attributes.TransactionSourceNo"      default="">
<cfparam name="Attributes.TransactionSourceId"      default="">
<cfparam name="Attributes.TransactionCategory"      default="">
<cfparam name="Attributes.MatchingRequired"         default="0">
<cfparam name="Attributes.ActionBefore"             default="">
<cfparam name="Attributes.ActionTerms"              default="">
<cfparam name="Attributes.ActionDescription"        default="">
<cfparam name="Attributes.ActionDiscountDays"       default="">
<cfparam name="Attributes.ActionDiscount"           default="">
<cfparam name="Attributes.ActionDiscountDate"       default="">

<!--- refers to when the action occurred orignally --->
<cfparam name="Attributes.DocumentDate"             default="">
<cfparam name="Attributes.DocumentCurrency"         default="">
<cfparam name="Attributes.CurrencyDate"             default="#DateFormat(now(), CLIENT.DateFormatShow)#">
<cfparam name="Attributes.DocumentAmount"           default="0">
<cfparam name="Attributes.DocumentAmountVerbal"     default="0">
<cfparam name="Attributes.Workflow"                 default="No">
<cfparam name="Attributes.EntityClass"              default="">
<cfparam name="Attributes.OfficerUserId"            default="#SESSION.acc#">
<cfparam name="Attributes.OfficerlastName"          default="#SESSION.last#">
<cfparam name="Attributes.OfficerFirstName"         default="#SESSION.first#">

<!--- convert to journal currency --->

<cf_verifyOperational 
         datasource= "#Attributes.DataSource#"
         module    = "Accounting" 
		 Warning   = "No">
		 
<cfif Operational eq "1"> 
	
	<cfquery name="Journal" 
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT    *
		FROM      Accounting.dbo.Journal
		WHERE     Journal     = '#Attributes.Journal#'
	</cfquery>
	
	<cfif Journal.recordcount eq "0">
						
		<cf_waitEnd> 
							
		<cf_message message = "Journal (#Attributes.Journal#) can not be determined or is closed. Operation not allowed."
				  return = "no">
		<cfabort>
	  
	<cfelse>
	
		<cfif attributes.JournalBatchNo eq "" and Journal.JournalBatchNo neq "">
			
			<cfset attributes.JournalBatchNo = Journal.JournalBatchNo>
		
		</cfif>
	
	</cfif>
	
	<cfset accountPeriod = attributes.AccountPeriod>
	
	<cfif accountperiod eq "">
	
		<cfquery name="Mission" 
		    datasource="#Attributes.DataSource#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT    *
			FROM      Organization.dbo.Ref_MissionPeriod
			WHERE     Mission = '#Journal.Mission#' 	
			AND       AccountPeriod is not NULL
			ORDER BY  DefaultPeriod DESC 
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
		   		
	<cfif AccountPeriod eq "">				
									
		<cf_message 
		  message = "A Fiscal accounting period (<cfoutput>#Journal.Mission#</cfoutput>) could not be determined for this transaction.<br>Operation not allowed."
		  return = "back">
		  
		<cfabort>
	  
	</cfif> 
	
	<!--- 9/2/2017 rechecked - prevent a transactionperiod lower than the fiscal year start --->
		
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
	
	<cfif attributes.transactionPeriod lt mintraper>
	
		<cfset attributes.transactionPeriod = mintraper>
	
	</cfif>

	<cfif Period.ActionStatus is "1">
	
		<cfquery name="Period" 
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT    TOP 1 *
			FROM      Accounting.dbo.Period
			WHERE     PeriodDateStart > (SELECT PeriodDateStart FROM Accounting.dbo.Period WHERE AccountPeriod = '#AccountPeriod#') 	
			AND       ActionStatus = 0
			ORDER BY  PeriodDateStart
		</cfquery>
		
		<cfif Period.recordcount gte "1">
		
			<cfset accountPeriod = Period.AccountPeriod>
		
		<cfelse>
									
			<!--- consider automatically take the next period --->
								
			<cf_message 
			  message = "Fiscal Period [#AccountPeriod#] is closed. Operation not allowed."
			  return = "back">
			<cfabort>
		
		</cfif>
	  
	</cfif>  
	
	<cfif Attributes.TransactionCategory eq "">
	  <cfset Attributes.TransactionCategory = "#Journal.TransactionCategory#">
	</cfif>
	
	<cfparam name="Attributes.DocumentAmount"           default="0">
	
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
			
	<cfquery name="DocumentCurr" 
	     datasource="#Attributes.DataSource#" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT   TOP 1 *
	     FROM     Accounting.dbo.CurrencyExchange
		 WHERE    Currency = '#Attributes.DocumentCurrency#' 
		 AND      EffectiveDate <= #cdt#
		 ORDER BY EffectiveDate DESC
	</cfquery>
			   		
	<cfif JournalCurr.recordcount eq "0" or DocumentCurr.recordcount eq "0">
								
		<cf_message 
		  message = "Exchange rate for #Attributes.DocumentCurrency# #Attributes.DocumentCurrency# was not recorded. Operation not allowed."
		  return = "back">
		<cfabort>
	  
	</cfif>  
		
	<cfset exc  = DocumentCurr.ExchangeRate/JournalCurr.ExchangeRate>	
	<cfset amt  = Attributes.DocumentAmount/exc>
	<cfset amt  = round(amt*100)/100>
	<cfset amtB = Attributes.DocumentAmount/DocumentCurr.ExchangeRate>
	<cfset amtB = round(amtB*100)/100>
	
	<cfparam name="Attributes.Amount"                   default="#amt#">
	<cfparam name="Attributes.AmountOutstanding"        default="#Attributes.Amount#">
		
	<cfset dateValue = "">
	<cfif Attributes.JournalBatchDate neq ''>
	   <CF_DateConvert Value="#Attributes.JournalBatchDate#">
	   <cfset jbd = dateValue>
	<cfelse>
	   <cfset jbd = 'NULL'>
	</cfif>   
	
	<cfset dateValue = "">
	<cfif Attributes.ActionBefore neq ''>
	   <CF_DateConvert Value="#Attributes.ActionBefore#">
	   <cfset dtebefore = dateValue>
	<cfelse>
	   <cfset dtebefore = 'NULL'>
	</cfif>   
	
	<cfset dateValue = "">
	<cfif #Attributes.ActionDiscountDate# neq ''>
	   <CF_DateConvert Value="#Attributes.ActionDiscountDate#">
	   <cfset dtediscount = dateValue>
	<cfelse>
	   <cfset dtediscount = 'NULL'>
	</cfif>   
	
	<cfset dateValue = "">
	<cfif Attributes.DocumentDate neq ''>
	   <CF_DateConvert Value="#Attributes.DocumentDate#">
	   <cfset dtedoc = dateValue>
	<cfelse>
	   <cfset dtedoc = 'NULL'>
	</cfif>    
	
	<!--- generate a journal serialNo --->
	
	<cfquery name="Set" 
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    UPDATE Accounting.dbo.Journal 
	    SET    JournalSerialNo = (JournalSerialNo + 1.0)
	    WHERE (Journal = '#Attributes.Journal#') 
	   </cfquery>
	
	   <cfquery name="Get" 
	   datasource="#Attributes.DataSource#" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT * 
		   FROM Accounting.dbo.Journal J
		   WHERE (Journal = '#Attributes.Journal#')
	   </cfquery>  	   
	   
	   <cfset JourNo = Get.JournalSerialNo>
	   
	   <!--- check existing --->
	   
	   <cfquery name="Check" 
	   datasource="#Attributes.DataSource#" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   Accounting.dbo.TransactionHeader
		   WHERE  Journal         = '#Attributes.Journal#'
		   AND    JournalSerialNo = '#journo#'
	   </cfquery>
	   
	   <cfif check.recordcount gte "1">
	   
		   	<cfquery name="Check" 
			   datasource="#Attributes.DataSource#" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				   SELECT TOP 1 * 
				   FROM Accounting.dbo.TransactionHeader
				   WHERE Journal = '#Attributes.Journal#'
				   ORDER BY JournalSerialNo DESC
			</cfquery>
	   
	   	    <cfset JourNo = Check.JournalSerialNo+1>
			
			<cfquery name="Set" 
			    datasource="#Attributes.DataSource#" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    UPDATE   Accounting.dbo.Journal 
			    SET      JournalSerialNo = '#Check.JournalSerialNo#'
			    WHERE    Journal = '#Attributes.Journal#' 
			</cfquery>
			  
	   </cfif>
	      
	   <cfif Attributes.JournalTransactionNo eq "">
	     <cfset Attributes.JournalTransactionNo = "#Get.Journal#-#Get.JournalSerialNo#">
	   </cfif>
	   
		<!--- generate a header record --->
		
		<cfif len(Attributes.Description) gt "300">
		    <cfset des = left(Attributes.Description,  300)>
		<cfelse>
		    <cfset des = Attributes.Description> 
		</cfif>
		
		<cfif len(Attributes.ReferenceName) gt "80">
		    <cfset rn = left(Attributes.ReferenceName,  80)>
		<cfelse>
		    <cfset rn = Attributes.ReferenceName> 
		</cfif>
		
		<cf_assignid>
		
		<cfif attributes.documentAmountVerbal eq "1">	
				<cfset amount = replace(attributes.documentamount,",","","ALL")>		
				<cf_numbertotext amount="#amount#">
		</cfif>					
		
		<cfquery name="InsertHeader" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO  Accounting.dbo.TransactionHeader  
		   	 ( TransactionId,
			   Journal, 
			   JournalSerialNo,		  
			   Mission,
			   OrgUnitOwner,
			   OrgUnitTax,
			   <cfif Attributes.ReferenceOrgUnit neq "">
			   ReferenceOrgUnit,
			   </cfif>
			   <cfif Attributes.ReferencePersonNo neq "">
			   ReferencePersonNo,
			   </cfif>
			   JournalTransactionNo, 		   
			   <cfif Attributes.JournalBatchNo neq "" and Attributes.journalBatchNo neq "0">
			   JournalBatchNo,
			   </cfif>
			   <cfif Attributes.JournalBatchDate neq "">
			   JournalBatchDate,
			   </cfif>
			   Description,
			   TransactionSource,
			   TransactionSourceNo,
			   <cfif Attributes.TransactionSourceId neq "">
			   TransactionSourceId,
			   </cfif>		   
			   TransactionDate,
			   TransactionPeriod,
			   AccountPeriod,
			   TransactionCategory,
			   Reference,
			   ReferenceName,
			   ReferenceNo,
			   <cfif attributes.referenceId neq "">
			   ReferenceId,
			   </cfif>
			   <cfif attributes.actionId neq "">
			   ActionId,
			   </cfif>
			   ActionStatus,
			   ActionBefore,
			   ActionTerms,
			   ActionDescription,
			   ActionDiscountDays,
			   ActionDiscount,
			   ActionDiscountDate,   
			   MatchingRequired,
			   DocumentDate,
			   DocumentCurrency,
			   DocumentAmount,
			   <cfif attributes.documentAmountVerbal eq "1">	
			   DocumentAmountVerbal,
			   </cfif>
			   ExchangeRate,
			   Currency,
			   Amount,
			   <cfif Attributes.MatchingRequired neq "0">
			   AmountOutstanding,
			   </cfif>
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName,
			   Created)
		VALUES 
			   ('#rowguid#',
			   '#Attributes.Journal#',
			   '#JourNo#',		  
			   '#Attributes.Mission#',
			   '#Attributes.OrgUnitOwner#',
			   '#Attributes.OrgUnitTax#',
			   <cfif Attributes.ReferenceOrgUnit neq "">
			   '#Attributes.ReferenceOrgUnit#',
			   </cfif>
			    <cfif Attributes.ReferencePersonNo neq "">
			   '#Attributes.ReferencePersonNo#',
			   </cfif>
			   '#Attributes.JournalTransactionNo#',
			   <cfif Attributes.JournalBatchNo neq "" and Attributes.journalBatchNo neq "0">
			   '#Attributes.JournalBatchNo#',
			   </cfif>
			   <cfif Attributes.JournalBatchDate neq "">
			   #jbd#,
			   </cfif>
			   '#des#',
			   '#Attributes.TransactionSource#',
			   '#Attributes.TransactionSourceNo#',
			   <cfif Attributes.TransactionSourceId neq "">
			   '#Attributes.TransactionSourceId#',
			   </cfif>
			   #dte#,
			   '#attributes.TransactionPeriod#',
			   '#AccountPeriod#',
			   '#Attributes.TransactionCategory#',
			   '#Attributes.Reference#',
			   '#rn#',
			   '#Attributes.ReferenceNo#',
			   <cfif attributes.referenceId neq "">
			   '#Attributes.ReferenceId#',
			   </cfif>
			   <cfif attributes.actionId neq "">
			   '#Attributes.ActionId#',
			   </cfif>
			   <cfif attributes.workflow eq "Yes">
			   '0',
			   <cfelse>
			   '#Attributes.ActionStatus#',
			   </cfif>
			   #dtebefore#,
			   '#Attributes.ActionTerms#',
			   '#Attributes.ActionDescription#',
			   '#Attributes.ActionDiscountDays#',
			   '#Attributes.ActionDiscount#',
			   #dtediscount#, 		
			   #Attributes.MatchingRequired#,
			   #dtedoc#,
			   '#Attributes.DocumentCurrency#',
			   '#Attributes.DocumentAmount#',
			   <cfif attributes.documentAmountVerbal eq "1">			   
			   '#textamount#',
			   </cfif>
			   '#exc#',
			   '#Journal.Currency#',
			   '#Attributes.Amount#',
			   <cfif Attributes.MatchingRequired neq "0">
			   '#Attributes.AmountOutstanding#',
			   </cfif>
			   '#attributes.officerUserId#',
			   '#attributes.officerLastName#',
			   '#attributes.officerFirstName#',
			    getDate())
		</cfquery>
		
		<!--- create the action for invoice to be saved --->
		
		<cfif attributes.actionCode neq "">
		
				<cfparam name="Attributes.ActionReference1" default="">
				<cfparam name="Attributes.ActionReference2" default="">
				<cfparam name="Attributes.ActionReference3" default="">
				<cfparam name="Attributes.ActionReference4" default="">
		
				<cfquery name="InsertHeader" 
				datasource="#Attributes.DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO  Accounting.dbo.TransactionHeaderAction  
						    ( Journal, 
							  JournalSerialNo,		
							  ActionCode,							  
							  ActionReference1,
							  ActionReference2,
							  ActionReference3,
							  ActionReference4,
							  ActionDate,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName )
					VALUES  ( '#Attributes.Journal#',
						      '#JourNo#',		
							  '#attributes.actionCode#',
							  '#Attributes.ActionReference1#',
							  '#Attributes.ActionReference2#',
							  '#Attributes.ActionReference3#',
							  '#Attributes.ActionReference4#',
							  getDate(),
							  '#attributes.officerUserId#',
						      '#attributes.officerLastName#',
						      '#attributes.officerFirstName#' )	   
				</cfquery>		
				
		</cfif>
		
		<!--- record relator actors, like the sales person here to grant the person access --->
		
		<cfparam name="Attributes.ActorRole" default="">
		
		<cfif attributes.actorRole neq "">	
		
			<cfparam name="Attributes.ActorPersonNo" default="">
						
				<cfquery name="InsertActor" 
				datasource="#Attributes.DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO  Accounting.dbo.TransactionHeaderActor  
						    ( Journal, 
							  JournalSerialNo,		
							  Role,							  
							  PersonNo,							 
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName )
					VALUES  ( '#Attributes.Journal#',
						      '#JourNo#',		
							  '#attributes.ActorRole#',
							  '#attributes.ActorPersonNo#',
							  '#attributes.officerUserId#',
						      '#attributes.officerLastName#',
						      '#attributes.officerFirstName#' )	   
				</cfquery>				
		
		</cfif>
		
		<cfif attributes.workflow eq "Yes">
		
		    <!--- generate a workflow --->
									
			<cfset link = "Gledger/Application/Transaction/View/TransactionViewDetail.cfm?id=#rowguid#">
				 
			<cfquery name="Transaction" 
				datasource="#Attributes.DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM    Accounting.dbo.TransactionHeader
				WHERE   TransactionId = '#rowguid#'
			</cfquery>
			   
			<cfquery name="Jrn" 
				datasource="#Attributes.DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM    Accounting.dbo.Journal
				WHERE   Journal = '#Transaction.Journal#'
			</cfquery>
			
			<cfif attributes.entityclass neq "">
				<cfset ecl = attributes.entityclass>
			<cfelse>
			    <cfset ecl = jrn.entityclass> 
			</cfif>
			  
			<cfif Transaction.OrgUnitOwner eq "0">			   
			      <cfset org = "">			   
			<cfelse>			   
			      <cfset org = Transaction.OrgUnitOwner>				  
			</cfif>
			
			
			<cf_ActionListing 
			    TableWidth       = "100%"
				Datasource       = "#Attributes.DataSource#"
			    EntityCode       = "GLTransaction"
				EntityClass      = "#ecl#"
				EntityGroup      = ""  <!--- to be configured --->	
				CompleteFirst    = "Yes"
				Mission          = "#Transaction.Mission#"
				OrgUnit          = "#org#"
				AjaxId           = "#rowguid#"
				ObjectReference  = "#Jrn.Description#"
				ObjectReference2 = "#Transaction.Description# : #Transaction.JournalTransactionNo#"
				ObjectKey4       = "#rowguid#"
			  	ObjectURL        = "#link#"
				Show             = "No"
				DocumentStatus   = "#Transaction.ActionStatus#">
				
		</cfif>
		
		<CFSET Caller.JournalTransactionNo = JourNo>
		<CFSET Caller.JournalSerialNo      = JourNo>	
		<CFSET Caller.JournalTransactionId = rowguid>		
	
</cfif>	
