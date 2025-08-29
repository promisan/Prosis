<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.customerid" default="">
 
<cfquery name="AddressType" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AddressType
</cfquery>

<cfquery name="Customer" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Customer
	WHERE  CustomerId = '#url.customerid#'
</cfquery>

<cfform name="addressform" onsubmit="return false">

	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	
	  <tr class="hide"><td id="addressprocess"></td></tr>
	  <tr><td style="border:0px dotted silver;padding:2px">
	  
	<cfoutput><input type="hidden" name="CustomerId" id="CustomerId" value="#URL.CustomerId#" class="regular"></cfoutput>
	
			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			 
			 			     
			  <tr>
			    <td width="100%" colspan="2" style="padding-top:2px">
						
			    <table border="0" cellpadding="0" cellspacing="0" width="96%" align="center" class="formpadding">
				
				<TR>
				    <td  style="padding-left:7px" class="labelmedium" width="170"><cf_tl id="Address type">: <font color="FF0000">*</font>
					<cf_space spaces="49">
					</td>
				    <td class="labelmedium">	 
					
					  <table cellspacing="0" cellpadding="0">
				   
				      <tr>
					    <td>
					   	<select name = "AddressType" required="No" class="regularxl">
						    <cfoutput query="AddressType">
								<option value="#AddressType#">#Description#</option>
							</cfoutput>
					   	</select>	
						</td>
					  </tr>
					  </table>
					  
					</td>
					
				</tr>
					  
				<tr>	
						
				 <td style="padding-left:7px;padding-right:10px"  class="labelmedium" height="30"><cf_tl id="Effective date">:</TD>			
				 <td>
				 
					 <table>
					 <tr>
					 <td>
						
								<cf_intelliCalendarDate9
									FormName="addressentry"
									FieldName="DateEffective" 
									class="regularxl"
									DateFormat="#APPLICATION.DateFormat#"
									message="Please enter an effective date"
									Default="#Dateformat(now(), CLIENT.DateFormatShow)#"	
							    	AllowBlank="False">
							
					 </td>									
					 <td class="labelmedium" style="padding-left:7px;padding-right:10px"><cf_tl id="Expiration">:<cf_space spaces="20"></TD>		    
					 <td>
							
								<cf_intelliCalendarDate9
									FormName="addressentry"
									FieldName="DateExpiration" 
									class="regularxl"
									DateFormat="#APPLICATION.DateFormat#"
									Default=""
									AllowBlank="True">				
								
					 </td>
					 
					 </tr>
					 
					 </table>
				 
				 </td>
						
				</tr>
				
				<tr class="line"><td colspan="2"></td></tr>
				  	
				<tr><td colspan="2" valign="top" style="padding-left:10px;">
										
				    <!--- address object --->	
					<cf_address mode="edit" addressscope="Customer" styleclass="labelmedium" mission="#customer.mission#" emailRequired="No">
			
				</td></tr>
				
				<cfquery name="ContactType" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Contact 
					ORDER  BY ListingOrder
				</cfquery>
				
				<tr class="labelmedium">
					<td colspan="2" style="font-size:20px;font-weight:200" align="left"><cf_tl id="Contact"></td>
				</tr>
								
				<cfoutput query="ContactType">
					<tr>
						<td class="labelmedium" style="min-width:120;padding-left:15px;">#Description#</td>
						<td style="padding-left:5px" align="left"><cfinput type="text" name="contact_#code#" id="contact_#code#" value="" class="regularxl"></td>
					</tr>
				</cfoutput>
				   			
			   </table>
			   
			      
			   </td>
			   </tr>
							 		   
			   <tr><td height="1" colspan="2" class="line"></td></tr>
			
				<tr><td colspan="2" align="center" style="padding-top:4px">
				
				   <cfoutput>
				  
				    <cf_tl id="Back" var="1">   
				
				   <input type    = "button" 
				          style   = "width:120" 
						  name    = "cancel" 
						  id      = "cancel" 
						  value   = "#lt_text#" 
				          class   = "button10g" 
					      onClick = "ptoken.navigate('#SESSION.root#/Warehouse/Application/Customer/Address/CustomerAddress.cfm?customerid=#url.customerid#','addressdetail')">
					
				   <cf_tl id="Reset" var="1">  
				   		  
				   <input class   = "button10g" 
				          style   = "width:120" 
						  type    = "reset"  
						  name    = "Reset" 
						  id      = "Reset" 
						  value   = "#lt_text#">
				
				   <cf_tl id="Save" var="1"> 		  
				   
				   <input class   = "button10g" 
				          style   = "width:120" 
						  type    = "button" 
						  name    = "Submit" 
						  id      = "Submit" 
						  value   = "#lt_text#" 
						  onclick = "addressentryvalidate()">	 
				   
				   </cfoutput>
				   
			   </td>
			   </tr>
			
			</table>
			
		</td>
		</tr>
		
	</table>		

</CFFORM>

<cfset ajaxonload("doCalendar")>

