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
<cfparam name="client.statementrep" default="pl">
<cfparam name="URL.Report" default="#client.statementrep#">

<cfparam name="client.statementper" default="">
<cfparam name="URL.Period" default="#client.statementper#">

<cfparam name="Form.Currency"          default="#application.BaseCurrency#">

<!--- transactionperiod --->
<cfparam name="Form.OrgUnitOwner"      default="">
<cfparam name="Form.aggregation"       default="detail">
<cfparam name="Form.Layout"            default="Corporate">

<cfparam name="Form.TransactionPeriod" default="">
<cfparam name="Form.AccountPeriod"     default="">
<cfparam name="Form.History"           default="TransactionPeriod">

<!---
<cfif url.mode eq "1">
	<cfset transactionperiod = "">
<cfelse>
	<cfset transactionperiod = Form.TransactionPeriod>
</cfif>
--->

<cfset AccountPeriod = "#Form.Period#">  

<cfif form.History eq "AccountPeriod">
     
    <cfif Form.AccountPeriod eq Form.Period>	
	
	    <cfset AccountPeriod = "#Form.Period#">
		<cfset opening = "">
		
	<cfelse>
	
		<cfquery name="PeriodList"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">							 
				SELECT   *
				FROM      Period
				WHERE     AccountPeriod >= '#Form.AccountPeriod#' 
				AND       AccountPeriod <= '#Form.Period#'		
				ORDER BY PeriodDateStart						
			</cfquery>	
			
		<cfif PeriodList.recordcount gte "2">
			<cfset opening = PeriodList.AccountPeriod>
		</cfif>
	
		<cfset AccountPeriod = "#quotedValueList(PeriodList.AccountPeriod)#">  		
				
	</cfif>	
	
<cfelse>

	<cfset opening = AccountPeriod>
		
</cfif>
 
<!--- added 8/6/2015 to make the list leaner in case of near 0 amounts that are less than 1 --->

<cfset FileNo = round(Rand()*30)>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Balance#FileNo#">


<cfinvoke component   = "Service.Process.GLedger.Statement"  
   method             = "getBalanceSheet" 
   mission            = "#url.mission#" 
   openingperiod      = "#opening#"
   accountperiod      = "#accountperiod#"
   transactionperiod  = "#transactionperiod#"
   currency           = "#form.currency#"
   orgunitowner       = "#form.orgunitOwner#"  
   layout             = "#form.layout#"
   table              = "#SESSION.acc#Balance#FileNo#"    
   returnvariable     = "result">	  

<script>
	Prosis.busy('no')
</script>	

<cfinclude template="BalanceView.cfm">