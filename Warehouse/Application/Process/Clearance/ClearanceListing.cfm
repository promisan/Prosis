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

<cfoutput>

<cfparam name="URL.act" default="">

<cf_tl id = "You entered an incorrect quantity" var ="vQuantity">

<script language="JavaScript">
	
	function reqedit(id,qty) {	
		if (parseFloat(qty)) {		
		   _cf_loadingtexthtml='';	
		   ptoken.navigate('setLineQuantity.cfm?role=#role#&sorting=#URL.Sorting#&id='+id+'&quantity='+qty,'amount_'+id)
		   } else  {
			  alert("#vQuantity# "+qty+")")
		}				
	}
	
	function mail2(mode,id) {
		window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplate#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}	
	
	function reload(id,act,sid) {	 
	    ptoken.location('ClearanceListingZoom.cfm?idmenu='+sid+'&ts='+new Date().getTime()+'&mission=#URL.Mission#&id=' + id + '&act=' + act)
	 }
	 
	function resort(sort) {
	    window.location = "Listing.cfm?idmenu=#url.idmenu#&mission=#URL.Mission#&sorting=" + sort + "&ID=#CLIENT.review#" 
	} 
	 
	function hl(itm,fld){    
	
	    while (itm.tagName!="TR")
	         { itm=itm.parentElement; }     
		 	 		 	
		 if (fld != false){			
			 itm.className = "highLight2 labelit";
		 } else {		
			 itm.className = "labelit";		
		 }	 
	}
	  
	function more(id) {
	
		url = "../../../Portal/Requester/ItemView.cfm?id="+id
		se = document.getElementById("b"+id)		
		if (se.className == "regular") {
			   se.className = "hide"			
		} else {
		se.className = "regular"		
		ptoken.navigate(url,'i'+id)	
	    }	
	}  

</script>

</cfoutput>

<cf_dialogMaterial>

<cfif SearchResult.recordCount gt "0">
	
	<cfif find("whs#IDStatus#", CLIENT.Review)>
	
	<cfform action="ClearanceSubmit.cfm?idmenu=#url.idmenu#&Mission=#URL.Mission#" method="post" name="whs#role#" id="whs#role#"> 
	
		    <cfoutput>
			   <input type="hidden" name="Role"       id="Role"       value = "#Role#">
			   <input type="hidden" name="StatusNext" id="StatusNext" value = "#StatusNext#">
			</cfoutput>   
	
		    <table width="96%" align="center" border="0">  
			
			<tr><td>
			 
		    <table width="95%" align="center" class="navigation_table">
		  
		    <tr>
		      <td colspan="6" style="height:40;padding-top:10px" class="labellarge"><cfoutput>#action#</cfoutput></td>		  
			  <td colspan="4" align="right" valign="middle">
			  
			  <select name="group" id="group" class="regularxl" size="1" onChange="resort(this.value)">		  
		       <option value="RequestDate"     <cfif URL.Sorting eq "RequestDate">selected</cfif>>     <cf_tl id="Group by Date">
			   <option value="ShipToWarehouse" <cfif URL.Sorting eq "ShipToWarehouse">selected</cfif>>     <cf_tl id="Requester">
				 <!---				
		        <option value="HierarchyCode"    <cfif URL.Sorting eq "HierarchyCode">selected</cfif>>   <cf_tl id="Group by OrgUnit">
				--->
				<option value="ItemDescription"  <cfif URL.Sorting eq "ItemDescription">selected</cfif>> <cf_tl id="Group by Item">				
		     </select> 
			
			  </td>
				  
		    </tr>
			
			<tr class="line labelmedium">
			    <TD height="20" width="20"></TD>
				<TD width="20"></TD>
				<TD width="12%"><cf_tl id="Reference"></TD>
				<TD width="20%"><cf_tl id="Requester"></TD>
				<TD width="40"><cf_tl id="Item"></TD>
				<TD width="30%"><cf_tl id="Description"></TD>
			    <TD width="6%"><cf_tl id="UoM"></TD>
			    <TD width="6%" align="right"><cf_tl id="Quantity"></TD>
				<td width="8%" align="right"><cf_tl id="Price"></td>
				<td width="8%" style="padding-right:10px" align="right"><cf_tl id="Total"></td>
			</TR>
					
		    <cfset amtT     = 0>	
			<cfset subt     = 0>
				
	        <cfoutput query = "SearchResult" group="#URL.Sorting#">					

		        <cfset amt      = 0>				
				<cfset subt = subt+1>
		    			
		    <tr class="labelmedium">
			
		       <cfswitch expression="#URL.Sorting#">
			        <cfcase value = "RequestDate">
					
					<cfquery name="subtotal" dbtype="query">
						SELECT sum(RequestedAmount) as RequestedAmount FROM SearchResult WHERE RequestDate = '#requestDate#'
					</cfquery>
					
			        <td colspan="9" style="height:25">#Dateformat(RequestDate, "#CLIENT.DateFormatShow#")#</td>
					<td align="right" id="subtotal_#subt#" style="padding-right:5px">#NumberFormat(subtotal.RequestedAmount,',.__')#</td>						
					</cfcase>
					
					<cfcase value = "ShipToWarehouse">
					
					<cfquery name="subtotal" dbtype="query">
						SELECT sum(RequestedAmount) as RequestedAmount FROM SearchResult WHERE ShipToWarehouseName = '#ShipToWarehouseName#'
					</cfquery>
					
			        <td colspan="9" style="height:25">#ShipToWarehouseName#</td>
					<td align="right" id="amount_#subt#" style="padding-right:5px">#NumberFormat(subtotal.RequestedAmount,',.__')#</td>									
			        </cfcase>
					
			        <cfcase value = "HierarchyCode">
					
					<cfquery name="subtotal" dbtype="query">
						SELECT sum(RequestedAmount) as RequestedAmount FROM SearchResult WHERE OrgUnitName = '#OrgUnitName#'
					</cfquery>
					
			        <td colspan="9" style="height:25">#Mission# #OrgUnitName#</td> 					
					<td align="right" id="amount_#subt#" style="padding-right:5px">#NumberFormat(subtotal.RequestedAmount,',.__')#</td>								
			        </cfcase>	 
					
			        <cfcase value = "ItemDescription">
					
					<cfquery name="subtotal" dbtype="query">
						SELECT sum(RequestedAmount) as RequestedAmount FROM SearchResult WHERE ItemNo = '#ItemNo#'
					</cfquery>
					
			      	<td colspan="9" style="height:25">#ItemNo# #ItemDescription#</td>
					<td align="right" id="amount_#subt#" style="padding-right:5px">#NumberFormat(subtotal.RequestedAmount,',.__')#</td>									
			       </cfcase>
				   
		       </cfswitch>
			   
		   </tr>
		   
			    <cfoutput group="Category">
				
				<tr>
				<td colspan="10" style="padding-left:2px;height:25">#Category#</td>
				</tr>
			   		     
				   <CFOUTPUT>
				
				    <TR class="labelit line navigation_row" bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f6f6f6'))#">
					
						   <td align="center" style="cursor: pointer;height:27px;">				   	   
						        <cf_img icon="expand" toggle="yes" onclick="more('#requestId#')">																	
						   </td>		
						   
				           <td align="center" style="padding-left:8px">
						   			     
							   <cfif Role eq "ReqReceipt">
							  				   
							      <cfif Status is IDStatus>
				                 	<input type="checkbox" class="radiol navigation_action" style="height:14px;width:14px" name="selected" id="selected" value="'#TransactionRecordNo#'" onClick="hl(this,this.checked)">
				     	          </cfif>
							   				 			 		   
							   <cfelse>
							   				   				   
							      <cfif Status is IDStatus>					
				                 	<input type="checkbox" class="radiol navigation_action" style="height:14px;width:14px" name="selected" id="selected" value="'#RequestId#'" onClick="hl(this,this.checked)">
				     	          </cfif>
														   				
								</cfif>			  
							  
					       </td>
						  	
					       <TD>
						   
							   <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
							   
								   <tr>
								   <td class="labelit"><a href="javascript:mail2('print','#Reference#')">#Reference#</a></td>
								   <td width="6"></td>
								   <td align="right" style="padding-right:4px">
								     <cf_img icon="print" onclick="mail2('print','#Reference#')">
									</td>
								   </tr>
								   
							   </table>
							   
						   </TD>
						   
						   <td><cfif ShipToWarehouseName neq "">#ShipToWarehouseName#<cfelse>#OfficerLastName#</cfif></td>				   
						   <TD><a href="javascript:more('#requestId#')">#ItemNo#</a></TD>
						   <TD>#HTMLEditformat(ItemDescription)#</TD>		     				   
				           <TD>#UoMDescription#</TD>	
						   		   
						   <TD align="right">
							
							   <cfif (status eq "i" or status eq "1") and Parameter.EnableQuantityChange eq "1">
							   
									   <input type="text" 
									       name="quantity" 
										   id="quantity"
										   value="#RequestedQuantity#"
									       size="2" 
										   class="regularxl enterastab" 
										   maxlength="5" 
										   style="text-align: center;"
									       onchange="reqedit('#requestId#',this.value)">		 
									   
							   <cfelse>
							   
					   				#RequestedQuantity#    
									
							   </cfif>			   
						   
				           </TD>
				           <td align="right" style="padding-right:5px">#NumberFormat(StandardCost,',.__')#</td>	
					       <td align="right" 
						        id="amount_#requestId#" style="padding-right:10px">#NumberFormat(RequestedAmount,',.__')#</td>	
						   	   <cfset Amt  = Amt  + RequestedAmount>
					           <cfset AmtT = AmtT + RequestedAmount>    		
								
				    </TR>			
					
					<tr class="hide" id="b#RequestId#">
					   <td colspan="10" id="i#RequestId#"></td>
				    </tr>
							
				    </CFOUTPUT>
				
				</cfoutput>
			
		  	</CFOUTPUT> 
			 
			 <cfoutput>
				     
		     <TR>
		       <td colspan="9" class="labelmedium" height="20" align="right" style="padding-right:10px;padding-left:10px">Grand total:&nbsp;</b>			          
			   <td align="right" class="labelmedium" bgcolor="BBE6F2" id="boxoverall" style="padding-right:10px">#NumberFormat(AmtT,',.__')#</b></td>	
		     </TR>
			
			</cfoutput>
			 
			 <tr><td colspan="10">
			 <cfif Role eq "ReqReceipt">
		      	<cf_DecisionBlock cancel="false" OK="Confirm receipt" Deny="Return" form="whs#role#"> 
			 <cfelse>
			    <cf_DecisionBlock cancel="false" form="whs#role#"> 
			 </cfif> 
		    </td></tr>  
			
		   </table>	
		  
		   </td></tr>   
			
		</table>
	  
	   </cfform> 
	  
	<cfelse>
	  
	  <cfoutput>
	  <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	    <tr style="cursor: pointer;" class="line" onClick="reload('whs#IDStatus#','add','#url.idmenu#')">
	    <td colspan="9" height="25" style="padding-left:40px" class="labelmedium"><b>		
			<font color="0080C0">#action#</font>
	    </td>
		<td width="30" align="right"></td> 
		</tr>		
	   </table>
	   </cfoutput>
	        
	</cfif>
	
</cfif>
