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

<table width="100%" align="center">
	
	<tr>
	
	    <td height="100%" valign="top" width="100%">		
		
			<table width="99%" align="center">
			
			<!--- voucher --->  	
			
						
		    <TR class="<cfif Check.EnableReference eq "1">labelmedium<cfelse>hide</cfif>"> 
		      <TD style="padding-top:5px;padding-right:20px" class="labelmedium" height="22"><cf_tl id="ReceiptNo"><cfif Check.EnableReference eq "1">:<font color="FF0000">*</font></cfif></TD>
		      <td align="left" style="padding-top:3px;" width="100%">
			  	
				<cfif Check.EnableReference eq "1">
				
				<input type      = "text" 
				       name      = "transactionreference" 
					   id        = "transactionreference"
					   class     = "regularxl enterastab" 
					   style     = "width:99" 
					   maxlength = "20">
												
				</cfif>	   
					   
				<cf_assignid>	   
				<input type="hidden" name="transactionid"            id="transactionid"            value = "#rowguid#">	   
				<input type="hidden" name="transactionreferencemode" id="transactionreferencemode" value = "#Check.EnableReference#">	
					   
		  	  </td>			  	   
		   </TR>   
			
		   <TR id="box8" class="hide"> 
	         <TD height="22" style="padding-top:3px;padding-right:12px" width="80" class="labelmedium"><cf_tl id="Storage">:<font color="FF0000">*</font></TD>
	         <td align="left" id="locationtransferbox" width="60%">			 		   
	  	    </td>			  	   
		   </TR>			   
		   
		   <TR id="box2"> 
		   
		      <TD style="height:27;padding-right:12px;min-width:160px" class="labelmedium"><cf_tl id="Equipment">:</TD>
			  <td>
				  <table cellspacing="0" cellpadding="0">
				  <tr>
				  		  
			      <td align="left" id="categoryboxcontent">		  		  					 
					   <cfinclude template="getCategorySelect.cfm">			  					
			  	  </td>			  	   
				 
			      <!--- <TD height="22" style="padding-top:3px;padding-right:12px"><cf_tl id="Equipment">:<font color="FF0000">*</font></TD> --->
				  
			      <td align="left" style="padding-left:4px">
		
					<cf_tl id="Enter serialno or license plate or portion" var="vAssetSelectTooltip">
		
				  	<cfinput type="text" 
						name      = "assetselect" 
						class     = "regularxl enterastab" 
						style     = "width:130" 
						maxlength = "20" 
						onkeyup   = "searchcombo('#mission#','#url.warehouse#',document.getElementById('categoryselect').value,'asset',this.value,'up',document.getElementById('itemno').value,'');"
						onkeydown = "searchcombo('#mission#','#url.warehouse#',document.getElementById('categoryselect').value,'asset',this.value,'down',document.getElementById('itemno').value,'');">
						
					<input type="hidden" name="assetidselect" id="assetidselect"  value="">
					
			  	  </td>		
				  
				  <td width="30" style="padding-left:5px" id="selectassetitem">
								  				
				       <cfset link = "#SESSION.root#/warehouse/application/stock/Transaction/getAsset.cfm?">			
					  
					   <cf_selectlookup
							    box          = "assetbox"
								link         = "#link#"
								title        = "Item Selection"
								icon         = "find1.png"
								button       = "No"
								close        = "Yes"					
								filter1      = "mission"
								filter1value = "#url.mission#"		
								filter2      = "warehouse"
								filter2value = "#url.warehouse#"		
								filter3      = "category"
								filter3value = "{categoryselect}"		
								filter4      = "supply"
								filter4value = "{itemno}"		
								class        = "Asset"
								des1         = "AssetId">							
									
					</td>				  
				  
				  </tr>
				  </table>	  	   
		    </TR>   
			
			<!--- combo box to select the asset --->
			<tr id="box2"><td></td><td bgcolor="white" id="assetselectbox">					
				<div style="position:absolute;  color: white; z-index: 2000;" id="assetfind"></div>			
			</td></tr>
						
			<!--- -------------- --->	
			<!--- --asset item-- --->
			<!--- -------------- --->
					
	    	<TR id="box2" class="regular"> 		
				
				<td></td>				
			
		        <td valign="top" align="left">
				
			    <table width="100%" height="100%">
				
					<tr>
					
					<td width="100%" height="0"  align="center" id="assetbox"></td>
					
						<input type="hidden" name="assetid"      id="assetid"      value=""  class="regular">	
						<input type="hidden" name="metrics"      id="metrics"      value=""  class="regular">	
						<input type="hidden" name="assetdetails" id="assetdetails" value=""  class="regular">						
						
					</tr>
					
				</table>  
				
		  	  </td>			  	   
	    
		    </TR>	
			
			<!--- ------------ --->
			<!--- ----unit---- --->			
			<!--- ------------ --->
		
					
			<TR id="box2"> 
						    
		        <TD class="labelmedium"><cf_tl id="Unit">:<font color="FF0000">*</font></TD>
				
		        <td width="90%" align="left" style="height:25px">
				
			    <table cellspacing="0" cellpadding="0">
				<tr>
															
					<td width="400" bgcolor="ffffff" style="height:23;padding:4px;border:1px solid silver;border-radius:3px;" align="center" id="unitbox"></td>		
					
					<td align="center" style=";width:25;padding-left:0px">
					
				       <cfset link = "#SESSION.root#/warehouse/application//stock/Transaction/getUnit.cfm?">	
						  		   
					   	  <cf_selectlookup
						    box          = "unitbox"
							link         = "#link#"
							title        = ""
							icon         = "find1.png"
							button       = "No"
							close        = "Yes"	
							filter1      = "mission"
							filter1value = "#url.mission#"					
							class        = "organization"
							des1         = "OrgUnit">	
							
						<input type="hidden" name="orgunit" id="orgunit" size="4" value="" class="regular" readonly style="text-align: center;">		
										
					</td>
									
							
				</tr>
				</table>  
		  	  </td>			  	   
		    </TR>		
					
			
			<TR id="box99"> 
		      <TD style="height:28;padding-right:12px" class="labelmedium"><cf_tl id="Receiver">:<font color="FF0000">*</font></TD>
		      <td align="left">
			  		
				<cf_tl id="Enter IndexNo or ID" var="vEnterIndex">
					
			  	<cfinput type = "text" 
				  name        = "personselect" 
				  class       = "regularxl enterastab" 
				  style       = "width:99" 
				  maxlength   = "20" 
				  onblur      = "_cf_loadingtexthtml='';ColdFusion.navigate('../Transaction/validatePerson.cfm?mission=#url.mission#&value='+this.value+'&personno='+document.getElementById('personidselect').value,'personfind')"
				  onkeyup     = "searchcombo('#mission#','#url.warehouse#',document.getElementById('categoryselect').value,'person',this.value,'up',document.getElementById('itemno').value,'');"
				  onkeydown   = "searchcombo('#mission#','#url.warehouse#',document.getElementById('categoryselect').value,'person',this.value,'down',document.getElementById('itemno').value,'');">
				 				 			  
				  <input type="hidden" name="personidselect" id="personidselect" value="">
				  
				  
		  	  </td>			  	   
		    </TR>  		
			
			<!--- combo box to select the person --->
			<tr id="box99"><td></td><td bgcolor="white" id="personselectbox">					
				<div style="position:absolute;  color: white; z-index: 2000;" id="personfind"></div>			
			</td></tr>	
			
			<TR> 
				   
				<td></td>  
				
		        <td colspan="1" align="left" valign="top">
				
			    <table width="100%" height="100%">
				
					<tr>
						
					<td width="100%" align="center" id="personbox"></td>		
					
					<input type="hidden" name="personno" id="personno" size="4" value="" readonly style="text-align: center;">	
					
					<!---
					
					<td width="30" style="padding-top:4px;padding-left:5px">
					
					        <cfset link = "#SESSION.root#/warehouse/application//stock/Transaction/getPerson.cfm?mission=#url.mission#">	
					   				   
					   		<cf_selectlookup
							    box          = "personbox"
								link         = "#link#"
								title        = "Employee"
								icon         = "find1.png"
								button       = "No"
								close        = "Yes"	
								filter1      = "mission"
								filter1value = "#url.mission#"						
								class        = "employee"
								des1         = "personno">	
							
															
					</td>
					--->
					
					</tr>
			  </table>  
		  	</td>			  	   
	   
	   		</TR>	
						
			<cfquery name="program" 
					   datasource="AppsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						SELECT   *
						FROM     WarehouseProgram D, Program.dbo.Program P
						WHERE    Warehouse     = '#url.warehouse#'		
						AND      D.ProgramCode =  P.ProgramCode
						AND      D.Operational = 1						 
			</cfquery>		
							
			<cfif program.recordcount gte "1">
						
				<TR id="projectbox"> 
			      <TD style="height:28;padding-top:0px;padding-right:12px" class="labelmedium"><cf_tl id="Purpose">:</TD>
			      <td align="left" id="projectboxcontent" style="padding-right:4px">	   
				   
					<!--- get the project --->
					<cfparam name="url.selected" default="">				
					
					   <select name="ProgramCode" id="ProgramCode" style="width:200" class="enterastab regularxl">
					        <option value="">n/a</option>
							<cfloop query="Program">
							<option value="#ProgramCode#" <cfif url.selected eq programcode>selected</cfif>>#ProgramName#</option>
							</cfloop>
					   </select>
					   		     		  				  
			  	  </td>			  	   
			    </TR>  	
			
			<cfelse>
			
				<input type = "Hidden"
				       name     = "programcode"
					   id       = "programcode">
						
			</cfif>	
									
		    <!--- quantity --->
		   
		    <TR> 
		      <TD style="height:28;padding-right:12px" class="labelmedium"><cf_tl id="Quantity">:<font color="FF0000">*</font></TD>
		      <td align="left" onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}">
			  
			  	  <table cellspacing="0" cellpadding="0">

				    <tr>
					<td style="height:27">
			  
				  	<input type = "Text"
				       name     = "transactionquantity"
					   id       = "transactionquantity"
				       validate = "float"
					   style    = "border:1px solid silver;width:80;text-align:right;padding-right:3px"
				       class    = "enterastab regularxl">
					   
					</td>
					
					<td style="padding-left:3px" id="uomtransaction">					
					
					 <cfinclude template="getTransactionUoMSelect.cfm">					
					</td>
					
					</tr>
									
				  </table>   
					   
		  	  </td>
			</tr>  
			
			<!--- billing mode --->
			
			<cfif check.BillingMode eq "External" and Access eq "ALL">
			
				<TR id="billingbox"> 
				
			      <TD style="height:28;padding-right:12px" class="labelmedium"><cf_tl id="Billing">:<font color="FF0000">*</font></TD>
			      <td align="left" id="billingboxcontent" style="padding-right:4px">	   
				  
					  <cfquery name="billingmode" 
						   datasource="AppsMaterials" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
								SELECT   *
								FROM     Ref_BillingMode							    		 
					   </cfquery>		
				  							
					   <select name="BillingMode" id="BillingMode" class="enterastab regularxl">				       
							<cfloop query="BillingMode">
						    	<option value="#Code#" <cfif check.BillingMode eq code>selected</cfif>>#Description#</option>
							</cfloop>
					   </select>					   
					   		     		  				  
			  	  </td>		
				  	  	   
			    </TR>  	
				
			<cfelseif check.BillingMode eq "External">
				
				<input type="hidden" name="billingmode" id="billingmode" value="External">	
			
			<cfelse>
			
				<input type="hidden" name="billingmode" id="billingmode" value="Internal">
						
			</cfif>			
			
			<TR>       
            
		         <td valign="top" style="height:28;padding-top:2px;padding-right:11px" class="labelmedium"><cf_tl id="Remarks">:<cf_space spaces="21"></TD>
		         <td align="left" style="padding-right:0px">
				 
			 		<cf_tl id="Remarks" var="vRemarks">
			 					
		  		    <textarea name="remarks" id="remarks"
						 class="regular enterastab"
						 totlength="200"
						 onkeyup="return ismaxlength(this)"					
						 style="padding:4px;font-size:14px;height:40;width:100%"></textarea>
						
				</td>		
					  	   
	        </TR>	
							
			</table>
		
	</td>
	     
   </tr>  
   
   <tr><td height="2"></td></tr>
  	  		
   <tr id="submitbox0" class="xxhide"><td class="line" colspan="2"></td></tr>
	
   <TR id="submitbox1" class="xxhide"> 
	
	     <TD colspan="2" style="padding:2px">
		 
			  <cf_tl id="Add Line" var="1">		
			  	  
			  <input type = "button" 
			      class   = "button10g" 
				  style   = "height:25;width:140" 				
				  value   = "#lt_text#" 
				  onclick = "save_manual_transaction('#url.warehouse#','#url.mode#','#url.scope#','#url.systemfunctionid#',document.getElementById('showdetails').checked);" 
				  name    = "addbutton" 
				  id      = "addbutton">
					  
	    </TD>
			  
	</TR>  
   
   </table>
   
</cfoutput>  

<cfif CategoryList.recordcount eq "0">
<script>
   try { document.getElementById('selectassetitem').className = 'hide' } catch(e) { }
</script>   
</cfif> 