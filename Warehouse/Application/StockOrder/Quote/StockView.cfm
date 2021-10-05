
<cfset title = "Stock inquiry and quote preparation">

<cf_dialogmaterial>
<cf_presenterscript>

<cf_screentop html="No" label="#title#" jquery="Yes">
	
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
	</cfquery>
	
	<cfoutput>

	<script language="JavaScript">
	
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
		    ptoken.navigate('addQuote.cfm?mission=#url.mission#&warehouse='+document.getElementById('warehousequote').value,'boxquote')      
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
			
		function setquote(no,act,val) {	  
	       _cf_loadingtexthtml='';		
		   ptoken.navigate('setQuote.cfm?action='+act+'&requestno='+no+'&val='+val,'boxprocess','','','POST','stockform') 	
		}	
		
		function applyQuote(act) {	  
	       _cf_loadingtexthtml='';		
		   ptoken.navigate('applyQuote.cfm?action='+act,'boxprocess','','','POST','stockform') 	
		}	
		
						
		function deleteitem(tra) {	  
	       _cf_loadingtexthtml='';		
		   ptoken.navigate('setQuote.cfm?action=deleteline&transactionid='+tra,'boxprocess') 	
		}
		
		function search() {     
		   _cf_loadingtexthtml='';  
		   ptoken.navigate('getStockContent.cfm','content','','','POST','stockform')      
		}
		
		function stockreserve(whs,itm,uom,mde) {
		 	ProsisUI.createWindow('stockinquiry','Reservations','',{x:100,y:100,width:900,height:420,resizable:true,modal:true,center:true})
			ptoken.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Quote/ReservationView.cfm?warehouse='+whs+'&itemNo='+itm+'&uom='+uom+'&mode='+mde,'stockinquiry')							
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
				
					<table class="formpadding navigation_table" style="height:100%;border-botomm:1px solid gray;width:100%;background-color:e6e6e6">
						<tr>
						<td>
							<table>
							<tr>
														    
								<td style="height:45px;padding-left:10px;padding-right:10px">
								
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
								
				<tr><td style="padding-left:10px;height:100%">
				        <cf_divscroll id="content"/>
				    </td>
				</tr>
					
				</table>				
		
		</cf_layoutarea>	
						
		<cf_layoutarea 
		    position="right" 
			name="commentbox" 
			minsize="380" 
			maxsize="380" 
			size="380" 
			overflow="yes" 
			
			collapsible="true" 
			splitter="true">
			
					<cfinclude template="QuoteView.cfm">			
					
					<!---
				
					<cf_divscroll style="height:100%">
						<cf_commentlisting objectid="#Object.ObjectId#"  ajax="No">		
					</cf_divscroll>
					
					--->
					
		</cf_layoutarea>	
							
	</cf_layout>		
	
	</form>			
		