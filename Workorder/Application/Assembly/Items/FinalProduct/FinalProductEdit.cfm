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
<cf_tl id="Finished Product" var="lblFinal">
	
<cf_tl id="Edit finished product" var="1">

<cf_screentop height="100%" 
			scroll="No" 
			html="No"
			layout="webapp" 			
			label="#lblFinal#" 
			user="No"
			option="#lt_text#" 
			banner="green"
			JQuery="yes">	
			
<cfajaximport tags="cfdiv,cfform">

<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkOrderId = '#url.WorkOrderId#'		
</cfquery>

<cfquery name="Get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineItem
		WHERE   WorkOrderItemId = '#url.WorkOrderItemId#'
</cfquery>

<cfquery name="GetItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Item I INNER JOIN ItemUoM U	ON I.ItemNo = U.ItemNo
		WHERE   I.ItemNo = '#get.ItemNo#'
		AND		U.UoM = '#get.UoM#'		
</cfquery>

<!--- Query returning search results --->
<cfquery name="Billing"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_BillingMode
	WHERE  Code != 'Supply'
</cfquery>	

<!--- Query returning search results --->
<cfquery name="Tax"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Tax
</cfquery>	

<cfoutput>
	
	<table class="hide"><tr><td><iframe id="processFinalProduct" name="processFinalProduct"></iframe></td></tr></table>
	
	<cfform name="frmFinalProduct" method="post" 
	      target="processFinalProduct" 
		  action="FinalProductEditSubmit.cfm?workorderitemid=#url.workOrderItemId#">
	
		<table width="93%" cellspacing="0" cellpadding="0" align="center">
		
			<tr><td height="5"></td></tr>
			
			<tr>
				
				<td style="padding:2px;" colspan="2">
					
					<cfset link = "#session.root#/WorkOrder/Application/Assembly/Items/FinalProduct/getItem.cfm?itemNo=#get.itemNo#&workorderid=#url.workOrderId#&workorderline=#url.workorderline#&uom=#get.uom#">
					
					<table width="100%">
						<tr>
							<cfif get.itemNo eq "">
								<td width="1%" style="padding-right:10px;">
									<cf_selectlookup
									    box          = "itembox"
										link         = "#link#&mode=select"
										title        = "Item Selection"
										icon         = "contract.gif"
										button       = "Yes"
										close        = "Yes"
										class        = "Item"
										filter2		 = "ItemClass"
										filter2value = "Service,Supply"
										des1         = "ItemNo">
								</td>
							</cfif>
							<td width="100%">
								<cfdiv id="itembox" bind="url:#link#&mode=read">
							</td>
						</tr>
					</table>
					
				</td>
			</tr>
			
			<cfquery name="Topics"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   R.Description,R.TopicLabel, CAST(I.TopicValue AS varchar) as TopicValue, I.ListCode
				FROM     ItemClassification I INNER JOIN
	                     Ref_Topic R ON I.Topic = R.Code
				WHERE    ItemNo = '#get.ItemNo#'		  
			</cfquery>		  
			
			<cfloop query="Topics">
			<tr>
				<td class="labelmedium" style="padding-left:10px;">#Description#:</td>
				<td class="labelmedium" style="padding:2px;">#listcode# #topicValue#</td>
			</tr>			
			</cfloop>
			
			<cfquery name="CommodityList" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    CommodityCode,
					          CommodityCode+' '+Description as Name
					FROM      Ref_Commodity R	
					ORDER BY  CommodityCode
				</cfquery>	
				
				<TR>
			    <TD class="labelmedium" style="padding-left:10px;width:200px;"><cf_tl id="Commodity">:</TD>
			    <TD class="labelmedium" style="padding:2px;">	
					<cfselect name="CommodityCode" 
							class="regularxl"
							query="CommodityList" 
							style="width:90%"
							required="No" 
							value="CommodityCode" 
							message="Please, select a commodity code" 
							display="Name" 
							selected="#get.CommodityCode#"/>
			  	 
			    </TD>
				</TR>
			
			<tr><td colspan="2" class="line"></td></tr>
			
			<tr>
				<td class="labelmedium" style="padding-left:10px;">
					<cf_tl id="Billing Mode">:
				</td>
				<td style="padding:2px;">
				
					 <select name="BillingMode" id="BillingMode" class="regularxl">
			            <cfloop query="Billing">
			        	<option value="#Code#" <cfif get.BillingMode eq Code>selected</cfif>>
						#Description#
						</option>
			         	</cfloop>
				    </select>
				
				</td>
			</tr>	
			
			<tr>
				<td class="labelmedium" style="padding-left:10px;">
					<cf_tl id="Sale Type">:
				</td>
				<td style="padding:2px;">	
							
					<cf_tl id="Standard"  var="vStandard">
					<cf_tl id="Promotion" var="vPromotion">
					<cf_tl id="Discount" var="vDiscount">
					
					<select id="SaleType" name="SaleType" class="regularxl enterastab">
					  <option value="Standard"  <cfif get.SaleType eq "Standard">selected</cfif>>#vStandard#</option>
					  <option value="Promotion" <cfif get.SaleType eq "Promotion">selected</cfif>>#vPromotion#</option>
					  <option value="Discount"  <cfif get.SaleType eq "Discount">selected</cfif>>#vDiscount#</option>
					</select>	
				
				</td>
			</tr>	
		
			<tr>
				<td class="labelmedium" style="padding-left:10px;">
					<cf_tl id="Quantity">:
				</td>
				<td style="padding:2px;">
					<cf_tl id="Please, enter a valid numeric quantity greater than 0." var="1">
					<cfinput type="text" class="regularxl" name="quantity" id="quantity" value="#Get.Quantity#" required="true" message="#lt_text#" validate="float" range="0.00000000001," 
					  style="width:100px; text-align:right; padding-right:2px;">
				</td>
			</tr>
						
			<tr>
				<td class="labelmedium" style="padding-left:10px;">
					<cf_tl id="Price">#workorder.currency#:
				</td>
				<td style="padding:2px;">
					<cf_tl id="Please, enter a valid numeric price greater than 0." var="1">
					<cfinput type="text" class="regularxl" name="price" id="price" value="#numberformat(Get.SalePrice,'.__')#" required="true" 
					 message="#lt_text#" validate="float" style="width:100px; text-align:right; padding-right:2px;">
				</td>				
			</tr>
			
			<tr>
				<td class="labelmedium" style="padding-left:10px;">
					<cf_tl id="Extended Price">:
				</td>
				<td style="padding:2px;" id="extended">
					<table cellspacing="0" cellpadding="0">
					<tr>
					<td bgcolor="f4f4f4" style="height:25;width:100px">
				    <cfdiv bind="url:setQuotation.cfm?element=extended&price={price}&quantity={quantity}" style="border:1px solid silver;padding-top:2px;text-align:right;padding-right:4px" class="labelmedium">
					</td></tr>
					</table>				 
				</td>
			</tr>
			
			<tr>
				<td class="labelmedium" style="padding-left:10px;">
					<cf_tl id="Tax code">:
				</td>
				<td style="padding:2px;">
				
					 <select name="taxcode" id="taxcode" class="regularxl" style="width:100px">
			            <cfloop query="Tax">
			        	<option value="#TaxCode#" <cfif get.taxcode eq TaxCode>selected</cfif>>
						#TaxCode# #Description#</option>
			         	</cfloop>
				    </select>
				
				</td>
			</tr>			
			
			<tr>
				<td class="labelmedium" style="padding-left:10px;">
					<cf_tl id="Tax">:
				</td>
				<td style="padding:2px;" id="tax">
					<table cellspacing="0" cellpadding="0">
					<tr>
					<td bgcolor="f4f4f4" style="height:20;border:0px solid silver;width:100">
					<cfdiv bind="url:setQuotation.cfm?element=tax&price={price}&quantity={quantity}&taxcode={taxcode}&taxexemption={taxexemption.checked}" 
					    style="border:1px solid silver;padding-top:2px;text-align:right;padding-right:4px" class="labelmedium">
					</td></tr>
					</table>				 
				</td>
			</tr>
			
			<tr>
				<td class="labelmedium" style="padding-left:10px;">
					<cf_tl id="Net Sale">:
				</td>
				<td style="padding:2px;" id="payable">
				    <table cellspacing="0" cellpadding="0">
					<tr>
					<td bgcolor="f4f4f4" style="height:25;border:0px solid silver;width:100">
					<cfdiv bind="url:setQuotation.cfm?element=netsale&price={price}&quantity={quantity}&taxcode={taxcode}&taxexemption={taxexemption.checked}" 
					   style="border:1px solid silver;padding-top:2px;text-align:right;padding-right:4px" class="labelmedium">
					</td></tr>
					</table>			
				</td>
			</tr>
			
			<tr>
				<td class="labelmedium" style="height:26px;padding-left:10px;">
					<cf_tl id="Tax Exemption">:
				</td>
				<td style="padding:2px;">				
				    <input type="checkbox" class="radiol" name="taxexemption" value="1" <cfif get.TaxExemption eq "1">checked</cfif>>
				   
				</td>
			</tr>
			
			<tr>
				<td class="labelmedium" style="padding-left:10px;">
					<cf_tl id="Payable">:
				</td>
				<td style="padding:2px;" id="payable">
				  <table cellspacing="0" cellpadding="0">
					<tr>
					<td bgcolor="f4f4f4" style="height:25;border:0px solid silver;width:100">
					<cfdiv bind="url:setQuotation.cfm?element=payable&price={price}&quantity={quantity}&taxcode={taxcode}&taxexemption={taxexemption.checked}" 
					   style="border:1px solid silver;padding-top:2px;text-align:right;padding-right:4px" class="labelmedium">
					</td></tr>
					</table>		
				</td>
			</tr>
			
			
			<tr>
				<td width="20%" class="labelmedium" style="padding-left:10px;">
					<cf_tl id="Memo">:
				</td>
				<td style="padding:2px;">
					<cf_tl id="Please, enter a valid memo." var="1">
					<cfinput type="text" class="regularxl" name="ItemMemo" id="ItemMemo" value="#Get.ItemMemo#" required="false" message="#lt_text#" maxlength="200" style="width:95%;">
				</td>
			</tr>
			
			<tr><td height="4"></td></tr>
			<tr><td class="line" colspan="2"></td></tr>
			<tr><td height="4"></td></tr>
			<tr>
				<td colspan="2" align="center">
				    <cf_tl id="Close" var="1">
				    <input class="button10g" style="height:25px;width:150px" type="button" name="btnSbmt" id="btnSbmt" value="#lt_text#" onclick="parent.ProsisUI.closeWindow('mydialog')">
					
					<cf_tl id="Save" var="1">
					<input class="button10g" style="height:25px;width:150px" type="submit" name="btnSbmt" id="btnSbmt" value="#lt_text#">
				</td>
			</tr>
		
		</table>
	
	</cfform>

</cfoutput>