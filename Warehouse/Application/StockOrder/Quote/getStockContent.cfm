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

<cfparam name="form.priceschedule"      default="3">
<cfparam name="Form.Category"           default="">
<cfparam name="Form.CategoryItem"       default="">
<cfparam name="Form.SettingOnHand"      default="">
<cfparam name="Form.SettingPromotion"   default="">
<cfparam name="Form.SettingReservation" default="">
<cfparam name="Form.FilterMake"         default="">

<cfset make = "">

<cfif Form.filterMake neq "">
		
	<cfloop index="itm" list="#form.FilterMake#" delimiters="|">
		
		<cfif make eq "">
			<cfset make = "'#itm#'">
		<cfelse>
			<cfset make = "#make#,'#itm#'">	
		</cfif>
	
	</cfloop> 

</cfif>

<cfparam name="Form.FilterSubCat"     default="">

<cfset subcat = "">

<cfif Form.FilterSubCat neq "">
	
	<cfloop index="itm" list="#form.FilterSubCat#" delimiters="|">
		
		<cfif subcat eq "">
			<cfset subcat = "'#itm#'">
		<cfelse>
			<cfset subcat = "#subcat#,'#itm#'">	
		</cfif>
	
	</cfloop> 

</cfif>

<cfquery name="Topics" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	 	 SELECT     *
         FROM       Ref_Topic
         WHERE      Code IN
                      (SELECT    Code
                       FROM      Ref_TopicCategory
                       WHERE     Category = '#form.category#')
		AND        Operational = 1
		AND        TopicClass = 'Category'	
		AND        ValueClass IN ('List','Text','Lookup')		   
	</cfquery>	

		
<cfset classify = "">
<cfset claslist = "">	

<cfloop query = "topics">

     <cfparam name="Form.Filter#code#" default="">	 
	 <cfset content = evaluate("Form.Filter#code#")>	
	 	 
	 <cfset val = "">
	 <cfloop index="itm" list="#content#" delimiters=",|">	 
		 <cfif val eq "">
		 	<cfset val = "'#itm#'">
		 <cfelse>
		    <cfset val = "#val#,'#itm#'">
		 </cfif>
		  <cfset claslist = "#claslist#|#code#:#itm#">
	 </cfloop>
		 
	 <cfif val neq "">	 
	 
	    <cfif classify eq "">		
			 <cfset classify  = " SELECT ItemNo FROM Materials.dbo.ItemClassification             WHERE Topic = '#code#' AND ListCode IN (#preserveSingleQuotes(val)#)"> 		
		<cfelse>		     
			 <cfset classify  = " SELECT #Code#.ItemNo FROM (#preserveSingleQuotes(classify)#) as #Code# INNER JOIN Materials.dbo.ItemClassification V ON #Code#.ItemNo = V.ItemNo WHERE Topic = '#code#' AND ListCode IN (#preserveSingleQuotes(val)#)"> 		
		</cfif>	 	 
		
	 </cfif>	
	 
</cfloop>	

<cfinvoke component = "Service.Process.Materials.Stock"  
   method              = "getStockListing"
   Content             = "Searcher" 
   Mission             = "#Form.Mission#"
   Warehouse           = "#Form.Warehouse#"
   PriceSchedule       = "#form.PriceSchedule#"
   Make                = "#Make#"
   Category            = "#Form.Category#"   
   CategoryItem        = "#SubCat#"
   ItemName            = "#Form.ItemName#"
   ItemNo              = "#Form.ItemNo#"
   Classify            = "#Classify#"
   SettingOnHand       = "#Form.SettingOnHand#"
   SettingPromotion    = "#Form.SettingPromotion#"
   SettingReservation  = "#Form.SettingReservation#"
   returnvariable      = "get">	
   

<table style="width:97%" class="formpadding navigation_table">
		
		<cfoutput>
		
		<tr class="labelmedium2 fixrow fixlengthlist line">	
		    
			<td><cf_tl id="Store"></td>			
			<td align="right"><cf_tl id="Box"></td>
			<!---
			<td align="right"><cf_tl id="Price"></td>
			<td align="right"><cf_tl id="Promotion"></td>
			--->			
			<td align="right"><cf_tl id="UoM"></td>	
			<td align="right"><cf_tl id="Sold"></td>
			<td align="right" style="padding-right:4px"><cf_tl id="Transit"></td>
			<td align="right"><cf_tl id="Available"></td>		
			<td align="right" title="Reserved for sales order"><cf_tl id="Reserved"></td>
			<td align="right" title="Serious quote"><cf_tl id="Requested"></td>			
			<!---
			<td style="min-width:70px;padding-right:4px" align="right"><cf_tl id="Disposed"></td>		
			--->	
					
		</tr>
		
		</cfoutput>
				
		
		<cfif get.recordcount eq "0">
		
		<tr class="labelmedium2"><td style="color:red;padding-top:30px;font-size:18px" colspan="9" align="center"><cf_tl class="message" id="no records"></td></tr>
		
		</cfif>
		
		<cf_tl id="Add" var="1">
					
			<cfoutput query="get" group="ItemNo">	
			
				<cfoutput group="UoM">	
			
					<tr class="fixrow2 line fixlengthlist"><td colspan="10" style="padding-top:10px;padding-bottom:4px">

					<table style="width:100%">					
					<tr>
										
					<td style="min-width:160px;padding-left:8px" align="center">
					   <cfif imagePath neq "">
					   
					    <div style="height:92px;margin-left: 5px;border-bottom: 1px solid ##efefef;">
				           <div style="float: left;">
				              <a href="#session.rootDocument#/#ImagePath#"
					             class='lightview'
				               	 data-lightview-group='Items#ItemNo#'
					             data-lightview-title="#ItemNo#<br>(#ItemNoExternal#)"
					             data-lightview-caption="#ItemDescription#<br>#Mission#"
				                 data-lightview-options="skin: 'mac'">
							   <img style="max-width: 150px;height:auto;border: 1px solid ##efefef;" src="#session.rootDocument#/#ImagePath#">		 
				            </a>
				           </div>
						 </div>
				   
					     </cfif>
						 
					</td>
													
					<td valign="top" style="width:100%;padding-left:13px;padding-bottom:3px">
					
						<table style="width:100%">
						
						    <!--- stange --->
							<tr><td style="font-size:18px"><cfif itemNoExternal neq ""><b>#ItemNoExternal#</b><cfelse>#ItemNo#</cfif>: #ItemDescription#</td></tr>
							<tr><td style="font-size:18px"><cfif itemNoExternal neq ""><b>#ItemNoExternal#</b><cfelse>#ItemNo#</cfif><span style="font-size:15px">: #ItemDescription#</span></td></tr>
														
							<tr>
							<td style="color:gray;width:20%;padding-right:4px;font-size:17px">
							
								<font size="1">#Currency#&nbsp;</font>
								<cfif promotion eq "1">
								<font size="4" color="FF0000"><b>#numberformat(SalesPrice,',.__')#</font>
								<cfelse>
								<font size="4" color="0080C0">#numberformat(SalesPrice,',.__')#</font>
								</cfif>
								&nbsp;#CategoryName#
							
							</td>
							</tr>
							
							<tr><td style="color:xwhite;gray;width:20%;padding-right:4px;font-size:13px">
							
								<cfquery name="class" 
								datasource="appsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">							
									SELECT     R.Code, R.TopicLabel, R.Description, C.ListCode, C.TopicValue
									FROM       ItemClassification AS C INNER JOIN Ref_Topic AS R ON C.Topic = R.Code
									WHERE      R.TopicClass = 'Category' 
									AND        Code IN (SELECT Code FROM Ref_TopicCategory WHERE Category = '#form.category#')
									AND        C.ItemNo     = '#ItemNo#'
									ORDER BY   R.ListingOrder, R.Code						
								</cfquery>
														
								<cfloop query="class"><font size="1">#topiclabel#:&nbsp;</font>
								
								<cfif findNoCase("#Code#:#ListCode#",claslist)>
									<span style="color:green;font-weight:bold;padding-right:4px;">#topicvalue#</span>
								<cfelse>
									<span style="font-weight:bold;padding-right:4px">#topicvalue#</span>
								</cfif>
								
								</cfloop>
								
							</td>	
							</tr>		
							
							<cf_tl id="Add" var="1">
							<tr>
							   <td  style="padding-top:4px;padding-left:10px">
							   <input type="button" value="#lt_text#" 
									class="button10g" 
									style="width:170px;border:1px solid silver" 
									onClick="additem('#warehouse#','#itemno#','#uom#','#currency#','#priceschedule#')">
							   </td>																				
							</tr>
						
						</table>
					</td>						
					</tr>					
										
					</table>
					
					</td></tr>
											
				<cfoutput>
				
				<cf_precision precision="#ItemPrecision#">
											
				<tr class="labelmedium2 line navigation_row fixlengthlist">	
				   
	   			    <!--- <cfif form.warehouse neq "999999"> --->
					<td style="font-size:15px;background-color:##f1f1f150;padding-left:18px">#WarehouseName#</td>	
					<!---					
					<cfelse>
					<td style="background-color:##f1f1f150;padding-left:3px">
					<table>
						<tr>
						<td>
						<input type="button" value="#lt_text#" class="button10g" style="border-radius:3px;width:67px;border:1px solid silver" 
							onClick="additem('#warehouse#','#itemno#','#uom#','#priceschedule#','#currency#')">
						</td>
						<td><cfif itemNoExternal neq "">#ItemNoExternal#<cfelse>#ItemNo#</cfif>: #ItemDescription#</td>
						</tr>
					</table>
					</td>	
					</cfif>
					--->
					<td style="background-color:##B0D8FF50" align="right">#MinReorderQuantity#</td>
					<!--- moved up
					<td style="background-color:##B0D8FF50" align="right">#numberformat(SalesPrice,',.__')#</td>					
					<td style="background-color:##B0D8FF50;font-weight:bold" align="right">
					<cfif promotion eq "0">--<cfelse>#numberformat(SalesPrice,',.__')#</cfif>
					</td>
					--->		
					<td align="right">#UoMName#</td>		
					<td style="background-color:##ffffaf50;" align="right">#dateformat(LastSold,"MMM-YY")#</td>
					
					<cfif QuantityInTransit eq "0">
					   <td style="font-size:14px;background-color:##e1e1e1" align="right">--</td>
					<cfelse>
					   <td style="backgtround-color:##ffffaf50" align="right">										   
					   <a href="javascript:stocktransit('#warehouse#','#itemno#','#uom#','transit')">
					   #numberformat(QuantityInTransit,'#pformat#')#
					   </a>				   
    				   </td>
					</cfif> 	
					
					<cfif QuantityForSale eq "0">
						<td style="font-size:13px;background-color:##f1f1f150" align="right">--</td>
					<cfelse>				
						<td style="font-size:16px;background-color:##80FF8050;border:1px solid silver" align="right">#numberformat(QuantityForSale,'#pformat#')#</td>
					</cfif>	
																						
					<cfif quantityreserved eq "0">
						<td style="font-size:14px;background-color:##e1e1e1" align="right">--</td>
					<cfelse>					
						<td style="font-size:15px;background-color:008080;border:1px solid silver" align="right">						
						<cfset link   = "#SESSION.root#/Warehouse/Application/StockOrder/Quote/QuoteAdd.cfm?mission=#form.mission#&">	 
				        <a href="javascript:stockquote('#warehouse#','#itemno#','#uom#','request','#link#')">#numberformat(quantityreserved,'#pformat#')#</a>						
						</td>
					</cfif>
					
					<cfif QuantityRequested eq "0">
					    <td style="font-size:14px;background-color:##e1e1e1" align="right">--</td>
					<cfelse>
					   <td style="backgtround-color:##ffffaf50" align="right">			
					   <cfset link   = "#SESSION.root#/Warehouse/Application/StockOrder/Quote/QuoteAdd.cfm?mission=#form.mission#&">	 
					   <a href="javascript:stockreserve('#warehouse#','#itemno#','#uom#','request','#link#')">
					   <font color="000000">#numberformat(QuantityRequested,'#pformat#')#
					   </a>
					   
					   </td>
					</cfif> 
					
									
											
				</tr>
				
				</cfoutput>
				
				</cfoutput>
			
			</cfoutput>
	
	</table>

	<cfset ajaxonload("doHighlight")>
