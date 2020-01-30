
<cfquery name="getEdition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AllotmentEdition
	WHERE     EditionId = '#url.EditionId#' 	
</cfquery>

<cfquery name="resetMapping" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE    TransactionLine
	SET       ContributionLineId = NULL
	WHERE     ProgramCode   = '#url.programcode#' 
	AND       ProgramPeriod = '#getEdition.Period#'
	<!--- all transactions for that mission excluding the generated ones for support cost, they will be corrected --->
	AND       Journal IN
	               (SELECT   Journal
	                FROM     Journal
	                WHERE    Mission       = '#getEdition.Mission#' 
					AND      SystemJournal != 'SupportCost') 
	AND       ContributionLineId IS NOT NULL
</cfquery>

<cfquery name="resetMappingForPSCtransaction" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE TransactionHeader
	FROM  TransactionHeader H
	WHERE H.Journal IN (
				    SELECT   Journal
	                FROM     Journal
	                WHERE    Mission       = '#getEdition.Mission#' 
					AND      SystemJournal = 'SupportCost'
				   ) 
	AND   H.JournalSerialNo IN (
	                          SELECT JournalSerialNo
	                          FROM   TransactionLine
							  WHERE  Journal       = H.Journal
							  AND    ProgramCode   = '#url.programcode#' 
						      AND    ProgramPeriod = '#getEdition.Period#'
							  AND    ContributionLineId IS NOT NULL
							  )						
</cfquery>

<font color="gray">Mapping and PSC reverted, wait until next batch</font>
