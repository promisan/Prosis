
<!--- transaction process  --->

<cfquery name="Process"
 datasource="AppsLedger" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   *
 FROM     TransactionHeader
 WHERE    Journal         = '#URL.Journal#'
 AND      JournalSerialno = '#URL.JournalSerialNo#' 
</cfquery> 

<cfquery name="ParentLine"
 datasource="AppsLedger" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   *
 FROM     TransactionLine
 WHERE    Journal             = '#URL.Journal#'
 AND      JournalSerialno     = '#URL.JournalSerialNo#' 
 AND      TransactionSerialNo = '#URL.transactionserialno#' 
 AND      GLAccount           = '#url.glaccount#'
</cfquery> 

<cfif ParentLine.recordcount neq "1">

	<cf_message message="Transaction Distribution Line could not be determined. Operation aborted">
	<cfabort>

</cfif>

<cfif ParentLine.AmountCredit gte 0>
	<cfset accounttype = "credit">
<cfelse>
	<cfset accounttype = "debit">
</cfif>

<cfquery name="Journal"
 datasource="AppsLedger" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   *
 FROM     Journal
 WHERE    Mission       = '#Process.Mission#' 
 AND      SystemJournal = 'Distribution'
 AND      Currency      = '#ParentLine.Currency#'
</cfquery> 

<cfoutput>
	
	<cfif Journal.recordcount eq "0">
	
		<cf_message message="Distribution Journal has not been defined for #Process.Mission# and currency: #ParentLine.Currency#. Operation not allowed.">
		<cfabort>
	
	</cfif>
	
	<script language="JavaScript">
	
	ptoken.location('TransactionInit.cfm?'+
	                    'mission=#process.mission#'+
						'&orgunitowner=#process.orgunitowner#'+
	                    '&journal=#journal.journal#'+
						'&parentjournal=#process.journal#'+
						'&parentjournalserialNo=#process.journalSerialno#'+
						'&parentlineid=#ParentLine.TransactionLineId#'+
						'&referenceid=#process.referenceid#'+
						'&glaccount=#ParentLine.GLAccount#'+
						'&fund1=#ParentLine.Fund#'+
						'&object1=#ParentLine.ObjectCode#'+
						'&programcode1=#ParentLine.ProgramCode#'+
						'&programcode2=#ParentLine.ProgramCodeProvider#'+
						'&orgunit1=#ParentLine.OrgUnit#'+
						'&contributionlineid=#ParentLine.ContributionLineId#'+
						'&accounttype=#accounttype#'+
						'&accountperiod=#Process.AccountPeriod#'+
						'&amount=#ParentLine.TransactionAmount#')
	
	</script>

</cfoutput>


