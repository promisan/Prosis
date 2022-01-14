<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   WorkOrderLine  		
		WHERE  WorkOrderLineId = '#url.workorderlineid#'					
</cfquery>	

<cfquery name="Settlement" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineSettlement										
		WHERE   WorkOrderId      = '#get.Workorderid#'
		AND     WorkOrderLine    = '#get.WorkOrderLine#'
		AND     OrgUnitOwner     = '#orgunitowner#'		
		AND     TransactionDate  = '#TransactionDate#'
 </cfquery>										

<cfif settlement.recordcount eq "0">

<!---
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td align="center" class="labelit"><cf_tl id="no settlement recorded"></td></tr>
	</table>	
	--->

<cfelse>

	<table width="100%" class="navigation_table">
	
		<tr class="labelmedium line">			
			<td style="padding-left:15px;"><cf_tl id="Name"></td>	
			<td style="padding-left:15px;"><cf_tl id="Reference"></td>	
			<td style="padding-left:15px;"><cf_tl id="Code"></td>			
			<td style="padding-right:10px" align="right"><cf_tl id="Amount"></td>		
		</tr>
		
		<cfoutput query = "Settlement">		
			<tr class="labelmedium navigation_row line" style="height:23px">			   
			   <td style="padding-left:15px">#SettleCustomerName#</td>		
			   <td style="padding-left:15px"><cfif SettleReference eq "">n/a<cfelse>#SettleReference#</cfif></td>		
			   <td style="padding-left:15px">#SettleCode#</td>			  
			   <td style="padding-right:10px" align="right">#SettleCurrency# #numberformat(SettleAmount,',.__')#</td>
			</tr>			
		</cfoutput>
	
	</table>	

</cfif>			

<cfset ajaxOnLoad("doHighlight")>		