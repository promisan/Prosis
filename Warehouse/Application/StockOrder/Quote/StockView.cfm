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

<cfset title = "Stock inquiry and quote preparation">

<cf_screentop html="No" label="#title#" jquery="Yes">

<cf_dialogmaterial>
<cf_presenterscript>
<cf_calendarscript>
<cf_authorizationscript>
<cf_dialogorganization>
<cf_menuscript>

<cfajaximport tags="cfdiv,cfform">
	
	<cfquery name="Warehouse" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Warehouse
	   WHERE     Mission = '#url.mission#'
	   AND       Warehouse IN (SELECT Warehouse FROM itemTransaction)
	   AND       Operational = 1  	   
	</cfquery>
	
	<cfquery name="Category" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Ref_Category
	   WHERE     Operational = 1  	
	   AND       FinishedProduct = 1   
	</cfquery>
	
	<cfoutput>
	
	<script language="JavaScript">
	
		function search() {     
		   _cf_loadingtexthtml='';  
		   ptoken.navigate('getStockContent.cfm','content','','','POST','stockform')      
		}
	
		function apply(e) {	  
		   _cf_loadingtexthtml='';  	      
		   keynum = e.keyCode ? e.keyCode : e.charCode;	   	 						
		   if (keynum == 13) {
		      search();
		   }						
		}
		
		// refresh data in Prosis not needed 	
		function refresh(mis,itm,box) {     
		   _cf_loadingtexthtml='';  
		   ptoken.navigate('getStock.cfm?mission='+mis+'&itemno='+itm,box)      
		}
				
		function getcategory(mis,cat) {     
		   _cf_loadingtexthtml='';  	  
		   ptoken.navigate('getSelectionCategory.cfm?mission='+mis+'&category='+cat,'boxcategory')      
		}
		
		function addquote() {     
		    _cf_loadingtexthtml='';  		  
		    ptoken.navigate('QuoteAdd.cfm?mission=#url.mission#&warehouse='+document.getElementById('warehousequote').value,'boxquote')      
			document.getElementById('boxaction').className = "hide"
		}
					
		function additem(whs,itm,uom,cur,sch) {		 
		  if (document.getElementById('requestno').value == '') {	     
		     addquote()	  
		  } else { 
		    _cf_loadingtexthtml='';		
		    ptoken.navigate('getQuoteLine.cfm?action=add&requestno='+document.getElementById('requestno').value+'&warehouse='+whs+'&itemno='+itm+'&uom='+uom+'&currency='+cur+'&priceschedule='+sch,'boxlines') 
			document.getElementById('boxaction').className = "regular"
		  }	
		}	
		
		function setpriceschedule(schedule,no) {
		     ptoken.navigate('applySchedule.cfm?priceschedule='+schedule+'&requestno='+document.getElementById('requestno').value,'process') 		
		}	
		
		function setquote(no,act,val) {	  
	       _cf_loadingtexthtml='';		
		   ptoken.navigate('QuoteEdit.cfm?action='+act+'&requestno='+no+'&val='+val,'boxprocess','','','POST','stockform') 	
		}	
						
		function deleteitem(tra) {	  
	       _cf_loadingtexthtml='';		
		   ptoken.navigate('QuoteEdit.cfm?action=deleteline&transactionid='+tra,'boxprocess') 	
		}
		
		function stockreserve(whs,itm,uom,mde,link) {
		 	ProsisUI.createWindow('quotationview','Reservations','',{x:100,y:100,width:900,height:420,resizable:true,modal:true,center:true})
			ptoken.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Quote/ReservationView.cfm?warehouse='+whs+'&itemNo='+itm+'&uom='+uom+'&mode='+mde+'&link='+link,'quotationview')							
		}
			
				
		function stocktransit(whs,itm,uom,mde) {
		 	ProsisUI.createWindow('stockinquiry','In Transit','',{x:100,y:100,width:900,height:420,resizable:true,modal:true,center:true})
			ptoken.navigate('#SESSION.root#/Procurement/Application/Receipt/ReceiptInquiry/ReceiptViewItem.cfm?warehouse='+whs+'&itemNo='+itm+'&uom='+uom+'&mode='+mde,'stockinquiry')							
		}
		
		function applyQuote(act,no) {	  
	       _cf_loadingtexthtml='';		
		   ProsisUI.createWindow('processquote','Quotation '+no,'',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,resizable:true,modal:true,center:true})
		   ptoken.navigate('applyQuote.cfm?requestno='+no+'&action='+act+'&idmenu=#url.systemfunctionid#','processquote','','','POST','stockform') 	
		}	
		
		function submitOrder(reqno) {	  
	       _cf_loadingtexthtml='';		   
			document.salesorder.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
			   ptoken.navigate('#session.root#/workorder/application/workorder/create/quote/DocumentSubmit.cfm?requestNo='+reqno+'&idmenu=#url.systemfunctionid#','boxprocess','','','POST','salesorder') 	
			 }   
        }	 
		
	</script>
	

	
	
	</cfoutput>
	
	<cf_layoutscript>
	<cf_textareascript>
		
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	  

	<cfparam name="url.summary" default="1">
	
	<form name="stockform" id="stockform" style="width:100%;height:100%">
		
	<cf_layout attributeCollection="#attrib#">

		<cf_layoutarea 
		          position="header"
				  size="50"
		          name="header">	
				  
				<cf_ViewTopMenu label="#Title#" menuaccess="context" background="blue">
						
		</cf_layoutarea>	
		
		<cf_layoutarea 
		          position="top"
				  size="35"
		          name="top">	
				
					<table class="formpadding navigation_table" style="height:100%;width:100%">
						<tr style="border-bottom:1px solid silver">
						<td>
							<table>
							<tr>
														    
								<td style="height:40px;padding-left:10px;padding-right:10px">
								
								<input type="hidden" name="Mission" value="<cfoutput>#url.mission#</cfoutput>">
								
								<select name="category" 
								   style="background-color:f5f5f5;font-size:19px;height:33px"
								   class="regularxxl" 
								   onChange="getcategory('<cfoutput>#url.mission#</cfoutput>',this.value);search()">
								   
									<option value="">Any</option>
									<cfoutput query="Category">
								     	<option value="#Category#">#Description#</option>
									</cfoutput>	
								
								</select>
								</td>
								
								<td style="font-size:14px;padding-bottom:3px;padding-right:4px"><cf_tl id="Store"></td>
								<td style="padding-right:10px">
								
								<select name="warehouse" style="background-color:f5f5f5;font-size:19px;height:33px" class="regularxxl" onChange="search()">
								<option value="">Any</option>
								<cfoutput query="Warehouse">
							     	<option value="#Warehouse#">#WarehouseName#</option>
								</cfoutput>	
								</select>
								</td>
								<td style="font-size:14px;padding-bottom:3px;padding-right:4px"><cf_tl id="SKU"></td>
								<td style="padding-right:10px">
								<input style="width:90px;text-align:center;background-color:f5f5f5;font-size:19px;height:33px" name="ItemNo" class="regularxxl" onKeyUp = "apply(event)">
								</td>
								<td style="font-size:14px;padding-bottom:3px;padding-right:4px"><cf_tl id="Name"></td>
								<td style="padding-right:10px">
								<input style="width:180px;background-color:f5f5f5;font-size:19px;height:33px" name="ItemName" class="regularxxl" onKeyUp = "apply(event)"></td>
								
								<td align="right" style="padding-right:4px">
								<input type="button" onclick="search()" style="height:33px;width:110px;border:1px solid silver;height:30px;" class="button10g" name="Find" value="Find">
								</td>
							</tr>
							</table>
						
						
						</tr>
						
						</table>
						
		</cf_layoutarea>	
		
		<cf_layoutarea 
		    position="left" 
			name="selectionbox" 
			minsize="230" 
			maxsize="230" 
			size="230" 
			overflow="yes" 
			initcollapsed="false"
			collapsible="true" 
			splitter="true">
						
				<cfinclude template="getSelection.cfm">			
									
		</cf_layoutarea>		 
		
		<cf_layoutarea  position="center" name="box">
			
				<table style="width:100%;height:100%" align="center" class="navigation_table">
				
				<cfquery name="Schedule" 
					 datasource="appsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					   SELECT    *
					   FROM      Ref_PriceSchedule
					   WHERE     Operational = 1  	
					   ORDER BY ListingOrder   
					</cfquery>
					
					<cfquery name="Default" 
					 datasource="appsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					   SELECT    *
					   FROM      Ref_PriceSchedule
					   WHERE     FieldDefault = 1  	   
					</cfquery>
					
					<cfif schedule.recordcount gte "1">
					
					  <tr class="labelmedium2 line" style="height:35px">
					      
						  <cf_tl id="Priceschedule" var="1">
					      
						  <td colspan="3" style="padding-left:10px;padding-right:10px" title="<cfoutput>#lt_text#</cfoutput>">
						  
						   <cf_UISelect name   = "PriceSchedule"
						     class          = "regularxxl"
						     queryposition  = "below"
						     query          = "#Schedule#"
						     value          = "Code"
						     onchange       = "search()"		     
						     required       = "No"
							 tooltip        = "#lt_text#"
							 style          = "width:100%"
						     display        = "Description"
						     selected       = "#Default.Code#"
							 filter         = "contains"
							 separator      = "|"
						     multiple       = "no"/>		
						  							
						  </td>
						  
					  </tr>
					
					</cfif>
					
					<tr class="hidexx"><td id="process"></td></tr>
								
					<tr><td colspan="3" style="padding-left:10px;height:100%">					
					        <cf_divscroll id="content"/>
					    </td>
					</tr>
					
				</table>				
		
		</cf_layoutarea>	
						
		<cf_layoutarea 
		    position="right" 
			name="commentbox" 
			minsize="400" 
			maxsize="400" 
			size="400" 
			overflow="yes" 
			
			collapsible="true" 
			splitter="true">
			
					<cfinclude template="StockViewQuote.cfm">			
					
					<!---
				
					<cf_divscroll style="height:100%">
						<cf_commentlisting objectid="#Object.ObjectId#"  ajax="No">		
					</cf_divscroll>
					
					--->
					
		</cf_layoutarea>	
							
	</cf_layout>		
	
	</form>			
		