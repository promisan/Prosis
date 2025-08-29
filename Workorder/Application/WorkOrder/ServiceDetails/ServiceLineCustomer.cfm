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
<cfparam name="url.customerid" default="">

<cfquery name="WorkOrder" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrder
		 WHERE   WorkOrderId       = '#url.workorderid#'
</cfquery>

<cfif url.CustomerId neq "">
		
	<cfquery name="Customer" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Customer
		WHERE  CustomerId = '#url.customerid#'	
	</cfquery>
	
<cfelse>
	
	<cfquery name="Customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Customer
		WHERE  CustomerId = '#workorder.customerid#'	
	</cfquery>
	
</cfif>

<table width="300" cellspacing="0" cellpadding="0">


    <tr><td>
	
	<cfoutput query="Customer">
		<input type="hidden" name="Customerid" id="Customerid" value="#Customer.CustomerId#">		
	</cfoutput>
	
	</td>

	<td style="padding-left:3px;padding-top:1px;padding-bottom:1px;height:25px;border-left: 1px solid Silver;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
	<cfoutput query="Customer">
	#Customer.CustomerName#
	</cfoutput>
	</td>
	
</tr></table>
