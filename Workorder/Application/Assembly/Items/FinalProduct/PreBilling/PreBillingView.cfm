
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