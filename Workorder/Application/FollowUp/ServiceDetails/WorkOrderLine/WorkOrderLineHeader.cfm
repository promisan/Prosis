
<cfquery name="getHeader" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT       W.WorkOrderId, W.Reference, W.Mission, W.ServiceItem, W.CustomerId, W.OrderDate, W.OrgUnitOwner, W.OrderMemo, W.Currency, W.ActionStatus, W.ListingOrder, W.ExternalLoad, C.OrgUnit, C.PersonNo, 
	             C.CustomerName, O.OrgUnitName, R.OrgUnitName AS ResponsibleName, O.Mission AS CustomerMission, S.Description AS ServiceItemName
	FROM         WorkOrder AS W INNER JOIN
	             Customer AS C ON W.CustomerId = C.CustomerId INNER JOIN
	             Organization.dbo.Organization AS O ON C.OrgUnit = O.OrgUnit INNER JOIN
	             Organization.dbo.Organization AS R ON W.OrgUnitOwner = R.OrgUnit INNER JOIN
	             ServiceItem AS S ON W.ServiceItem = S.Code
	WHERE        W.WorkOrderId = '#get.WorkOrderId#'
</cfquery>

<cfoutput>

<table width="96%" align="center" style="background-color:e4e4e4">
	
	<tr><td style="padding-left:10px;padding-right:10px">
		
		<table width="100%">

		<tr class="labelmedium2 fixlengthlist">
			 <td style="font-size:14px"><cf_tl id="Entity">:</td>
			 <td style="font-size:14px">#getheader.Mission#</td>
			 <td style="font-size:14px"><cf_tl id="Reference">:</td>
			 <td style="font-size:14px">#getheader.Reference#</td>
		 </tr>

		 <tr class="labelmedium2 fixlengthlist">
			 <td style="font-size:14px"><cf_tl id="Owner">:</td>
			 <td style="font-size:14px">#getheader.ResponsibleName#</td>
			 <td style="font-size:14px"><cf_tl id="Date">:</td>
			 <td style="font-size:14px">#dateformat(getheader.OrderDate,client.dateformatshow)#</td>
		 </tr>

		 <tr class="labelmedium2 fixlengthlist">
			 <td style="font-size:14px"><cf_tl id="Service">:</td>
			 <td style="font-size:14px">#getheader.ServiceItemName#</td>
			 <td style="font-size:14px"><cf_tl id="Reference">:</td>
			 <td style="font-size:14px">#getHeader.OrgUnitName#</td>
		 </tr>

		 <tr class="labelmedium2 fixlengthlist">
			 <td style="font-size:14px"><cf_tl id="Status">:</td>
			 <td style="font-size:14px">#getheader.ActionStatus#</td>
			 <td style="font-size:14px"><cf_tl id="Memo">:</td>
			 <td style="font-size:14px">#getHeader.OrderMemo#</td>
		 </tr>
			
		</table>
		
	</td></tr>
 
</table>
	
</cfoutput>	