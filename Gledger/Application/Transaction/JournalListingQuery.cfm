
<cfparam name="url.page"  default="1">
<cfparam name="url.query" default="0">

<cfquery name="OrgUnit" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Organization
	 WHERE  OrgUnit = '#URL.OrgUnit#' 
</cfquery>

<cfquery name="Journal" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *, (SELECT Count(*) 
			     FROM   JournalAccount 
			     WHERE  Journal = J.Journal 
			     AND    Mode = 'Contra') as GLAccount
	  FROM   Journal J
	  WHERE  Journal = '#URL.Journal#'  
</cfquery>

<cfif isNumeric(url.find)>
    <cfset num = "1">
<cfelse>
	<cfset num = "0"> 
</cfif>

<cfif url.journal eq "">
	
	 <cfset outst = 1>
	
<cfelse>
			
	<cfif Journal.TransactionCategory is "Payables"      or 
	      Journal.TransactionCategory is "DirectPayment" or 
		  Journal.TransactionCategory is "Receivables"   or
		  Journal.TransactionCategory is "Advances">
				  
		  <cfset outst = 1>
				  
	<cfelse>
		
		  <cfset outst = 0>
				  
	</cfif>		  		  
	
</cfif>

<cfoutput>


	<cfsavecontent variable="querystatement">
	    TransactionHeader T WITH (NOLOCK)
		       INNER JOIN TransactionLine L WITH (NOLOCK) ON T.Journal = L.Journal AND T.JournalSerialNo = L.JournalSerialNo
			   LEFT OUTER JOIN Employee.dbo.Person P WITH (NOLOCK) ON P.PersonNo = T.ReferencePersonNo
			   LEFT OUTER JOIN Materials.dbo.Customer C WITH (NOLOCK) ON C.CustomerId = T.ReferenceId
		
		WHERE  L.TransactionSerialNo = (SELECT MIN(TransactionSerialNo)
										FROM     TransactionLine WITH (NOLOCK)
										WHERE    Journal         = T.Journal
										AND      JournalSerialNo = T.JournalSerialNo
										GROUP BY Journal, JournalSerialNo
										)
		
		<cfif url.journal neq "" AND url.journal neq "0">	
		AND    T.Journal                = '#URL.Journal#' 
		</cfif>
		
		<cfif url.period neq "">	
		AND    T.AccountPeriod          = '#URL.Period#'
		</cfif>
		
		<cfif URL.ReferenceId neq "">
		AND    (T.ReferenceId = '#url.referenceid#' OR L.ReferenceId  = '#URL.ReferenceId#') 
		</cfif>
		
		<cfif URL.Month neq "">
		AND    Month(T.TransactionDate) = '#URL.month#'
		</cfif>
		
		<cfif URL.JournalBatchNo neq "">
		AND    JournalBatchNo           = '#URL.JournalBatchNo#'
		</cfif>			
									
		<cfif URL.IDStatus eq "Pending"> <!--- workflow driven --->
		AND   T.ActionStatus = '0' AND RecordStatus = '1'		
		<cfelseif URL.IDStatus eq "Outstanding"> <!--- status of the offset --->
		AND    T.AmountOutstanding > 0 AND RecordStatus = '1'	
		<cfelseif URL.IDStatus eq "Voided"> <!--- status of the record --->
		AND    RecordStatus = '9'	
		<cfelse>
		AND    RecordStatus = '1'	
		</cfif>
						
		<cfif URL.find neq "">
		AND    (
		       T.JournalTransactionNo LIKE '%#URL.Find#%' OR
		       T.ReferenceName     LIKE '%#URL.Find#%' OR
			   L.ReferenceNo       LIKE '%#URL.Find#%' OR
			   C.CustomerName      LIKE '%#URL.Find#%' OR
			   T.ReferencePersonNo LIKE '%#URL.Find#%' OR
			   P.LastName          LIKE '%#URL.Find#%' OR 
			   P.IndexNo           LIKE '%#URL.Find#%' OR
			   T.Description       LIKE '%#URL.Find#%' OR
			   T.JournalSerialNo   LIKE '%#URL.Find#%' OR
			   T.TransactionReference LIKE '%#URL.Find#%' OR
			   T.JournalSerialNo IN (SELECT JournalSerialNo 
			                         FROM   TransactionLine P WITH (NOLOCK)
									 WHERE  Journal         = T.Journal 
									 AND    JournalSerialNo = T.JournalSerialNo 
									 AND    (Fund LIKE '#URL.Find#%' OR ProgramCode LIKE '#URL.Find#%' OR ProgramCode IN (SELECT ProgramCode FROM Program.dbo.ProgramPeriod WHERE ProgramCode = P.ProgramCode and Reference LIKE '#URL.Find#%')))
			   <cfif num eq "1">  OR  T.DocumentAmount   LIKE '%#URL.Find#%' </cfif>
			   )
				
		</cfif>
		
		<cfif URL.OrgUnit eq "0">
		
		<cfelse>
						
		AND    T.OrgUnitOwner IN (SELECT OrgUnit 
	                          FROM    Organization.dbo.Organization
	                          WHERE   Mission          = '#OrgUnit.Mission#'
							  AND     MissionOrgUnitId = '#OrgUnit.MissionOrgUnitId#')
					
		</cfif>
		
		GROUP BY T.Journal, 
	       T.JournalSerialNo,
		   T.TransactionId,
		   T.JournalTransactionNo, 
		   T.TransactionId,
		   T.Created,
		   T.AccountPeriod,
		   T.TransactionDate, 
		   T.JournalBatchDate,
		   T.DocumentDate,
		   T.ReferenceName,
		   T.ReferenceId,
		   T.ReferenceNo,
		   T.Description,
		   T.Reference, 
		   T.Currency,
		   T.ActionStatus,
		   T.RecordStatus,
		   T.ReferencePersonNo,
		   T.OfficerFirstName,
		   T.OfficerLastName,
		   P.LastName,
		   P.FirstName,
		   P.IndexNo,
		   C.CustomerName,
		   T.Amount, 
		   T.AmountOutstanding 
	
	</cfsavecontent>
	
</cfoutput>

<cfif url.query eq "0">
	
	<cfquery name="getTotal"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		SELECT     COUNT(*) AS Records, 
		           SUM(Amount) as Amount, 
				   SUM(AmountOutstanding)   as AmountOutstanding,
				   SUM(AmountTriggerDebit)  as AmountTriggerDebit, 
				   SUM(AmountTriggerCredit) as AmountTriggerCredit 
		FROM      (SELECT  T.TransactionId,
			               SUM(Amount) as Amount, 
				           SUM(AmountOutstanding)  as AmountOutstanding,
					       SUM(L.AmountDebit)      as AmountTriggerDebit, 
			               SUM(L.AmountCredit)     as AmountTriggerCredit 
				   FROM    #preserveSingleQuotes(querystatement)# ) as Tbl
	</cfquery>		

<cfelse>
	
	<cfquery name="getTotal"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		SELECT     COUNT(*) AS Records
		FROM      (SELECT  T.TransactionId
				   FROM    #preserveSingleQuotes(querystatement)# ) as Tbl
	</cfquery>		

</cfif>

<cf_pagecountN show="#client.pagerecords#" 
          count="#getTotal.records#">
		  
<cfset selection = url.page * client.pagerecords>
<cfset start = selection - client.pagerecords>
<cfif start gt gettotal.records>
	<cfset url.page = "1">
	<cfset selection = client.pagerecords>
</cfif>		  

<!--- obtain records that you indeed want to show --->	 

<cfparam name="URL.IDSorting" default="ReferenceNo">	

<cfquery name="TransactionListing"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP #selection# T.Journal, 
		       T.JournalSerialNo,
			   T.TransactionId,
			   T.TransactionId,
			   T.TransactionDate, 
			   T.DocumentDate,
			   T.JournalBatchDate,
			   T.Created,
			   T.JournalTransactionNo, 
			   T.Description,
			   T.ReferenceName,
	           T.ReferenceId,
			   T.ReferenceNo,
			   T.Reference, 
			   T.Currency,
			   T.ActionStatus,
			   T.RecordStatus,
			   T.AccountPeriod,
			   T.ReferencePersonNo,
			   P.LastName,
			   P.FirstName,
			   P.IndexNo,
	           C.CustomerName,
			   T.OfficerFirstName,
			   T.OfficerLastName,
			   T.Amount, 
			   T.AmountOutstanding, 
			   SUM(L.AmountDebit)  as AmountTriggerDebit,
			   SUM(L.AmountCredit) as AmountTriggerCredit
		 FROM  #preserveSingleQuotes(querystatement)#
		 ORDER BY T.Currency, T.#IDSorting#, T.Created DESC		 
</cfquery>