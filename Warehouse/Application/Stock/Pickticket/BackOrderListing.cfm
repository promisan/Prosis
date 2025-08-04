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

<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cfparam name="URL.id"        default="0000">
<cfparam name="URL.mission"   default="Promisan">
<cfparam name="URL.Group"     default="ItemNo">
<cfparam name="URL.Page"      default="1">
<cfparam name="URL.Mode"      default="">
<cfparam name="URL.IDStatus"  default="2b">
<cfparam name="URL.ItemClass" default="Supply">
<cfparam name="URL.fnd"       default="">

<cfif url.mode eq "Review">
	<cfinclude template="../Schedule/Backorder.cfm">
</cfif>

<cfif URL.Group eq "">
  <cfset URL.Group = "ItemNo">
</cfif>

<cfinclude template="getListingData.cfm">

<cfset rows = 45>
<cfset first   = ((URL.Page-1)*rows)+1>
<cfset pages   = Ceiling(SearchResult.recordCount/rows)>
<cfif pages lt '1'>
   <cfset pages = '1'>
</cfif>

<table width="100%"  
	   class="formpadding"     
       border="0"
	   align="center"
       cellspacing="0"	   
	   cellpadding="0">

  <!---	   
  <tr><td colspan="2" height="57">
  
 			 <table height="57px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
				<tr>
					<td style="z-index:5; position:absolute; top:5px; left:35px; ">
						<img src="<cfoutput>#SESSION.root#</cfoutput>/images/logos/warehouse/backorder.png" alt="" width="60" height="60" border="0">
					</td>
				</tr>							
				<tr>
					<td style="z-index:3; position:absolute; top:37px; left:120px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
						<cf_tl id="Backordered items">
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:14px; left:120px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
						<cf_tl id="Backorders items">
					</td>
				</tr>							
				<tr>
					<td style="position:absolute; top:55px; left:120px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
						
					</td>
				</tr>							
			</table>
	</td>
  </tr>	 
  
  --->
  
  <cfoutput>  
  
  <tr>  
		  <td style="padding-left:20px">
		  
		  	<table class="formspacing">
			<tr>			
				<td>		  
			  	<input type="radio" name="Process" id="Process" style="height:19px;width:19px" value="Process" class="radiol" onclick="stockpicking('s','#url.systemfunctionid#')"/>			
				</td>
				<td style="font-size:20px;padding-left:3px" class="labelmedium"><cf_tl id="Process Replenishment"></td>
				<td style="padding-left:10px">		  
			  	<input type="radio" checked name="Backorder" style="height:19px;width:19px" id="Backorder" value="Pending" class="radiol" onclick="stockbackorder('s','#url.systemfunctionid#')"/>			
				</td>
				<td style="font-size:20px;padding-left:3px" class="labelmedium"><cf_tl id="On Backorder"></td>		
			</tr>
			</table>
				
		  </td>		  
	  
  </tr>	
  
  </cfoutput> 	  
			
  <tr><td colspan="2" height="1"  class="linedotted"></td></tr>
	  	   
  <tr onKeyUp="javascript:search()">
	 
	  <td valign="top">
					
			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
			
			<cfoutput>
			
			<tr>
			<td width="218px" class="labelit">
			
				<table cellspacing="0" cellpadding="0">
				<tr>
				<td style="padding-left:15px" class="labelmedium"><cf_tl id="Find">:</td>				
				<td style="padding-left:5px">
						
				   <input type="text"
				       name="find"
					   id="find"
				       value="#URL.Fnd#"
				       size="10"
				       maxlength="25"
				       class="regularxl"
				       style="border:1px solid silver;"
				       onClick="clearsearch()">
				   
				</td>
				
				<td style="padding-left:5px">   
			   
			     <img src="#SESSION.root#/Images/search.png" 
						  alt         = "Search" 
						  name        = "locate"
						  height      = "25"
						  width       = "25"
						  onMouseOver = "document.locate.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut  = "document.locate.src='#SESSION.root#/Images/search.png'"
						  style       = "cursor: pointer; height:25px" 
						  border      = "0" 
						  align       = "absmiddle" 
						  onclick     = "stockbackorder('s','#url.systemfunctionid#')">
						  
				  </td>
				  </tr>
				  </table>
			
			</td>
			
			<TD height="26" align="right" style="padding-right:4px">		
			
				<table cellspacing="0" cellpadding="0"><tr>
				
				<td style="padding-left:3px">	
				<select name="group" id="group" class="regularxl" size="1" style="background: ffffff;" onChange="javascript:stockbackorder('s','#url.systemfunctionid#')">
				     <option value="Location" <cfif URL.Group eq "Location">selected</cfif>><cf_tl id="Group by Location">
				     <OPTION value="ItemNo" <cfif URL.Group eq "ItemNo">selected</cfif>><cf_tl id="Group by Item">
				</SELECT> 
				</td>
				
				<td style="padding-left:3px">
			   	<select name="page" id="page" class="regularxl"  size="1" style="background: ffffff;" onChange="javascript:stockbackorder('s','#url.systemfunctionid#')">
				    <cfloop index="Item" from="1" to="#pages#" step="1">
				        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
			    	</cfloop>	 
				</SELECT>   
				</td></tr>
				</table>
			
			</TD>
			</tr>
			
			</cfoutput>		
			</table>			
	  </td>			
  </tr>
    
  <tr><td colspan="2" height="1" class="line"></td></tr>
					
  <TR onKeyUp="navigate()">
	<td height="100%" colspan="2">
		
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
		<cfoutput>
		
		<cfif SearchResult.recordcount gt "0">
		
		<tr class="labelmedium line">
		    <td width="5%" height="18"></td>						
			<TD width="10%"><cf_tl id="Reference">&nbsp;&nbsp;&nbsp;</TD>			
			<TD width="15%"><cf_tl id="Contact"></TD>
			<TD width="8%"><cf_tl id="ItemNo"></TD>
			<TD width="20%"><cf_tl id="Description"></TD>
		    <TD width="10%"><cf_tl id="UoM"></TD>
		    <TD width="9%" align="right"><cf_tl id="Qty"></TD>
			<TD width="9%" align="right"><cf_tl id="Picked"></TD>
			<td width="9%" align="right"><cf_tl id="Price"></td>
			<td width="9%" align="right"><cf_tl id="Total"></td>
		 </TR>
		
		</cfif> 
		 
		 <cfif SearchResult.recordcount eq "0">
		 
		  <tr>
		  <td colspan="10" align="center" style="padding-top:40px" class="labelmedium">
		  <cf_tl id="There are no more Backordered Items">
		  </td>
		  </tr>
		  
		 <cfelse>
		
		  <tr class="line"><td colspan="10" style="height:36px;padding-left:25px">
			  <cf_tl id="Evaluate Backorder Requests" var="1">
			  <cfoutput>
			  <input type="button" class="button10g" style="width:240px;height:26" name="Add" id="Add" onclick="stockbackorder('review','#url.systemfunctionid#')" value="#lt_text#">
			  </cfoutput>
		  </td></tr> 		  
		  		 
		 </cfif> 
		
		</cfoutput>
												
		<cfoutput>
				
			<input type="hidden" name="refresh" id="refresh" onClick="javascript:stockbackorder('','#url.systemfunctionid#')">
			<input type="hidden" name="pages" id="pages" value="#pages#">
			<input type="hidden" name="total" id="total" value="#rows#">
			<input type="hidden" name="row" id="row" value="0">
			<input type="hidden" name="topic" id="topic" value="#SearchResult.ItemNo#" onClick="javascript:item(this.value,'','#URL.Mission#')">
					
		</cfoutput>
				
		<cfset row   = 0>
		<cfset grp   = 1>
		<cfset prior = "">
				
		<cfset amtT    = 0>
		<cfset amt    = 0>
								
		<cfoutput query="SearchResult" startrow="#first#">
				
				<cfif currentrow-first lt rows>
				
				  <cfset row = "#currentrow-first+1#">
				  				  						
					    <tr bgcolor = "#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('Ffffff'))#"
						    class   = "labelmedium navigation_row"
							style   = "cursor : pointer">
													
							<cfif itemClass eq "Supply">
						    	<td align="left">
								<!---
								<cfif Status is '2' or Status is "2b">
								   	<input type="checkbox" name="selected" value="'#RequestId#'" onClick="hl(this,this.checked)" checked>
						    	</cfif>
								--->
							<cfelse>
						    	<td align="center">
								<!---
							   	<cfif Status is '2' or Status is "2b">
									<img src="#SESSION.root#/Images/btn_select.jpg" name="sel#RequestId#" 
									onMouseOver="document.sel#RequestId#.src='#SESSION.root#/Images/btn_select1.jpg'" 
									onMouseOut="document.sel#RequestId#.src='#SESSION.root#/Images/btn_select.jpg'" 
									style="cursor: pointer;" alt="" border="0" 
									onClick="javascript:asset('#RequestId#')">
						    	</cfif>
								--->
								
						    </cfif>		
										
							</td>							
							<td>#reference#</td>
							<td><cfif ShipToWarehouseName neq "">#ShipToWarehouseName#<cfelse>#Contact#</cfif></td>
							<TD><a href="javascript:item('#ItemNo#','#url.systemfunctionid#','#url.mission#')">#ItemNo#</a></TD>
							<TD>#ItemDescription#</TD>
						    <TD>#UoMDescription#</TD>
						    <TD align="right">#RequestedQuantity#</TD>
							<TD align="right"><cfif fullfilled eq "">0<cfelse>#fullfilled#</cfif></TD>
						    <td align="right" style="padding-right:4px">#NumberFormat(StandardCost,',.__')#</td>	
							<td align="right" style="padding-right:4px">#NumberFormat(RequestedAmount,',.__')#</td>	
							
							<cfset Amt  = Amt  + RequestedAmount>
						    <cfset AmtT = AmtT + RequestedAmount>
					    		
						</TR>
						
						<!--- find where this item could be found alternatively --->
											
						<cfquery name="Stock" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   TOP 1 *
							FROM     skStockOnHand
							WHERE    Mission        = '#URL.Mission#'
							AND      Warehouse     != '#url.warehouse#'
							AND      Warehouse IN (SELECT Warehouse
							                       FROM   Warehouse 
												   WHERE  Operational = 1 
												   AND    Distribution = 1)
							AND      ItemNo         = '#ItemNo#'
							AND      TransactionUoM = '#UnitOfMeasure#'								
							AND      OnHand > '0'
							ORDER BY OnHand DESC
						</cfquery>
						
						<cfloop query="Stock">
						
						<tr class="labelmedium">
						  <td height="20"></td>
						  <td bgcolor="ffffaf">Also carried by:</td>
						  <td bgcolor="ffffaf">#Warehouse#</td>
						  <td colspan="7" bgcolor="ffffaf" id="forward_#SearchResult.requestid#"><img src="#SESSION.root#/images/forward.gif" align="absmiddle" alt="" border="0">
						  &nbsp;<a href="javascript:forwardrequest('#SearchResult.requestid#','#Warehouse#')">Forward request</td></td>
						</tr>
						
						</cfloop>
																  
				  <cfset prior = itemno>
													  
  			    </cfif>					
												 									
			</CFOUTPUT>
					
			</TABLE>
							
		</td>
	</tr>		
</table>	

<cfset ajaxonload("doHighlight")>
