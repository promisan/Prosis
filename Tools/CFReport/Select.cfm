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
<head>
    <title>Open report selection screen</title>
    <!--- correction on the selection for CF ajax --->
    <script src="HTML/fixColdfusionAjax.js"></script>
	<cfajaximport tags="cfform,cfdiv">
	<cfoutput>
	<link rel="stylesheet" type="text/css" src="#SESSION.root#/#client.style#">
	</cfoutput>	
</head>

<cfif Report.FunctionClass eq "System">
	
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Crit">
		
		<cfquery name="VariantDefaults" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT *
			 INTO   userQuery.dbo.#SESSION.acc#Crit
			 FROM   UserReportCriteria 
			 WHERE  ReportId = '#URL.Id#' 
		</cfquery>
	
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Defaults">
	
	<cfquery name="GlobalDefaults" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT    UC.*
		 INTO      userQuery.dbo.#SESSION.acc#Defaults
		 FROM      UserReportCriteria UC INNER JOIN
		           UserReport U ON UC.ReportId = U.ReportId INNER JOIN
		           Ref_ReportControlLayout RL ON U.LayoutId = RL.LayoutId INNER JOIN
		           Ref_ReportControl R ON RL.ControlId = R.ControlId
		 WHERE     U.Account = '#SESSION.acc#' 
		 AND       R.SystemModule = '#Report.SystemModule#' 
		 AND       U.Status = '6'
	</cfquery>

</cfif>
 
<cfquery name="Report" 
 datasource="AppsSystem" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ReportControl
	 WHERE  ControlId = '#URL.ID#' 
</cfquery>

<cfif Report.recordcount eq "1" and url.context neq "Subscription">

	<cfset SelDistributionSubject = "#Report.FunctionName#">
	<cfloop index="day" from="1" to="7">
		<cfparam name="SelDistribution#Day#" default="0">
	</cfloop>
			
	<cfset controlId = "#URL.ID#">
	<cfset reportId  = "00000000-0000-0000-0000-000000000000">
	
<cfelseif url.context eq "Subscription">
	
	<cfquery name="Report" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT  U.*, R.* 
		     FROM    UserReport U INNER JOIN
		             Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId INNER JOIN
		             Ref_ReportControl R ON L.ControlId = R.ControlId
			 WHERE   U.ReportId = '#reportid#' 
		</cfquery>
				
		
		<cfset controlid   = "#Report.ControlId#">
		<cfset reportId    = "#reportid#">
		
				 		
<cfelse>  

	<!--- user must have selected his variant --->

	<cfquery name="Report" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  U.*, R.* 
	     FROM    UserReport U INNER JOIN
	             Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId INNER JOIN
	             Ref_ReportControl R ON L.ControlId = R.ControlId
		 WHERE   U.ReportId = '#URL.ID#' 
	</cfquery>
			
	<cfset controlid   = "#Report.ControlId#">
	<cfset reportId    = "#URL.ID#">
				
</cfif> 

<cfif Report.FunctionClass eq "System">	

    <cfset format = "HTML">
	<cfinclude template="HTML/FormHTMLSystem.cfm">
	
<cfelse>
	
  	<cfset format = "HTML">			
	<cfinclude template="#Format#/Form#format#.cfm">
	
</cfif>	

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Defaults">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Crit">
