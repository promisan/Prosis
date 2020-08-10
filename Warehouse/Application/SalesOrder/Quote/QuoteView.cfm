		
<cf_screentop height="99%" label="Quotation" jquery="Yes" html="No" scroll="No">
	
	<cfquery name="Parameter"
		datasource="AppsPurchase"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
	</cfquery>
	
	<cfquery name="Param"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
	</cfquery>
	
	<cfinclude template="../../Stock/StockControl/StockScript.cfm">
	
	<cfquery name="Request"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM   CustomerRequest
		WHERE  Requestno = '#URL.Requestno#'
	</cfquery>
	
	<cfquery name="Customer"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Customer
		WHERE  CustomerId = '#Request.CustomerId#'
	</cfquery>
				
	<cfquery name="CustomerAddress"
		datasource="AppsSystem"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Address
		WHERE  AddressId = '#Request.AddressId#'
	</cfquery>
	
	<cfoutput>
	
		<script>		
			function setSaleQuote() {
			    document.getElementById('trarequestno').innerHTML        = '#Request.requestno#'				
			 	document.getElementById('customerselect').value          = '#customer.reference#' 											
				customertoggle('customerdata','#Request.customerid#','open','#Request.warehouse#','#Request.addressid#');									
				document.getElementById('customerdata_toggle').className = 'regular'		
				Prosis.busy('no')								 			
			}
		
		</script>
		
	</cfoutput>
		
	<cfoutput>		
	
	<table style="width:100%;height:100%">
	
	<tr>
	<td style="background-color:ffffff;min-width:230px;padding:7px" valign="top">

	<table style="width:100%">
	<tr class="line labelmedium">
	   <td style="font-size:20px"><cf_tl id="Quotation"></td>
	   <td align="right" style="padding-right:4px;font-size:25px">#url.requestNo#</td>
    </tr>
	<tr class="labelmedium">
	      <td><cf_tl id="Warehouse">:</td>
	      <td>#Request.Warehouse#</td>
	</tr>
	<tr class="labelmedium">
	      <td><cf_tl id="Requester">:</td>
	      <td>#Request.OfficerLastName#</td>
	</tr>
	<tr class="labelmedium">
	      <td><cf_tl id="Address">:</td>
	      <td>#CustomerAddress.Address#</td>
	</tr>
	<tr class="labelmedium">
	      <td><cf_tl id="Source">:</td>
	      <td>#Request.Source#</td>
	</tr>
	<tr class="labelmedium">
	      <td><cf_tl id="Recorded">:</td>
	      <td>#Request.OfficerFirstName#</td>
	</tr>
	<tr class="labelmedium">
	      <td><cf_tl id="Time">:</td>
	      <td>#dateformat(Request.Created,client.dateformatshow)# #timeformat(Request.Created,"HH:MM")#</td>
	</tr>
	<tr class="labelmedium">
	      <td><cf_tl id="Load">:</td>
	      <td><input type="button" name="Load" value="Load" class="button10g" 
		  onclick="Prosis.busy('yes');ptoken.navigate('#session.root#/warehouse/application/salesOrder/POS/Sale/SaleInit.cfm?systemfunctionid=#url.systemfunctionid#&scope=#url.scope#&mission=#url.mission#&warehouse=#url.warehouse#&requestNo=#url.requestNo#','quote')">
		  </td>
	</tr>
	</table>
	
	</td>
	<td style="width:100%;padding:8px;padding-bottom:0px;height:100%" valign="top">
	
	<cf_divscroll style="width:100%">
		<cf_securediv style="height:99.0%;border:1px solid gray" id="quote"
		  bind="url:#session.root#/warehouse/application/salesOrder/POS/Sale/SaleInit.cfm?systemfunctionid=#url.systemfunctionid#&scope=#url.scope#&mission=#url.mission#&warehouse=#url.warehouse#&requestNo=#url.requestNo#">
		  
	</cf_divscroll>
	
	</td>
	</tr>
	</table>
	
	</cfoutput>
	