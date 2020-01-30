
<cfif Form.DateReceived neq "">
	<CF_DateConvert Value="#Form.DateReceived#">
	<cfset dateRec    = dateValue>
<cfelse>
	<cfset dateRec    = "NULL">	
</cfif>	

<cfif Form.DateEffective neq "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset dateEff     = dateValue>
<cfelse>
	<cfset dateEff     = "NULL">
</cfif>	

<cfif Form.DateExpiration neq "">
	<CF_DateConvert Value="#Form.DateExpiration#">
	<cfset dateExp    = dateValue>
<cfelse>
	<cfset dateExp    = "NULL">
</cfif>	

<cf_exchangerate CurrencyFrom = "#FORM.Currency#" CurrencyTo = "#Application.BaseCurrency#" datasource="AppsProgram">
<!---replacing the commas this number could have, as this must be expressed in a number format ---->
<cfset Form.Amount		 = Replace(Form.Amount,",","","All")>
<cfset vConverted_Amount = round(FORM.Amount * exc * 100 )/ 100>

<cf_assignId>

<cfquery name="qSubmitLine" 
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	INSERT INTO ContributionLine
           (ContributionId,
		   ContributionLineId,
		   DateReceived,
		   DateEffective,
           DateExpiration,
		   Reference,
           Fund,
           Currency,
           Amount,
           AmountBase,
           OfficerUserId,
           OfficerLastName,
           OfficerFirstName)
     VALUES ('#URL.ContributionId#',
			 '#rowguid#',
			 #DateRec#,
			 #DateEff#,
	         #DateExp#,
			 '#Form.Reference#',
	         '#Form.Fund#',
	         '#Form.Currency#',
	         '#Form.Amount#',
	         '#vConverted_Amount#',
	         '#SESSION.acc#',
	         '#SESSION.last#',
	         '#SESSION.first#')
</cfquery>

<cfquery name="qSubmitLine" 
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	INSERT INTO ContributionLineProgram
           (ContributionLineId,
		    ProgramCode,
            OfficerUserId,
            OfficerLastName,
            OfficerFirstName)
	 SELECT '#rowguid#',ProgramCode,OfficerUserid,OfficerLastName,OfficerFirstName
	 FROM   ContributionProgram	   
	 WHERE  Contributionid = '#URL.ContributionId#'	
</cfquery>


<cfoutput>
<script>
	ColdFusion.navigate('ContributionLines.cfm?systemFunctionId=#url.systemFunctionId#&contributionId=#url.contributionId#','dlines');
</script>
</cfoutput>