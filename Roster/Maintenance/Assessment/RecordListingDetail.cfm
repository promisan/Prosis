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
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_AssessmentCategory	
</cfquery>

<table width="100%" class="navigation_table">
	
    <tr class="labelmedium2 line fixrow">
	   <td style="width:30px"></td>
	   <td style="width:30px">Class</td>
	   <td width="50%">Skill Area</td>
	   <td width="10">Oper.</b></td>
	   <td width="20%">Officer</b></td>
	   <td width="80" align="right">Created</b></td>		
	   <td width="30"></td>			  	  
    </tr>	
			
	<cfif URL.code eq "new">
	
		<tr class="line">
		
			<td colspan="7">
			
			<cfform method="POST" name="mytopic" onsubmit="return false">
			
				<table width="100%" align="center">
				
					<tr class="labelmedium2" style="background-color:#f4f4f4;">		
					<td></td>
					<td height="25" style="padding-left:4px">
					    <cfinput type="Text" 
					         value="" 
							 name="Code" 
							 message="You must enter a code" 
							 required="Yes" 
							 size="2" 
							 maxlength="20" 
							 class="regularxxl">
			        </td>	
										   
					<td>
					   	<cfinput type="Text" 
					         name="Description" 
							 message="You must enter a name" 
							 required="Yes" 
							 size="50" 						 
							 maxlength="50" 
							 class="regularxxl">
					</td>
					
					<td><input type="Checkbox" class="radiol" name="Operational" value="1" checked> </td>													   
					<td colspan="2" align="right"><input type="submit" value="Save" onclick="save('new')" class="button10g"></td>
					
					</tr>
				</table>
			
			</cfform>
				
			</td>
		</tr>
												
	</cfif>						
		
	<cfoutput>

	
	<cfloop query="Listing">
	
		<cfif URL.code eq Listing.code>		
			
			<tr class="line">
				<td colspan="7">
				
					<cfform name="mytopic" onsubmit="return false">
				
					<table align="center" width="100%">
						
						<input type="hidden" name="Code" value="<cfoutput>#Code#</cfoutput>">
																
						<tr style="background-color:##f4f4f4;">
						
						   <td></td>
						   <td height="30" style="padding-left:4px">#Code#</td>
						   <td>
						   	   <cfinput type = "Text" 
							   	value        = "#description#" 
								name         = "Description" 
								message      = "You must enter a description" 
								required     = "Yes" 
								size         = "50" 
								maxlength    = "60" 
								class        = "regularxxl">			  
				           </td>
						   
						   <td> <input type="Checkbox" class="radiol" name="Operational"  value="1"  <cfif operational eq "1">checked</cfif>> </td>
								
						   <td colspan="2" align="right">  <input type="submit" value="Save" onclick="save('#code#')" class="button10g"> </td>
					    </tr>	
							
					</table>
					
					</cfform>
				</td>
			</tr>
																	
		<cfelse>
										
			<tr class="labelmedium2 navigation_row line">			  			   
			   <td align="center">
				  <cf_img icon="open" onclick="ptoken.navigate('RecordListingDetail.cfm?code=#code#','listing')" navigation="Yes">
			  </td>			   
			   <td>#code#</td>
			   <td>#description#</td>			  
			   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td colspan="1">#OfficerFirstName# #OfficerLastName#</td>
			   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>			   			   				   
			   <td align="center" width="20" id="del_#code#"><cfinclude template="RecordListingDelete.cfm"></td>   
			   		   
		   </tr>	
			 
		   <tr><td></td>		        
				<td colspan="5" style="padding:5px;background-color:f1f1f1">
		       <cf_securediv id="#code#_list" bind="url:List.cfm?midprovision=999999999&code=#code#"/>			
			</td></tr>
			 					
		</cfif>
					
	</cfloop>
	</cfoutput>													
				
</table>						

