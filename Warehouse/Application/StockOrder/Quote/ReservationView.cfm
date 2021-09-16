
<!--- requested view --->

<cfif url.mode eq "request">

<cfquery name="myRequest"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT        vw.Mission, 
	              vw.ActionStatus,
				  vw.RequestNo, 
				  vw.RequestClass, 
				  vw.CustomerId, 
				  C.CustomerName, 
				  C.CustomerSerialNo, 
				  vw.AddressId, 
				  vw.Warehouse, 
				  vw.ItemNo, 
				  vw.ItemClass, 
				  vw.ItemDescription, 
				  I.ItemPrecision,	
				  vw.ItemCategory, 
	              vw.TransactionUoM, 
				  vw.TransactionQuantity, 
				  vw.Source, 
				  vw.OfficerUserId, vw.OfficerLastName, vw.OfficerFirstName, vw.Created 
				  
	FROM          vwCustomerRequest AS vw LEFT OUTER JOIN
	              Customer AS C ON vw.CustomerId = C.CustomerId INNER JOIN
				  Item I ON vw.ItemNo = I.ItemNo
	WHERE         vw.ItemNo         = '#url.itemno#'
	AND           vw.TransactionUoM = '#url.Uom#'
	AND           vw.Warehouse      = '#url.warehouse#'
	AND           vw.BatchNo IS NULL 
	AND           vw.RequestClass = 'QteReserve' 
	AND           vw.ActionStatus = '1'
			
	<!--- Hanno 10/9/2021 once the real workorder is reserved 
	    we need to reset the quote to release the request --->
	
</cfquery>

<table width="97%" align="center" class="navigation_table">

<tr class="labelmedium2">
   <td><cf_tl id="Request"></td> 
   <td><cf_tl id="Customer"></td>
   <td><cf_tl id="Officer"></td>
   <td><cf_tl id="Date"></td>
   <td align="right"><cf_tl id="Quantity"></td>   
</tr>

<tr class="labelmedium2"><td style="font-size:20px" colspan="5"><cf_tl id="Reservation"></td></tr>

<tr class="labelmedium2"><td style="font-size:20px" colspan="5"><cf_tl id="Requested"></td></tr>

<cfoutput query="myRequest">
	
	<tr class="labelmedium2 navigation_row line">
	   <td style="padding-left:4px">#RequestNo#</td> 
	   <td>#CustomerName#</td>
	   <td>#OfficerLastName#</td>
	   <td>#dateformat(Created, client.dateformatshow)#</td>
	   <cf_precision precision="#ItemPrecision#">	
	   <td style="text-align:right;padding-right:4px">#numberformat(transactionQuantity,'#pformat#')#</td>   
	</tr>

</cfoutput>

<tr><td></td></tr>

</table>

</cfif>

<cfset ajaxonload("doHighlight")>
<!--- reserved view --->