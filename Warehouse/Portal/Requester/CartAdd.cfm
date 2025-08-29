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
<!--- Query returning detail information for selected item
28/8/2012 : Dev, this form may be tuned for regular portal requests only from the traditional screen
--->

<cfparam name="url.itemno"     default="">
<cfparam name="url.storageid"  default="">
<cfparam name="url.shipto"     default="">
<cfparam name="url.uom"        default="0">
<cfparam name="url.warehouse"  default="">
<cfparam name="url.mission"    default="">
<cfparam name="url.mode"       default="">

<cfquery name="Detail" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Item I, ItemUoM U
	WHERE  I.ItemNo = U.ItemNo
	AND    I.ItemNo  = '#URL.ItemNo#'
	AND    U.Uom     = '#URL.UoM#' 
</cfquery>

<cfif url.warehouse eq "">

	<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   TOP 1 *
		FROM     Warehouse
		WHERE    Mission = '#URL.Mission#'	
		ORDER BY WarehouseDefault DESC 
	</cfquery>
	
	<cfif warehouse.recordcount eq "0">
		
		<table width="100%">
		
		<tr>
		<td height="30" bgcolor="ffffff" align="center" class="labelit">
			No facility configured yet
		</td>
		</tr>
		
		</table>
	
	    <cfabort>
	
	</cfif>

<cfelse>
	
	<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Warehouse
		WHERE  Warehouse = '#URL.Warehouse#'	
	</cfquery>
	
	<cfif warehouse.recordcount eq "0">
		
		<table width="100%">
		
		<tr>
		<td height="30" bgcolor="ffffff" align="center">
			<font face="Verdana" color="FF0000">No facility configured yet</font>
		</td>
		</tr>
		
		</table>
	
	    <cfabort>
	
	</cfif>
	
</cfif>

<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ParameterMission
	 WHERE  Mission   = '#warehouse.Mission#'
</cfquery>

<cfquery name="Special" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
	FROM    ItemWarehouse
	WHERE   ItemNo    = '#URL.ItemNo#'
	AND     Warehouse = '#warehouse.Warehouse#'
</cfquery>
		
<CFOUTPUT query="Detail">	

<table width="96%" align="center" cellpadding="0" cellspacing="0">

<tr><TD height="40" style="padding-top:6px;" bgcolor="ffffff">

  <cfif url.mode eq "">	
	
		<cf_button 
			id="back2"
			icon="Images/back2.png" 
			iconheight="19" 
			label="Back" 
			fontweight="normal" 
			fontsize="12px" 
			color="black" 
			onclick="list('1')">
							
  </cfif>
  
  <font face="Calibri" size="2" color="gray"><cf_tl id="Product">:</font>
  &nbsp;   
	<font face="Calibri" size="5" color="0D3262"><b>#ItemDescription#</b></font>
	
				<cfquery name="Category" 
			       datasource="AppsMaterials" 
			       username="#SESSION.login#" 
			       password="#SESSION.dbpw#">
			         SELECT    *
			         FROM      Ref_Category
			         WHERE     Category = '#Detail.Category#'	 				 
			 	</cfquery>
			  
		     <font face="Calibri" size="3">&nbsp;(#Category.Description#)
	</TD>	
</tr>

<tr><td colspan="2" class="linedotted"></td></tr>	

<tr class="hide"><td colspan="2" height="8" id="process"></td></tr>	

</table>

</cfoutput>

<CFOUTPUT query="Detail">

	<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
	    <td width="130" align="center" valign="top" style="padding-top:10px;border-right:1px dotted silver;padding-right:6px">
		
		 <cfif FileExists("#SESSION.rootDocumentPath#/Warehouse/Pictures/#ItemNo#.jpg")>		 
		 
		       <cftry>
			   
			       <cfinvoke component="Service.Image.CFImageEffects" method="init" returnvariable="effects">
			   
			       <cfimage action="RESIZE" 
					  source="#SESSION.rootDocument#Warehouse/Pictures/#ItemNo#.jpg" 
					  name="showimage" 
					  height="80" 
					  width="80">	
					  		 						  
					  <cfset showimage = effects.applyReflectionEffect(showimage, "gray", 60)>
						  
				    <cfimage action="WRITETOBROWSER" source="#showimage#">
					
										  
				<cfcatch>
								
				     <img src="#SESSION.rootDocument#/Warehouse/Pictures/#ItemNo#.jpg"
					     alt="#ItemDescription#"
					     width="80"
					     height="80"
					     border="0"
					     align="absmiddle">
				  
				</cfcatch>	  
				
				</cftry>
		 
		  	 <cfelse>		 
			 
			      <b><img src="#SESSION.root#/images/image-not-found1.gif" alt="#ItemDescription#" border="0" align="absmiddle"></b>
				  
		  </cfif>
		  
		</td>
		
		<td valign="top" style="padding-left:9px">
				
		    <table width="100%" valign="header" border="0" bordercolor="silver" cellpadding="0" cellspacing="0" class="formpadding">
						 
		      <input type="hidden" name="itemno"            id="itemno"          value="#URL.ItemNo#"> 
			  <input type="hidden" name="itemuom"           id="itemuom"         value="#URL.UoM#"> 
			  <input type="hidden" name="shipto"            id="shipto"          value="#URL.ShipTo#"> 
			  <input type="hidden" name="storageid"         id="storageid"       value="#URL.StorageId#">
		    
			  <tr><td height="2"></td></tr>
			  
			  <cfif url.mode eq "dialog">
			  
			       <tr><td height="4"></td></tr>
			  
				   <tr>						   
			        
					<TD height="20" width="130" class="labelmedium"><cf_tl id="Direct to">:</TD>
					
					<TD height="20"></TD>
					
			        <TD height="20" width="70%">
					
						 <cfquery name="WarehouseList" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   * 
								FROM     Warehouse P
								WHERE    Mission = '#URL.Mission#' 
								AND      Warehouse IN (SELECT Warehouse 
								                       FROM   WarehouseCategory 
													   WHERE  Warehouse = P.Warehouse
													   AND    Category  = '#Detail.Category#'
						                               AND    Operational = 1
													   AND    SelfService = 1)
								AND      Distribution = 1										   
												   
								ORDER BY WarehouseDefault DESC
						   </cfquery>
						   
						   <cfif WarehouseList.recordcount eq "0">
						   
							   <cfquery name="WarehouseList" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM     Warehouse P
									WHERE    Mission = '#URL.Mission#' 
									AND      Distribution = 1	
									ORDER BY WarehouseDefault DESC
							   </cfquery>
						   						   
						   </cfif>
						   
						   <cfquery name="getRequester" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM     Warehouse W,WarehouseLocation L
									WHERE    W.Warehouse = L.Warehouse
									AND      Storageid = '#url.storageid#'							
							</cfquery>
								  
						  <cfquery name="WarehouseSelect" dbtype="query">
								SELECT   * 
								FROM     WarehouseList
								WHERE    City = '#getRequester.city#'								 			   												   
								ORDER BY WarehouseDefault DESC
							</cfquery>
						   
						   <cfif warehouseSelect.recordcount neq "0">
						   
						   		<cfset sel = warehouseSelect.Warehouse>
								
						   <cfelse>
							
								<cfset sel = warehouseList.Warehouse>
								
						   </cfif>								   					    
							
						   <cfparam name="URL.Warehouse" default="#WarehouseSelect.warehouse#">
							
						   <cfif url.warehouse eq "">						
								<cfset url.warehouse = WarehouseSelect.warehouse>							
						   </cfif>															
							
						   <select style="font:18;height:27" name="warehouse" id="warehouse">
								<cfloop query="WarehouseList">
									<option value="#Warehouse#" <cfif URL.Warehouse eq Warehouse>selected</cfif>>#WarehouseName#</option>
								</cfloop>
						   </select>		
				  
				   </td>
				   
			      </TR>	
				  
				  <tr><td height="1"></td></tr>
			  
			  </cfif>				
			  					
			   <cfif url.storageid eq "">
				
					<tr>
			       		<TD height="30" width="130"><font face="Calibri" size="3"><cf_tl id="Quantity">:</TD>
						<TD height="30"></TD>
				        <TD height="30">
					
						<input type="text" 
						       name="requestquantity" 
							   id="requestquantity" 
							   value="#Special.MinReorderQuantity#" 
							   class="regular" 
							   size="4" 
							   maxlength="8" 
							   style="text-align: center;"> #Detail.UoMDescription#
							   
						</TD> 
			        </TR>		   
					   
				<cfelse>
				
				 	<cfquery name="get" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   * 
							FROM     WarehouseLocation
							WHERE    StorageId = '#url.storageid#'							
					</cfquery>
					
					<!--- files --->						
					
					<cfquery name="LocationSelect" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   L.* , (SELECT SerialNo FROM AssetItem WHERE Assetid = L.AssetId) as SerialNo
							FROM     WarehouseLocation L
							WHERE    Warehouse  = '#get.Warehouse#'
							<cfif get.Locationid eq "">
							AND      LocationId is NULL			
							<cfelse>
							AND      LocationId = '#get.Locationid#'							
							</cfif>		
							AND      Location IN (SELECT Location 
							                      FROM   ItemWarehouseLocationTransaction 
												  WHERE  Warehouse = L.Warehouse												
												  AND    Location  = L.Location
												  AND    ItemNo    = '#url.itemNo#'
												  AND    UoM       = '#url.uom#'
												  AND    TransactionType = '9'
												  AND    Operational = 1 )
							AND      Operational = 1
							
					</cfquery>					
					
					<!--- only geo locations --->
					   
					<cfquery name="LocationSelect" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   L.* , (SELECT SerialNo FROM AssetItem WHERE Assetid = L.AssetId) as SerialNo
							FROM     WarehouseLocation L
							WHERE    Warehouse  = '#get.Warehouse#'
							<cfif get.Locationid eq "">
							AND      LocationId is NULL			
							<cfelse>
							AND      LocationId = '#get.Locationid#'							
							</cfif>		
							AND      Location IN (SELECT Location 
							                      FROM   ItemWarehouseLocationTransaction 
												  WHERE  Warehouse = L.Warehouse												
												  AND    Location  = L.Location
												  AND    ItemNo    = '#url.itemNo#'
												  AND    UoM       = '#url.uom#'
												  AND    TransactionType = '9'
												  AND    Operational = 1 )
							AND      Operational = 1
							
					</cfquery>						
					
					<!--- safe guard --->
					
					<cfif LocationSelect.recordcount eq "0">
										
						<!--- only geo locations --->
						   
						<cfquery name="LocationSelect" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   L.* , (SELECT SerialNo FROM AssetItem WHERE Assetid = L.AssetId) as SerialNo
								FROM     WarehouseLocation L
								WHERE    Warehouse  = '#get.Warehouse#'
								<cfif get.Locationid eq "">
								AND      LocationId is NULL			
								<cfelse>
								AND      LocationId = '#get.Locationid#'							
								</cfif>		
								AND      Location IN (SELECT Location 
								                      FROM   ItemWarehouseLocation 
													  WHERE  Warehouse = L.Warehouse												
													  AND    Location  = L.Location
													  AND    ItemNo    = '#url.itemNo#'
													  AND    UoM       = '#url.uom#')
								AND      Operational = 1
								
						</cfquery>						
					
					</cfif>	
									  												
					<cfloop query="LocationSelect">
					
						<tr>					
						
							<td class="labelmedium">
							
							   <cfif LocationSelect.recordcount eq "1">
							   
							   <b><u>Requirement</u></b>
							   
							   <cfelse>
							   
									<table cellspacing="0" cellpadding="0">
									<tr>
									<td class="labelmedium" height="20" style="padding-right:4px">#Description#</td>
									<td class="labelmedium" style="padding-right:4px">#StorageCode#</td>
									<td class="labelmedium" style="padding-right:4px"><cfif serialNo neq ""><font color="808080">[#SerialNo#]</cfif>:</td>									
									</tr>
									</table>
									
								</cfif>	
							</td>
							
							<td></td>
							
						</tr>
						
						<tr>	
							
							
							<td colspan="2" class="labelmedium" style="padding-left:30px">
							
															
								<cfquery name="Detail" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT *
									FROM   Item I, ItemUoM U
									WHERE  I.ItemNo = U.ItemNo
									AND    I.ItemNo  = '#URL.ItemNo#'
									AND    U.Uom     = '#URL.UoM#' 
								</cfquery>
								
								<b><u>#Detail.ItemDescription#</u></b>

							</td>
							
							<td>
							
								<cf_tl id="Invalid Quantity" var="1">
													
								<cfinput type="text" 
							       name="requestquantity_#left(storageid,8)#" 
								   id="requestquantity_#left(storageid,8)#" 
								   validate="float"
								   message="#lt_text#"
								   value="" 
								   class="regular" 
								   size="4" 
								   maxlength="8" 
								   style="height:30;font:22px;text-align: center;"> 								   
								   #Detail.UoMDescription#
								   
						    </td>					  						
								
						</tr>
						
					</cfloop>
														
				</cfif>	 		
			  		  
			  
			  <cfif Parameter.PortalInterfaceMode neq "Internal">
			  
				  <tr>
			        <TD height="25" lass="labelmedium"><cf_tl id="Classification">:</TD>
					<TD height="25"></TD>
			        <TD height="25">#Classification# [#ItemNo#]</TD>
			      </tr>
				  <tr>
			        <TD height="25" lass="labelmedium"><cf_tl id="Color">:</TD>
					<TD height="25"></TD>
			        <TD height="25"><cfif itemcolor neq "">#ItemColor#<cfelse>N/A</cfif></TD>
			      </tr>
				  <tr>
			    	<TD height="25" lass="labelmedium"><cf_tl id="Class">:</TD>
					<TD height="25"></TD>
			        <TD height="25">#ItemClass#</TD>
			      </tr>
				  
			  </cfif>
			  
			  <cfif itemUoMdetails neq "">
				   <tr>
				        <TD height="25" lass="labelmedium"><cf_tl id="Details">:</TD>
						<TD height="25"></TD>
				        <td height="25">#ItemUoMDetails#</td>
			      </tr>
			  </cfif>
			 			  
			  <cfif Parameter.PortalInterfaceMode neq "Internal">
							  
			  <cfquery name="OnHand" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   W.Warehouse,
					         W.WarehouseName, 
					         SUM(TransactionQuantity) as OnHand
					FROM     Warehouse W, ItemTransaction I
					WHERE    I.Mission         = '#URL.Mission#'
					AND      I.Warehouse       = W.Warehouse
					AND      I.ItemNo          = '#URL.ItemNo#'
					AND      I.TransactionUom  = '#URL.UoM#'				
					AND      W.Distribution = 1
					AND      W.Warehouse IN (SELECT Warehouse 
							                 FROM   WarehouseCategory 
										     WHERE  Warehouse = I.Warehouse
						                     AND    Operational = 1
										     AND    SelfService = 1)					   
					GROUP BY W.Warehouse, W.WarehouseName
			  </cfquery>
			 		  
			  <tr>
		        <TD height="20" valign="top" style="padding-top:4px"><font face="Verdana"><cf_tl id="Availability">:</TD>
				<TD height="20"></TD>
				<cf_Precision number="#ItemPrecision#">
				
		        <TD height="20" colspan="3">
				
				<cfif OnHand.recordcount eq "0">
				
					<font color="800000"><cf_tl id="Not available"></font>
					
				<cfelse>
				
					<table width="200" cellspacing="0" cellpadding="0">
						<cfloop query = "OnHand">
						<tr><td>#WarehouseName#</td>
						    <td align="right" colspan="3">
							
							<cfif Parameter.PortalInterfaceMode neq "Internal">
							
								<cfif OnHand.OnHand gt "0">
							    <cf_tl id="On Hand">: #NumberFormat(OnHand.OnHand,"#pformat#")#					       
								<cfelse>
								<font color="800000"><cf_tl id="Not available"></font>
							    </cfif>
								
							<cfelse>
							
								<cfif OnHand.OnHand gt "0">
							    <font color="green"><cf_tl id="Available"></font>			       
								<cfelse>
								<font color="800000"><cf_tl id="Not available"></font>
							    </cfif>							
								
							</cfif>	
							</td>
						</tr>
						<cfif currentrow neq recordcount>
						<tr><td colspan="2" style="border-top:1px dotted silver"></td></tr>
						</cfif>
						</cfloop>
					</table>
						
				</cfif>
				</TD>
		      </tr>		 
			  
			  </cfif>
			  			  			  			  
			  <cfif Parameter.PortalInterfaceMode neq "Internal">
			  
				  <tr>
			        <TD height="25" lass="labelmedium">><cf_tl id="Price">:</TD>
					<TD height="25"></TD>
			        <TD height="25"><font face="Calibri" size="3">#NumberFormat(StandardCost,'$____.__')#</TD>
			      </tr>
			  
			  </cfif>
			  
			  <tr>
			   <td height="25" valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Remarks">:</td>
			   <TD height="25" width="10"></TD>
		       <TD height="25" colspan="4" style="padding-top:2px">
					<textarea class="regular" name="remarks" id="remarks" style="width:90%;height:70"></textarea>				
	           </td>
			  </tr>		
			  		
	      </table>
		 		  
		  </td>    
	   </tr>
	   
	   <tr><td colspan="3">	   
	   
	   		<cfinclude template="CartAddDetail.cfm">	   
		
	   </td></tr>	   
	   
	   <tr><td colspan="3" height="6"></td></tr>	
	   <tr><td colspan="3" style="border-bottom:1px dotted silver"></td></tr>	
	   
	   <tr><td height="30" colspan="3" align="center" style="padding-top:4px">
	   
	   		<cfif url.mode eq "">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
					   <cf_button 
					   		id="Back"
					   		icon="Images/back2.png" 
							iconheight="19" 
							label="Back" 
							fontweight="normal" 
							fontsize="12px" 
							color="black" 
							onclick="list('1')">
					</td>
					<td>	
					       
					   <cf_button 
					   		id="add"
					   		icon="Images/add2.png" 
							iconheight="19" 
							label="Add" 
							fontweight="normal" 
							fontsize="12px" 
							color="black" 
							onclick="addtomycart()">
	    			</td>
				</tr>
			</table>
			
		   <cfelse>
		   
		   	   <cf_tl id="Add to Request" var="vAdd">
	   	   	   <cf_tl id="Send for submission" var="vQuestion">
		   
			   <cf_button 
			   	    id         = "add3"
			   		icon       = "Images/add2.png" 
					iconheight = "19" 
					mode       = "graylarge"
					width      = "180x" 
					label      = "#vAdd#" 
					fontweight = "normal" 
					fontsize   = "15px" 
					height     = "20"
					color      = "black" 
					onclick    = "if (confirm('#vQuestion# ?')) { addtocart('#url.mission#','#url.itemno#','#url.uom#') }">	
		   </cfif>
		 
		   </td>
	   </tr>
	   
	   <tr><td colspan="3" style="border-bottom:1px dotted silver"></td></tr>	
	   
	   <tr><td colspan="3" height="6"></td></tr>	

</table>
</cfoutput>
