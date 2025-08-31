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
<cfif url.content eq "NonBillable">
	    <cfset dbselect = "NonBillable">
<cfelse>
	    <cfset dbselect = "">		
</cfif>

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">		
	SELECT    * 
	FROM      WorkorderLine 
	WHERE     WorkorderLineId = '#url.workorderlineid#'
</cfquery>

<cfquery name="getCalls" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">		
	SELECT    *
	FROM      WorkOrderLineDetail#dbselect# 
	WHERE     WorkOrderId   = '#get.workorderid#' 
	AND       WorkOrderLine = '#get.workorderline#'
	AND       year(TransactionDate)  = '#url.year#'
	AND       month(TransactionDate) = '#url.month#'	
	AND       day(TransactionDate)   = '#url.day#'	
	
	<cfif url.ref neq "">
	AND       Reference LIKE ('%#url.ref#%')	
	</cfif>		
	
	<cfif dbselect eq "">
	AND      ActionStatus != '9'
	</cfif>
</cfquery>


<cfset sel=CreateDate(URL.year,URL.month,URL.Day)>

<table align="center" cellspacing="2" cellpadding="2">
<tr>
<td class="labelit">
<cfoutput>
  #dateformat(sel,"DDDD #CLIENT.DateFormatShow#")#
</cfoutput>	
</td>
</tr>
<tr>
<td class="labelit">
<cfoutput>
  Total of traffic: <b>#getCalls.recordcount#</b>
</cfoutput>	
</td>
</tr>
</table>
