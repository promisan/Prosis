
<!--- script to perform varios audit validations --->

<!--- ---------------------------------------------------------------------------- --->
<!--- ----------------correct transactions that do not have any lines------------- --->
<!--- ---------------------------------------------------------------------------- --->

<cfquery name="TransactionsWithoutLines"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   TransactionHeader TH 
	WHERE 
	NOT EXISTS ( SELECT 'X'
          		 FROM   TransactionLine
		         WHERE  Journal = TH.Journal
		         AND    JournalSerialNo = TH.JournalSerialNo
	)
</cfquery>	

<cfloop query="TransactionsWithoutLines">
	
	<cfquery name="check"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM TransactionLine 
		WHERE ParentJournal         = '#Journal#'
		AND   ParentJournalSerialNo = '#JournalSerialNo#'
	</cfquery>	
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="check"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM TransactionHeader 
			WHERE Journal = '#Journal#'
			AND   JournalSerialNo = '#JournalSerialNo#'
		</cfquery>	
	
	<cfelse>
	
		<!--- this is strange and should normally not happen --->
	
	</cfif>

</cfloop>


<!--- ---------------------------------------------------------------------------- --->
<!--- correct reconciliation transactions that do no longer connect to the parent- --->
<!--- ---------------------------------------------------------------------------- --->

<cfquery name="Select"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     S.TransactionLineId AS Line, S.ParentLineId AS ParentOld, P.TransactionLineId AS ParentNew
	FROM       dbo.TransactionLine AS S INNER JOIN
	           dbo.TransactionLine AS P ON S.ParentJournal = P.Journal AND S.ParentJournalSerialNo = P.JournalSerialNo AND P.TransactionSerialNo = 0
	WHERE     S.ParentLineId IS NOT NULL 
	AND       S.ParentLineId NOT IN
	                    (SELECT     TransactionLineId
	                     FROM       dbo.TransactionLine) 
						 
    AND       S.ParentLineId NOT IN
	                    (SELECT     TransactionId
	                     FROM       dbo.TransactionHeader) 
	AND       S.Journal IN 
	                     (SELECT    Journal
	                      FROM      dbo.Journal
	                      WHERE     TransactionCategory = 'Banking')
</cfquery>							

<cfloop query="Select">
	
	<cfquery name="UPDATE"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE dbo.TransactionLine
		SET    ParentLineId = '#ParentNew#'
		WHERE  TransactionLineId = '#line#'
	</cfquery>				

</cfloop>

<!--- ---------------------------------------------------------------------------- --->
<!--- correct transaction line source records for the first level, AR ------------ --->
<!--- ---------------------------------------------------------------------------- --->

<cfquery name="UPDATE"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM TransactionLineSource
		WHERE  Source = 'Level1'		
	</cfquery>				

<cfquery name="Level1"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	INSERT INTO TransactionLineSource
	
	(TransactionLineId, SourceTransactionLineId, Source, SourceGLAccount, SourceOrgUnit, SourceProgramCode, SourceObjectCode, AmountRatio)
	
	SELECT       L.TransactionLineId, 
	             S.TransactionLineId, 
				 'Level1', 
				 S.GLAccount, 
				 S.OrgUnit, 
				 S.ProgramCode, 
				 S.ObjectCode,  
	             ROUND(S.TransactionAmount /
	                 (SELECT    (CASE WHEN SUM(TransactionAmount) > 0 THEN SUM(TransactionAmount) ELSE 1000000 END) AS Expr1
	                  FROM      TransactionLine AS TL
	                  WHERE     Journal          = L.ParentJournal 
					  AND       JournalSerialNo  = L.ParentJournalSerialNo 
					  AND       GLAccount       <> L.GLAccount),3) AS SourceRatio 
					  
	FROM         TransactionLine AS L INNER JOIN
	             TransactionHeader AS H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo INNER JOIN
	             TransactionLine AS S ON L.ParentJournal = S.Journal AND L.ParentJournalSerialNo = S.JournalSerialNo AND L.GLAccount <> S.GLAccount
	WHERE        L.TransactionSerialNo = '0' 
	AND          L.GLAccount IN   (SELECT   GLAccount
	                               FROM     Ref_Account
	                               WHERE    FundAccount = '0') 
	AND          L.ParentJournal IS NOT NULL 
	AND          H.RecordStatus IN ('1') 
	AND          H.ActionStatus IN ('0','1')

</cfquery>

