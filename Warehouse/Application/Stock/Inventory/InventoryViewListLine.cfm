
<!--- item --->										
<cfif onhand lt -0.005>
	<cfset color = "FED7CF">
<cfelse>
	<cfset color = "transparent">
</cfif>

<cfif url.zero eq "true" and abs(onhand) lte "0.01">					
   <cfset cl="hide">					
<cfelse>					
   <cfset cl="regular">										
</cfif>		

<cfoutput>

<table width="100%" >

	<tr bgcolor="#color#" class="#cl# navigation_row line <cfif abs(onhand) lte "0.02">zero<cfelse>standard</cfif>">			 	    			  
	    		
		<td align="right" valign="top" style="min-width:26px;padding-left:6px">#currentrow#.</td>					
		<td style="min-width:110"><cfif transactionReference neq "">#TransactionReference#:</cfif></td>	
				
		<cfif url.earmark eq "false">
		
		<td style="min-width:200">#mylot#</td>
		
		<cfelse>
				
			<cfif requirementid neq "00000000-0000-0000-0000-000000000000">
			
				<cfquery name="get"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT W.Reference, WL.WorkOrderLineId
					FROM   WorkOrderLine WL INNER JOIN WorkOrder W ON  WL.WorkOrderId   = W.WorkOrderId
					WHERE  WL.WorkOrderId   = '#workorderid#' 
					AND    WL.WorkOrderLine = '#workorderline#'
				</cfquery>		
				
				<cfquery name="RelatedPOs"
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  DISTINCT PL.PurchaseNo
					FROM RequisitionLine RL INNER JOIN PurchaseLine PL
					ON PL.RequisitionNo=RL.RequisitionNo
					WHERE RL.workOrderId='#workorderid#'
					AND RL.workorderline='#workorderline#'
					AND RL.ActionStatus!='9'
					AND PL.ActionStatus!='9'					
				</cfquery>		


				<td class="labelit" style="min-width:200">
				<table width="100%">
					<tr>
						<td>
							<a href="javascript:workorderline('#get.WorkOrderLineid#','#url.systemfunctionid#','#get.WorkOrderLineid#')">#get.Reference#/#WorkOrderLine#</a>
						</td>
					</tr>
					<cfloop query="RelatedPOs">
					<tr>
						<td style="padding-left:30px">
							<a href="javascript:ProcPOEdit('#RelatedPOs.PurchaseNo#','view')">#RelatedPOs.PurchaseNo#</a>								
						</td>	
					</tr>
					</cfloop>
				</table>	
				</td>
			
			<cfelse>
				<td class="labelit" style="font-weight:200;min-width:200">
				--<cf_tl id="Free">--
				</td>
				
			</cfif>	
		
		</cfif>					
		
		<td style="padding-left:3px;min-width:100">#ItemBarCode#</td>
		
		<td style="cursor:pointer;padding-left:4px;padding-right:4px;;min-width:20" 
		  onclick="locarcshow('#warehouse#','#location#','#itemno#','#uom#','#transactionlot#','locarc#url.box#_#currentrow#')">
		  						
		<img src="#SESSION.root#/images/ExpandArrow.gif"
			  id="locarc#url.box#_#currentrow#exp" 
			  class="show">
		 
		<img src="#SESSION.root#/images/arrow_up1.gif" 
			  id="locarc#url.box#_#currentrow#min" 
			  width="10" 
			  class="hide">
			
		</td>
		
		<td style="padding-left:2px;min-width:100">
							
			<cfif Strapping eq "0">
			   <cfset url.mode = "standard">
				#vStandard#
			<cfelse>
			   <cfset url.mode = "strapping">
				#vStrapping#
			</cfif>
			
		</td>		
		
		<td style="padding-left:1px;min-width:100">#UoMDescription#</td>
		
		<td align="right" style="padding-right:2px;min-width:100">
		   <cf_precision number="#itemprecision#">#NumberFormat(onhand,'#pformat#')#
		</td>
		
		    <cfif url.mode eq "standard">
			
				<td align="right" style="background-color:ffffaf;height:100%;padding-right:3px;padding-left:3px;min-width:100;border-left:1px solid silver;border-right:1px solid silver">
					
				<input type="text"
				      name="counted"
					  id="counted"
				      value="#counted#"			     
				      style="background-color:ffffaf;height:100%;border:0px;text-align:right;width:97%;padding-right:2px;" 
					  onChange="invsave('#TransactionId#',this.value,'regular','#url.systemfunctionid#','#url.box#');document.getElementById('save#url.box#_#currentrow#').className='regular'"
					  maxlength="10"
					  class="regularxl enterastab">
					  
				</td>	  
				  
			<cfelse>
			
			<td align="right" bgcolor="ffffcf" style="border-left:1px solid silver;padding-left:10px;;min-width:200">
			
				<!--- strapping table --->
						
				<table cellspacing="0" cellpadding="0" style="padding-top:10px">
				
					<tr class="labelmedium">
					<td>#vDepth#:&nbsp;</td>
					<td style="padding-right:3px">
		
						<input type="text"
						      name="counted"
							  id="counted"
						      value="#counted#"				     
						      style="text-align:right; width:50;padding-right:2px;;border:0px;border-left:1px solid silver;border-right:1px solid silver"
							  onChange="invsave('#TransactionId#',this.value,'strapping','#url.systemfunctionid#');document.getElementById('save#url.box#_#currentrow#').className='regular'"
							  maxlength="10"
							  class="regularxl enterastab">
					
					</td>
					</tr>
					
					<tr class="labelmedium">
					<td >#vCelc#:</td>
					<td style="padding-right:3px">
		
							<input type="text"
						      name="metric"
							  id="metric"
						      value="#metric#"				    
						      style="text-align:right; width:50;padding-top:1px;padding-right:2px"
							  onChange="invsave('#TransactionId#',this.value,'metric','#url.systemfunctionid#');document.getElementById('save#url.box#_#currentrow#').className='regular'"
							  maxlength="10"
							  class="regularxl enterastab">
					
					</td>
					</tr>
							
				</table>
			
		    </td>
							  
		</cfif>	  		
	   
	   <td style="width:100%;min-width:100px">
	  	     
		   <table width="100%" height="100%" cellspacing="0" cellpadding="0">
		      <tr>
			  
			  	<td id="f#TransactionId#" style="padding-left:1px" width="100%">  
				   
				   <cfset url.id = transactionid> 
				   <cfset itemlocationid = itemlocationid>
				   <cf_tl id="Measured" var = "vMeasured">		
		   		   <cf_tl id="Variance" var = "vVariance">				   
				   <cfset init = "1">
				   
				   <cfif counted neq "">
				   	   <cfinclude template="doCheck.cfm">     				   
				   </cfif>
				  							   							   		           
		   		</td>
								
				<cfif counted eq "">
				    <cfset cl = "hide">
				<cfelse>
					<cfset cl = "regular">
				</cfif>
						
				<td id="f#TransactionId#_log" style="padding-left:3px;padding-right:3px" align="right" colspan="11" class="#cl#">
				
					<cfif workorderid eq "">
							
			   		<input name="Save" 
					     id="Save" 
						 tabindex="9999"
						 type="button"
						 value="Log" style="height:19;width:50px;font-size:11px" 
						 class="button10g" 
						 onclick="invarchive('#location#','#itemno#','#uom#','#transactionlot#','#url.systemfunctionid#','#currentrow#','#url.box#')">
						 
					</cfif>	 
						
		    	</td>
				
			  </tr>	
		   </table>	
		  
	   </td>
	</tr>
				
	<tr id="locarc#url.box#_#currentrow#_box" class="hide">		
	    <td id="locarc#url.box#_#currentrow#" class="hide" align="center" colspan="10"></td>
	</tr>	
	
</table>	
	
</cfoutput>	

