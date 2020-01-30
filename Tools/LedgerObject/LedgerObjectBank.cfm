<cfquery name="Bank" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Accounting.dbo.Ref_BankAccount A
	  WHERE   Currency = '#url.Currency#'		 
</cfquery>		

<cfoutput>	

<select name="#url.Area#_Bank" id="#url.Area#_Bank">
	<cfloop query="Bank">
		<option value="#BankId#" <cfif bankid eq url.bankid>selected</cfif>>#BankName#</option>
	</cfloop>
</select>
</cfoutput>	