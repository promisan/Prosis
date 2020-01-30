
<cfparam name="URL.WorkOrderId"   default="">
<cfparam name="URL.WorkorderLine" default="0">
<cfparam name="URL.ResourceId"    default="">

<cfparam name="URL.Mode" default="Edit">

<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkOrderId = '#url.workorderid#'	
</cfquery>	

<cfquery name="qResource" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	 
	SELECT    *
    FROM      Ref_ResourceMode
    ORDER BY  Code     									  
</cfquery>
	
<cf_tl id="Service Item" var="lblFinal">	

<cfif url.resourceid eq "">

	<cf_tl id="Add item" var="1">
	
	<cf_screentop height="99%" 
			scroll="no" 
			layout="webapp" 
			label="#lblFinal#" 			
			banner="red"
			close="parent.ColdFusion.Window.destroy('myservice',true)"
			JQuery="yes">
	
<cfelse>
	
	<cf_tl id="Edit item" var="1">
	
	<cf_screentop height="99%" 
			scroll="no" 
			layout="webapp" 
			label="#lblFinal#" 
			option="#lt_text#" 
			banner="red"
			close="parent.ColdFusion.Window.destroy('myservice',true)"
			JQuery="yes">
	
</cfif>

<cfajaximport tags="cfdiv,cfwindow,cfform">

<cf_tl id="Select a valid item and uom" var="msgItemReq">

<cfoutput>

	<script language="JavaScript">
		
		function validate() {		
			document.frmResource.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
	        	ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/BOM/ResourceEditServiceSubmit.cfm?workorderid=#url.workorderid#&workorderline=#url.workOrderline#&resourceid=#url.resourceid#','resulths','','','POST','frmResource')
			}			
		}
	
		function selectresourceitem(itm,mis) {						  
			ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/BOM/getItem.cfm?mission='+mis+'&mode=item&itemNo='+itm+'&resourceid=#url.resourceid#','itembox')
		}
		
	</script>

</cfoutput>
	
<cfquery name="Get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineResource  
		<cfif url.resourceid eq "">		
		WHERE   1=0
		<cfelse>
		WHERE   ResourceId  = '#url.resourceid#'
		</cfif>		
</cfquery>

<cfquery name="GetItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Item I INNER JOIN ItemUoM U	ON I.ItemNo = U.ItemNo
		WHERE   I.ItemNo = '#get.ResourceItemNo#'
		AND		U.UoM    = '#get.ResourceUoM#'		
</cfquery>

<cfoutput>
		
<table width="100%" height="99%" cellspacing="0" cellpadding="0">

<tr>

	<cfif url.mode eq "Edit">

    <td style="width:200;padding:3px" valign="top">
		
	<table width="95%" height="100%" cellspacing="0" cellpadding="0" align="center">
								
		<tr>
			
			<td height="100%" style="padding:2px;">
									
				<table width="100%" height="100%" cellspacing="0" cellpadding="0" style="border:0px dotted silver">
				
				    <tr><td style="padding-top:5px">
					<cfoutput>
						<input type="text" 
						onkeyup="_cf_loadingtexthtml='';ptoken.navigate('getItemList.cfm?class=service&mission=#workorder.mission#&workorderid=#url.workorderid#&find='+this.value,'items')"
						style="width:98%;border:1px outset d1d1d1" class="regularxl" id="findvalue" name="findvalue">
					</cfoutput>
					</td></tr>
					<tr><td height="5"></td></tr>
					<tr>												
							<td style="padding-right:0px;height:100%">							
								<cf_divscroll id="items">		
								    <cfset url.find    = "">	
									<cfset url.class   = "Service">
									<cfset url.mission = WorkOrder.Mission>						
									<cfinclude template="getItemList.cfm">									
								</cf_divscroll>																									
							</td>												
					</tr>
				</table>							
				
			</td>
		</tr>	
				
	</table>

	</td>
	
	</cfif>

	<td width="70%" style="padding:10px" valign="top">

	<cfform name="frmResource"
	   method="post" 
	   target="processResource" 
	   action="ResourceEditServiceSubmit.cfm?workorderid=#url.workOrderId#&workorderline=#url.workorderline#&resourceid=#url.resourceid#">
	
		<table width="96%" border="0" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">
			
			<cfquery name="Parameter" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
	    			SELECT *
    				FROM   Ref_ParameterMission
					WHERE  Mission = '#workorder.Mission#' 
			</cfquery>  	
		
			<tr><td height="10"></td></tr>				
			
			<tr>
				<td style="padding:2px;" class="labelmedium" width="30%">
					<cf_tl id="Item"> : 
				</td>
								
				<td style="padding:2px;" id="itembox" class="labelmedium" width="30%">
					#GetItem.Classification# #GetItem.ItemDescription#			
					<input type="hidden" name="ItemNo" value="#getItem.ItemNo#">	
				</td>
				<td width="40%">
				
				</td>
			</tr>
			
			<tr>
				<td style="padding:2px;" class="labelmedium">
					<cf_tl id="UoM"> : 
				</td>
				
				<td style="padding:2px;" id="uombox" class="labelmedium">
				
				<cfif mode eq "Edit">
				
					<cfquery name="GetUoM" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT 	U.*
					    FROM 	ItemUoM U
						WHERE	U.ItemNo = '#getItem.ItemNo#'
					</cfquery>
							
					<cf_tl id="Select a valid UoM" var="1">
					<cfselect name="uom" id="uom" query="getUoM" required="true" message="#lt_text#" value="UoM" display="UoMDescription" selected="#getItem.UoM#" class="regularxl enterastab"/>
							
				<cfelse>	
					
					#getItem.UoMDescription#
					
				</cfif>				
								
				</td>
				<td></td>	
			</tr>

			
			<tr>
				<td class="labelmedium" style="padding:2px;">
					<cf_tl id="Resource Mode">:
				</td>
				<td style="padding:2px;">
					<select id="resourcemode" name="resourcemode" class="regularxl enterastab">
						<cfloop query="qResource">
							<option value="#qResource.code#">#qResource.description#</option>
						</cfloop>
					</select> 
				</td>
			</tr>
		
			<tr>
				<td class="labelmedium" style="padding:2px;">
					<cf_tl id="Quantity">:
				</td>
				<td style="padding:2px;">
					<cf_tl id="Please, enter a valid numeric quantity greater than 0." var="1">
					<cfinput type="text" class="regularxl enterastab" name="quantity" id="quantity" value="#Get.Quantity#" required="true" message="#lt_text#" validate="float" range="0.00000000001," style="width:70px; text-align:right; padding-right:2px;">
				</td>
				<td></td>
			</tr>			
			
			<tr>
				<td class="labelmedium" style="padding:2px;">
					<cf_tl id="Cost price"> #application.basecurrency#:
				</td>
				<td style="padding:2px;">
					<cf_tl id="Please, enter a valid numeric price greater than 0." var="1">
					<cfinput type="text" class="regularxl enterastab" name="price" id="price" value="#numberformat(Get.Price,'__.__')#" required="true" message="#lt_text#" validate="float" range="0.00000000001," style="width:70px; text-align:right; padding-right:2px;">
				</td>
				<td></td>
			</tr>			
			
			<tr>
				<td class="labelmedium" style="padding:2px;">
					<cf_tl id="Total">:
				</td>
				<td style="padding:2px;" class="labelmedium">				
					<cfdiv bind="url:ResourceTotal.cfm?qty={quantity}&price={price}" id="dTotal" class="labelmedium enterastab" style="background-color:f4f4f4;border:1px solid silver; width:100; height:25px; text-align:right;padding:2px;">								
				</td>
				<td></td>
			</tr>
			
			<tr>
				<td class="labelmedium" style="padding:2px;">
					<cf_tl id="Memo">:
				</td>
				<td style="padding:2px;" class="labelmedium">
					<cfinput type="text" maxlength="100" class="regularxl enterastab" name="remarks" id="remarks" value="#Get.Memo#" style="width:300px; text-align:left; padding-right:2px;">
				</td>
				<td></td>
			</tr>
			
			<tr><td height="10"></td></tr>
			
			<tr><td class="line" colspan="3"></td></tr>
			
			<tr><td height="10"></td></tr>
			<tr>
				<td colspan="3" align="center">
					<cf_tl id="Save" var="1">
					<input type="button" class="button10g" style="width:150" onsubmit="return false" name="btnSbmt" id="btnSbmt" value="#lt_text#" onclick="validate();">
				</td>
			</tr>
		
		</table>
	
	</cfform>
	
	</td>
</tr>

<div id="resulths">

</table>	

</cfoutput>
