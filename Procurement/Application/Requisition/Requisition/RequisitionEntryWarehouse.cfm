
<cfparam name="URL.mode"   default="">
<cfparam name="URL.option" default="uom">
<cfparam name="URL.access" default="#url.mode#">
	
<cfoutput>

	<cfswitch expression="#URL.option#">
	
	<cfcase value="itm">
	
		<cfquery name="Item" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Item
			WHERE  ItemNo = '#URL.item#'
		</cfquery>

		<cfif url.Access eq "View">
		
			<table cellspacing="0" cellpadding="0">
			<tr><td class="labelmedium">
			#Item.ItemNo# 

			<cfif item.ItemNoExternal neq "">
				 (#item.ItemNoExternal#)
			</cfif>
						
			#Item.ItemDescription# / #url.des# 
			
			</td></tr>
			</table>
			
		<cfelse>		
		
		<table cellspacing="0" cellpadding="0">
		 <tr class="labelmedium">
		  <td style="min-width:110px;padding-right:6px"><cf_tl id="Stock Item"></td>
		  <td>
		  
		  	<table>
			<tr>			
									
			<td style="padding-left:0px">	
				<input type="text" name="itemno" id="itemno" value="#Item.ItemNo#" size="4" maxlength="6" readonly class="regularxl" style="width:50px;"> 			
			</td>						 
				
		 	<td style="padding-left:3px">
			
				<cfif item.ItemNoExternal neq "">
					<cfset vDescription = "#Item.ItemDescription# (#item.ItemNoExternal#)">
				<cfelse>
					<cfset vDescription = "#Item.ItemDescription#">	 
				</cfif>
		 		
			   <input type="text" name="itemdescription" id="itemdescription" value="#vDescription#" style="width:400px" size="45" class="regularxl" maxlength="80" readonly> 
			</td>		
			
			<td style="padding-left:3px">
												
			<cfif access eq "Limited">
						
			  <img src="#SESSION.root#/Images/search.png" alt="Select item" name="img2" 			 
				  style="cursor: pointer" width="25" height="25" border="0" align="absmiddle" 
				  onClick="selectitm(document.getElementById('mission').value,document.getElementById('itemmaster').value,'item','applyitem','','0')"> 
								
			<cfelse>
			
			  <img src="#SESSION.root#/Images/search.png" alt="Select item" name="img2" 			 
				  style="cursor: pointer" width="25" height="25" border="0" align="absmiddle" 
				  onClick="selectitm(document.getElementById('mission').value,document.getElementById('itemmaster').value,'item','applyitem','','1')"> 
			  
			</cfif>  
			
			</td>
			
			</tr>
			
			</table>
			
			
			</td>
			
	    </tr>
		
		<cfparam name="url.reqid" default="">
		
		<cfif url.reqid neq "">
		
			<cfquery name="get" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     RequisitionLine
				WHERE    RequisitionNo = '#url.ReqId#'					
			</cfquery>
			
			<tr><td height="4"></td></tr>
		
			<tr class="labelmedium">
			
			 <td style="min-width:110px;padding-right:3px"><cf_tl id="Model">/<cf_tl id="Brand"></td>		 
			 <td colspan="2">
		  	 	<input type="text" name="requestdescription" id="requestdescription" value="#get.requestdescription#" style="width:100%" class="regularxl" maxlength="200"> 						  
			 </td>
			
			</tr>
			
		<cfelse>
		
			<tr><td height="4"></td></tr>
			
			<tr class="labelmedium">
			
			 <td style="min-width:110px;padding-right:3px"><cf_tl id="Model">/<cf_tl id="Brand">:</td>		 
			 <td colspan="2">
		  	 	<input type="text" name="requestdescription" id="requestdescription" value="#Item.itemdescriptionexternal#" style="width:100%" class="regularxl" maxlength="200"> 						  
			 </td>
			
			</tr>	
			
		</cfif>
		
		
		</table>
					
		</cfif> 
		
	</cfcase>
	
	<cfcase value="uom">
			
		<cfif Access eq "View">
		
			#url.UoM#
			
		<cfelse>		
		
			<table>
			 <tr>
			 <td id="setuom">
			 			 			 		 
			 <cfset url.uom = url.uomwhs>			
			 <cfinclude template="RequisitionEntryWarehouseUoM.cfm">		 
						
			</td>
			</tr>
			</table>
		
		</cfif>		
		
	</cfcase>
	
	</cfswitch>
	
</cfoutput>			

