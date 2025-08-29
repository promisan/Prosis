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
<cfquery name="List" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  ItemMasterList
	WHERE ItemMaster = '#URL.Code#'	
	ORDER By ListOrder
</cfquery>

<cfquery name="Last" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Max(ListOrder)+1 as Last
    FROM  ItemMasterList	
	WHERE ItemMaster = '#URL.Code#'	
</cfquery>

<cfif Last.last eq "">

  <cfset lst = "1">
  
<cfelse>

  <cfset lst = last.last>
    
</cfif>

<cfparam name="url.id2" default="---">
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="C0C0C0" rules="rows">
				
		<cfif list.recordcount eq "0">
		  <cfset url.id2 = "">
		</cfif>  
		
		<tr><td height="3"></td></tr>
						
		    <TR>
			   <td></td>
			   <td width="50">Code</td>
			   <td width="60%">Name</td>
			   <td width="50">Sort</td>
			   <td width="50">Price</td>	
			   <td align="center">D</td>		   
			   <td align="center">O</td>
			   <td></td>
			    <td></td>  
		    </TR>		
			
			<tr><td colspan="9" class="line" height="1"></td></tr>					
				
		<cfoutput>
		
		<cfloop query="List">
					
			<cfset nm = TopicValueCode>
			<cfset de = TopicValue>
			<cfset ls = ListOrder>
			<cfset am = ListAmount>
			<cfset op = Operational>
			<cfset def = ListDefault>
																		
			<cfif URL.ID2 eq nm>		
														
			    <input type="hidden" name="topicvaluecode" id="topicvaluecode" value="<cfoutput>#nm#</cfoutput>">
													
				<TR onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
				   <td align="center"></td>
				   <td>#nm#</td>
				   <td>
				   	   <input type="Text" 
					   	value="#de#" 
						name="topicvalue" 
                        id="topicvalue"
						message="You must enter a description" 
						required="Yes" 
						style="width:95%" 
						maxlength="60" 
						class="regular">
				  
		           </td>
				   <td height="22">
				   	<input type="Text"
					       name="listordering"
					       value="#ls#"
						   class="regular"
					       validate="integer"
					       required="Yes"
						   message="Please enter an order value" 
					       visible="Yes"
					       enabled="Yes"					      
						   style="width:40" 
					       size="1"
					       maxlength="2"
						   style="text-align:center">
				   			   
				     </td>
					 <td>
					 	<input type="Text"
					       name="listamount"
					       value="#numberformat(am,'_,__')#"
						   class="regular"					      
						   style="width:98%" 
					       size="3"
					       maxlength="6"
						   style="text-align:center">
					 
					 </td>
				   <td>
				      <input type="checkbox" name="listdefault" id="listdefault" value="1" <cfif "1" eq def>checked</cfif>>
					</td>
				   <td align="center">
				      <input type="checkbox" name="operational" id="operational" value="1" <cfif "1" eq op>checked</cfif>>
					</td>
				   <td colspan="2" align="right">
				   <input type="button" 
				        value="Save" 
						onclick="ptoken.navigate('ListSubmit.cfm?code=#url.code#&id2='+topicvaluecode.value+'&topicvalue='+topicvalue.value+'&listorder='+listordering.value+'&listamount='+listamount.value+'&listdefault='+listdefault.checked+'&operational='+operational.checked,'list')"					
						class="button10s" 
						style="width:50">&nbsp;</td>
			    </TR>					
															
			<cfelse>
											
				<TR onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
				   <td width="20" align="center">#currentrow#.</td>
				   <td height="15">#nm#</td>
				   <td>#de#</td>
				   <td>#ls#</td>
				   <td align="right">#numberformat(am,'_.__')#</td>
				   <td align="center"><cfif def eq "1">*</cfif></td>	
				   <td align="center"><cfif op eq "0"><font color="FF0000">-</font><cfelse>*</cfif></td>
				   <td align="right" style="padding-top:3px;">
				   	  <cf_img icon="edit" onclick="ptoken.navigate('List.cfm?Code=#URL.Code#&ID2=#nm#','list');">
				   </td>
			   			   
				   <cfquery name="Check" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT *
					    FROM  ProgramAllotmentRequest
						WHERE ItemMaster = '#URL.Code#'	
						AND   TopicValueCode = '#TopicValueCode#'
				   </cfquery>
				   
				   <td align="center" width="20" style="padding-top:3px;">
				     <cfif check.recordcount eq "0">
						   <cf_img icon="delete" onclick="ptoken.navigate('ListPurge.cfm?Code=#URL.Code#&ID2=#nm#','list');">
					 </cfif>	   
					  
				    </td>
					
				 </TR>	
				 
										
			</cfif>
						
		</cfloop>
																
		<cfif URL.ID2 eq "">
					
			<TR onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
			
			<td></td>
			<td height="28">
			
				<cf_space spaces="9">
			
			    <input type="Text" 
			         value="" 
					 name="topicvaluecode" 
                     id="topicvaluecode"
					 message="You must enter a code" 
					 required="Yes" 
					 size="3" 
					 style="width:95%" 
					 maxlength="10" 
					 class="regular">
										 
	        </td>
						   
			    <td>
				   	<input type="Text" 
				         name="topicvalue" 
                         id="topicvalue"
						 message="You must enter a name" 
						 required="Yes" 
						 size="40" 
						 style="width:98%" 
						 maxlength="80" 
						 class="regular">
				</td>								 
				<td>
				   <input type = "Text" 
				      name     = "listordering" 					
					  size     = "1" 
					  style    = "text-align:center"
					  value    = "#lst#"
					  style    = "width:40" 
					  validate = "integer"
					  class    = "regular"
					  maxlength= "2">
				</td>
				
				 <td>
					 	<input type="Text"
					       name="listamount"
					       value="0.00"
						   class="regular"					      
						   style="width:98%" 
					       size="4"
					       maxlength="6"
						   style="text-align:center">
					 
					 </td>
				
			<td>
			     <input type="checkbox" name="listdefault" id="listdefault" value="1">
			</td>		
			
			<td align="center">
				<input type="checkbox" name="operational" id="operational" value="1" checked>
			</td>
								   
			<td colspan="2" align="right">
									
				<input type="submit" 
					value="Add" 
					class="button10s" 
					onclick="ptoken.navigate('ListSubmit.cfm?code=#url.code#&topicvaluecode='+topicvaluecode.value+'&topicvalue='+topicvalue.value+'&listorder='+listordering.value+'&listamount='+listamount.value+'&listdefault='+listdefault.checked+'&operational='+operational.checked,'list')"
					style="width:40">
					
			</td>			    
			</TR>	
														
		</cfif>								
		
		</cfoutput>
</table>		
						

