
<cf_tl id="Half Product" var="lblFinal">
<cfinclude template="HalfProductInit.cfm">

<cf_tl id="Record requested half product" var="1">

<cf_screentop height="100%" 		
		layout="webapp" 
		label="#lblFinal#" 
		option="#lt_text#" 
		banner="blue"
		bannerforce="Yes"
		html="No"
		JQuery="yes">	

<cfajaximport tags="cfwindow,cfdiv,cfform">

<cf_tl id="Are you sure you want to delete this row?" var="alertdelete">

<cf_tl id="Select a valid item and uom" var="msgItemReq">

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkOrderId = '#url.WorkOrderId#'			
</cfquery>

<cfquery name="param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ServiceItemMission
		WHERE   Mission     = '#WorkOrder.Mission#'			
		AND     ServiceItem = '#WorkOrder.ServiceItem#'
</cfquery>


<cfoutput>

	<script>
		
		function validateFields(){
			if ($('##itemNo').val() != "" && $('##uom').val() != "") {
				return true;
			}else{
				alert('#msgItemReq#');
				return false;	
			}
		}
		
		function selectitem(itm) {		
		   
			_cf_loadingtexthtml='';	
			<cfif param.WorkorderItemMode eq "1">
			ColdFusion.navigate('#session.root#/WorkOrder/Application/Assembly/Items/HalfProduct/getItem.cfm?mode=production&itemNo='+itm+'&workorderid=#url.workOrderId#&workorderline=#url.workorderline#','itembox')
			<cfelse>			
			ColdFusion.navigate('#session.root#/WorkOrder/Application/Assembly/Items/HalfProduct/selectitem.cfm?mode=production&itemNo='+itm+'&workorderid=#url.workOrderId#&workorderline=#url.workorderline#','finalproduct')			
			</cfif>
		}

		function submitTransactions(wo,wl) {				
			ColdFusion.navigate('HalfProductAddSubmit.cfm?WorkOrderId='+wo+'&WorkOrderLine='+wl,'addFinalProductBox');		    			
		}
		
		function deleteSelected(id)	{
			// if (confirm('#alertdelete#')) { 			    
				_cf_loadingtexthtml='';	
				ptoken.navigate('SelectedPurgeSubmit.cfm?WorkorderItemId='+id+'&workorderid=#url.workOrderId#&workorderline=#url.workOrderLine#','itembox');
			// }					
		}
		
	</script>

</cfoutput>


<cfquery name="Get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineItem
		WHERE   WorkOrderId   = '#url.WorkOrderId#'
		AND		WorkOrderLine = '#url.WorkOrderLine#'
		AND		ItemNo        = '#url.ItemNo#'
		AND		UoM           = '#url.UoM#'		
</cfquery>

<cfif workorder.ActionStatus eq "3" or workorder.ActionStatus eq "9">

		<table width="96%" align="center">
		
			<tr><td height="5"></td></tr>
			
			<tr>
				<td colspan="2" align="center" style="height:100" class="labelmedium">You may no longer amend this workorder.</td>
			</tr>
			
		</table>	
	
	    <cfabort>
	
</cfif>	

<!--- <cf_ObjectControls> --->
<cf_LayoutScript>
<cfajaximport tags="cftree,cfform">	
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop"
	   	minsize	  = "50px"
		maxsize	  = "50px"
		size 	  = "50px">	
			  
		<cf_ViewTopMenu label="#lblFinal#" option="#lt_text#" background="blue">
			 			  
	</cf_layoutarea>		
	  
	<cf_layoutarea 
	    position    = "left" 
		name        = "treebox" 		 		
		size        = "340" 
		minsize     = "340"
		collapsible = "true" 
		splitter    = "true">
		
			<table width="95%" height="100%" cellspacing="2" cellpadding="2" align="center">
								
				<tr>
					
					<td height="100%" style="padding:2px;">
											
						<table width="100%" height="100%" cellspacing="0" cellpadding="0" style="border:0px dotted silver">
						
						    <tr><td style="padding-top:5px">
							<cfoutput>
							<input type="text" 
							onkeyup="_cf_loadingtexthtml='';ptoken.navigate('HalfProductItemSelect.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&mission=#workorder.mission#&find='+this.value,'items')"
							style="width:98%;border:1px outset d1d1d1" class="regularxl" id="findvalue" name="findvalue">
							</cfoutput>
							</td></tr>
							<tr><td height="5"></td></tr>
							<tr>
								<cfif url.itemNo eq "">
								<td style="padding-right:0px;height:100%">
								
									<cf_divscroll id="items">		
									    <cfset url.find = "">	
										<cfset url.mission = workorder.mission>						
										<cfinclude template="HalfProductItemSelect.cfm">									
									</cf_divscroll>
																										
								</td>
								</cfif>
								<td class="hide" id="itembox"></td>
							</tr>
						</table>							
						
					</td>
				</tr>
				
				<!---
				<tr><td class="line"></td></tr>
				
				<tr><td colspan="2" height="30" class="labelit" style="padding:5px">
					In order to define items to be produced, first set a base item which serves as a <u>TEMPLATE</u> for the items to be created and which information will be the basis for the inheritance
					to any items that would need to be added to the item repository. If an item already exists in the repository it will identified as such.			
					</td>
				</tr>
				--->
			
			
			</table>
	
	</cf_layoutarea>
	
	<cf_layoutarea position="center" name="box" overflow="scroll">
	
	    <table class="hide">
		   <tr><td id="addFinalProductBox"><iframe id="processFinalProduct" name="processFinalProduct"></iframe></td></tr></table>
		
		<table height="100%" width="96%" align="center">
								
			<!--- shows the final project items selected --->
			<tr><td colspan="2" id="selecteditems">			
			<cfinclude template="HalfProductSelected.cfm">			
			</td></tr>			
			<tr class="hide"><td id="process"></td></tr>			
			<tr><td colspan="2" class="line"></td></tr>		
				
			<!--- shows the input for final projects --->		
			<tr><td colspan="2" id="selectfields"></td></tr>						
			
			<!--- shows the valid combinations --->
			<tr><td colspan="2" height="100%" style="padding-top:5px">
			<cf_divscroll height="100%" id="finalproduct"/>			
			</td></tr>		
							
		</table>
						
	</cf_layoutarea>			
		
</cf_layout>
	