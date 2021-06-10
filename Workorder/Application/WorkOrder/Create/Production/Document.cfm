
<cf_tl id="Finished Product" var="lblFinal">

<!---
<cfinclude template="FinalProductInit.cfm">
--->

<cf_tl id="Record finished product" var="1">

<cf_screentop height="100%" 		
		layout="webapp" 
		label="#lblFinal#" 
		option="#lt_text#" 
		banner="blue"
		bannerforce="Yes"
		html="No"
		JQuery="yes">	

<cf_tl id="Are you sure you want to delete this row?" var="alertdelete">

<cf_tl id="Select a valid item and uom" var="msgItemReq">

<!---

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkOrderId = '#url.WorkOrderId#'			
</cfquery>

--->

<cf_calendarscript>

<cfparam name="url.workorderid"   default="">
<cfparam name="url.workorderline" default="">

<cfquery name="param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ServiceItemMission
		WHERE   Mission     = '#url.Mission#'			
		AND     ServiceItem = '#url.ServiceItem#'
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
			ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/FinalProduct/getItem.cfm?mode=production&itemNo='+itm+'&workorderid=#url.workOrderId#&workorderline=#url.workorderline#','itembox')
			<cfelse>			
			ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/FinalProduct/selectitem.cfm?mode=production&itemNo='+itm+'&workorderid=#url.workOrderId#&workorderline=#url.workorderline#','finalproduct')			
			</cfif>
		}

		function submitTransactions(wo,wl) {				
			ptoken.navigate('FinalProductAddSubmit.cfm?WorkOrderId='+wo+'&WorkOrderLine='+wl,'addFinalProductBox');		    			
		}
		
		function deleteSelected(id)	{
			// if (confirm('#alertdelete#')) { 			    
				_cf_loadingtexthtml='';	
				ptoken.navigate('SelectedPurgeSubmit.cfm?WorkorderItemId='+id+'&workorderid=#url.workOrderId#&workorderline=#url.workOrderLine#','processFinalProduct');
			// }					
		}
		
	</script>

</cfoutput>



<table width="100%" height="100%">

  <tr>
  
  <!---
  
  <td colspan="1" valign="top" height="100%" width="35%">
						
			<table width="95%" height="100%" cellspacing="2" cellpadding="2" align="center">
								
				<tr>
					
					<td height="100%" style="padding:2px;">
																
						<table width="100%" height="100%" cellspacing="0" cellpadding="0" style="border:0px dotted silver">
						
						    <tr><td style="padding-top:5px">
							<cfoutput>
							<input type="text" 
							onkeyup="_cf_loadingtexthtml='';ptoken.navigate('FinalProductItemSelect.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&mission=#url.mission#&find='+this.value,'items')"
							style="width:98%;border:1px outset d1d1d1" class="regularxl" id="findvalue" name="findvalue">
							</cfoutput>
							</td></tr>
							<tr><td height="5"></td></tr>
							<tr>
								
								<td style="padding-right:0px;height:100%">
								
									<cf_divscroll id="items">		
									    <cfset url.find = "">															
										<cfinclude template="ProductionItemSelect.cfm">									
									</cf_divscroll>
																										
								</td>
								
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
	
	  </td>
	  
	  --->
	  
	  <td>
	
	    <table class="hide">
		   <tr><td id="addFinalProductBox"><iframe id="processFinalProduct" name="processFinalProduct"></iframe></td></tr></table>
		
		<table width="96%" align="center">
		
			<tr><td height="5"></td></tr>
						
			<!--- shows the final project items selected --->
					
			<tr class="hide"><td id="process"></td></tr>			
			<tr><td colspan="2" class="line"></td></tr>		
				
			<!--- shows the input for final projects --->		
			<tr><td colspan="2" id="selectfields"></td></tr>						
			
			<!--- shows the valid combinations --->
			<tr>
			<td colspan="2" id="finalproduct" style="padding-top:5px">					
				<cfinclude template="ProductionMain.cfm">
			</td>
			</tr>		
							
		</table>
	
	</td>
	
	</tr>
	
</table>