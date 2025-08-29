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
<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrder
	WHERE    WorkOrderId   = '#url.workorderid#'	
</cfquery>	

<cfquery name="WorkorderReceivable" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrderGLedger
	WHERE     WorkOrderId = '#url.workorderid#'	
	AND       Area        = 'Receivable'
	AND       GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
</cfquery>  

<cfquery name="AdvanceJournal" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Journal
	WHERE     Mission   = '#workorder.mission#'	
	AND       Currency  = '#workorder.currency#'
	AND       TransactionCategory = 'Advances'	
</cfquery>  

<cfif WorkorderReceivable.recordcount eq "0" or AdvanceJournal.recordcount eq "0">

<table width="100%">
  <tr><td class="labelmedium" align="center" style="padding-top:10px"><font color="FF0000">Please check with your administrator to enable this function</td></tr>
</table>

<cfelse>

<table width="100%">
   <tr>
   <td id="content">
   <cfinclude template="PreBillingEntry.cfm"></td>
   </tr>
</table>

</cfif>