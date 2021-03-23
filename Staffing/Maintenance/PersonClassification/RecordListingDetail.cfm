		
<cfparam name="url.id2" default="">	

<cfparam name="form.operational" default="0">	
	
<cfquery name="Listing" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, (SELECT count(*) FROM Ref_PersonGroupList WHERE GroupCode = P.Code) as ListValues
    FROM  Ref_PersonGroup P	
	ORDER BY Code
</cfquery>

<cfquery name="ContextList" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Context
    FROM  Ref_PersonGroup
</cfquery>

<cfquery name="Action" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Action
	WHERE ActionSource IN ('Person')	
</cfquery>

<table width="95%" align="center" class="navigation_table">
			
    <tr class="labelmedium2 line fixrow">
	   <td width="20"></td>
	   <td width="10%">Code</td>
	   <td width="30%">Description</td>
	   <td width="10%">PA Action</td>
	   <td width="10%">Context</td>
	   <td width="5%">List</td>
	   <td width="60">Oper.</b></td>
	   <td width="20%">Officer</b></td>
	   <td width="80" align="right">Created</b></td>		
	   <td wisth="30"></td>			  	  
    </tr>	

	<cfif URL.ID2 eq "new">
	
		<TR><TD colspan="10" style="height:35px">	
		
		<cfform method="POST" name="mytopic" onsubmit="return false">
		
		<TABLE width="100%">		
		<tr class="line" height="20" bgcolor="f4f4f4">		
		<td></td>
		<td height="25">
		
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
					 maxlength="60" 
					 style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
					 class="regularxxl">
		</td>
		
		<td>
			<select name="ActionCode" class="regularxxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
			    <option value="">N/A</option>
				<cfoutput query="Action">
					<option value="#ActionCode#">#ActionCode# #Description#</option>
				</cfoutput>		
			</select>		
		</td>
				
		<td>
		
		 <select name="Context" class="regularxxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">							
					<cfoutput query="ContextList">
						<option value="#context#">#Context#</option>
					</cfoutput>		
		</select>		
		   
		</td>
		
		<td></td>
		
		<td>
		      <input type="Checkbox" name="Operational" class="radiol" value="1" checked>   
		</td>
										   
		<td colspan="2" align="center">
			<cfoutput>
				<input type="submit" 
					value="Save" 
					style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
					onclick="save('new')"
					class="button10g">
			</cfoutput>		
		</td>			    
		</tr>	
			
		</TABLE>		
		
		</cfform>
		</TD>
		</TR>				
												
	</cfif>						
		
	<cfoutput>
	
	<cfloop query="Listing">
																								
		<cfif URL.ID2 eq code>		
			<TR><TD colspan="10" style="height:35px">

			<cfform name="mytopic" onsubmit="return false">
			
				<TABLE width="100%">				
			  
			    <input type="hidden" name="Code" value="<cfoutput>#Code#</cfoutput>">
																	
				<tr height="20" class="line">
				
				   <td width="20"></td>
				   <td width="10%" height="30" class="labelit">#Code#</td>
				   <td>
				   	   <cfinput type = "Text" 
					   	value        = "#description#" 
						name         = "Description" 
						message      = "You must enter a description" 
						required     = "Yes" 
						size         = "30" 
						maxlength    = "60" 
						style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
						class        = "regularxxl">			  
		           </td>
							   
				   <td width="20%">
			
						<select name="ActionCode" class="regularxxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
							<option value="">N/A</option>
							<cfloop query="Action">
								<option value="#ActionCode#" <cfif listing.actioncode eq actioncode>selected</cfif>>#ActionCode# #Description#</option>
							</cfloop>		
						</select>		
						
					</td>
			
				   
				   <td width="20%" class="labelit">
				   
				   	   <select name="Context" class="regularxxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">							
							<cfloop query="ContextList">
								<option value="#context#" <cfif listing.context eq context>selected</cfif>>#Context#</option>
							</cfloop>		
						</select>		
				   
				    
				   
				   </td>
				   
				   <td width="10%" class="labelit">#ListValues#</td>
				   
				    <td width="5%">
				 
					     <input type="Checkbox"
					       name="Operational" class="radiol"
					       value="1"
						   <cfif operational eq "1">checked</cfif>>
						   
				   </td>
						
				   <td colspan="2" align="center" width="60">
				   
				   <input type="submit" 
				        value="Save" 
						style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
						onclick="save('#code#')"
						class="button10g">
	
					</td>
			    </tr>	
							
				
				</TABLE>
			</cfform>
			</TD></TR>
			
			<tr><td colspan="1"></td><td colspan="8" id= "#code#_list">
		   			
				<cfset url.code = code>
				<cfinclude template="List.cfm">
					
			</td></tr>		
			
			<tr class="line"><td></td>			   
				<td colspan="8" align="center" class="labelmedium2" style="font-weight:bold;font-size:18px">Control access</td></tr>
			
			<tr><td colspan="1"></td><td style="padding-left:0px" colspan="8" id="#code#_owner">
		   		
				<cfset url.code = code>
				<cfinclude template="Owner.cfm">
					
			</td></tr>		
			
			<tr style="height:10px;"><td colspan="10"></td></tr>
			
			<tr><td colspan="1"></td>
			    <td style="padding-left:0px" colspan="8" id = "#code#_role">
						
				<cfset url.code = code>
				<cfinclude template="Role.cfm">
					
			</td></tr>			
																				
		<cfelse>
										
			<tr height="20" class="labelmedium2 navigation_row line">			
			  			   
			   <td align="center" style="padding-top:1px;">
				 <cf_img icon="open" navigation="Yes" onclick="ColdFusion.navigate('RecordListingDetail.cfm?ID2=#code#','listing')">
			  </td>
			   
			   <td height="17" style="padding-left:4px">#code#</td>
			   <td>#description#</td>
			   <td>#ActionCode#</td>
			   <td>#context#</td>
			   <td>#listvalues#</td>
			   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   
			   <td>#OfficerFirstName# #OfficerLastName#</td>
			   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
			   
			     <cfquery name="Check" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT TOP 1 GroupCode
					    FROM   PersonGroup
						WHERE  GroupCode = '#Code#'	
						
						UNION
						
					    SELECT TOP 1 GroupCode
					    FROM   PersonAssignmentTopic
						WHERE  GroupCode = '#Code#'																
				   </cfquery>
				   
				 <td align="center" style="padding-left:4px;padding-top:3px">
				 
				  <cfif check.recordcount eq "0" and code neq "AssignEnd">
					  <cf_img icon="delete" onclick="ptoken.navigate('RecordListingPurge.cfm?Code=#code#','listing');">
				  </cfif>	   
					  
				</td>   
			   		   
		   </tr>		 	 			 
			 					
		</cfif>
					
	</cfloop>
		
	</cfoutput>													
				
</table>				

<cfset AjaxOnLoad("doHighlight")>			

