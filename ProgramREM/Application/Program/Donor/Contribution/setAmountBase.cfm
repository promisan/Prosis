
<cfset vAmount = trim(replace(url.amount, ",", "", "ALL"))>

<cfset vMessage = "">

<cfquery name="Param" 
	datasource="AppsProgram"  
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.mission#'		
</cfquery>

<cf_exchangeRate 
	    DataSource    = "AppsProgram"
		CurrencyFrom  = "#url.cur#" 
		CurrencyTo    = "#Param.BudgetCurrency#">

<cfif Exc eq "0" or Exc eq "">
	<cfset exc = 1>
</cfif>			
		
<cfset vAmountBase = vAmount / exc>

<cfoutput>

	#numberformat(vAmountBase,',.__')# 
	<input type="Hidden" id="AmountBase" name="AmountBase" value="#vAmountBase#">	
	<script language="JavaScript">
		 ColdFusion.navigate('ContributionLineDialogPeriod.cfm?contributionlineid=#url.contributionlineid#&amountbase=#vAmountBase#','amountperiod') 
	</script>

</cfoutput>