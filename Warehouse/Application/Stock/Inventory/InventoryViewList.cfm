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
<cfparam name="url.parentItemNo" default="">
<cfparam name="url.refresh"      default="1">
<cfparam name="url.earmark"      default="false">
<cfparam name="url.find"         default="">

<!--- correction for the time in the warehouse --->

<cfparam name="url.Transaction_date"   default="#dateformat(now(),client.dateformatshow)#">
<cfparam name="url.Transaction_hour"   default="#timeformat(now(),'h')#">
<cfparam name="url.Transaction_minute" default="#timeformat(now(),'n')#">

<cfset date = evaluate("url.transaction_date")>	
<cfset hour = evaluate("url.transaction_hour")>	
<cfset minu = evaluate("url.transaction_minute")>	

<CF_DateConvert Value = "#date#">
<cfset dte = dateValue>		

<cfset dte = DateAdd("h","#hour#", dte)>
<cfset dte = DateAdd("n","#minu#", dte)>

<cf_getWarehouseTime warehouse="#url.warehouse#">

<cfset dte = DateAdd("h",tzcorrection*-1, dte)>

<cfquery name="check"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   * 
	FROM     userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc# P
	WHERE    Warehouse    = '#URL.Warehouse#'
	AND      Location     = '#URL.Location#'
	AND      Category     = '#url.category#'
	AND      CategoryItem = '#url.categoryitem#'
	<cfif URL.parentItemNo neq "">
	AND      ParentItemNo = '#URL.parentItemNo#'
	</cfif>	
	
</cfquery>	

<!--- we refresh if no records found or it is disabled --->

<cfif url.refresh eq "1" or check.recordcount eq "0">
	<cfinclude template="getInventoryData.cfm">	
</cfif>

<cfif url.find eq "undefined">
 <cfset url.find = "">
</cfif>

<cfquery name="Warehouse"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   * 
	FROM     Warehouse
	WHERE    Warehouse = '#URL.Warehouse#'		
</cfquery>

<cfif warehouse.LocationReceipt eq url.location>
	<cfset locationReceipt = "1">
<cfelse>
	<cfset locationReceipt = "0">	
</cfif>

<cfquery name="List"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   * 
	FROM     userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc# P
	WHERE    Warehouse    = '#URL.Warehouse#'
	AND      Location     = '#URL.Location#'
	AND      Category     = '#url.category#'
	AND      CategoryItem = '#url.categoryitem#'
	<cfif URL.parentItemNo neq "">
	AND      ParentItemNo = '#URL.parentItemNo#' 
	</cfif>	
	<cfif URL.Lot neq "">
	AND      TransactionLot = '#URL.lot#' 
	</cfif>
	<cfif url.earmark eq "false">
	AND      RequirementId = '00000000-0000-0000-0000-000000000000'
	</cfif>
		
	<cfif url.find neq "" and url.find neq "undefined">
	
	AND     (
	        	ItemDescription      LIKE '%#url.find#%' OR
				ItemNo               LIKE '%#url.find#%' OR
				TransactionReference LIKE '%#url.find#%' OR
				CategoryItemName     LIKE '%#url.find#%' OR 
				ItemBarCode          LIKE '%#url.find#%' OR
				UoMDescription       LIKE '%#url.find#%' OR
				TransactionLot       LIKE '%#url.find#%'
			)	
	</cfif>
	
	<!--- prevent adding stock to receipt location --->
	<cfif LocationReceipt eq "1" and URL.Lot eq "">
	AND     abs(OnHand) > 0.002 
	</cfif>
	
	ORDER BY Category,
	         CategoryItemName,
			 ItemDescription,
			 TransactionLot,
			 WorkOrderId  <!--- first the onhand option --->
			 
</cfquery>

<!---
<cfoutput>query show: #cfquery.executiontime#</cfoutput>
--->

<form method="post"
      name="forminventory<cfoutput>_#url.box#</cfoutput>"
      id="forminventory<cfoutput>_#url.box#</cfoutput>" 
	  style="padding:0px; margin:0px;">

<table width="100%" style="padding:6px;border:0px solid silver" bgcolor="fbfbfb">

	<tr><td>
		
	<table width="100%" border="0" align="center" class="navigation_table">

		    <tr class="labelmedium2 fixrow3 clsFilterRow">
			   <td style="min-width:26px;top:53px"></td>			  
			   <td style="min-width:110px;top:53px"><cf_tl id="Roll"></td>	
			   <td style="min-width:200px;top:53px"><cf_tl id="Earmarked"></td>   <!--- earmark --->			  		   		  			   
			   <td style="min-width:100px;top:53px"><cf_tl id="Barcode"></td>
			   <td style="min-width:20px;top:53px"></td>
			   <td style="min-width:100px;top:53px"><cf_tl id="Mode"></td>  
			   <td style="min-width:100px;top:53px"><cf_tl id="UoM"></td>   
			   <td style="min-width:100px;top:53px" align="right"><cf_tl id="On Hand"></td>
			   <td style="min-width:100px;top:53px" align="right"><cf_tl id="Measurement"></td>
			   <td style="min-width:100px;padding-right:5px;top:53px" align="right"><cf_tl id="Result"></td>				   
			</tr>	
							
			<cf_tl id = "Standard"   var = "vStandard">
			<cf_tl id = "Strapping"  var = "vStrapping">
			<cf_tl id = "Depth"      var = "vDepth">
			<cf_tl id = "Celc"       var = "vCelc">
					
			<cfoutput query="list" group="ItemDescription">
			
			<cfoutput group="ItemNo">
						
			<tr bgcolor="e6e6e6" class="line clsFilterRow">
			
			<td colspan="10"><table>
				<tr class="labelmedium2">
					<td style="padding-left:10px;font-size:15px;min-width:60px;"><a href="javascript:locationitem('#itemLocationId#')" class="ccontent">#ItemNo#</a></td>
					<td style="font-size:16px" class="ccontent">#ItemDescription# <cfif ItemNoExternal neq "">/ #itemNoExternal#</cfif> <font style="cursor:hand" title="parent item" size="1">#ParentItemNo#</font></td>
					<td style="display:none;" class="ccontent">#ItemBarCode#</td>
					<td style="display:none;" class="ccontent">#ItemDescription#</td>
					<td style="display:none;" class="ccontent">#itemNoExternal#</td>
				</tr>
				</table>
			</td></tr>
										
			<cfoutput group="TransactionLot">
				
					<cfif TransactionLot neq "0" and TransactionLot neq "">		
					
						<cfif url.earmark eq "false">
						
							<cfsavecontent variable="myLot">#TransactionLot#</cfsavecontent>
						
						<cfelse>
												
							<cfquery name="Lot"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   *, (SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = L.OrgUnitVendor) as OrgUnitName
								FROM     ProductionLot L
								WHERE    Mission        = '#Warehouse.Mission#'		
								AND      TransactionLot = '#TransactionLot#'
							</cfquery>
						
							<tr class="fixlengthlist labelmedium2 line clsFilterRow" style="height:20px;background-color:BCFAC7">						
								<td colspan="10">
								   <table>
								   <tr class="labelmedium2 fixlengthlist" style="height:20px;background-color:BCFAC7">
									   <td style="padding-left:8px"><b>LOT</b>:&nbsp;#TransactionLot#</td>
									   <td>#dateformat(Lot.TransactionLotDate,client.dateformatshow)#</td>
									   <td>#Lot.OrgUnitName#</td>
								   </tr>
								   </table>						  
								</td>
								<td class="ccontent hide">#ItemNo#</td>
								<td class="ccontent hide">#ItemDescription# #ItemBarCode# #itemNoExternal# #transactionlot#</td>						
							</tr>
						
						</cfif>		
																			
						<cfoutput>	
														
							<!--- item --->										
							<cfif onhand lt -0.005>
								<cfset color = "FED7CF">
							<cfelse>
								<cfset color = "transparent">
							</cfif>
							
							<cfif url.zero eq "true" and abs(onhand) lte "0.01">					
							   <cfset cl="hide">					
							<cfelse>					
							   <cfset cl="regular">										
							</cfif>			
							
						   <tr bgcolor="#color#" class="fixlengthlist #cl# clsFilterRow navigation_row line <cfif abs(onhand) lte "0.02">zero<cfelse>standard</cfif>">	
						   								
						       <cfinclude template="InventoryViewListLine.cfm"> 
							   <td class="ccontent hide">#ItemNo#</td>
							   <td class="ccontent hide">#ItemDescription#</td>
							   <td class="ccontent hide">#ItemNoExternal# #transactionlot# #ItemBarCode#</td>	
							</tr>	
							
							<tr id="locarc#url.box#_#currentrow#_box" class="hide">		
							    <td id="locarc#url.box#_#currentrow#" class="hide" align="center" colspan="10"></td>
							</tr>	
							
						</cfoutput>					
						
					<cfelse>
					
						<cfset mylot = "">
					
						<cfoutput>																	
															
							<!--- item --->										
							<cfif onhand lt -0.005>
								<cfset color = "FED7CF">
							<cfelse>
								<cfset color = "transparent">
							</cfif>
							
							<cfif url.zero eq "true" and abs(onhand) lte "0.01">					
							   <cfset cl="hide">					
							<cfelse>					
							   <cfset cl="regular">										
							</cfif>			   
													
							<tr bgcolor="#color#" class="fixlengthlist #cl# clsFilterRow navigation_row line <cfif abs(onhand) lte "0.02">zero<cfelse>standard</cfif>">																		  				
							   <cfinclude template="InventoryViewListLine.cfm">	
							   <td class="ccontent hide">#ItemNo#</td>			
							   <td class="ccontent hide">#ItemNoExternal#</td>											   
							   <td class="ccontent hide">#ItemDescription#</td>
							</tr>		
							
							<tr id="locarc#url.box#_#currentrow#_box" class="hide">		
							    <td id="locarc#url.box#_#currentrow#" class="hide" align="center" colspan="10"></td>
							</tr>	
												
						</cfoutput>
																			
					</cfif>
																			
			</cfoutput>	
				
			</cfoutput>
			
			</cfoutput>
							
			<cfoutput>
			
			<tr class="clsFilterRow"><td colspan="10" align="center">

				<table width="100%" align="center">

				<!--- kherrera (10/06/2020): allows show the submit button when searching --->
				<tr style="display:none;">
					<td>
						<cfloop query="list">
							<div style="display:none;" class="ccontent">#ItemNo#</div>
						</cfloop>	
						<cfloop query="list">
							<div style="display:none;" class="ccontent">#ItemDescription#</div>
						</cfloop>
						<cfloop query="list">
							<div style="display:none;" class="ccontent">#ItemBarCode#</div>
						</cfloop>
						<cfloop query="list">
							<div style="display:none;" class="ccontent">#ItemNoExternal#</div>
						</cfloop>
					</td>	
				</tr>
												
				<tr class="hide">
				
					<td width="80" class="labelit" style="padding-left:8px"><cf_tl id="Date/Time">:</td>
					<td>
					
					 <cf_getWarehouseTime warehouse="#url.warehouse#">
					 					 					
					 <cf_setCalendarDate
					      name       = "transaction_#url.location#"        
					      timeZone   = "#tzcorrection#"    
						  value      = "#dateformat(dte,client.dateformatshow)#" 
						  valuehour  = "#timeformat(dte,'HH')#"
						  valueminu  = "#timeformat(dte,'MM')#"
					      font       = "14"
						  edit       = "Yes"
						  class      = "regular"				  
					      mode       = "datetime"> 
						  
					</td>				  
						  
				</tr>	
				
				<tr> 				    
			        <td colspan="2" valign="top" class="labelit" style="padding-top:5px;padding-left:2px"><cf_tl id="Memo">:</TD>
				</tr>
				<tr>	
			        <td colspan="2" align="left" width="97%" style="padding:2px;padding-left:2px">
					  
					    <textarea name  = "description_#url.location#" 
							      id    = "description_#url.location#"				    
							      class = "regular enterastab" 
							      totlength="400"
							      onkeyup="return ismaxlength(this)"					
							      style="padding:3px;font-size:14px;height:38;width:98%"></textarea>
	
				  	</td>			  	   
				</tr>
														
				<TR> 
				
		          <td colspan="2" height="30" align="center" id="#url.box#_#url.location#">
				  
				    <table>
					<tr>					
					
					<cfif getAdministrator(warehouse.mission) eq "1">				
					
						<td style="padding-left:1px;height:40px">
							<button type="button" name="Submit" id="Submit" value="Submit" style="font-size:13px;height:24;width:140px" 
							   class="button10g" 
							   onclick="invsubmit('#url.location#','#url.category#','#url.categoryitem#','#url.systemfunctionid#','#url.box#','#url.parentItemNo#')">
							   <cf_tl id="Submit"></button>
						</td>							
					
					<cfelse>
					
						<cfquery name="Access"
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   MAX(AccessLevel) as AccessLevel
							FROM     OrganizationAuthorization
							WHERE    UserAccount    = '#SESSION.acc#'
							AND      Role           = 'WhsPick'
							AND      ClassParameter = '#url.systemfunctionid#' 
							AND      Mission        = '#warehouse.mission#'	
						</cfquery>	
						
						<cfif Access.AccessLevel eq "2">				
						
						<td style="padding-left:1px;height:40px">
							<button type="button" name="Submit" id="Submit" value="Submit" style="font-size:13px;height:24;width:120px" class="button10g" 
							    onclick="invsubmit('#url.location#','#url.category#','#url.categoryitem#','#url.systemfunctionid#','#url.box#','#url.parentItemNo#')">
								<cf_tl id="Submit">
							</button>
						</td>
						
						</cfif>		
					
					</cfif>						
					
					</tr>
					</table>
			  	  </td>			  	   
				</TR>
			  
			  </table>
					  
			  </td>
			</tr>
			
			</cfoutput>
			
			</table>
		
	</td>
	</tr>
	
</table>

</form>

<cfoutput>
<script>
    try {
	document.getElementById('filter#url.box#').className = "regular"
	} catch(e) {}
	Prosis.busy('no');
</script>
</cfoutput>

<cfset ajaxonload("doHighlight")>
