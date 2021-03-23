
<cfoutput>

<cfparam name="url.currency" default="">

<cfquery name="Currency" 
datasource="AppsLedger"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<cfif url.currency eq "">
	
	<cfquery name="SalarySchedule" 
	datasource="AppsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  SalarySchedule
		WHERE SalarySchedule IN (SELECT   TOP 1 SalarySchedule 
							     FROM     Employee.dbo.PersonContract
								 WHERE    ActionStatus = '1'
								 AND      PersonNo = '#URL.ID#'
								 ORDER BY Created DESC)
	</cfquery>
	
	<cfif salaryschedule.paymentCurrency neq "">
	       <cfset cur = salaryschedule.paymentCurrency>
	<cfelse>
	       <cfset cur = APPLICATION.BaseCurrency>
	</cfif>
	
	<select name="Currency" size="1" class="regularxxl enterastab" style="border:0px;width:100%">
		<option value=""></option>
		<cfloop query="Currency">
		<option value="#Currency#" <cfif cur eq Currency>selected</cfif>>#Currency#</option>
		</cfloop>
	</select>
	
<cfelse>
	
	#url.currency#
	<input type="hidden" name="Currency" value="#url.currency#" style="border:0px;width:100%">
	
</cfif>	

</cfoutput>