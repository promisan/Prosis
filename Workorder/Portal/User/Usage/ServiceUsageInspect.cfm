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
<cfparam name="url.mission" default="O">
<cfparam name="url.content" default="">

<!--- set defaults for the selection period --->

<cfparam name="url.year"  default="#year(now())#">
<cfparam name="url.month" default="#month(now())#">
<cfparam name="url.day"   default="">

<!--- keep the default selected month as passed for this client --->	

<cfset client.selectedmonth = url.month>			
<cfset client.selectedyear  = url.year>

<!--- ------------------------------------ --->

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">		
	SELECT    * 
	FROM      WorkorderLine 
	WHERE     WorkorderLineId = '#url.workorderlineid#'
</cfquery>

<cfif url.content eq "NonBillable">
    <cfset dbselect = "NonBillable">
<cfelse>
    <cfset dbselect = "">		
</cfif>

<cfquery name="getDates" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">		
	SELECT    TOP 1 YEAR(D.TransactionDate) AS Year, MONTH(D.TransactionDate) AS Month
	FROM      WorkOrderLineDetail#dbselect# AS D INNER JOIN
	          ServiceItemUnit AS U ON D.ServiceItem = U.ServiceItem AND D.ServiceItemUnit = U.Unit
	WHERE     D.WorkOrderId = '#get.workorderid#' 
	AND       D.WorkOrderLine = '#get.workorderline#'
	<cfif dbselect eq "">
	AND       D.ActionStatus != '9'
	</cfif>
	ORDER BY  TransactionDate DESC
	
</cfquery>

<!--- if there is no billable usage try with non-billable usage -> RTU mostly non-billable --->

<cfif getDates.recordcount eq "0" and dbselect eq "">

	<cfset dbselect = "NonBillable">
	<cfset url.content = "NonBillable">	

	<cfquery name="getDates" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">		
		
		SELECT    TOP 1 YEAR(D.TransactionDate) AS Year, MONTH(D.TransactionDate) AS Month
		FROM      WorkOrderLineDetail#dbselect# AS D INNER JOIN
		          ServiceItemUnit AS U ON D.ServiceItem = U.ServiceItem AND D.ServiceItemUnit = U.Unit
		WHERE     D.WorkOrderId   = '#get.workorderid#' 
		AND       D.WorkOrderLine = '#get.workorderline#'
		<cfif dbselect eq "">
		AND       D.ActionStatus != '9'
		</cfif>
		ORDER BY  TransactionDate DESC

	</cfquery>	
	
</cfif>

<cfif getDates.recordcount gt "0">

	<table cellpadding="0" cellspacing="0" border="0" height="100%" width="100%" style="padding-left:10px;padding-right:10px" >
	
	<tr id="filterme"><td style="padding-left:20px;padding-top:4px" height="20">
		
		<cfinvoke component = "Service.Presentation.TableFilter"  
		   method           = "tablefilterfield" 
		   filtermode       = "direct"
		   name             = "filter"
		   style            = "font:15px;height:24;width:140"
		   rowclass         = "filterrow"
		   rowfields        = "filtercontent">
	   		
	</td>
	
	</tr>
	
	<cfoutput>
	<script language="JavaScript">
		expandArea('myservices','inspect');		
	</script>
	</cfoutput>
	
	<tr>
		<td id="inspectlines" valign="top" style="padding-top:4px" style="height:100%">	
	
		<cfset url.year  = getDates.year>
		
		<cfif client.selectedmonth neq "" and client.selectedmonth neq "0">
			<cfset url.month = client.selectedmonth>
		<cfelse>
			<cfset url.month = getDates.month>
		</cfif>	       
	
		<!--- show the lines --->
		<cfinclude template="serviceUsageInspectLines.cfm">	
		
		</td>
	</tr>
		
	</table>
	
<cfelse>

	<cfoutput>
	
	<script language="JavaScript">
		<!---collapseArea('myservices','inspect');--->
		ColdFusion.navigate('ServiceUsageBodyBlank.cfm','body')
	</script>	
	
	</cfoutput>

</cfif>	
