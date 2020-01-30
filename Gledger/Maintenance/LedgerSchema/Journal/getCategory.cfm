<cfquery name="Category" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT *
	FROM Ref_TransactionCategory
	<cfif url.cat neq "Actuals">
	WHERE TransactionCategory = 'Memorial'
	</cfif>
	ORDER By OrderListing	
	</cfquery>
 
 	 <select name="transactioncategory" class="regularxl" onChange="system()">
      <cfoutput query="category">
       	<option value="#TransactionCategory#">#TransactionCategory#</option>
      </cfoutput>
	</select>
	
		
		