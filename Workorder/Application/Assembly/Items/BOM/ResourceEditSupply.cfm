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
<cf_tl id="Raw material" var="lblFinal">

<cfparam name="URL.Mode" default="Edit">
<cfparam name="URL.workOrderItemIdResource" default="">

<cfquery name="FinishedProduct" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineItem
		WHERE   WorkOrderItemId = '#URL.workOrderItemId#'	
</cfquery>	

<cfquery name="FinishedProductName" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Item I INNER JOIN ItemUoM U ON I.ItemNo = U.ItemNo 
		WHERE	I.ItemNo = '#FinishedProduct.itemno#'				
		AND     U.UoM    = '#FinishedProduct.Uom#'
</cfquery>

<cfif URL.workOrderItemIdResource neq "">

	<cfquery name="GetWOIR" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  WR.WorkOrderItemId, WR.ResourceItemNo, WR.ResourceUoM
		FROM    WorkOrderLineItemResource WR LEFT OUTER JOIN
				Organization.dbo.Organization O ON 
				O.OrgUnit = WR.OrgUnit 
		WHERE   WorkOrderItemIdResource = '#URL.workOrderItemIdResource#'	
	</cfquery>	

	<cfset URL.WorkOrderItemId 	= GetWOIR.WorkOrderItemId>
	<cfset URL.ItemNo 			= GetWOIR.ResourceItemNo>
	<cfset URL.UoM    			= GetWOIR.ResourceUoM>	

</cfif>

<cfquery name="WorkOrder" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    WorkOrder
			WHERE   WorkOrderId = '#FinishedProduct.workOrderId#'	
	</cfquery>	

<cfif url.itemNo eq "">

	<cf_tl id="Add BOM item" var="1">
	
	<cf_screentop height="100%" 
			scroll="Yes" 
			layout="webapp" 
			label="#lblFinal#" 			
			banner="green"
			JQuery="yes">
	
<cfelse>
	
	<cf_tl id="Edit BOM item" var="1">
	
	<cf_screentop height="100%" 
			scroll="Yes" 
			layout="webapp" 
			label="BOM: #FinishedProductName.ItemDescription# #FinishedProductName.UoMDescription#" 
			option="#lt_text#" 
			banner="green"
			JQuery="yes">
	
</cfif>

<cfajaximport tags="cfdiv,cfform">

<cf_tl id="Select a valid item and uom" var="msgItemReq">

<cfoutput>

	<script language="JavaScript">
		
		function validate() {		
			document.frmResource.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
	        	ptoken.navigate('ResourceEditSupplySubmit.cfm?workorderitemid=#url.workorderitemid#&workorderitemidresource=#url.workOrderItemIdResource#','process','','','POST','frmResource')
			}			
		}
	
		function selectresourceitem(itm,mis) {						  
			ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/BOM/getItem.cfm?mission='+mis+'&mode=item&itemNo='+itm+'&workorderitemid=#url.workOrderItemId#','itembox')
		}
		
	</script>

</cfoutput>
	
<cfquery name="Get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  WR.*, O.OrgUnitName
	FROM    WorkOrderLineItemResource WR LEFT OUTER JOIN
			Organization.dbo.Organization O ON 
			O.OrgUnit = WR.OrgUnit 
	<cfif URL.WorkOrderItemIdResource neq "">				
	WHERE   WorkOrderItemIdResource  = '#url.WorkOrderItemIdResource#'
	<cfelse>
	WHERE   1=0
	</cfif>		
</cfquery>

<cfquery name="GetItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Item I 
			INNER JOIN ItemUoM U ON I.ItemNo = U.ItemNo
	WHERE   I.ItemNo = '#url.ItemNo#'
	AND		U.UoM    = '#url.UoM#'		
</cfquery>

<cfoutput>
		
	<table width="100%" height="100%">
	
	<tr>
		
		<cfif url.mode eq "Edit">
	
	    <td style="width:300" valign="top">	
		
		<table width="95%" height="100%" class="formpadding" align="center">
									
			<tr>
				
				<td height="100%" style="padding:2px;">
										
					<table width="100%" height="100%">
					
					    <tr><td style="padding-top:5px">
						<cfoutput>
							<input type="text" 
							onkeyup="_cf_loadingtexthtml='';ptoken.navigate('getItemList.cfm?mission=#workorder.mission#&workorderitemid=#url.workorderitemid#&find='+this.value,'items')"
							style="width:98%;border:1px solid silver" 
							class="regularxl" id="findvalue" name="findvalue">
						</cfoutput>
						</td></tr>
						<tr><td height="5"></td></tr>
						<tr>												
								<td style="padding-right:0px;height:100%">							
									<cf_divscroll id="items">		
									    <cfset url.find     = "">	
										<cfset url.mission  = WorkOrder.Mission>						
										<cfinclude template = "getItemList.cfm">									
									</cf_divscroll>																									
								</td>												
						</tr>
					</table>							
					
				</td>
			</tr>	
					
		</table>
	
		</td>
		
		</cfif>
	
		<td width="60%" valign="top">
	
		<cfform name="frmResource"
			   method="post" 
			   target="processResource" 
			   action="ResourceEditSupplySubmit.cfm?workorderitemid=#url.workOrderItemId#&itemNo=#url.itemNo#&uom=#url.uom#">
		   
		   <cfif URL.workOrderItemIdResource neq "">	  
			   	<input type="hidden" name="IdResource" value="#URL.workOrderItemIdResource#">
				<cfset resourceid = URL.workOrderItemIdResource>
		   <cfelse>
			   	<cf_assignid>			
				<cfset resourceid = rowguid>
			    <input type="hidden" name="IdResource" value="#rowguid#">
		   </cfif>	
		
			<table width="97%" border="0" class="formpadding" align="center">
				
				<cfquery name="Parameter" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
		    			SELECT *
	    				FROM   Ref_ParameterMission
						WHERE  Mission = '#workorder.Mission#' 					
				</cfquery>  	
			
				<tr><td height="12"></td></tr>
								
				<tr>
					<td style="padding:2px;height:30;" class="labelmedium" width="30%">
						<cf_tl id="Item"> : 
						<cf_space spaces="35">
					</td>
					
					<td width="50%" style="padding:2px;" class="labelmedium" colspan="2">
					
					<table width="100%" height="24" cellspacing="0" cellpadding="0">
					<tr>			
						<td id="itembox" class="labelmedium" width="100%" style="padding-left:3px;padding:2px;background-color:f4f4f4;border:1px solid silver; width:120; height:20px;">
							<cfif getitem.recordcount eq "0">  ---<cf_tl id="select from list">---  <cfelse>#GetItem.Classification# #GetItem.ItemDescription#</cfif>
							<input type="hidden" name="ItemNo" value="#getItem.ItemNo#">	
						</td>	
					</tr>
					</table>		
					
					</td>
					
				</tr>
				
				<tr>
					<td style="padding:2px;" class="labelmedium">
						<cf_tl id="UoM"> : 
					</td>
					
					<td style="padding:2px;" id="uombox" class="labelmedium">
					
					<cfif mode eq "Edit">
					
						<cfquery name="GetUoM" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT 	U.*
						    FROM 	ItemUoM U
							WHERE	U.ItemNo = '#url.ItemNo#'
						</cfquery>
													
						<cf_tl id="Select a valid UoM" var="1">
																		
						<cfselect name="uom" 
						          id="uom" 
								  query="getUoM" 
								  required="true" 
								  message="#lt_text#" 
								  value="UoM" 
								  display="UoMDescription" 
								  selected="#url.UoM#" 
								  onchange="ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/BOM/getItemPrice.cfm?mission=#url.mission#&mode=uom&itemNo=#url.itemno#&uom='+this.value+'&quantity='+document.getElementById('quantity').value,'uomprice')"								  
								  class="regularxl"/>
								
					<cfelse>	
						
						#getItem.UoMDescription#
						
					</cfif>				
									
					</td>
					<td id="uomprice"></td>	
				</tr>
							
				<tr>
					<td class="labelmedium" style="padding:2px;">
						<cf_tl id="Reference">:
					</td>
					<td style="padding:2px;">								
						<cfinput maxlength="20" 
				          type="text" 
						  class="regularxl enterastab" 
						  name="reference" 
						  id="reference" 
						  value="#Get.Reference#" 
						  required="false" 
						  message="#lt_text#" 
						  style="width:120px; padding-left:2px;">
					</td>
					<td></td>
				</tr>	
						
				<tr>
					<td class="labelmedium" style="padding:2px;">
						<cf_tl id="Quantity">:
					</td>
					<td style="padding:2px;">
						<cf_tl id="Please, enter a valid numeric quantity greater than 0." var="1">
						<cfinput type="text" 
						    class="regularxl enterastab" 
							name="quantity" 
							id="quantity" 
							value="#Get.Quantity#" 
							required="true" 
							message="#lt_text#" 
							validate="float" 
							range="0.00000000001," 
							style="width:70px; text-align:right; padding-right:2px;">
					</td>
					<td></td>
				</tr>			
				
				<tr>
					<td class="labelmedium" style="padding:2px;">
						<cf_tl id="Cost price">#application.basecurrency#:
					</td>
					<td style="padding:2px;">
						
						<cf_tl id="Please, enter a valid numeric price greater than 0." var="1">
						
						<cfinput type = "text" 
						   class      = "regularxl enterastab" 
						   name       = "price" 
						   id         = "price" 
						   value      = "#numberformat(Get.Price,'.__')#" 
						   required   = "true" 
						   message    = "#lt_text#" 
						   validate   = "float" 
						   range      = "0.00000000001," 
						   style      = "width:70px; text-align:right; padding-right:2px;">
					</td>
					<td></td>
				</tr>
				
				
				<tr>
					<td class="labelmedium" style="padding:2px;">
						<cf_tl id="Total">:
					</td>
					<td style="padding:2px;" class="labelmedium">				
						<cfdiv bind="url:ResourceTotal.cfm?qty={quantity}&price={price}" 
						    id="dTotal" 
							class="labelmedium" 
							style="background-color:f4f4f4;border:1px solid silver; width:100; height:25px; text-align:right;padding:2px;">								
					</td>
					<td></td>
				</tr>
				
				<tr>
					<td style="padding:2px;" class="labelmedium">
					
					    <table cellspacing="0" cellpadding="0">
						<tr><td class="labelmedium">
						  	<cf_tl id="Provider" var="vRecord">#vRecord#:
						    </td>					
						</tr>
						</table>	
										  					
					</td>
					
					<td style="padding:2px;" class="labelmedium">
					
						<table cellspacing="0" cellpadding="0">
						
						  <tr> 
						  					  
						  	<cfset link = "#session.root#/WorkOrder/Application/Assembly/Items/BOM/getOrganization.cfm?">							   						
							<td>
							   <cfdiv id="orgbox" bind="url:#link#&orgunit=#Get.OrgUnit#&mode=read"
							        style="height:24;padding-left:3px;border:1px solid silver;width:200" 
									class="labelmedium">
							</td>	
													
							<td style="padding-left:1px"> 							
				   
					   		<cf_selectlookup
						    	class        = "Organization"
					    		box          = "orgbox"
								title        = "#vRecord#"
								close        = "Yes"							
								link         = "#link#&mode=select"			
								des1         = "OrgUnit"
								filter1      = "Mission"
								icon         = "search.png"
								iconheight   = "24"
								iconwidth    = "25"
								filter1Value = "#Parameter.TreeVendor#">	
															
							</td>
							
							</tr>
							
						</table>	
						
					</td>
					<td></td>
				</tr>
				
				<tr>
					<td class="labelmedium" style="padding:2px;">
						<cf_tl id="Memo">:
					</td>
					<td style="padding:2px;" colspan="2" class="labelmedium">
						<cfinput type="text" class="regularxl enterastab" name="remarks" id="remarks" value="#Get.Memo#" style="width:99%; text-align:left; padding-right:2px;">
					</td>
					<td></td>
				</tr>
										
				<tr><td height="6"></td></tr>			
				<tr><td class="line" colspan="4"></td></tr>			
				<tr><td height="6"></td></tr>
				<tr><td colspan="4">
					<table>
					<tr>
						<td style="padding-left:4px" colspan="2">
						<cfif url.itemNo neq "">
							<table><tr id="applybox" class="hide">
							<td class="labelmedium" style="padding-left:5px;">
								<font color="gray"><cf_tl id="Apply to all lines">:</font>
							</td>				
							<td style="padding:3px;" colspan="2" class="labelmedium">
								<cfinput type="Checkbox" name="apply" value="1" class="radiol enterastab" id="apply">
							</td>				
							</tr>
							</table>
						</cfif>
						</td>				
						<td colspan="2" id="process" style="padding-left:3px">
							<cf_tl id="Save" var="1">
							<input class = "button10g" 
							    style    = "height:26;font-size:13px;width:200" 
							    type     = "button" 
								onsubmit = "return false" 
								name     = "btnSbmt" 
								id       = "btnSbmt" 
								value    = "#lt_text#" 
								onclick  = "validate();">					
						</td>
						
						
					</tr>
					</table>
					</td>
				</tr>
				
				<tr><td height="6"></td></tr>
				<tr><td class="line" colspan="4"></td></tr>	
				
				<tr>
					<td class="labelmedium" colspan="4" style="height:30px;padding:2px;">
						<cf_tl id="Attachment">:
					</td>
				</tr>
				<tr>	
					<td colspan="4" style="padding-left:10px;" class="labelmedium">
					
	                 <cfif url.mode eq "edit">
										
						<cf_filelibraryN
						    box="box_#resourceid#"
							DocumentPath="WorkOrder"
							SubDirectory="#resourceid#" 
							Filter=""	
							Listing="1"							
							Insert="Yes"
							Remove="yes"										
							width="100%"	
							Loadscript="yes"				
							border="1">	
						
					<cfelse>
					
						<cf_filelibraryN
						    box="box_#resource#"
							DocumentPath="WorkOrderItem"
							SubDirectory="#resourceid#" 
							Filter=""								
							Insert="no"
							Remove="no"
							width="100%"	
							Loadscript="yes"														
							border="1">							
					
					</cfif>								
						
					</td>
					
				</tr>
			
			</table>
		
		</cfform>
		
		</td>
	</tr>
	</table>	
	
</cfoutput>