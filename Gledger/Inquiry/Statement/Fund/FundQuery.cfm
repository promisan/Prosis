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

<!--- Query Trial balance --->

<cfparam name="client.statementrep" default="fund">
<cfparam name="URL.Report" default="#client.statementrep#">

<cfparam name="client.statementper" default="">
<cfparam name="URL.Period" default="#client.statementper#">

<!--- transactionperiod --->

<cfparam name="Form.OrgUnitOwner"      default="">
<cfparam name="Form.OrgUnit"           default="">
<cfparam name="Form.Aggregation"       default="detail">
<cfparam name="Form.Layout"            default="Horizontal">
<cfparam name="Form.Mode"              default="Economic">
<cfparam name="form.Format"            default="list">  <!--- list | graph --->
<cfparam name="Form.Currency"          default="#Application.BaseCurrency#">

<cfparam name="Form.History"           default="TransactionPeriod">
<cfparam name="Form.AccountPeriod"     default="">
<cfparam name="Form.TransactionPeriod" default="">

<cfset orgunit           = Form.OrgUnit>
<cfset orgunitowner      = Form.OrgUnitOwner>
<cfset transactionperiod = Form.TransactionPeriod>

<cfset AccountPeriod = "'#Form.Period#'">  

<cfif form.History eq "AccountPeriod">
     
    <cfif Form.AccountPeriod eq Form.Period or Form.AccountPeriod eq "">	
	
	    <cfset AccountPeriod = "'#Form.Period#'">
				
	<cfelse>
					
		<cfset AccountPeriod = Form.accountPeriod>  		
				
	</cfif>	
			
</cfif>

<cfset cur = form.Currency>

<cfif OrgUnit neq "">

	<cfquery name="getUnit"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
           FROM    Organization.dbo.Organization
           WHERE   OrgUnit = '#Form.OrgUnit#' 		
	</cfquery>	

	<cfquery name="getUnits"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			SELECT OrgUnit
			FROM   Organization.dbo.Organization
			WHERE  Mission    = '#getUnit.Mission#'
			AND    MandateNo  = '#getUnit.MandateNo#'
			AND    HierarchyCode LIKE '#getUnit.HierarchyCode#%'										
	</cfquery>
	
	<cfset units = quotedValueList(GetUnits.OrgUnit)>
			
<cfelse>

	<cfset units = "">		
	
</cfif>

<cfset FileNo = round(Rand()*30)>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Fund#FileNo#">

<cfinvoke component   = "Service.Process.GLedger.Statement"  
   method             = "getFundStatement" 
   mission            = "#url.mission#"   
   accountperiod      = "#accountperiod#"
   history            = "#form.history#"
   transactionperiod  = "#transactionperiod#"
   currency           = "#cur#"
   orgunitowner       = "#form.orgunitOwner#"  
   orgunit            = "#units#"
   program            = "#form.program#"
   Aggregation        = "#form.Aggregation#"   
   mode               = "#form.mode#"
   layout             = "#form.layout#"
   table              = "#SESSION.acc#Fund#FileNo#"    
   returnvariable     = "result">	

<cfif form.format eq "list">

	<cfinclude template="FundView.cfm">
	
<cfelse>

	<cfinclude template="FundViewGraph.cfm">

</cfif>

<script>
	Prosis.busy('no')
</script>	