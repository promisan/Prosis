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

<cfquery name="List" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TE.ElementClass,T.Code, T.Description, TE.ListingOrder, TE.ElementSection, TE.PresentationMode FROM Ref_TopicElementClass TE
	INNER JOIN Ref_Topic T
		ON T.Code = TE.Code
	WHERE ElementClass = '#URL.element#'
	ORDER BY TE.ListingOrder
</cfquery>

<cfparam name="URL.code" default="">
	
<table width="80%" cellspacing="0" cellpadding="0" aling="center" class="formpadding navigation_table">					
				
		<cfoutput>
		
		 <tr height="18" class="labelheader line">
			   <td>&nbsp;<cf_tl id="Code"></td>
			   <td width="40%"><cf_tl id="Description"></td>
			   <td><cf_tl id="Element section"></td>
			   <td><cf_tl id="Listing Order"></td>		  
			   <td><cf_tl id="Presentation mode"></td>
		  </tr>		
		
		<cfloop query="List">
					
			<cfset co  = Code>
			<cfset nm  = Description>
			<cfset order  = ListingOrder>
																								
			<cfif url.code eq co>		
			
			<tr class="linedotted navigation_row">
				<td colspan="6">
					<cfform action="ListSubmit.cfm?element=#URL.element#&code=#url.code#"  method="POST" name="element">
					<table width="100%" align="center">
										
						<tr>
						   <td>&nbsp;#co#</td>
						   <td>
						   	  &nbsp;#nm#
				           </td>
						   <td>
						    <cfquery name="Section" datasource="AppsCaseFile" username="#SESSION.login#" password="#SESSION.dbpw#">
								SELECT * FROM Ref_ElementSection
							</cfquery>
							<select name="ElementSection" class="regularxl">
								<cfloop query="Section">
									<option value="#Section.Code#" <cfif List.ElementSection eq Section.Code> selected</cfif>>#Description#</option>
								</cfloop>
							</select>
		
						   </td>
						   <td>
							    <cf_tl id="You must enter a listing order" var ="1" class="Message">
								<cfinput type="Text" 
								   	value="#order#" 
									name="ListingOrder" 
									message="#lt_text#" 
									required="Yes" 							 
									maxlength="2" 
									class="regularxl" style="width:25px;">
						   </td>
						    <td>
							    <cf_tl id="You must enter a presentation mode" var ="1" class="Message">
									
								<select name="PresentationMode" class="regularxl">
									<option value="0" <cfif presentationMode eq 0>selected</cfif>>Hide in listing</option>
									<option value="1" <cfif presentationMode eq 1>selected</cfif>>Show in listing</option>
									<option value="6" <cfif presentationMode eq 6>selected</cfif>>Show in header/listing</option>
								</select>
									
						   </td>
						   <td colspan="2" align="right">
		   					    <cf_tl id="Save" var ="1">
							   <input type="submit" 
							        value="#lt_text#" 
									class="button10s" 
									style="width:50">&nbsp;
						   </td>
					    </tr>	
					</table>
					</cfform>
				</td>
			</tr>
															
			<cfelse>								
						
				<tr class="linedotted cellcontent navigation_row">
				   <td>&nbsp;#co#</td>
				   <td height="20">#nm#</td>
				   <td>#ElementSection#</td>
   				   <td height="20">#order#</td>
				   <td>
				   		<cfif PresentationMode eq 0>
							Hide in listing
						<cfelseif PresentationMode eq 1>
							Show in listing
						<cfelseif PresentationMode eq 6>
							Show in header/listing
						<cfelse>
							Not defined
						</cfif>
				   </td>
				   <td align="right">
						<cf_img icon="edit" onclick="ColdFusion.navigate('List.cfm?Element=#URL.Element#&code=#co#','#url.element#_list')">
				   </td>
					
				 </tr>	
						
			</cfif>
						
		</cfloop>
		</cfoutput>
																					
</table>	

<cfset AjaxOnLoad("doHighlight")>
