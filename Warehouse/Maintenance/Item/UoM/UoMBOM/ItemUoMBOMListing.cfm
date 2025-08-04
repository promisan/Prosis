<!--
    Copyright © 2025 Promisan

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

<cfquery name="UoMMission" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ItemUoMMission
	WHERE	ItemNo = '#URL.ID#'
	AND		UoM    = '#URL.UoM#'
</cfquery>

<cfif UoMMission.recordcount neq 0>
	
	<TABLE width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
		<cfquery name="Item" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Item
			WHERE 	ItemNo = '#URL.ID#'
		</cfquery>
	
		<tr><td height="3"></td></tr>
			
	    <cfoutput>
		
		<cfquery name="Cls" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_ItemClass
			WHERE 	Code = '#Item.ItemClass#'
		</cfquery>
		
		<TR>
	    <td colspan="3" class="labelit" width="170"><cf_tl id="Class">:</b></td>
	    <TD colspan="8" width="80%" class="labelmedium">#Cls.Description#</td>
	    </tr>
		
	    <TR>
	    <TD colspan="3" class="labelit"><cf_tl id="Code">:</TD>
	    <TD colspan="8" class="labelmedium">#item.Classification#</TD></TR>
		
		<TR class="line">
	    <TD colspan="3" class="labelit" style="padding-right:10px"><cf_tl id="Description">:</TD>
	    <TD colspan="8" class="labelmedium">#item.ItemDescription#</TD>
		</TR>	
				
		</cfoutput>
				
		<cfloop query="UoMMission">
		
		<TR height="20"><TD colspan="10" class="labelmedium2"><cfoutput>#Mission#</cfoutput></TD></TR>
		<TR><TD colspan="10">
			    <table>
				<tr>
				
				<cfoutput>
				
					<cf_tl id="Inherit from other item" var=1>
					<td style="padding-right:10px" class="labelmedium2">
						<a onclick="javascript:BOMInherit('#URL.ID#','#URL.UoM#','#Mission#')" href="##">#lt_text#</a>
					</td>	
					
					<td style="border:1px solid silver"></td>				
					
					<cf_tl id="New BOM" var=1>			
					
					<td style="padding-left:10px;padding-right:10px" class="labelmedium2">
					
						<a onclick="editBOM('#URL.ID#','#URL.UoM#','','#Mission#')" href="##">#lt_text#</a>
						
					</td>						
					
					<cfquery name="Related" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
							SELECT   *
							FROM     ItemUoMMission
							WHERE    ItemNo IN (SELECT ItemNo FROM Item WHERE ParentItemNo = '#URL.ID#')
							AND      UoM = '#URL.UoM#'
							AND      Mission = '#mission#'
					</cfquery>					
								
					<cfif Related.recordcount gte "1">
					
					<cfset bomItemList = valueList(Related.ItemNo)>
					<cfset bomItemList = replace(bomItemList, ",", ", ", "ALL")>
					
					<td style="border:1px solid silver"></td>
					<td style="padding-left:10px" class="labelmedium"><font color="gray">#related.recordcount# associated BOM item<cfif related.recordcount gt "1">s</cfif><br>[<span style="font-size:12px;">#bomItemList#</span>]</td>
										
					</cfif>
										
					
				</cfoutput>
				
				</tr>
				</table>			
			
		</TD></TR>
		
		
		<tr><td colspan="11" class="line"></td></tr>
				
			<cfquery name="qItems" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT    I.Classification,
						  B.BomId,
				          B.Mission, 
						  B.DateEffective,
						  B.ItemNo, 
						  B.UoM,  
						  BU.UoMCode,
						  BD.MaterialItemNo, 
						  BD.MaterialUoM, 
						  BD.MaterialQuantity, 
						  BD.MaterialCost,
						  BD.MaterialAmount,
						  <!---
						  BD.MaterialReference,
						  --->
						  BD.MaterialMemo, 
						  BD.MaterialId, 
						  I.ItemDescription, 
	                      U.UoMDescription
				FROM      ItemBOM B INNER JOIN
	                      ItemBOMDetail BD ON B.BOMId = BD.BOMId INNER JOIN
						  ItemUoM BU ON B.ItemNo = BU.ItemNo AND B.UoM = BU.UoM INNER JOIN
						  
	                      Item I ON BD.MaterialItemNo = I.ItemNo INNER JOIN
	                      ItemUoM U ON BD.MaterialItemNo = U.ItemNo AND BD.MaterialUoM = U.UoM
						  
				WHERE 	  B.ItemNo  =  '#URL.ID#'	
				AND       B.Uom     =  '#URL.UoM#'
				AND       B.Mission =  '#Mission#'
				ORDER BY B.Mission, B.DateEffective DESC		
					
			</cfquery>
			
							
			<!--- we show the items by mission, and then by Effective date --->
		
			<cfoutput query="qItems" group="mission">			
								
				<tr class="labelmedium2 line">
				<td></td>
				<td></td>
				<td><cf_tl id="No"></td>
				<td><cf_tl id="Class"></td>
				<td><cf_tl id="Name"></td>
				<td><!---Reference---></td>
				<td><cf_tl id="UoM"></td>				
				<td align="right"><cf_tl id="Quantity"></td>
				<td align="right"><cf_tl id="Price"></td>
				<td align="right"><cf_tl id="Total"></td>			
				</tr>	
										
				<cfset row = 0>
							
				<cfoutput group="dateeffective">
				
					<cfset row = row + 1>
										
					<cfif row eq "1">
					
						<TR height="24" class="line">
						 		 
						  <TD colspan="9" style="cursor:pointer;padding-left:4px" class="labelit" onclick="editBOM('#URL.ID#','#URL.UoM#','#BomId#')">
						   Effective: <font size="3" color="0080C0">#dateformat(DateEffective,client.dateformatshow)#</font>
						  </TD>
						  
						   <td style="padding-left:6px;height:20;padding-right:2px;" align="right" width="2%">						
							<cf_img icon="open" navigation="Yes" onclick="editBOM('#URL.ID#','#URL.UoM#','#BomId#','#Mission#')">
						  </td>
						  
					    </TR>	
					
					<cfelse>
					
						<TR height="24" class="line">
						 		 
						  <TD colspan="10" style="cursor:pointer;padding-left:4px" class="labelit">
						   Effective: #dateformat(DateEffective,client.dateformatshow)#
						  </TD>
						  			  
					    </TR>	
					
					</cfif>
			   				
				    <cfset i = 0>
					<cfset tot = 0>
		
					<cfoutput>
					
						<cfset i = i +1>
						
				    	<tr class="navigation_row line labelmedium2">	    	
						  
							<td width="1%" style="padding-left:8px">#i#.</td>
												
							<td style="padding-left:7px;padding-top:2px;padding-right:4px" width="2%">
								<cf_img icon="delete" onclick="deleteBOM('#URL.ID#','#URL.UoM#','#MaterialId#')">
							</td>
											
							<td width="5%">#MaterialItemNo#</td>
							<td width="10%">#Classification#</td>
							<td width="30%">#ItemDescription#</td>																	 
							<td width="10%"><!--- #MaterialReference# ---></td>
							<td width="14%">#UoMDescription#</td>							
							<td width="8%" style="padding-right:4px" align="right">#MaterialQuantity#</td>		
							<td width="8%" style="padding-right:4px" align="right">#numberformat(MaterialCost,'.___')#</td>	
							<td width="8%" style="padding-right:4px" align="right">#numberformat(MaterialAmount,'.___')#</td>		
																
						</tr>
						
						<cfif MaterialMemo neq "">
						
						<tr>
						<td></td>
						<td colspan="8" width="20%" class="labelmedium">#MaterialMemo#</td>
						</tr>
						
						</cfif>
												
						<cfset tot = tot + MaterialAmount>		
						
					</cfoutput>						
									
					<tr>
						<td colspan="8"></td>
						<td colspan="2" width="8%" class="labellarge" style="padding-right:4px" align="right">#numberformat(tot,',.___')#</td>				
					</tr>
					
					<cfif row eq "1">
				
					    <!--- at this point we will also check if the standard cost would have to be adjusted.
						
						Hanno : 18/1/2014, 
						
						Attention it is better to move this to the ItemUoMBOMSubmit.cfm --->
					
						<cfquery name="getStandardCost" 
						datasource="appsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
							SELECT    *
							FROM      ItemUoMMission
							WHERE 	  ItemNo =  '#ItemNo#'	
							AND       Uom    =  '#UoM#'
							AND       Mission = '#UoMMission.Mission#'						
						</cfquery>
																	
					    <cfif getStandardCost.standardcost neq tot>		
												
							<cfquery name="setStandardCost" 
								datasource="appsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE    ItemUoMMission
									SET       StandardCost = '#tot#'
									WHERE 	  ItemNo       = '#ItemNo#'	
									AND       Uom          = '#UoM#'
									AND       Mission      = '#UoMMission.Mission#'						
							</cfquery>
							
							 <cfinvoke component = "Service.Process.Materials.Stock"  
						       method            = "setStockPrice" 
						       mission           = "#UoMMission.Mission#"
							   ItemNo            = "#ItemNo#"			  
							   UoM               = "#UOM#"			   
							   Price             = "#tot#">								   
							
							<cfif UoMCode neq "">							
							
								<!--- also update the standard cost of child items 18/1/2014 
						        	but ONLY if the global UoM is the same --->
							
								<cfquery name="getChildren" 
									datasource="appsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT U.* 
									FROM   ItemUoM U, Item I
									WHERE  U.ItemNo = I.ItemNo
									AND    I.ItemNo IN (SELECT ItemNo 
									                    FROM   Item 
													    WHERE  ParentItemNo = '#ItemNo#')
									AND    U.UoMCode = '#UoMCode#'											
				                </cfquery> 	
								
								<cfloop query="getChildren">
								
									<!--- update the standard cost of the children for that mission --->
									
									<cfquery name="check" 
										datasource="appsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										   SELECT  *
										   FROM    ItemUoMMission						   
										   WHERE   ItemNo         = '#itemNo#' 
										   AND     UoM            = '#UoM#'
										   AND     Mission        = '#UoMMission.Mission#'												   
									 </cfquery>	
									 
									<cfif check.recordcount eq "1">
						
										<cfquery name="Update" 
											datasource="appsMaterials" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">											
											   UPDATE  ItemUoMMission
											   SET     StandardCost   = '#tot#'						   
											   WHERE   ItemNo         = '#check.itemNo#' 
											   AND     UoM            = '#check.UoM#'
											   AND     Mission        = '#check.Mission#'		
										 </cfquery>	
										 
										  <cfinvoke component = "Service.Process.Materials.Stock"  
										       method            = "setStockPrice" 
										       mission           = "#check.mission#"
											   ItemNo            = "#check.ItemNo#"			  
											   UoM               = "#check.UOM#"			   
											   Price             = "#standardcost#">	 
									   
									  </cfif> 
								 			 
								 </cfloop>		
														 
							 </cfif>						
												
					    </cfif>
				
				  </cfif>
									
				  <tr><td colspan="11" class="line"></td></tr>
				
				</cfoutput>
				
			</cfoutput>	
			
		</cfloop>	
		
	</table>

<cfelse>

	<table width="95%" align="center" class="formpadding">
		<tr>
			<td class="labelit">Please define first an entity for this unit of measure</td>
		</tr>
	</table>	
	
</cfif>			

<cfset AjaxOnLoad("doHighlight")>		
				
