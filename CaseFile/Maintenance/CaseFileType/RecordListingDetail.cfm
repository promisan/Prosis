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

<cfparam name="form.operational" default="0">	
	
<cfquery name="Listing" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, 
	     (SELECT count(*) 
		  FROM  Ref_ClaimTypeClass WHERE ClaimType = D.Code) as Classes
    FROM  Ref_ClaimType D
	ORDER BY Created 
</cfquery>

<table width="97%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
	   <td width="20"></td>
	   <td width="20"></td>
	   <td width="10%"><cf_tl id="Code"></td>
	   <td width="40%"><cf_tl id="Description"></td>
	   <td width="20%"><cf_tl id="Class"></td>
	   <td width="10%"><cf_tl id="Oper">.</b></td>
	   <td width="20%"><cf_tl id="Officer"></b></td>
	   <td width="80" align="right"><cf_tl id="Created"></b></td>		
	   <td width="30"></td>			  	  
	</tr>	
	
	<cfif URL.code eq "new">
		
	  <tr class="labelmedium2">
		<td colspan="9">
			
			<cfform method="POST" name="mytopic" onsubmit="return false">
				<table width="100%" align="center">
			
					<tr bgcolor="f4f4f4" class="linedotted">
					
					<td></td>
					<td height="25">&nbsp;
							<cfoutput>
							<cf_tl id="You must enter a code" var = "1" class="Message">
						    <cfinput type="Text" 
						         value="" 
								 name="Code" 
								 message="#lt_text#" 
								 required="Yes" 
								 size="2" 
								 maxlength="20" 
								 class="regularH">
							</cfoutput>	 
			        </td>	
										   
					<td>
							<cfoutput>
							<cf_tl id="You must enter a name" var = "1" class="Message">
						   	<cfinput type="Text" 
						         name="Description" 
								 message="#lt_text#" 
								 required="Yes" 
								 size="50" 						 
								 maxlength="50" 
								 class="regularH">
							</cfoutput>	 
					</td>
					<td></td>
					<td>		
					      <input type="Checkbox"
					       name="Operational"
					       value="1" checked>
					</td>
													   
					<td colspan="3" align="right">
					<cfoutput>
						<cf_tl id="Save" var = "1">
						<input type="submit" 
							value="#lt_text#" 
							onclick="save('new')"
							class="button10g">
					</cfoutput>
					
					</td>			    
					</tr>	
		
				</table>
			</cfform>
				
		  </td>
	  </tr>
												
	</cfif>						
		
	<cfoutput>
		
	<cfloop query="Listing">
																								
		<cfif URL.code eq code>		

			<cfform name="mytopic" onsubmit="return false">
							
		    <input type="hidden" name="Code" value="<cfoutput>#Code#</cfoutput>">
																
			<tr bgcolor="ffffcf" class="line">
			
			   <td></td>
			   <td height="30">&nbsp;#Code#</td>
			   <td>
				   <cf_tl id="You must enter a description" var = "1" class="Message">
				   
			   	   <cfinput type = "Text" 
				   	value        = "#description#" 
					name         = "Description" 
					message      = "#lt_text#" 
					required     = "Yes" 
					size         = "50" 
					maxlength    = "60" 
					class        = "regularxxl">		
						  
	           </td>
			   
			   <td>#classes#</td>
				
			   <td>
			 
				  <input type="Checkbox"
				       name="Operational"
				       value="1"
					   <cfif operational eq "1">checked</cfif>>
					   
			   </td>
					
			   <td colspan="3" align="right">
			 
			 	   <cf_tl id="Save" var = "1">
				   <input type="submit" 
			        value="#lt_text#" 
					onclick="save('#code#')"
					class="button10g">

				</td>
		    </tr>	
			
			</cfform>
																	
		<cfelse>
										
			<tr class="labelmedium2 line navigation_row">			
			   <td width="30">				   
				   <cf_img icon="open" onclick="typeedit('#code#');" navigation="Yes">						 
			   </td>
  			   <td width="30" style="padding-top:8px;padding-left:5px;">
  				   <cf_img icon="expand" toggle="Yes" onclick="show('#code#')">
			   </td>
			   <td height="17">&nbsp;#code#</td>
			   <td>#description#</td>
			   <td>#classes#</td>
			   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td>#OfficerFirstName# #OfficerLastName#</td>
			   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>			   			   			   
			   <td align="center" width="40" id="del_#code#">
				 <cfinclude template="RecordListingDelete.cfm">					  
			   </td>   			   		   
		   </tr>	
			 
		   <tr id="#code#" class="hide">
		       <td></td>
			   <td colspan="8">
		       <cfdiv id="#code#_list"/>			
			   </td>
		   </tr>
			 					
		</cfif>
					
	</cfloop>
	</cfoutput>													
				
</table>						

