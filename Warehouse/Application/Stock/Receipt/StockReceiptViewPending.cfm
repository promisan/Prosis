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
<cfinclude template="StockReceiptPrepare.cfm">


<cfquery name="Param"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT 	*
		FROM 	Ref_ParameterMission
		WHERE   Mission = '#url.mission#'		
</cfquery>

<cfquery name="Warehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT 	*
		FROM 	Warehouse
		WHERE   Warehouse = '#url.warehouse#'		
</cfquery>

<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#url.mission#" 
	   missionorgunitid  = "#warehouse.missionOrgUnitId#"	   
	   role              = "'WhsPick'"	   	   
	   Parameter         = "#url.systemfunctionid#"
	   accesslevel       = "2"	  
	   returnvariable    = "accessright">	
	  	  

<cfparam name="url.fnd" default="">

<cfquery name="getListing"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT 	 *
		FROM 	 Receipt#URL.Warehouse#_#SESSION.acc# I
		WHERE    (I.ItemNo LIKE '%#URL.fnd#%' OR I.ItemDescription LIKE '%#URL.fnd#%')
		ORDER BY Category, ReceiptDeliveryDateEnd DESC		
</cfquery>

<!--- Pending receipts --->

<cf_PresentationScript>

<table width="100%" height="100%">
		
		<!-- <cfform name="frmProcessReceiptPending" id="frmProcessReceiptPending" onsubmit="return false;"> -->
		
		<tr>
		<td>
		
		   <table width="98%" align="center" class="navigation_table">
		   <tr class="line labelmedium">
				
						
			<td style="padding-left:5px;">
			
				<cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 
				   filtermode       = "enter"
				   name             = "filtersearch"
				   style            = "font:13px;height:24;width:190"
				   rowclass         = "clsDetail"
				   rowfields        = "ccategorydescription,creceiptno,citemno,citembarcode,citemdescription,cuomdescription,clot">							
				
			</td>
			
			<td style="padding-right:5px"><cf_tl id="Program"></td>
			
			 <cfquery name="Program" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   SELECT  * 
				   FROM    Program.dbo.Program P
				   WHERE   ProgramClass = 'Project'
				   AND     EXISTS (SELECT 'X'
								   FROM   ItemTransaction AS T INNER JOIN Item AS I ON T.ItemNo = I.ItemNo
								   WHERE  T.Mission   = P.Mission 
								   AND    T.Warehouse = '#url.warehouse#'
								   AND    I.ProgramCode = P.ProgramCode
								   AND    T.TransactionType = '1')								   
				
				   ORDER BY Created DESC	   
				</cfquery>	
			
			<td>
			  <cfoutput>
			  <select name="programcode" id="programcode" style="width:300px;" class="regularxl" 
			     onchange="Prosis.busy('yes');ptoken.navigate('../Receipt/StockReceiptViewPending.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#&programcode='+this.value,'contentbox1')">
					<option value=""><cf_tl id="Any"></option>
					<cfloop query="Program">
					<option value="#ProgramCode#" <cfif programcode eq client.programcode>selected</cfif>>#ProgramName#</option>
					</cfloop>
				</select>
				</cfoutput>
			</td>
			
			<td align="right" style="width:40%;font-size:18px; padding-right:125px;">
				
				<cfquery name="getSelected"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
						SELECT    *
						FROM 	  Receipt#URL.Warehouse#_#SESSION.acc# I
						WHERE     (I.ItemNo LIKE '%#URL.fnd#%' OR I.ItemDescription LIKE '%#URL.fnd#%')
						AND		  Selected = '1'
						ORDER BY  Category, ReceiptDeliveryDateEnd DESC						
				</cfquery>
			
				<cfoutput>
				<cf_tl id="process selected receipts" var="1">
				<cf_tl id="Selected Receipts" var="1">
				<table><tr class="labelmedium">
				<td>#lt_text#</td>
				<td style="padding-left:5px;font-size:18px">
				<a href="javascript: submitSelectedItems('#url.mission#','#url.warehouse#');" style="cursor:pointer; color:1E70D2;" title="#lt_text#">					
					<span id="selectedCounter">#getSelected.recordCount#</span> 
				</a>
				</td><td style="font-size:18px">:</td><td style="font-size:18px">#getListing.recordcount#</td>
				</tr></table>
				</cfoutput>
			</td>
			</tr>
			</table>
		</td>
			
		</tr>		
		
		<tr class="hide">
			<td align="center" style="padding-top:4px">
				<cfset vBtnDisplay = "display:none;">				
				<span id="spanBtnSubmit" style="<cfoutput>#vBtnDisplay#</cfoutput>">
					<cfdiv id="processSelectItem" bind="url:#SESSION.root#/warehouse/application/stock/receipt/setSelectItem.cfm?mission=#url.mission#&warehouse=#url.warehouse#&list=&value=">
				</span>
			</td>
		</tr>
		
		
		
		<tr>
		<td width="100%" style="height:100%;border:0px solid silver">
		
			<cf_divscroll overflowy="scroll">
			
			<table width="98%" border="0" align="center" class="navigation_table">
			
				<tr class="labelmedium line fixrow fixlengthlist">
						
						<td style="min-width:20"></td>
						<td style="min-width:40"></td>
						<td style="min-width:80"><cf_tl id="Receipt"></td>
						<td><cf_tl id="Date"></td>
						<td style="min-width:80"><cf_tl id="Item"></td>					
						<td><cf_tl id="Code"></td>
						<cfif Param.LotManagement eq "1"><td style="min-width:80"><cf_tl id="Lot"></td></cfif>
						<td><cf_tl id="Description"></td>
						<td align="right" style="min-width:80px"><cf_tl id="UoM"></td>					
						<td align="right" style="min-width:100px"><cf_tl id="Qty"></td>
						<!---
						<td align="right" ><cf_tl id="Price"></td>
						--->
						<cfif accessright eq "GRANTED">
						<td align="right" style="min-width:120px"><cf_tl id="Value"></td>
						</cfif>
						<cf_tl id="Quantity to be transferred" var="1">
						<td style="min-width:40px" align="center">
							<cfset vSelectAll = 0>
							<cfif getListing.recordCount eq getSelected.recordCount>
								<cfset vSelectAll = 1>
							</cfif>
							<cfoutput>
								<cf_tl id="select all visible items" var="1">
								<input type="Checkbox" id="selectAll" name="selectAll" onclick="selectAllItems('#url.mission#','#url.warehouse#',this);" title="#lt_text#" <cfif vSelectAll eq 1>checked</cfif>>
							</cfoutput>
						</td>
						<td align="right" style="min-width:100px;padding-right:5px" title="<cfoutput>#lt_text#</cfoutput>" class="selectAll"><cf_tl id="Transfer"></td>
				</TR>		
			
											
				<cfoutput query="getListing" group="category">
				
					<tr class="clsHeader line fixrow2 fixlengthlist">
											
						<td colspan="13" height="30" class="headerCategoryDescription" style="font-size:18px; font-family:Calibri;">
							<cfquery name="qGetSelected" dbtype="query">
								SELECT 	*
								FROM	getSelected
								WHERE	Category = '#category#'
							</cfquery>
							<cfquery name="qGetListing" dbtype="query">
								SELECT 	*
								FROM	getListing
								WHERE	Category = '#category#'
							</cfquery>
							<cf_tl id="select all visible items from" var="1">
							<input type="Checkbox" id="group_#category#" name="group_#category#" class="clsCategorySelector" title="#lt_text# #ucase(categoryDescription)#" onclick="selectItemsByCategory('#url.mission#','#url.warehouse#','#category#',this);" <cfif qGetSelected.recordCount eq qGetListing.recordCount>checked</cfif>>
							#categoryDescription#&nbsp;
							<span id="info_#category#" class="clsCategoryInfo" style="color:808080; font-size:15px;"></span>
						</td>
								
					</tr>
										
					<cfoutput>
					
						<tr class="clsDetail navigation_row labelmedium line fixlengthlist">
							
							<td class="ccategorydescription" style="visibility:hidden; height:21;font-size:1px;">#categoryDescription#</td>
							
							<cf_tl id="view receipt detail" var="1">
							
							<td align="center">
							
								<cfif accessright eq "GRANTED">
							
								<cf_tl id="click to show price definition" var="1">
																
								<img src="#SESSION.root#/images/toggle_up.png" 
									 class="clsTwistiePrices" 
									 id="twistiePrice_#transactionId#" 
									 height="15" 
									 align="absmiddle" 
									 title="#lt_text#"
									 style="cursor:pointer;" 
									 onclick="toggleReceiptPriceDetail('#url.mission#','#url.warehouse#','#warehouse#','#transactionId#','#currentrow#','pendingTargetPriceDetail_#transactionId#','Pending');">
									 
								<cfelse>
								
								<cf_img icon="select" onclick="item('#ItemNo#','#url.systemfunctionid#','#url.mission#');">	 
									 
								</cfif>	 
									 
							</td>
							<cf_tl id="view receipt document" var="1">		
							<td class="creceiptno" onclick="receipt('#receiptno#','receipt');" style="padding-left:4px;cursor:pointer; color:0080C0;" title="#lt_text#">#ReceiptNo#</td>							
							<td>#dateFormat(ReceiptDeliveryDateEnd,'#CLIENT.DateFormatShow#')#</td>							
							<cf_tl id="view item detail" var="1">							
							<td class="citemno" onclick="item('#ItemNo#','#url.systemfunctionid#','#url.mission#');" style="cursor:pointer;color:0080C0" title="#lt_text#">#ItemNo#</td>							
							<td class="citembarcode">#ItemBarcode#</td>
							<cfif Param.LotManagement eq "1"><td class="clot"><cfif TransactionLot neq "0">#TransactionLot#</cfif></td></cfif>
							<td class="citemdescription">#ItemDescription#</td>
							<td align="center" class="cuomdescription">#UoMDescription#</td>	
													
							<td align="right" style="<cfif quantity lt 0>background-color:red</cfif>">#lsNumberFormat(Quantity,",")#</td>
							<!---
							<td align="right">#lsNumberformat(StandardCost,",.__")#</td>
							--->
							<cfif accessright eq "GRANTED">
							<td align="right">#lsNumberFormat(Amount,",.__")#</td>
							</cfif>
							<td align="center" class="#category#">
								<cfif quantity gt 0>
								<input type="Checkbox" id="line_#TransactionId#" name="line_#TransactionId#" class="clsItem" value="#TransactionId#" 
								onclick="selectItem('#url.mission#','#url.warehouse#',this);" <cfif selected eq 1>checked</cfif>>
								</cfif>
							</td>
							<td align="right" class="#category#">
								
								<cf_tl id="Enter a valid integer quantity between 1 and" var="1">
								<cfset vMesInit = "#lt_text#">
								<cf_tl id="for barcode" var="1">
								<cfset vMesEnd = "#lt_text#">
								
								<cfset vDisplay = "display:none;">
								<cfif selected eq 1>
									<cfset vDisplay = "">
								</cfif>
								
								<cfinput type="Text" 
										name="quantity_#TransactionId#" 
										id="quantity_#TransactionId#" 
										value="#TransferQuantity#" 
										required="Yes" 
										validate="integer" 
										message="#vMesInit# #Quantity# #vMesEnd# #ItemBarcode#" 
										range="1,#Quantity#"							
										size="5" 
										maxlength="8" 
										class="clsTransferQuantity regularxl enterastab" 
										style="height:19px;padding-top:1px;text-align:right; padding-right:2px; #vDisplay#"
										onfocus="$(this).select();" 
										onchange="saveChangeTmpReceipt('#url.mission#','#url.warehouse#','TransferQuantity',this.value, '#transactionId#', '#quantity#');">
									
							</td>									
						</tr>
						
						<tr id="priceDetail_#transactionId#" style="display:none; width:100%; overflow:auto;">
						 
							<td style="width:100%; overflow:auto;" colspan="13">
							
								<table width="100%" height="100%">
									
									<tr>
										<td valign="top" align="right">
											<img src="#SESSION.root#/images/join.gif">
										</td>
										<td style="padding-left:3px;" width="96%" height="100%" id="pendingTargetPriceDetail_#transactionId#"></td>
									</tr>
									<tr><td height="10"></td></tr>
									
								</table>
								
							</td>
						
						</tr>
						
					</cfoutput>	
				</cfoutput>
			</table>
			</cf_divscroll>
		</td>
		</tr>
		<!-- </cfform> -->		
		<tr class="hide"><td id="processTempReceipt"></td></tr>
				
</table>

<cfset ajaxOnLoad("doHighlight")>		
<script>
	Prosis.busy('no');			
</script>		