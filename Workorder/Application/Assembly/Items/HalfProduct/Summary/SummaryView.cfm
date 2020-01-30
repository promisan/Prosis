
<!--- clean items --->

<cfquery name="workorder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE  WorkOrderLineItem 
	FROM    WorkOrderLineItem I
	WHERE     UoM NOT IN
                    (SELECT   UoM
                     FROM     Materials.dbo.ItemUoM
                     WHERE    ItemNo = I.ItemNo)
	AND     WorkOrderId = '#url.workorderid#'							
</cfquery>							

<cfquery name="workorder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId  = '#url.workorderid#'	
</cfquery>


<cfoutput>
<table height="100%" width="98%" align="center">

<tr><td height="20" style="padding-top:4px" class="labellarge"><cf_tl id="Production recapitulation in"> #application.BaseCurrency#</td></tr>

<tr><td class="line"></td></tr>

<tr><td height="100%">

    <cf_divscroll>

	<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr><td width="50%" valign="top" style="padding:15px">
		<cfinclude template="PlanningView.cfm">
		</td>
		<td style="border-left:1px solid silver;padding:15px" width="50%" valign="top">
		<cfinclude template="ActualsView.cfm">
		</td>
	</tr>	
	</table>	
	
	</cf_divscroll>
	

</td></tr>

</table>

</cfoutput>
