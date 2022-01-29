
<cfparam name="url.transactionid" default="">
<cfparam name="attributes.TransactionId"   default="#url.transactionid#">
<cfparam name="attributes.Journal"         default="">
<cfparam name="attributes.JournalSerialNo" default="">

<cfif attributes.TransactionId neq "">

	<cfquery name="get"
	   datasource="AppsLedger" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		     SELECT *
			 FROM   TransactionHeader
		     WHERE  TransactionId = '#attributes.TransactionId#'	  
	</cfquery>
	
	<cfset attributes.journal = get.Journal>
	<cfset attributes.JournalSerialNo = get.JournalSerialNo>

</cfif>

<cfquery name="get"
   datasource="AppsLedger" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT *
		FROM   TransactionHeader
		WHERE  Journal         = '#attributes.Journal#'	  
		AND    JournalserialNo = '#attributes.JournalSerialNo#'	  
</cfquery>


<cfquery name="SelectLines" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT MAX(GLAccount) as GLAccount,
		       ROUND(SUM(AmountDebit-AmountCredit),2) as Total 
		       /* ROUND(SUM(	CASE WHEN Currency  = '#Application.BaseCurrency#' 
							     THEN AmountBaseDebit
							     ELSE AmountBaseDebit * ExchangeRateBase
							    END
							    -
							CASE WHEN Currency  = '#Application.BaseCurrency#' 
							     THEN AmountBaseCredit
							     ELSE AmountBaseCredit * ExchangeRateBase
							    END ),2) as Total */
		FROM   TransactionLine
		WHERE  Journal         = '#attributes.Journal#' 
		AND    JournalSerialNo = '#attributes.JournalSerialNo#' 
		AND    TransactionSerialNo = 0 
		<!--- this is the original transaction base which needs to be matched --->
</cfquery>   
	
<cfif SelectLines.Total neq "">

	<cfquery name="Associated" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    <!--- it is possible that the matching is processed from a different journal, in that case we have the exchangerate field --->
		SELECT 
				ROUND(SUM((TL.AmountCredit*TL.ExchangeRate) - (tl.AmountDebit*TL.ExchangeRate)),2) as Total 
				/* ROUND(SUM((
						  CASE WHEN TL.TransactionCurrency = '#Application.BaseCurrency#' --parent 
						       THEN TL.AmountBaseCredit
						       ELSE TL.AmountBaseCredit * Tl.ExchangeRateBase
						  END
						) - (
						  CASE WHEN TL.TransactionCurrency  ='#Application.BaseCurrency#'
						       THEN TL.AmountBaseDebit
						       ELSE TL.AmountBaseDebit * Tl.ExchangeRateBase
						  END
						  )),2) as Total */
						  
		FROM   TransactionLine as TL INNER JOIN TransactionHeader as TH	ON TL.Journal = TH.Journal
							AND   TL.JournalSerialNo 	= TH.JournalSerialNo
							AND   TH.RecordStatus 		!= '9'
							AND   th.ActionStatus 		IN ('0','1')			
		WHERE  TL.ParentJournal          = '#attributes.Journal#'		    
		AND    TL.ParentJournalSerialNo  = '#attributes.JournalSerialNo#'   
		AND    TL.GLAccount              = '#SelectLines.GLAccount#'	
		
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

	<cfif ABS(out) lte 0.05>
		<cfset out 	= "0.0">
	</cfif>
		
	<cfquery name="Update" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    UPDATE TransactionHeader
			SET    AmountOutstanding   = ROUND(#out#,2)
			WHERE  Journal             = '#attributes.Journal#'		    
			AND    JournalSerialNo     = '#attributes.JournalSerialNo#'   			
	</cfquery>  		
	
	<!--- CORRECTION --->			
					
	<cfquery name="Outstanding" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    UPDATE TransactionHeader 
		    SET    AmountOutstanding = 0		   
		    WHERE  Journal          = '#attributes.Journal#'		    
			AND    JournalSerialNo  = '#attributes.JournalSerialNo#'
			AND    abs(AmountOutstanding) < 0.03 
	</cfquery>		
	
	<!--- correction for the payments done in a prior period --->
	
	<cfquery name 	= "children"
		  datasource 	= "Appsledger" 
		  username		="#SESSION.login#"
		  password		="#SESSION.dbpw#">
				SELECT *
				FROM    Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as th
						ON tl.Journal	= th.Journal AND tl.JournalSerialNo	= th.JournalSerialNo
				WHERE 	TL.ParentJournal 			= '#attributes.Journal#' 
				AND		TL.ParentJournalSerialNo 	= '#attributes.JournalSerialNo#'
				AND		TH.TransactionPeriod 		< '#get.TransactionPeriod#'
				AND 	TH.recordStatus            != '9'
		</cfquery>
		
		<cfif children.recordCount gte 1>
		
		<!--- -Correction --->
		
			<cfquery  name 	= "updTl"
			 	 datasource 	= "Appsledger" 
				  username		="#SESSION.login#"
				  password		="#SESSION.dbpw#">
					UPDATE  TL
					SET     TL.TransactionPeriod = '#get.TransactionPeriod#'
					FROM    Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as TH
							ON tl.Journal	= th.Journal AND tl.JournalSerialNo	= th.JournalSerialNo					
					WHERE 	TL.ParentJournal 			= '#attributes.Journal#' 
					AND		TL.ParentJournalSerialNo 	= '#attributes.JournalSerialNo#'
					AND		TL.TransactionPeriod	 	< '#get.TransactionPeriod#'
					AND 	TH.recordStatus != '9'
			</cfquery>
			
			<cfquery  name 	= "updTr"
				  datasource 	= "Appsledger" 
				  username		="#SESSION.login#"
				  password		="#SESSION.dbpw#">
					UPDATE  TH
					SET     TH.TransactionPeriod 	= '#get.TransactionPeriod#'
					FROM 	Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as th
							ON tl.Journal	= th.Journal AND tl.JournalSerialNo	= th.JournalSerialNo					
					WHERE 	tl.ParentJournal 			= '#attributes.Journal#' 
					AND		tl.ParentJournalSerialNo 	= '#attributes.JournalSerialNo#'
					AND		th.TransactionPeriod 		< '#get.TransactionPeriod#'
					AND 	th.recordStatus != '9'
			</cfquery>
		
		</cfif>
				
		<!--- check if transaction is voided and still has payments active --->
		
		<cfif get.RecordStatus eq "9">
		
			<cfquery name 	= "children"
		  	   datasource 	= "Appsledger" 
			   username		= "#SESSION.login#"
			   password		= "#SESSION.dbpw#">
					SELECT  TL.Journal, 
					        TL.JournalSerialNo,
							TH.TransactionPEriod
					FROM    Accounting.dbo.TransactionLine as tl INNER JOIN Accounting.dbo.TransactionHeader as th
							ON tl.Journal	= th.Journal AND tl.JournalSerialNo	= th.JournalSerialNo
					WHERE 	TL.ParentJournal 			= '#attributes.Journal#' 
					AND		TL.ParentJournalSerialNo 	= '#attributes.JournalSerialNo#'
					AND 	TH.recordStatus != '9' 
			</cfquery>
			
			<cfif children.recordCount gte 1>
			
				<!--- -Correction --->
				
				<cfquery  name 	= "updTr"
				  datasource 	= "Appsledger" 
				  username		="#SESSION.login#"
				  password		="#SESSION.dbpw#">
					UPDATE    TH
					SET       TH.RecordStatus	= '9'
					FROM 	  Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as th
							  ON tl.Journal	= th.Journal AND tl.JournalSerialNo	= th.JournalSerialNo
					WHERE 	  TL.ParentJournal 			= '#attributes.Journal#' 
					AND		  TL.ParentJournalSerialNo 	= '#attributes.JournalSerialNo#'
					AND 	  TH.recordStatus 			!= '9'
				</cfquery>
			
			</cfif>
			
		</cfif>
		
		<!--- record the action --->
		
		<cftry>
		
		<cfquery name="InsertAction" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    INSERT INTO TransactionHeaderAction
			(Journal,JournalSerialNo,ActionCode,ActionDate,OfficerUserId,OfficerLastName,OfficerFirstName)
			VALUES
			('#attributes.Journal#','#attributes.JournalSerialNo#','Outstanding',getDate(),'#session.acc#',
			'#session.last#',
			'#session.first#')   			
		</cfquery>  	
		
		<cfcatch></cfcatch>
		
		</cftry>
		
	
</cfif>	