
<!--- record action for the line --->

 <cfquery name="setStatusLog" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        INSERT INTO ItemTransactionAction
           (TransactionId,ActionCode,ActionStatus,OfficerUserId,OfficerLastName,OfficerFirstName)
        VALUES
           ('#url.transactionid#',
            'SalesPerson',
            '1',                
            '#session.acc#',
            '#session.last#',
            '#session.first#')
</cfquery>
		
<!--- updated sales person --->

<cfquery name="Set" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE ItemTransactionShipping
	SET    SalesPersonNo = '#url.personno#'
	WHERE  Transactionid = '#url.transactionid#'	
</cfquery>

<!--- show sales person --->

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Person
	WHERE PersonNo = '#url.personno#'	
</cfquery>

<cfoutput>#Person.LastName#</cfoutput>

