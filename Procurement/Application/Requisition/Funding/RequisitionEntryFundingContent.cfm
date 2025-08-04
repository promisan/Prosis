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

<!--- ---------------------------------------------- --->
<!--- ------create table with allotment info-------- --->
<!--- ---------------------------------------------- --->

<cfif edition.editionid eq "">

	<tr>
	<td height="60" align="center" class="labelmedium">*****
	<font color="0080FF">Problem, edition was not determined for this execution period</font></td>
	</tr>
	
	<cfabort>

</cfif>

<cfif url.org neq "">

	<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Organization WHERE OrgUnit = '#url.org#'
	</cfquery>	
	
	<cfset hierbase = org.hierarchyCode>
	<cfset orgnamebase = Org.OrgUnitName>		
	
	<cfif Org.ParentOrgunit eq "" or Org.Autonomous eq "1">
	
	    <!--- --------------------- --->
		<!--- this is the top level --->
		<!--- --------------------- --->
			
		<cfset hier      = hierbase>
		<cfset orgname   = orgnamebase>	
		<cfset showmode  = "standard">
	
	<cfelse>
	
		<!--- find the top level --->
		
		<cfset top = 0>
				
		<cfloop condition="#top# neq 1">
		
			<cfquery name="Org" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Organization 
				WHERE  Mission     = '#org.Mission#' 
				AND    MandateNo   = '#org.MandateNo#'
				AND    OrgUnitCode = '#org.ParentOrgUnit#'
			</cfquery>	
			
			<cfif Org.ParentOrgunit eq "" or Org.Autonomous eq "1">
			
			    <!--- this is the base --->
			
				<cfset hier     = org.hierarchyCode>
				<cfset orgname  = Org.OrgUnitName>
				<cfset showmode = "total">
				
				<cfinclude template="RequisitionEntryFundingContentTotal.cfm">
				<cfinclude template="RequisitionEntryFundingContentData.cfm">
				
				<!--- stop loop --->
				<cfset top = 1>
				
			</cfif>
				
		</cfloop>
		
		<cfset showmode = "standard">
		<cfset hier    = hierbase>
		<cfset orgname = orgnamebase>	
		
	</cfif>
		
<cfelse>
	
	<cfset hier     = "">	
	<cfset orgname  = "">
	<cfset showmode = "standard">
	
</cfif>

<cfinclude template="RequisitionEntryFundingContentTotal.cfm">
<cfinclude template="RequisitionEntryFundingContentData.cfm">
