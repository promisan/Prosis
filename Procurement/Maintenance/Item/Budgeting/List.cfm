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
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
				
		<cfif list.recordcount eq "0">
		  <cfset url.id2 = "">
		</cfif>  
		
		<tr><td height="3"></td></tr>
						
		    <TR class="labelit line">
			   <td></td>
			   <td width="50"><cf_tl id="Code"></td>
			   <td width="55%"><cf_tl id="Name"></td>
			   <td width="50"><cf_tl id="Sort"></td>
			   <td align="right"><cf_tl id="Std Cost"></td>	
			   <td align="center"><cf_tl id="Def"></td>		   
			   <td align="center">O</td>
			   <td width="24"></td>
			   <td width="24"></td>  
		    </TR>		
						
				
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
													
				<TR class="navigation_row line">
				
				   <td align="center"></td>
				   <td class="labelmedium" style="padding-left:3px;padding-right:5px">#nm#</td>
				   <td>
				   	   <cf_tl id="You must enter a description" var="vDescriptionMessage" class="message">
					   
				   	   <input type="Text" 
					   	value="#de#" 
						name="topicvalue" 
                        id="topicvalue"
						message="#vDescriptionMessage#" 
						required="Yes" 
						style="width:95%" 
						maxlength="60" 
						class="regularxl">
				  
		           </td>
				   <td height="22">
				    <cf_tl id="Please enter an order value" var="vOrderMessage" class="message">
				   	<input type="Text"
					       name="listordering"
						   id="listordering"
					       value="#ls#"
						   class="regularxl"
					       validate="integer"
					       required="Yes"
						   message="#vOrderMessage#" 
					       visible="Yes"
					       enabled="Yes"					      						  
					       size="1"
					       maxlength="2"
						   style="width:30;text-align:center">
				   			   
				     </td>
					 <td align="right">
					 	<input type="Text"
						       name="listamount"
							   id="listamount"
						       value="#numberformat(am,'_,__')#"
							   class="regularxl"					      
							   style="width:60;text-align:right" 
						       maxlength="6">
					 
					 </td>
				   <td align="center">
				      <input type="checkbox" class="radiol" name="listdefault" id="listdefault" value="1" <cfif "1" eq def>checked</cfif>>
					</td>
				   <td align="center">
				      <input type="checkbox"  class="radiol" name="operational" id="operational" value="1" <cfif "1" eq op>checked</cfif>>
					</td>
				   <td colspan="2" align="right" style="padding-right:4px">
				   <cf_tl id="Save" var="vSave">
				   
				   <input type="button" 
				        value="#vSave#" 
						onclick="_cf_loadingtexthtml='';ptoken.navigate('Budgeting/ListSubmit.cfm?code=#url.code#&id2='+document.getElementById('topicvaluecode').value+'&topicvalue='+document.getElementById('topicvalue').value+'&listorder='+document.getElementById('listordering').value+'&listamount='+document.getElementById('listamount').value+'&listdefault='+document.getElementById('listdefault').checked+'&operational='+document.getElementById('operational').checked,'list')"					
						class="button10s" 
						style="width:40;height:25">
						
					</td>
			    </TR>					
															
			<cfelse>
											
				<TR class="navigation_row line labelmedium" style="height:20px">
				
				   <td style="padding-left:5px;padding-right:6px" width="20" align="center">#currentrow#.</td>
				   <td height="15">#nm#</td>
				   <td>#de#</td>
				   <td>#ls#</td>
				   <td align="right">#numberformat(am,'_.__')#</td>
				   <td align="center"><cfif def eq "1">*</cfif></td>	
				   <td align="center">
				   		<cfif op eq "0">
							<font color="FF0000">
								<cf_tl id="N">
							</font>
						<cfelse>
							<cf_tl id="Y">
						</cfif>
				   </td>
					
				   <td align="right" style="padding-top:3px">				   
				   	  <cf_img icon="edit" navigation="Yes" onclick="_cf_loadingtexthtml='';ptoken.navigate('Budgeting/List.cfm?Code=#URL.Code#&ID2=#nm#','list');">					  
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
				   
				   <td align="right" style="padding-top:3px;padding-right:4px">
				     <cfif check.recordcount eq "0">
						   <cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('Budgeting/ListPurge.cfm?Code=#URL.Code#&ID2=#nm#','list');">
					 </cfif>							  
				   </td>
					
				 </tr>	
				 
										
			</cfif>
						
		</cfloop>
																
		<cfif URL.ID2 eq "">
					
			<TR class="navigation_row line">
			
				<td style="height:29px"></td>
	
				<td style="padding-left:3px">
				<cf_tl id="You must enter a code" var="vCodeMessage" class="message">
			    <input type="Text" 
			         value="" 
					 name="topicvaluecode" 
                     id="topicvaluecode"
					 message="#vCodeMessage#" 
					 required="Yes" 
					 size="3" 
					 style="width:80" 
					 maxlength="10" 
					 class="regularxl">					 
					 										 
	    	    </td>
						   
			    <td>
					<cf_tl id="You must enter a name" var="vNameMessage" class="message">
					
				   	<input type="Text" 
				         name="topicvalue" 
                         id="topicvalue"
						 message="#vNameMessage#" 
						 required="Yes" 
						 size="40" 
						 style="width:98%" 
						 maxlength="80" 
						 class="regularxl">
						 
				</td>	
											 
				<td>
				
				   <input type = "Text" 
				      name     = "listordering" 	
					  id       = "listordering"				
					  size     = "1" 
					  style    = "width:30;text-align:center"
					  value    = "#lst#"					
					  validate = "integer"
					  class    = "regularxl"
					  maxlength= "2">
					  
				</td>
				
				<td>
					 	<input type="Text"
					       name  = "listamount"
						   id    = "listamount"
					       value = "0.00"
						   class = "regularxl"					      
						   style = "width:98%;text-align:right" 
					       size  = "4"
					       maxlength="6">
					 
				</td>
				
				<td align="center">
				  <input type="checkbox"  class="radiol" name="listdefault" id="listdefault" value="1">
				</td>		
			
				<td align="center">
					<input type="checkbox"  class="radiol" name="operational" id="operational" value="1" checked>
				</td>
								   
				<td colspan="2" align="right" style="padding-right:2px">
										
					<input type="submit" 
						value="Add" 
						class="button10g" 
						onclick="_cf_loadingtexthtml='';ptoken.navigate('Budgeting/ListSubmit.cfm?code=#url.code#&topicvaluecode='+document.getElementById('topicvaluecode').value+'&topicvalue='+document.getElementById('topicvalue').value+'&listorder='+document.getElementById('listordering').value+'&listamount='+document.getElementById('listamount').value+'&listdefault='+document.getElementById('listdefault').checked+'&operational='+document.getElementById('operational').checked,'list')"
						style="height:25px;width:40">
						
				</td>	
						    
			</TR>	
														
		</cfif>								
		
		</cfoutput>
</table>		
						
<cfset AjaxOnLoad("doHighlight")>	
