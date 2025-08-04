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

<!--- define expenditire periods --->
<cfquery name="Expenditure" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    DISTINCT Period, AccountPeriod
FROM      Ref_MissionPeriod
WHERE     Mission = '#url.Mission#'
AND       EditionId IN (SELECT EditionId
						FROM      Ref_MissionPeriod
						WHERE     Mission = '#url..Mission#'
						AND       Period  = '#URL.Period#') 
</cfquery>

<cfset per = "">

<cfloop query="Expenditure">

  <cfif per eq "">
     <cfset per = "'#Period#'"> 
	  <cfset peraccsel = "'#AccountPeriod#'"> 
  <cfelse>
     <cfset per = "#per#,'#Period#'">
	  <cfset peraccsel = "#peraccsel#,'#AccountPeriod#'"> 
  </cfif>
  
</cfloop>

<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Requisition" 
		   mission          = "#url.mission#"
		   programhierarchy = "#url.prghier#"
		   unithierarchy    = "#url.orghier#"
		   period           = "#per#" 
		   status           = "planned"
		   currency         = "#application.basecurrency#"
		   fund             = "#url.fund#"
		   Object           = "#url.objectCode#"
		   ObjectParent     = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "CreateView"
		   Table            = "vwListingForecast#SESSION.acc#">			

<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Requisition" 
		   mission          = "#url.mission#"
		   programhierarchy = "#url.prghier#"
		   unithierarchy    = "#url.orghier#"
		   period           = "#per#" 
		   status           = "cleared"
		   currency         = "#application.basecurrency#"
		   fund             = "#url.fund#"
		   Object           = "#url.objectCode#"
		   ObjectParent     = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "CreateView"
		   Table            = "vwListingRequisition#SESSION.acc#">	
		
<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Obligation" 
		   mission          = "#url.mission#"
		   programhierarchy = "#url.prghier#"
		   unithierarchy    = "#url.orghier#"
		   period           = "#per#" 
		   currency         = "#application.basecurrency#"
		   fund             = "#url.fund#"
		   Object           = "#url.objectCode#"
		   ObjectParent     = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "CreateView"
		   Table            = "vwListingObligation#SESSION.acc#">	
		   
<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Obligation" 
		   mission          = "#url.mission#"
		   programhierarchy = "#url.prghier#"
		   unithierarchy    = "#url.orghier#"
		   period           = "#per#" 
		   Scope            = "Unliquidated"
		   currency         = "#application.basecurrency#"
		   fund             = "#url.fund#"
		   Object           = "#url.objectCode#"
		   ObjectParent     = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "CreateView"
		   Table            = "vwListingUnliquidated#SESSION.acc#">		
		   
<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Disbursement" 
		   mission          = "#url.mission#"
		   programhierarchy = "#url.prghier#"
		   unithierarchy    = "#url.orghier#"
		   period           = "#per#" 
		   accountperiod    = "#peraccsel#"
		   currency         = "#application.basecurrency#"
		   fund             = "#url.fund#"
		   Object           = "#url.objectCode#"
		   ObjectParent     = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "CreateView"
		   Table            = "vwListingDisbursed#SESSION.acc#">				   		   	

<cfset table1   = "vwListingForecast#SESSION.acc#">	
<cfset table2   = "vwListingRequisition#SESSION.acc#">	
<cfset table3   = "vwListingObligation#SESSION.acc#">	
<cfset table4   = "vwListingUnliquidated#SESSION.acc#">	
<cfset table5   = "vwListingDisbursed#SESSION.acc#">	
