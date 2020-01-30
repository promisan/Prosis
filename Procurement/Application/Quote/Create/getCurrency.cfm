
<!--- get currency --->

<cfquery name="CurrencyList" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Accounting.dbo.Currency
	WHERE     EnableProcurement = '1'
</cfquery>

<cfif url.currency neq "">
   
<select name="Currency" id="Currency" class="regularxl enterastab">
	  <cfoutput query="CurrencyList">
	     <option value="#Currency#" <cfif currency eq url.currency>selected</cfif>>#Currency#</option>
	  </cfoutput>
</select>

<cfelse>

 <select name="Currency" id="Currency" class="regularxl enterastab">
			  <cfoutput query="CurrencyList">
			     <option value="#Currency#" <cfif currency eq Application.baseCurrency>selected</cfif>>#Currency#</option>
			  </cfoutput>
		   </select>

</cfif>