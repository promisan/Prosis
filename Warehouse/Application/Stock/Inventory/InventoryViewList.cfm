
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
	<cfif url.earmark eq "false">
	AND      RequirementId = '00000000-0000-0000-0000-000000000000'
	</cfif>
		
	<cfif url.find neq "" and url.find neq "undefined">
	
	AND     (
	        	ItemDescription LIKE '%#url.find#%' OR
				ItemNo LIKE '%#url.find#%' OR
				TransactionReference LIKE '%#url.find#%' OR
				CategoryItemName LIKE '%#url.find#%' OR 
				ItemBarCode LIKE '%#url.find#%' OR
				UoMDescription LIKE '%#url.find#%' OR
				TransactionLot LIKE '%#url.find#%'
			)	
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
      id="forminventory<cfoutput>_#url.box#</cfoutput>">

<table width="100%" style="padding:6px;border:0px solid silver" bgcolor="fbfbfb">

	<tr><td style="padding:0px">
		
			<table width="100%" lign="center" class="navigation_table">
							
			<cf_tl id = "Standard"   var = "vStandard">
			<cf_tl id = "Strapping"  var = "vStrapping">
			<cf_tl id = "Depth"      var = "vDepth">
			<cf_tl id = "Celc"       var = "vCelc">
					
			<cfoutput query="list" group="ItemDescription">
			
			<cfoutput group="ItemNo">
						
			<tr bgcolor="f4f4f4" class="line clsFilterRow">
			<td><table>
				<tr class="labelmedium">
					<td class="ccontent" style="font-size:15px;padding-left:40px;min-width:70px;"><a href="javascript:locationitem('#itemLocationId#')">#ItemNo#</a></td>
					<td class="ccontent" style="height:26;font-size:15px">#ItemDescription#</td>
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
							
								<tr class="labelmedium line clsFilterRow">						
								<td style="padding-left:70px">
								   <table>
								   <tr>
									   <td style="font-size:13px;font-weight:400;min-width:200px">#TransactionLot#</td>
									   <td style="font-size:13px;font-weight:400;min-width:100px">#dateformat(Lot.TransactionLotDate,client.dateformatshow)#</td>
									   <td style="font-size:13px;font-weight:400;min-width:100px">#Lot.OrgUnitName#</td>
								   </tr>
								   </table>						  
								</td>
								<td class="ccontent hide">#ItemNo# #ItemDescription#</td>						
								</tr>
							
							</cfif>				
													
							<tr class="clsFilterRow">
							<td style="padding:0px">	
							
							   <cfoutput>													
							      <cfinclude template="InventoryViewListLine.cfm"> 
							   </cfoutput>						    
							
							</td>
							<td class="ccontent hide">#ItemNo# #ItemDescription#</td>
							</tr>	
							
						<cfelse>
						
							<cfset mylot = "">
						
							<cfoutput>			   
														
								<tr class="clsFilterRow">
								<td>															
								   <cfinclude template="InventoryViewListLine.cfm">														   
								</td>
								<td class="ccontent hide">#ItemNo# #ItemDescription#</td>
								</tr>		
													
							</cfoutput>
																				
						</cfif>
																				
				</cfoutput>	
				
				</cfoutput>
			
			</cfoutput>
							
			<cfoutput>
			
			<tr><td colspan="10" align="center">
				
				<table width="100%" cellspacing="0" cellpadding="0" align="center">
												
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
					  
					    <textarea name="description_#url.location#" 
							 id="description_#url.location#"				    
							 class="regular enterastab" 
							 totlength="400"
							 onkeyup="return ismaxlength(this)"					
							 style="padding:3px;font-size:13px;height:38;width:98%"></textarea>
	
				  	</td>			  	   
				</tr>
														
				<TR> 
				
		          <td colspan="2" height="30" align="center" id="#url.box#_#url.location#">
				  
				    <table cellspacing="0" cellpadding="0">
					<tr>					
					
					<cfif getAdministrator(warehouse.mission) eq "1">				
					
						<td style="padding-left:1px;height:40px">
							<button type="button" name="Submit" id="Submit" value="Submit" style="font-size:13px;height:24;width:140px" class="button10g" onclick="invsubmit('#url.location#','#url.category#','#url.categoryitem#','#url.systemfunctionid#','#url.box#','#url.parentItemNo#')"><cf_tl id="Submit"></button>
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
