
	
<cf_screentop height="99%" label="Quotation #URL.RequestNo#" html="No" layout="webapp" jquery="Yes" scroll="No">

	<cfset url.scope = "Quote">
			
	<cfquery name="Clear"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		DELETE FROM CustomerRequestLine
		WHERE BatchId IS NOT NULL
		AND  Created < getDate()-2		
	</cfquery>
	
	<cfquery name="Clear"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		DELETE FROM CustomerRequest
		WHERE RequestNo NOT IN (SELECT RequestNO FROM CustomerRequestLine)
		AND  Created < getDate()-1		
	</cfquery>
			
	<cfquery name="Request"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM   CustomerRequest
		WHERE  Requestno = '#URL.Requestno#'
	</cfquery>
	
	<cfif Request.recordcount gte "1">
	
		<cfquery name="Parameter"
			datasource="AppsPurchase"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMission
			WHERE  Mission = '#Request.Mission#'
		</cfquery>
		
		<cfquery name="Param"
			datasource="AppsMaterials"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMission
			WHERE  Mission = '#Request.Mission#'
		</cfquery>
		
		<cfinclude template="../../Stock/StockControl/StockScript.cfm">
	
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
				 	document.getElementById('customerselect').value          = '#customer.customerserialno#' 											
					customertoggle('customerdata','#Request.customerid#','open','#Request.warehouse#','#Request.addressid#');									
					document.getElementById('customerdata_toggle').className = 'regular'		
					Prosis.busy('no')								 			
				}
			
			</script>
			
		</cfoutput>
						
		<cfquery name="Object" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   OrganizationObject
			WHERE  EntityCode = 'WhsQuote'
			AND    ObjectKeyValue1 = '#Request.RequestNo#'
			AND    Operational = 1
		</cfquery>
		
		<cf_textareascript>		
		<cf_layoutscript>
		<cf_dialogLedger>
				
		<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	  
		
		<cfoutput>
				
		<cf_layout attributeCollection="#attrib#">

			<cf_layoutarea 
		          position="header"
				  size="50"
		          name="controltop">	
				  
				<cf_ViewTopMenu label="Quotation #URL.RequestNo#" menuaccess="context" background="blue">
						
			</cf_layoutarea>		 
		
			<cf_layoutarea  position="left" name="box" collapsible="true" size="280" 
						splitter="true">
			
				<form name="quote" id="quote" style="width:100%;height:98%;padding-left:5px;padding-right:3px">
			
				<table style="width:96%" align="center" class="formpadding formspacing">
				
				<tr class="line labelmedium" style="height:40px">
				   <td style="font-size:20px"><cf_tl id="Quotation"></td>
				   <td align="right" style="padding-right:4px;font-size:25px">#url.requestNo#</td>
			    </tr>
				
				<tr><td style="height:10px"></td></tr>
				<tr class="labelmedium" style="height:20px">
				      <td><cf_tl id="Warehouse">:</td>
				      <td>#Request.Warehouse#</td>
				</tr>
				<tr class="labelmedium" style="height:20px">
				      <td><cf_tl id="Customer">:</td>
				      <td><a href="javascript:editCustomer('#customer.Customerid#')">#Customer.CustomerName#</a></td>
				</tr>
				<tr class="labelmedium" style="height:20px">
				      <td><cf_tl id="Address">:</td>
				      <td><cfif customerAddress.Address eq "">N/A<cfelse>#CustomerAddress.Address#</cfif></td>
				</tr>
				<tr class="labelmedium" style="height:20px">
				      <td><cf_tl id="Source">:</td>
				      <td>#Request.Source#</td>
				</tr>
				<tr class="labelmedium" style="height:20px">
				      <td><cf_tl id="Recorded">:</td>
				      <td>#Request.OfficerFirstName#</td>
				</tr>
				<tr class="labelmedium" style="height:20px">
				      <td><cf_tl id="Status">:</td>
				      <td><cfif Request.BatchNo neq ""><cf_tl id="Sold"><cfelse><cf_tl id="Pending"></cfif></td>
				</tr>
				<tr class="labelmedium" style="height:20px">
				      <td><cf_tl id="Time">:</td>
				      <td>#dateformat(Request.Created,client.dateformatshow)# #timeformat(Request.Created,"HH:MM")#</td>
				</tr>
				
								
				<tr class="labelmedium" style="height:20px">
				      <td colspan="2" style="font-weight:bold"><cf_tl id="About this request">:</td>				    
				</tr>
				
				<cfset apply = "ptoken.navigate('#session.root#/warehouse/application/salesOrder/Quote/setQuote.cfm?requestNo=#request.RequestNo#','process','','','POST','quote')">
				
				<cfif Request.BatchNo eq "">
				
					<tr class="labelmedium" style="height:20px">
				      <td><cf_tl id="Responsible">:</td>
				      <td>#Request.OfficerFirstName#</td>
					</tr>					
				
					<tr class="labelmedium" style="height:20px">
					      <td colspan="2">
						  
							  <table>
								  <tr>
									  <td><input type="radio" name="RequestClass" class="radiol" value="Quote" onclick="#apply#" <cfif Request.RequestClass eq "Quote">checked</cfif>></td>
									  <td style="padding-left:3px"><cf_tl id="Quote"></td>
									  <td style="padding-left:3px"><input type="radio" name="RequestClass" class="radiol" onclick="#apply#" value="QteReserve" <cfif Request.RequestClass eq "QteReserve">checked</cfif>></td>
									  <td style="padding-left:3px"><cf_tl id="Reservation"></td>
								  </tr>
							  </table>
						
						  </td>
					</tr>
				
				<cfelse>
				
					<tr class="labelmedium" style="height:20px">
				      <td><cf_tl id="Responsible">:</td>
				      <td>#Request.OfficerFirstName#</td>
					</tr>		
				
				      <input type="hidden" name="RequestClass" value="#Request.RequestClass#">
				
				</cfif>
				
				<tr class="labelmedium" style="padding-top:4px;height:20px">
				      <td colspan="2">
					  <textarea name="remarks" 
					  onchange="#apply#"
					  style="padding:5px;width:98%;font-size:14px;height:80px;background-color:ffffff">#Request.Remarks#</textarea>
					  </td>
				</tr>
				<tr class="hide"><td id="process"></td></tr>
				
				<cfif Request.BatchNo eq "">
						
				<tr class="labelmedium">
				      <td style="height:40px"><cf_tl id="Open">:</td>
				      <td>					 
					  <input type="button" name="Load" value="Load" class="button10g" 
					  onclick="Prosis.busy('yes');ptoken.navigate('#session.root#/warehouse/application/salesOrder/Quote/QuoteInit.cfm?systemfunctionid=#url.systemfunctionid#&scope=#url.scope#&requestNo=#url.requestNo#','content')">
					  </td>
				</tr>
				
				</cfif>
				
				</table>
				
				</form>		     
				 		
			</cf_layoutarea>	
			
			<cf_layoutarea  position="center" name="content">
			
				<cf_divscroll style="height:98%">		
			
				<cfif Request.BatchNo eq "">
						
					<cf_securediv style="height:99.0%" id="contentquote"
						  bind="url:#session.root#/warehouse/application/salesOrder/POS/Sale/SaleInit.cfm?systemfunctionid=#url.systemfunctionid#&scope=#url.scope#&mission=#Request.mission#&warehouse=#Request.warehouse#&requestNo=#url.requestNo#">
								  
				<cfelse>
		
					<cfset url.batchno = request.BatchNo>
					<cfset url.mode    = "embed">										
					<cfinclude template="../../Stock/Batch/BatchView.cfm">
											
				</cfif>	  
				
				</cf_divscroll>			
			
			</cf_layoutarea>	
			
			
			<cfif Object.recordcount gte "1">
						
				<cf_layoutarea 
					    position="right" 
						name="commentbox" 
						minsize="200" 
						maxsize="300" 
						size="380" 
						overflow="yes" 
						initcollapsed="yes"
						collapsible="true" 
						splitter="true">
					
						<cf_divscroll style="height:100%" minsize="20%" maxsize="30%" size="380" overflow="yes">
							<cf_commentlisting objectid="#Object.ObjectId#" ajax="No">		
						</cf_divscroll>
						
				</cf_layoutarea>	
			
			</cfif>
							
		</cf_layout>				
		
		</cfoutput>
		
	<cfelse>
	
		<table><tr><td>Not found</td></tr></table>		
	
	</cfif>
	