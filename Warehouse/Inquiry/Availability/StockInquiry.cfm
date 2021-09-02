
<cfset title = "Stock inquiry and quote preparation">

<cf_screentop html="No" label="#title#" jquery="Yes">
	
	<cfquery name="Warehouse" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Warehouse
	   WHERE     Warehouse IN (SELECT Warehouse FROM itemTransaction)
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
	
	function search() {     
	   _cf_loadingtexthtml='';  
	   ptoken.navigate('StockInquirySubmit.cfm','content','','','POST','stockform')      
	}
	
	function stockreserve(itm,whs) {
	 	ProsisUI.createWindow('stockinquiry','Inquiry Reservations','',{x:100,y:100,width:900,height:420,resizable:true,modal:true,center:true})
		// ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/Stock/StockView.cfm?warehouse='+whs+'&itemNo='+itm+'&uom='+uom,'stockinquiry')							
	}
	
	</script>
	
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
				
					<table class="formpadding navigation_table" style="height:100%;border-botomm:1px solid gray;width:100%;background-color:f1f1f1">
						<tr>
						<td>
							<table>
							<tr>
							
							    <td style="font-size:12px;padding-bottom:10px;padding-left:10px;padding-right:4px"><cf_tl id="Category"></td>
								<td style="padding-right:10px">
								
								<select name="category" 
								   style="background-color:f1f1f1" 
								   class="regularxxl" 
								   onChange="getcategory('<cfoutput>#url.mission#</cfoutput>',this.value);search()">
								   
									<option value="">Any</option>
									<cfoutput query="Category">
								     	<option value="#Category#">#Description#</option>
									</cfoutput>	
								
								</select>
								</td>
								
								<td style="font-size:12px;padding-bottom:10px;padding-right:4px"><cf_tl id="Store"></td>
								<td style="padding-right:10px">
								
								<select name="warehouse" style="background-color:f1f1f1" class="regularxxl" onChange="search()">
								<option value="">Any</option>
								<cfoutput query="Warehouse">
							     	<option value="#Warehouse#">#WarehouseName#</option>
								</cfoutput>	
								</select>
								</td>
								<td style="font-size:12px;padding-bottom:10px;padding-right:4px"><cf_tl id="SKU"></td>
								<td style="padding-right:10px">
								<input style="width:70px;text-align:center;border:0px;background-color:f1f1f1" name="ItemNo" class="regularxxl" onKeyUp = "apply(event)">
								</td>
								<td style="font-size:12px;padding-bottom:10px;padding-right:4px"><cf_tl id="Name"></td>
								<td style="padding-right:10px">
								<input style="width:180px;background-color:f1f1f1" name="ItemName" class="regularxxl" onKeyUp = "apply(event)"></td>
							</tr>
							</table>
						
						<td align="right" style="padding-right:4px">
						<input type="button" onclick="search()" style="width:110px" class="button10g" name="Find" value="Find">
						</td>
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
			minsize="20%" 
			maxsize="30%" 
			size="380" 
			overflow="yes" 
			initcollapsed="yes"
			collapsible="true" 
			splitter="true">
			
					<cfinclude template="getQuote.cfm">			
					
					<!---
				
					<cf_divscroll style="height:100%">
						<cf_commentlisting objectid="#Object.ObjectId#"  ajax="No">		
					</cf_divscroll>
					
					--->
					
		</cf_layoutarea>	
							
	</cf_layout>		
	
	</form>			
		