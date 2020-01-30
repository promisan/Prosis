
<!--- batch Process initial load --->

<cfflush>

<cfquery name="Clean" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT * 
	FROM   Accounting.dbo.TransactionHeader
	WHERE  Reference = 'Invoice'
	AND    Mission = 'CMP'
	AND    ReferenceId IN (SELECT InvoiceId 
	                        FROM Invoice 
							WHERE Invoiceid IN (SELECT ReferenceId FROM Accounting.dbo.TransactionHeader WHERE Referenceid is not NULL))
	AND Journal = '20002'						
</cfquery>

<cfloop query="Clean">
	
	<cfquery name="CleanPosting" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		DELETE FROM Accounting.dbo.TransactionHeader
		WHERE  Journal = '#Clean.Journal#'
		AND    JournalSerialNo = '#Clean.JournalSerialNo#'	
	</cfquery>

</cfloop>

<cfquery name="Listing" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT  *
	FROM    Invoice 
	WHERE   ActionStatus >= 1
</cfquery>

<cfset URL.ID = "">

<cfoutput query="Listing">

	#currentrow# : #TransactionNo#<br>
	<cfflush>
		
			
	<cfset URL.INVID = Listing.InvoiceId>
	<cfset url.clear = 0>
	
	<cfinclude template="PostInvoice.cfm">		
	
	<cfquery name="Update" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		UPDATE Purchase.dbo.Invoice
		SET ActionStatus='2'
		WHERE InvoiceId='#InvoiceId#'
	</cfquery>	
	
</cfoutput>	