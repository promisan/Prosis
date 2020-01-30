
<cfquery name="List" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_PersonGroupList
	WHERE    GroupCode = '#URL.Code#'	
	ORDER BY GroupListOrder
</cfquery>

<cfquery name="Last" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT MAX(GroupListOrder)+1 as Last
    FROM   Ref_PersonGroupList	
	WHERE  GroupCode = '#URL.Code#'	
</cfquery>

<cfparam name="URL.ID2" default="new">
	
<table width="100%" cellspacing="0" cellpadding="0">
							
	    <TR height="18" class="line labelmedium">
		   <td width="80" class="label"><cf_space spaces="50">List value</b></td>
		   <td width="70%" class="label">Description</td>
		   <td width="50" align="center" class="label">S.</td>
		   <td width="30" align="center" class="label">A.</td>
		   <td colspan="2" align="right" class="labelit">
	       <cfoutput>
			 <cfif URL.ID2 neq "new">
			     <A href="javascript:ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=new','#url.code#_list')">
				 <font color="0080FF">&nbsp;Add&nbsp;Value</font></a>
			 </cfif>
			 </cfoutput>
		   </td>		  
	    </TR>
		
		<TR>
		<TD colspan="6">
		
		<cfoutput>
		
		<cfloop query="List">
					
			<cfset nm = GroupListCode>
			<cfset de = Description>
			<cfset ls = GroupListOrder>
			<cfset op = Operational>		
																				
			<cfif URL.ID2 eq nm>					
				<cfform	name="formlist#URL.Code#_#url.id2#" onsubmit="return false">
				<TABLE width="100%">				
				<TR class="line">
				   <td height="20" width="80">#nm#
				   </td>
				   <td width="80%">
				       <cfinput type="text" name="GroupListCode" id="GroupListCode" value="#nm#">				   
				   	   <cfinput type="Text" 
					   	value="#de#" 
						name="Description" 
						id="GroupListDescription"
						message="You must enter a description" 
						required="Yes" 
						size="80" 
						maxlength="60" 
						class="regular">
				  
		           </td>
				   <td height="22" align="center" width="50">
				   	<cfinput type="Text"
					       name="GroupListOrder"
					       id="GroupListOrder"
					       value="#ls#"
					       validate="integer"
					       required="Yes"
						   class="regular"
						   message="Please enter an order value" 
					       visible="Yes"
					       enabled="Yes"
					       typeahead="No"
					       size="1"
					       maxlength="2"
						   style="text-align:center">
				   			   
				     </td>
				  
				   <td align="center" width="30">
				      <input type="checkbox" name="Operational" id="Operational"  value="1" <cfif "1" eq op>checked</cfif>>
					</td>
				   <td colspan="2" align="center" width="2">
				   	
				   <input type="button" 
				        value="Save" 
				        id="formlist#URL.Code#_#url.id2#_111"
						onclick="ColdFusion.navigate('ListSubmit.cfm?Code=#URL.Code#&id2=#url.id2#&lc='+$('##GroupListCode').val()+'&de='+$('##GroupListDescription').val()+'&lo='+$('##GroupListOrder').val(),'#url.code#_list')" 
						class="button10s" 
						style="width:40;height:17"></td>
			    </TR>	
				</TABLE>
				</cfform>
															
			<cfelse>							
						
				<TR class="line labelmedium">
				   <td height="15" width="100">#nm#</td>
				   <td>#de#</td>
				   <td align="center">#ls#</td>
				   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
				   <td align="center" width="25">
					   <cf_img icon="edit" onclick="ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=#nm#','#url.code#_list');">
				   </td>
			   			   
				   <cfquery name="Check" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT TOP 1 GroupCode
					    FROM  PersonGroup
						WHERE GroupCode = '#GroupCode#'	
						AND   GroupListCode = '#GroupListCode#'				    	
				        UNION
					    SELECT TOP 1 GroupCode
					    FROM  PersonAssignmentTopic
						WHERE GroupCode = '#GroupCode#'	
						AND   GroupListCode = '#GroupListCode#'				    	
				   </cfquery>
				   
				   <td align="center" width="25">
				   
				     <cfif check.recordcount eq "0" or groupcode eq "AssignEnd">
						   <cf_img icon="delete" onclick="ColdFusion.navigate('ListPurge.cfm?Code=#URL.Code#&ID2=#nm#','#url.code#_list')">
					 </cfif>	   
					  
				    </td>
					
				 </TR>	
														
			</cfif>
						
		</cfloop>
		</cfoutput>
		</TD>
		</TR>						

		<TR>
		<TD colspan="6">
		
													
		<cfif URL.ID2 eq "new" or List.recordcount eq "0">

			<cfform name="formnew">
			<TABLE width="100%">					
			<TR>
				<td height="28" width="80">&nbsp;
				    <cfinput type="Text" 
				         value="" 
						 name="GroupListCode" 
						 message="You must enter a code" 
						 required="Yes" 
						 size="2" 
						 maxlength="20" 
						 class="regular">
		        </td>
			    <td width="80%">
				   	<cfinput type="Text" 
				         name="Description" 
						 message="You must enter a name" 
						 required="Yes" 
						 size="60" 
						 maxlength="80" 
						 class="regular">
				</td>								 
				<td width="50">
				   <cfinput type="Text" 
				      name="GroupListOrder" 
					  id="GroupListOrder" 
					  message="You must enter an order" 
					  required="Yes" 
					  size="1" 
					  style="text-align:center"
					  value="#last.Last#"
					  class="regular"
					  validate="integer"
					  maxlength="2">
				</td>
			
				<td align="center" width="30">
					<input type="checkbox" name="Operational" id="Operational" value="1" checked>
				</td>
								   
				<td colspan="2" align="right">
				<cfoutput>

					<input type="button" 
						value="Save" 
						class="button10s" 
						onclick="ColdFusion.navigate('ListSubmit.cfm?Code=#URL.Code#&id2=new','#url.code#_list','','','POST','formnew')" 
						style="width:45;height:17">
				
				</cfoutput>
				</td>			    
				</TR>	
			</TABLE>																
			</cfform>
		</cfif>		

		</TD>
		</TR>						
				
		<tr style="height:10px;"><td colspan="6"></td></tr>				
		
</table>		
						

