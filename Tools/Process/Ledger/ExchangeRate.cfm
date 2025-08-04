<!--
    Copyright © 2025 Promisan

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