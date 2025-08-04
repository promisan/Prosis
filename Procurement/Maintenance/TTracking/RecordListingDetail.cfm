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

<cfinvoke component="Service.Presentation.Presentation"
       method="highlight"
    returnvariable="stylescroll"/>
		
<cfparam name="url.id2" default="">	

<cfparam name="form.operational" default="0">	
	
<cfquery name="Listing" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Transport
	ORDER BY Created DESC
</cfquery>

<table width="94%" align="center" class="formpadding">
			
    <TR height="18" class="line labelmedium2 fixrow">
	   <td style="width:30px"></td>
	   <td width="4%">Code</td>
	   <td width="50%">Description</td>
	   <td width="40">Enabled</td>
	   <td width="40">Tracking</td>
	   <td width="80" align="right">Created</b></td>		
	   <td width="30"></td>			  	  
    </TR>	
		
	<cfif URL.ID2 eq "new">
	
	<tr>
	<td colspan="7">
	
	<cfform method="POST" name="mytopic" onsubmit="return false">			
	
	<table width="100%">
	
		<TR bgcolor="f4f4f4">
		
		<td></td>
		<td height="25">&nbsp;
		
			    <cfinput type="Text" 
			         value="" 
					 name="Code" 
					 message="You must enter a code" 
					 required="Yes" 
					 size="2" 
					 maxlength="20" 
					 style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
					 class="regularxxl">
        </td>	
							   
		<td>
		
			   	<cfinput type="Text" 
			         name="Description" 
					 message="You must enter a name" 
					 required="Yes" 
					 size="50" 						 
					 maxlength="50" 
					 style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
					 class="regularxxl">
		</td>
						
		<td>		
		      <input type="Checkbox" name="Operational" id="Operational" class="radiol" value="1" checked>
		</td>
		
		<td>		
		      <input type="Checkbox" name="Tracking" class="radiol" id="Tracking" value="1" checked>
		</td>
										   
		<td colspan="2" align="right">
		<cfoutput>
			<input type="submit" 
				value="Save" 
				onclick="save('new')"
				class="button10g">
		</cfoutput>
		</table>
		</td>			    
		</TR>	
		
	</table>			
	</cfform>	
	</td>
	</tr>
	</cfif>				
		
	<cfoutput>
	
	<cfloop query="Listing">
																							
		<cfif URL.ID2 eq code>		
		
			<tr>
			<td colspan="7">
			<cfform method="POST" name="mytopic" onsubmit="return false">							
			<table width="100%">
		    <input type="hidden" name="Code" id="Code" value="<cfoutput>#Code#</cfoutput>">
																
			<TR bgcolor="ffffcf" class="labelmedium2 line">			
			   <td></td>
			   <td height="30">#Code#</td>
			   <td>
			   	   <cfinput type = "Text" 
				   	value        = "#description#" 
					name         = "Description" 
					message      = "You must enter a description" 
					required     = "Yes" 
					size         = "50" 
					maxlength    = "60" 
					style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
					class        = "regularxxl">			  
	           </td>
			   			   			   
			   <td>			 
			     <input type="Checkbox" name="Operational" id="Operational" class="radiol" value="1" <cfif operational eq "1">checked</cfif>>					   
			   </td>			   
			   <td>			 
				 <input type="Checkbox" name="Tracking" id="Tracking" class="radiol" value="1" <cfif Tracking eq "1">checked</cfif>>					   
			   </td>					
			   <td colspan="2" align="right">			   
			   <input type="submit" value="Save" onclick="save('#code#')" class="button10g">
				</td>
				
		    </TR>											
			</table>
			
			</cfform>
			</td>
			</tr>
																	
		<cfelse>
										
			<TR class="labelmedium2">
			  			   
			   <td align="center" style="padding-top:1px;">				  
				 <cf_img icon="open" onclick="ptoken.navigate('RecordListingDetail.cfm?ID2=#code#','listing')">
			  </td>
			   
			   <td height="17">#code#</td>
			   <td>#description#</td>
			  
			   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td><cfif tracking eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   
			   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
			   
			     <cfquery name="Check" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT TOP 1 *
					    FROM  Purchase
						WHERE TransportCode = '#Code#'						
				   </cfquery>
				   
				<td align="center" width="20" style="padding-top:3px;">
				  <cfif check.recordcount eq "0">
				      <cf_img icon="delete" onclick="ptoken.navigate('RecordListingPurge.cfm?Code=#code#);">
				  </cfif>	   
					  
				</td>   
			   		   
		   </tr>	
		   
		   <cfif tracking eq "1">
			 
			   	<tr>
			   	<td></td><td></td><td colspan="4">
			       <cfdiv id="#code#_list">				
					   <cfset url.code = code>
					   <cfinclude template="List.cfm">					   
				   </cfdiv>	
				</td>
				</tr>
			
			</cfif>
				 
		   <tr><td height="1" colspan="7" class="line"></td></tr>			 			 
			 					
		</cfif>
					
	</cfloop>
	
	</cfoutput>													
				
</table>						



