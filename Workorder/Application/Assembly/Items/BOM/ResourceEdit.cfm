
<cfparam name="url.scope" default="Service">

<cfoutput>
	
	<table width="100%" height="100%">
	
	<tr><td style="height:100%;width:100%" valign="top">
	
	<cf_getMID>
	
	<cfif url.scope eq "service">
	
		<iframe src="#session.root#/workorder/application/Assembly/Items/BOM/ResourceEditService.cfm?WorkOrderId=#url.workorderid#&WorkOrderLine=#url.workorderline#&ResourceId=#url.resourceid#&mid=#mid#" 
		   width="100%" height="99%" frameborder="0"></iframe>
		   
	<cfelse>
		
	    <iframe src="#session.root#/workorder/application/Assembly/Items/BOM/ResourceEditSupply.cfm?WorkOrderItemId=#url.WorkOrderItemId#&workorderitemidresource=#url.workorderitemidresource#&itemNo=#url.itemno#&uom=#url.uom#&mid=#mid#" 
		  width="100%" height="99%" frameborder="0"></iframe>
	
	</cfif>
		
	</td></tr>
	
	</table>
	
</cfoutput>
