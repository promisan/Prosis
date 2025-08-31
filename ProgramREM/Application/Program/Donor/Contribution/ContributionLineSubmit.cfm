<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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