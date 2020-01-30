
<cfquery name="List" 
datasource="#alias#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_TopicList
	WHERE Code = '#URL.Code#'	
	ORDER By ListOrder
</cfquery>

<cfquery name="Last" 
datasource="#alias#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Max(ListOrder)+1 as Last
    FROM  Ref_TopicList	
	WHERE Code = '#URL.Code#'	
</cfquery>

<cfif Last.last eq "">

  <cfset lst = "1">
  
<cfelse>

  <cfset lst = last.last>
    
</cfif>


<cfparam name="URL.ID2" default="new">
<cfform  method="POST"  name="listform" id="listform">

<table width="90%" class="navigation_table" align="center" border="0" style="padding-left:10px;padding-right:10px">
   
		<cfif list.recordcount eq "0">
		  <cfset url.id2 = "new">
		</cfif>  
		
		
		    <TR class="line labelmedium">
			   <td height="23" style="padding-left:3px" width="40">#.</td>
			   <td width="50">Code</td>
			   <td width="60%">Description</td>			  
			   <td width="50">Def.</td>
			   <td width="30" align="center">Active</td>
			   <td colspan="2" align="right">
		       <cfoutput>
				 <cfif URL.ID2 neq "new">
				     <A href="javascript:ColdFusion.navigate('#SESSION.root#/tools/topic/List.cfm?alias=#alias#&Code=#URL.Code#&ID2=new&systemmodule=#url.systemmodule#','#url.code#_list')">
					 <font face="calibri" size="2" color="0080FF">[Add]</font></a>
				 </cfif>
				 </cfoutput>&nbsp;
			   </td>		  
		    </TR>
							
				
		<cfoutput>

		<cfloop query="List">
					
			<cfset nm = ListCode>
			<cfset de = ListValue>
			<cfset ls = ListOrder>
			<cfset op = Operational>
			<cfset def = ListDefault>
																					
			<cfif URL.ID2 eq nm>		
											
			    <input type="hidden" name="ListCode" id="ListCode" value="<cfoutput>#nm#</cfoutput>">
													
				<TR class="labelmedium" style="height:10px">
					<td height="20" valign="top">
						
				   	<cfinput type="Text"
					       name="ListOrder"
					       value="#ls#"
						   class="regularh"
					       validate="integer"
					       required="Yes"
						   message="Please enter an order value" 
					       visible="Yes"
					       enabled="Yes"
					       typeahead="No"
					       size="1"
					       maxlength="2"
						   style="text-align:center">

				   </td>
				   <td valign="top">#nm#</td>
				   <td>
				   
				   <cfif systemmodule eq "Roster">		
						<cfset tablecode = "Ref_Topic">		
				   <cfelse>		
						<cfset tablecode = "topic#systemmodule#">
				   </cfif>				   
				   
						<cf_LanguageInput
							TableCode       = "#tablecode#List" 
							Mode            = "Edit"
							Name            = "ListValue"
							Id              = "ListValue"
							Type            = "Input"
							Value			= "#de#"
							Key1Value       = "#URL.Code#"
							Key2Value       = "#nm#"
							Required        = "Yes"
							Message         = "Please enter a topic description"
							MaxLength       = "50"						
							Size            = "50"
							Class           = "regularxl">
							
						
		           </td>
				  
				   <td><input type="checkbox" class="radiol" name="ListDefault" id="ListDefault" value="1" <cfif "1" eq def>checked</cfif>></td>
				   <td align="center">
				      <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
				   </td>
				   <td align="right">
				   
					<cfinput type="button" 
						value="Update" 
						name = "Update"
						class="button10s" 
						style="width:70" 
						onClick="updateList('#code#_list','#url.code#','#url.systemmodule#','#alias#','edit')">
						
				   </td>
					
			    </TR>	
						
															
			<cfelse>								
						
				<TR class="line labelmedium navigation_row" style="height:10px">
				   <td style="padding-left:3px">#ls#.</td>
				   <td style="padding-left:3px">#nm#</td>
				   <td>#de#</td>				   
				   <td><cfif def eq "1">Yes</cfif></td>	
				   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
				  
				   <td align="right" style="padding-top:2px">				  
				   <table>					 
					 <tr>					 
					 <td style="padding-top:2px">
				      <cf_img icon="edit" onclick="ColdFusion.navigate('#SESSION.root#/tools/topic/List.cfm?alias=#alias#&Code=#URL.Code#&ID2=#nm#&systemmodule=#url.systemmodule#','#url.code#_list')">						  					
				     </td>
							   			   
					   <cfquery name="Check" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    	SELECT *
						    FROM  ProgramAllotmentRequestTopic
							WHERE Topic = '#URL.Code#'	
							AND   ListCode = '#ListCode#'
					   </cfquery>
					   
					  <td align="left" style="padding-left:5px;padding-top:2px;padding-right:4px">
					     <cfif check.recordcount eq "0">
						     <cf_img icon="delete" onclick="ColdFusion.navigate('#SESSION.root#/tools/topic/ListPurge.cfm?alias=#alias#&Code=#URL.Code#&ID2=#nm#&systemmodule=#url.systemmodule#','#url.code#_list')">					 	      
						 </cfif>	   						  
					  </td>
					
					 </tr>
					
					</table>
					
				 </TR>	
				 				 						
			</cfif>
						
		</cfloop>
		
		</cfoutput>
								
		<cfif URL.ID2 eq "new">
		
			 <TR>
			
				<td height="25">
				
				   <cfinput type="Text" 
				      name="ListOrder" 
					  message="You must enter an order" 
					  required="Yes" 
					  size="1" 
					  style="text-align:center;width:30"
					  value="#lst#"
					  validate="integer"
					  class="regularh"
					  maxlength="2">
					  
				</td>
				
			<td height="28">
			
				    <cfinput type="Text" 
				         value="" 
						 name="ListCode" 
						 message="You must enter a code" 
						 required="Yes" 
						 size="2" 
						 maxlength="20" 
						 class="regularh">
	        </td>
						  						 
			
				
				  <td>
				   	<cfinput type="Text" 
				         name="ListValue" 
						 message="You must enter a name" 
						 required="Yes" 
						 size="60" 
						 maxlength="80" 
						 class="regularh">
				</td>		
				
			<td>
			     <cfinput type="checkbox" class="radiol" name="ListDefault" id="ListDefault" value="1">
			</td>		
			
			<td align="center">
				<cfinput type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td align="right">
			<cfoutput>

			<cfinput type="button" 
				value="Add" 
				name = "Add"
				class="button10s" 
				style="width:50" 
				onClick="updateList('#code#_list','#url.code#','#url.systemmodule#','#alias#','new')">
			
			</cfoutput>
			</td>			    
			</TR>	
								
		</cfif>								
</table>	

</cfform>

<cfset ajaxonload("doHighlight")>
						
