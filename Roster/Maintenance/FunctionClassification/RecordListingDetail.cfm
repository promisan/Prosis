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
<cfparam name="url.code" default="">	

<cfparam name="form.operational" default="0">	
	
<cfquery name="Listing" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_FunctionClassificationParent
	ORDER BY ListingOrder
</cfquery>

<table width="95%" align="center" cellspacing="0" class="navigation_table">
			
    <tr class="labelmedium2 line">
	   <td width="20"></td>
   	   <td width="20"></td>
	   <td width="10%">Code</td>
	   <td width="50%">Description</td>
	   <td width="10">O</td>
	   <td width="20%">Officer</td>
	   <td width="80" align="right">Created</b></td>		
	   <td width="30"></td>			  	  
    </tr>	
			
	<cfif URL.code eq "new">

		<tr>
			<td colspan="8">
			
				<cfform method="POST" name="mytopic" onsubmit="return false">
				
					<table width="100%" align="center">
					
						<tr style="background-color:#f4f4f4;">
							<td></td>
							<td height="25">&nbsp;
							
								    <cfinput type="Text" 
								         value="" 
										 name="Code" 
										 id="Code"
										 message="You must enter a code" 
										 required="Yes" 
										 size="2" 
										 maxlength="20" 
										 class="regularxl">
					        </td>	
												   
							<td>
								   	<cfinput type="Text" 
								         name="Description" 
										 id ="Description"
										 message="You must enter a name" 
										 required="Yes" 
										 size="50" 						 
										 maxlength="50" 
										 class="regularxl">
							</td>
							
							<td>		
							      <input type="Checkbox" name="Operational" id="Operational" value="1" checked>
							</td>
															   
							<td colspan="3" align="right">
								<input type="submit"  value="Save" 	onclick="save('new')" class="button10g">
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
		
			<tr>
			
				<td colspan="8">
				
					<cfform name="mytopic" onsubmit="return false">
				
					<table height="100%" width="100%" align="center">
					
						  <input type="hidden" name="Code" value="<cfoutput>#Code#</cfoutput>">
			
							<tr class="line labelmedium2" style="background-color:##f4f4f4;">					
							
							   <td></td>
							   <td height="30">&nbsp;#Code#</td>
							   <td>
							   	   <cfinput type = "Text" 
								   	value        = "#description#" 
									name         = "Description" 
									message      = "You must enter a description" 
									required     = "Yes" 
									size         = "50" 
									maxlength    = "60" 
									style        = "border:0px;border-left:1px solid silver;border-right:1px solid silver;padding-top:1px"
									class        = "regularxxl">			  
					           </td>
							   <td>   <input type="Checkbox" class="radiol" name="Operational" value="1"  <cfif operational eq "1">checked</cfif>> </td>
									
							   <td colspan="3" align="right"> <input type="submit"  value="Save" onclick="save('#code#')" class="button10g"> </td>
							   
						    </tr>	
					
					</table>
					
					</cfform>
					
				</td>
			</tr>
			
										
		<cfelse>
										
			<tr class="labelmedium2 line navigation_row">			
			   <td style="padding-top:1px"><cf_img icon="open" onclick="ptoken.navigate('RecordListingDetail.cfm?code=#code#','listing');" navigation="Yes"></td>			  
			   <td style="padding-top:7px" align="left"><cf_img icon="expand" toggle="yes" onclick="show('#code#')"> </td>			    
			   <td height="17">&nbsp;#code#</td>
			   <td>#description#</td>			  
			   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td colspan="1">#OfficerFirstName# #OfficerLastName#</td>
			   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>			   			   
			   <td align="center" width="20" id="del_#code#">
				 <cfinclude template="RecordListingDelete.cfm">					  
			   </td>   			   		   
		   </tr>	
			 
		   <tr id="#code#" class="hide"><td></td><td colspan="6">
		       <cfdiv id="#code#_list"/>			
			</td></tr>			 
			 					
		</cfif>
					
	</cfloop>
	</cfoutput>													
				
</table>						
