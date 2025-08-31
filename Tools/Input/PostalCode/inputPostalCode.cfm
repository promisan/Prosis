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
<cf_comboscript>
	
<cfparam name="attributes.Box"              default="PostalCode">
<cfparam name="attributes.Country"          default="NET">
<cfparam name="Attributes.Mission"          default="">
<cfparam name="Attributes.InputMode"        default="System">
<cfparam name="Attributes.InputMask"        default="">
<cfparam name="Attributes.LabelClass"       default="Label">
<cfparam name="Attributes.Labelwidth"       default="80">
<cfparam name="Attributes.Required"         default="No">
<cfparam name="Attributes.AccessMode"       default="Edit">
<cfparam name="Attributes.Length"           default="7">
<cfparam name="Attributes.InputClass"       default="regular">
<cfparam name="Attributes.FieldZIP"         default="PostalCode">
<cfparam name="Attributes.FieldCity"        default="City">
<cfparam name="Attributes.FieldAddress"     default="Address">

<cfparam name="Attributes.SelectedPostal"   default="9441 PA">

<cfquery name="getZIP" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT   *
		FROM     PostalAddress
		WHERE    Country    = '#attributes.country#'
		AND      PostalCode = '#Attributes.SelectedPostal#'				 
</cfquery>	

<cfparam name="Attributes.SelectedAddress"    default="#getZip.Address#">
<cfparam name="Attributes.SelectedAddressNo"  default="">

<cfif getZIP.City neq "">
	<cfparam name="Attributes.SelectedCity"       default="#getZip.City#">
</cfif>	

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">

<tr>	
	<td style="padding-left:0px">
	
	<table width="100%" cellspacing="0" cellpadding="0">
		
		<tr>
		
			<td style="width:#attributes.labelwidth#" class="#attributes.labelclass#" onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}"><cf_tl id="ZIP">:</td>
			<td style="padding-left:9px" width="90%" class="#attributes.labelclass#">
			
			    <cfif attributes.accessmode eq "view">
				
					<cfif attributes.SelectedPostal neq "">#attributes.SelectedPostal#<cfelse>N/A</cfif>
				
				<cfelse>
			
				<table cellspacing="0" cellpadding="0">
					
					<tr>
					
					<td>
																		
			        <!--- pass cfm for searching, getting and the condition needed for both search and getting --->
					
					<cfif attributes.inputmask eq "">
			
			        <input type      = "text" 
					       name      = "field_#attributes.box#" 
						   id        = "field_#attributes.box#" 
						   value     = "#attributes.SelectedPostal#" 
						   size      = "15" 
						   maxlength = "#attributes.length#" 
						   class     = "#attributes.InputClass# enterastab" 
				           onkeyup   = "selectcombo('#attributes.box#','tools/Input/PostalCode/getPostal.cfm','tools/Input/PostalCode/setPostal.cfm','mission=#attributes.mission#&country=#attributes.country#',document.getElementById('field_#attributes.box#').value,'up')"
					       onkeydown = "selectcombo('#attributes.box#','tools/Input/PostalCode/getPostal.cfm','tools/Input/PostalCode/setPostal.cfm','mission=#attributes.mission#&country=#attributes.country#',document.getElementById('field_#attributes.box#').value,'down')">
						   
					<cfelse>
										
						<cfinput type      = "text" 
					       name      = "field_#attributes.box#" 
						   id        = "field_#attributes.box#" 
						   value     = "#attributes.SelectedPostal#" 
						   size      = "15" 
						   mask      = "#attributes.inputmask#"
						   maxlength = "#attributes.length#" 
						   class     = "#attributes.InputClass# enterastab" 
				           onkeyup   = "selectcombo('#attributes.box#','tools/Input/PostalCode/getPostal.cfm','tools/Input/PostalCode/setPostal.cfm','mission=#attributes.mission#&country=#attributes.country#',document.getElementById('field_#attributes.box#').value,'up')"
					       onkeydown = "selectcombo('#attributes.box#','tools/Input/PostalCode/getPostal.cfm','tools/Input/PostalCode/setPostal.cfm','mission=#attributes.mission#&country=#attributes.country#',document.getElementById('field_#attributes.box#').value,'down')">
											
					</cfif>	   
					
					</td>
					
					<td class="hide">
										
						<cfif attributes.Required eq "Yes">
						
							<cfinput type="hidden" name="postalcode_#attributes.box#" id="postalcode_#attributes.box#" value="#attributes.SelectedPostal#" required="Yes" message="Please enter a Postal Code">					
						
						<cfelse>
						
							<input type="hidden" name="postalcode_#attributes.box#" id="postalcode_#attributes.box#" value="#attributes.SelectedPostal#">
							
						</cfif>	

					</td>
										
					</tr>
					
				</table>
				
				</cfif>
					
			</td>
			
		</tr>	
		
		<!--- combo box to select the value --->
		<tr id="select_#attributes.box#">
		    <td></td>
			<td bgcolor="white">			
			<div style="position:absolute;  color: white; z-index: 2000;" id="selectcontent_#attributes.box#"></div>			
			</td>
		</tr>
							
		<tr>
			<td class="#attributes.labelclass#"><cf_tl id="City">:</td>
			<td style="height:35px;padding-left:9px" class="#attributes.labelclass#">
			
			 <cfif attributes.accessmode eq "view">
				
				<cfif attributes.SelectedCity eq "">N/A<cfelse>#attributes.SelectedCity#</cfif> 
				
			 <cfelse>
			 
			   <cfif attributes.Required eq "Yes">
			   
			   	   <cfif attributes.inputMode eq "System">
				
				      <cfinput type="text" name="city_#attributes.box#"  id="city_#attributes.box#"   required="Yes" message="Please enter a City"  value="#attributes.SelectedCity#"    size="40" maxlength="40" class="regular2 enterastab" readonly>
				   
				   <cfelse>
				   
				   	  <cfinput type="text" name="city_#attributes.box#"  id="city_#attributes.box#"   required="Yes" message="Please enter a City"  value="#attributes.SelectedCity#"    size="40" maxlength="40" class="#attributes.InputClass# enterastab">
				   			   
				   </cfif>
			   
			   <cfelse>
			 
				   <cfif attributes.inputMode eq "System">
				
				      <input type="text" name="city_#attributes.box#"  id="city_#attributes.box#"    value="#attributes.SelectedCity#"    size="40" maxlength="40" class="regular2 enterastab" readonly>
				   
				   <cfelse>
				   
				   	  <input type="text" name="city_#attributes.box#"  id="city_#attributes.box#"    value="#attributes.SelectedCity#"    size="40" maxlength="40" class="#attributes.InputClass# enterastab">
				   			   
				   </cfif>
				   
				 </cfif>  
			 
			 </cfif>
			   
			 </td>
			   
		</tr>
				
		<tr>
			<td class="#attributes.labelclass#"><cf_tl id="Street">:</td>
			<td style="padding-left:9px">
			
			<table><tr><td class="#attributes.labelclass#">
			
			 <cfif attributes.accessmode eq "view">
				
				<cfif attributes.SelectedAddress eq "">N/A<cfelse>#attributes.SelectedAddress#</cfif>
				
			 <cfelse>
			 
			    <cfif attributes.Required eq "Yes">
				
					<cfif attributes.inputMode eq "System">							
						<cfinput type="text" name="address_#attributes.box#" id="address_#attributes.box#" value="#attributes.SelectedAddress#" required="Yes" message="Please enter an Address" size="60" maxlength="100" class="regular2 enterastab" readonly>					
					<cfelse>								
						<cfinput type="text" name="address_#attributes.box#" id="address_#attributes.box#" value="#attributes.SelectedAddress#" required="Yes" message="Please enter an Address" size="60" maxlength="100" class="#attributes.InputClass# enterastab">														
					</cfif>	
				
				<cfelse>
			 
				 	<cfif attributes.inputMode eq "System">							
						<input type="text" name="address_#attributes.box#" id="address_#attributes.box#" value="#attributes.SelectedAddress#" size="60" maxlength="100" class="regular2 enterastab" readonly>					
					<cfelse>								
						<input type="text" name="address_#attributes.box#" id="address_#attributes.box#" value="#attributes.SelectedAddress#" size="60" maxlength="100" class="#attributes.InputClass# enterastab">														
					</cfif>	
					
				</cfif>	
			
			 </cfif>	
			 
			 </td>
				<td style="padding-left:10px" class="#attributes.labelclass#"><cf_tl id="No">:</td>
				<td style="padding-left:9px" class="#attributes.labelclass#">
				
				 <cfif attributes.accessmode eq "view">
					
					<cfif attributes.SelectedAddressNo eq "">N/A<cfelse>#attributes.SelectedAddressNo#</cfif>
					
				 <cfelse>
				
					<input type="text" name="addressno_#attributes.box#" id="addressno_#attributes.box#" value="#attributes.SelectedAddressNo#" style="width:40" maxlength="100" class="#attributes.InputClass# enterastab">
				
				 </cfif>	
					
				 </td>
			</tr>			
			 
			 </table>
				
			 </td>
		</tr>	
		
		
		
	</table>
	
	</td>
	
</tr>

</table>

</cfoutput>