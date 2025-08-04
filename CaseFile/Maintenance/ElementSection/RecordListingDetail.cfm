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
		
<cfparam name="url.code" default="">
	
<cfquery name="Listing" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT * FROM
   Ref_ElementSection
   ORDER BY ListingOrder
</cfquery>

<cfform  method="POST" name="mysection" onsubmit="return false">

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table maintenancetable">
	
<thead>
    <tr>
  	    <td width="8"></td>
	    <td><cf_tl id="Code"></td>	
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Listing Label"></td>
		<td><cf_tl id="Listing Order"></td>
		<td><cf_tl id="Listing Icon"></td>
		<td><cf_tl id="Officer"></td>
	    <td><cf_tl id="Entered"></td> 
  	    <td width="20"></td>
  	    <td width="20"></td>
    </tr>	
</thead>

<tbody>	
	<cfif url.code eq "new">
	
		<cfoutput>
		<tr bgcolor="f4f4f4">
			<td width="8"></td>
			<!--- Field: Code --->
			<td height="25">&nbsp;
				<cf_tl id = "Please enter an element code" var = "1">
				<cfinput type="Text" name="Code" value="" message="#lt_text#" required="Yes" size="10" maxlength="10" class="regularxl">
	        </td>	
			<!--- Field: Description --->				   
			<td>
				<cf_tl id = "Please enter a description" var = "1">
				<cfinput type="Text" name="Description" value="" message="#lt_text#" required="Yes" size="40" maxlength="40" class="regularxl">
			</td>
			<!--- Field: ListingLabel --->				   
			<td>
				<cfinput type="Text" name="ListingLabel" value="" size="50" maxlength="50" class="regularxl">
			</td>
			<!--- Field: ListingOrder --->				   
			<td>
				<cf_tl id = "Please enter a listing order" var = "1">
				<cfinput type="Text" name="ListingOrder" value="" message="#lt_text#" required="Yes" size="2" maxlength="2" class="regularxl">
			</td>
			<!--- Field: ListingIcon --->				   
			<td>
				<cfinput type="Text" name="ListingIcon" value="" size="40" maxlength="50" class="regularxl">
			</td>
			<td colspan="4" align="center">
				<cf_tl id = "Save" var = "1">
				<input type="submit" value="#lt_text#" 	onclick="save('new')"  class="button10g">
			</td>
		</tr>
		</cfoutput>

	</cfif>
	
	<cfoutput query="Listing">
	
		<cfif url.code eq Code>
	
			<tr bgcolor="ffffcf">
				<td width="8"></td>
				<!--- Field: Code --->
				<td height="25" class="labelit">#Code#</td>	
				<!--- Field: Description --->				   
				<td>
					<cf_tl id = "Please enter a description" var = "1">
					<cfinput type="Text" name="Description" value="#Description#" message="#lt_text#" required="Yes" size="50" maxlength="50" class="regularxl">
				</td>
				<!--- Field: ListingLabel --->				   
				<td>
					<cfinput type="Text" name="ListingLabel" value="#ListingLabel#" size="40" maxlength="40" class="regularxl">
				</td>
				<!--- Field: ListingOrder --->				   
				<td>
					<cf_tl id = "Please enter a listing order" var = "1">
					<cfinput type="Text" name="ListingOrder" value="#ListingOrder#" message="#lt_text#" required="Yes" size="2" maxlength="2" class="regularxl">
				</td>
				<!--- Field: ListingIcon --->				   
				<td>
					<cfinput type="Text" name="ListingIcon" value="#ListingIcon#" size="40" maxlength="50" class="regularxl">
				</td>
				<td colspan="4" align="center">
					<cf_tl id = "Save" var = "1">
					<input type="submit" value="#lt_text#" 	onclick="save('#Code#')"  class="button10g">
				</td>
			</tr>

		<cfelse>
			<tr class="navigation_row">
		  	    <td height="25" align="left" width="8"></td>
				<td class="labelit">#Code#</td>	
				<td class="labelit">#Description#</td>
				<td class="labelit">#ListingLabel#</td>
				<td class="labelit">#ListingOrder#</td>
				<td class="labelit">
					<cfif ListingIcon neq ''>
						<img src="#Client.VirtualDir#/images/#ListingIcon#" height="22px" width="22px">
					</cfif>
				</td>
				<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
				<td class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td> 
					
			    <td>
				      <cf_img icon="edit" onclick="sectionedit('#Code#')" navigation="yes">
			    </td>
					  
			   <cfquery name="Check" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    	SELECT TOP 1 ElementClass
				    FROM  Ref_TopicElementClass
					WHERE ElementSection = '#Code#'				
			   </cfquery>
					   	
			    <td style="padding-left:5px;">
				 <cfif check.recordcount eq "0">
					  <cf_img icon="delete" onclick="ColdFusion.navigate('RecordListingPurge.cfm?Code=#code#','listing')">
				  </cfif>
				</td>
			    
				
  		      </tr>			
			</cfif>		 
	
																	
	</cfoutput>

</tbody>
	
</table>						

</cfform>
