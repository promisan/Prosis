
<cfquery name="Total" 
	datasource="#Attributes.DataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    SUM(AmountDebit-AmountCredit) AS Amount, 
	          SUM(AmountBaseDebit-AmountBaseCredit) AS AmountBase
	FROM      Accounting.dbo.TransactionLine
	WHERE     Journal = '#Attributes.Journal#' 
	AND       JournalSerialNo = '#Attributes.JournalSerialNo#'		
</cfquery>

<cfif Total.Amount gte "0">

	<cfquery name="update" 
	datasource="#Attributes.DataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  Accounting.dbo.TransactionLine
		SET     TransactionAmount = '#Total.Amount#'
		        AmountDebit       = '0',
		        AmountCredit      = '#Total.Amount#',
			    AmountBaseDebit   = '0',
		        AmountBaseCredit  = '#Total.AmountBase#'
	  	WHERE   Journal = '#Attributes.Journal#' 
		AND     JournalSerialNo = '#Attributes.JournalSerialNo#'		
		AND     TransactionSerialNo = '0'
	</cfquery>
	
<cfelse>

	<cfquery name="update" 
	datasource="#Attributes.DataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  Accounting.dbo.TransactionLine
		SET     TransactionAmount = '#abs(Total.Amount)#',
		        AmountCredit      = '0',
		        AmountDebit       = '#abs(Total.Amount)#',
			    AmountBaseCredit  = '0',
		        AmountBaseDebit   = '#abs(Total.AmountBase)#'
	  	WHERE   Journal = '#Attributes.Journal#' 
		AND     JournalSerialNo = '#Attributes.JournalSerialNo#'		
		AND     TransactionSerialNo = '0'
	</cfquery>

</cfif>

<cfquery name="update" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  Accounting.dbo.TransactionHeader
		SET   DocumentAmount    = '#abs(Total.Amount)#',
		      Amount            = '#abs(Total.Amount)#',
			  AmountOutstanding = '#abs(Total.Amount)#'		    
	  	WHERE     Journal = '#Attributes.Journal#' 
		AND       JournalSerialNo = '#Attributes.JournalSerialNo#'		
</cfquery>	
