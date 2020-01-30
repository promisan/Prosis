<cfparam name="Attributes.Datasource"      default="appsLedger">
<cfparam name="Attributes.CurrencyFrom"    default="#APPLICATION.BaseCurrency#">
<cfparam name="Attributes.CurrencyTo"      default="#APPLICATION.BaseCurrency#">
<cfparam name="Attributes.EffectiveDate"   default="#dateformat(now(),client.dateformatshow)#">
<cfparam name="Attributes.EffectiveStart"  default="#Attributes.EffectiveDate#">  <!--- define a period for getting the average over period --->

<cfif Attributes.EffectiveStart neq ''>
    <CF_DateConvert Value="#Attributes.EffectiveStart#" Status="0">
	<cfset STR = dateValue>
</cfif>	

<cfif Attributes.EffectiveDate neq ''>
    <CF_DateConvert Value="#Attributes.EffectiveDate#" Status="0">
	<cfset DTE = dateValue>
</cfif>	

<cfquery name="FromCurr" 
     datasource="#Attributes.DataSource#" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   TOP 1 *
     FROM     Accounting.dbo.CurrencyExchange
     WHERE    Currency = '#Attributes.CurrencyFrom#'
	 <cfif attributes.effectiveDate eq "">
	  AND      EffectiveDate <= getDate()
	 <cfelse>
	  AND      EffectiveDate <= #dte#
	 </cfif> 
	  ORDER BY EffectiveDate DESC
</cfquery>

<cfif FromCurr.ExchangeRate gt "0">
   <cfset frm = FromCurr.ExchangeRate>
<cfelse>
   <cfset frm = 1> 
</cfif>
						
<cfquery name="ToCurr" 
     datasource="#Attributes.DataSource#" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   TOP 1 *
     FROM     Accounting.dbo.CurrencyExchange
	 WHERE    Currency = '#Attributes.CurrencyTo#'
	 <cfif attributes.effectiveDate eq "">
	  AND      EffectiveDate <= getDate()
	 <cfelse>
	  AND      EffectiveDate <= #dte#
	 </cfif> 	 	 
	 ORDER BY EffectiveDate DESC
</cfquery>

<cfif ToCurr.ExchangeRate gt "0">
  <cfset des = ToCurr.ExchangeRate>
<cfelse>
  <cfset des = 1> 
</cfif>

<CFSET Caller.exc = frm/des>