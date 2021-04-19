<cfquery name="getTransaction"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   TransactionLine
	WHERE  Journal = '#url.journal#'
	AND    JournalSerialNo = '#url.journalserialno#'	
	AND    Reference = 'Sale'	
</cfquery>

<cfset acc = getTransaction.GLAccount>

<cfquery name="getAccount"
   datasource="AppsLedger" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   
   <cfif getTransaction.recordcount gte 1>
    SELECT *
	FROM   Ref_Account
	WHERE  GLAccount IN (#quotedValueList(getTransaction.GLAccount)#)
		
	UNION
   </cfif>
	
	SELECT *
	FROM Ref_Account
	WHERE GLAccount IN (
			 SELECT GLAccount
			 FROM   JournalAccount
			 WHERE  Journal = '#url.selected#'
			 AND    Mode = 'Correction'	)			
</cfquery>				
					
<select name="glaccount" id="glaccount" class="regularxxl enterastab">
		 
   <cfoutput query="getAccount">
  	   <option value="#glaccount#" <cfif glaccount is acc>selected</cfif>>
         	   <cfif accountlabel neq "">#AccountLabel#<cfelse>#Glaccount#</cfif> #Description#
	   </option>
  </cfoutput>
  
</select>