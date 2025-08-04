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
<cfquery name="getUoM" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	I.ItemNo, I.ItemDescription, U.UoM, U.UoMDescription
		FROM 	Item I,
				ItemUoM U
		WHERE	I.ItemNo = U.ItemNo
		AND		I.ItemNo = '#url.itemno#'
</cfquery>

<cfoutput>

<table class="hide">
    <tr><td id="process"></td></tr>
	<tr><td><iframe name="processeditvendoritem" id="processeditvendoritem" frameborder="0"></iframe></td></tr>
</table>
	
<cfform name="frmeditvendoritem" method="POST"
  action="#SESSION.root#/Warehouse/Maintenance/ItemMaster/Vendors/vendorEditHeaderSubmit.cfm?itemno=#url.itemno#&mission=#url.mission#&uom=#url.uom#&orgunitvendor=#url.orgunitvendor#" target="processeditvendoritem">

<table width="100%" align="center" class="formpadding formspacing">
	
	<cfif url.uom eq "">	
	<tr>
		<td width="20%" class="labelmedium" height="23"><cf_tl id="Item">:</td>
		<td class="labelmedium">
			#getUoM.ItemDescription# <cfif url.uom neq "" and url.orgunitvendor neq ""> (#get.UoMDescription#) </cfif>
		</td>
	</tr>
	</cfif>
	
	<cfif url.uom neq "" and url.orgunitvendor neq "">
	
	<cfelse>
	
	<tr>
		<td class="labelmedium" height="23"><cf_tl id="UoM">:</td>
		<td>
			
				<select name="uom" id="uom" class="regularxxl">
					<cfloop query="getUoM">
						<option value="#getUoM.UoM#">#getUoM.UoMDescription#</option> 
					</cfloop>
				</select>
			
		</td>
	</tr>
	
	</cfif>			
	
	<tr>
		<td class="labelmedium2"><cf_tl id="Vendor">:</td>
		<td colspan="3" class="labelmedium2">
		
			<cfif url.uom neq "" and url.orgunitvendor neq "">
			
				<a href="javascript: showVendorInfo('#url.orgUnitVendor#');">#get.VendorName#</a>
				
			<cfelse>
			
			    <table>
				<tr>
				
			   <td>
 				   <cfinput type="text"   id="referenceorgunitname1" name="referenceorgunitname1" class="regularxl" value="#get.vendorName#" size="46" maxlength="40" required="Yes" message="Plaese, select a valid vendor." readonly>
				   <input type="hidden" name="referenceorgunit" id="referenceorgunit1" value="#get.orgunitvendor#">		
				     			  
			   </td>
			   
			   <td style="padding-left:1px">				   					

				<img src="#SESSION.root#/Images/search.png" alt="Select vendor" name="img1" 
				  onMouseOver="document.img1.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" alt="" width="23" height="23" border="0" align="absmiddle" 
				  onClick="selectorgN('#getVendorTree.treeVendor#','','referenceorgunit','applyorgunit','1','1','modal')">
				  
		       </td>
			   
			   </tr>
			   </table>
			   
			</cfif>			
		</td>
	</tr>
	<tr>
		<td height="23" class="labelmedium"><cf_tl id="Item No.">:</td>
		<td>		   
			<cfinput type="Text" name="vendoritemno" value="#get.vendoritemno#" class="regularxl" required="No" message="Please, enter a vendor item number." size="8" maxlength="20">
		</td>	
	</tr>
	<tr>	
		<td height="23" class="labelmedium"><cf_tl id="Description">:</td>
		<td>
			<cfinput style="width:90%" type="Text" name="vendoritemdescription" class="regularxl" value="#get.vendoritemdescription#" required="No" message="Please, enter a vendor item description." size="60" maxlength="100">
		</td>
	</tr>
	<tr>
		<td height="23" class="labelmedium"><cf_tl id="Preferred">:</td>
		<td colspan="3" class="labelmedium">
		    <table><tr class="labelmedium">
			<td><input type="radio" class="radiol" name="preferred" id="preferred" <cfif get.preferred eq "0" or (url.uom eq "" and url.orgunitvendor eq "")>checked</cfif> value="0"></td>
			<td style="padding-left:6px">No</td>
			<td style="padding-left:9px"><input type="radio" class="radiol" name="preferred" id="preferred" <cfif get.preferred eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:6px">Yes</td>
			</tr></table>
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td height="1" class="line" colspan="4"></td></tr>
	<tr><td height="3"></td></tr>
	<tr>
		<td colspan="4">
		
		<input 
			class       = "button10g"
			value       = "Save" 
			type        = "Submit"
			id          = "Save"					
			width       = "140px" 					
			color       = "636334"
			fontsize    = "11px">   
		
		</td>
	</tr>
	
</table>

</cfform>

</cfoutput>