
<!--- show the related requisition lines --->

<cfparam name="url.workorderid"   default="00000000-0000-0000-8802-00A5BD1E28A6">
<cfparam name="url.workorderline" default="349">

<cfquery name="Mission" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT Mission
		FROM WorkOrder
		WHERE WorkOrderId = '#URL.WorkOrderId#'
</cfquery>		

<cfquery name="Procurement" 
	datasource="AppsPurchase"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   L.*, left(RequestDescription,40) as RequestDescriptionShort, R.Description as ItemMasterName,
		         (SELECT count(*)
				  FROM   RequisitionLineTopic T, Ref_Topic S
				  WHERE  T.Topic = S.Code
				  AND    S.Operational   = 1
				  AND    T.RequisitionNo = L.RequisitionNo) as Topics	
		
	    FROM     RequisitionLine L, ItemMaster R
		WHERE    L.Mission          = '#Mission.Mission#'	
		AND      L.RequirementId    = '#url.workorderitemid#'
		AND      L.ItemMaster = R.Code
		AND      ActionStatus >= '1' and ActionStatus != '9'
</cfquery>

<table width="100%" class="navigation_table">
	
	<cfoutput query="Procurement">
	
	<tr class="labelmedium2 line navigation_row">
		<td style="padding-left:4px" width="20"><cf_img icon="open" onclick="ProcReqEdit('#requisitionno#','workorder','#workorderitemid#')"></td>
		<td>#ItemMasterName#</td>
		<td>#Reference#</td>		
		<td align="right">#RequestQuantity#</td>
		<td align="right" style="padding-right:4px">#numberformat(RequestAmountBase,",.__")#</td>
	</tr>	
	
	<cfif topics gte "1">
	<tr><td></td>
	    <td colspan="4" bgcolor="ffffdf" style="padding:4px">
		<cf_getRequisitionTopic RequisitionNo = "#RequisitionNo#">
	    </td>
	</tr>
	</cfif>
	
	</cfoutput>

</table>

<cfset ajaxOnLoad("doHighlight")>


