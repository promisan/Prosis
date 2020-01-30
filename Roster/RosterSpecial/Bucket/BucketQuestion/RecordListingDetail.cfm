<!--- Create Criteria string for query from data entered thru search form --->
		
<cfparam name="url.topicid" default="">	
<cfparam name="form.operational" default="0">	

<cfquery name="ParentList" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM Ref_ExperienceParent	 
</cfquery>	
	
<cfquery name="Listing" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM FunctionOrganizationTopic
	 WHERE FunctionId = '#URL.IDFunction#'
	 ORDER BY TopicOrder, Parent
</cfquery>	

<table width="100%"><tr><td width="100%">

<cfform method="POST" name="mytopic" onsubmit="return false">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
				
	    <TR class="labelmedium linedotted" height="18">
		   <td width="1%" style="padding-right:4px"></td>		   
		   <td width="10%">Parent</td>
		   <td width="30%">Question</td>
		   <td width="50">Order</td>
		   <td width="10">Oper.</td>
		   <td width="15%">Officer</td>
		   <td width="80" align="right">Created</td>		
		   <cfoutput>
		   	<td width="30" style="padding-left:4px">
			<a href="javascript:ColdFusion.navigate('../Bucket/BucketQuestion/RecordListingDetail.cfm?idfunction=#url.idfunction#&topicid=new','listing')">
			<font color="0080FF">[add]</font>
			</a>
			</td>			  	  
		   </cfoutput>
	    </TR>	
		
		<tr><td height="1" colspan="8" class="linedotted"></td></tr>
				
		<cfif URL.topicid eq "new">
						
			<TR class="linedotted" style="height:30px">
			
			<td></td>
									
			<td height="25">
			
				<select name="Parent" class="regularxl">
					<cfoutput query="ParentList">
						<option value="#Parent#">#Description#</option>
					</cfoutput>		
				</select>		
				
	        </td>	
								   
			<td style="padding-left:1px">		
				   	<cfinput type="Text" 
				         name="TopicPhrase" 
						 message="You must enter a name" 
						 required="Yes" 
						 style="width:99%"							 					 				 
						 maxlength="150" 
						 class="regularxl">
			</td>
			
			<td style="padding-left:1px">
			
				<cfinput type="Text" 
				         name="TopicOrder" 
						 message="You must enter an order" 
						 validate="integer"
						 required="Yes" 
						 style="text-align:center"		
						 size="1" 						 
						 maxlength="2" 
						 class="regularxl">
			
			</td>
			<td>		
			      <input type="Checkbox"
			       name="Operational" class="radiol"
			       value="1" checked>
			</td>
											   
			<td colspan="3" align="right">
			<cfoutput>
				<input type="submit" 
					value="Save" 
					onclick="quesave('new')"
					class="button10g">
			</cfoutput>
			
			</td>			    
			</TR>	
																		
		</cfif>						
			
		<cfoutput>
			
		<cfloop query="Listing">
																									
			<cfif URL.topicid eq topicid>		
										
			    <input type="hidden" name="TopicId" value="<cfoutput>#TopicId#</cfoutput>">
																	
				<TR class="linedotted">
				
				   <td style="height:30px;width:1%"></td>
								  				   
				   <td>
				   
				   <select name="Parent" class="regularxl">
					<cfloop query="ParentList">
						<option value="#Parent#" <cfif listing.parent eq parent>selected</cfif>>#Description#</option>
					</cfloop>		
				   </select>		
				   
				   </td>
				   <td style="padding-left:1px">
				   	   <cfinput type = "Text" 
					   	value        = "#TopicPhrase#" 
						name         = "TopicPhrase" 
						message      = "You must enter a description" 
						required     = "Yes" 
						style        = "width:99%"							
						maxlength    = "60" 
						class        = "regularxl">			  
		           </td>
				   
				   <td style="padding-left:1px">
				   
				   	<cfinput type="Text" 
				         name="TopicOrder" 
						 value="#TopicOrder#" 
						 message="You must enter an order" 
						 validate="integer"
						 style="text-align:center"		
						 required="Yes" 
						 size="1" 						 
						 maxlength="2" 
						 class="regularxl">
			
				   
				   </td>
				   <td>
				 
					     <input type="Checkbox"
					       name="Operational" class="radiol"
					       value="1"
						   <cfif operational eq "1">checked</cfif>>
						   
				   </td>
						
				   <td colspan="3" align="right">
				   
				   <input type="submit" 
				        value="Save" 
						onclick="quesave('#topicid#')"
						class="button10g">
	
					</td>
			    </TR>	
																											
			<cfelse>
											
				<TR class="navigation_row labelmedium linedotted">
							
				   <td align="center" width="20" height="24" style="padding-top:3px;padding-right:7px">				  
					  <cf_img icon="edit" onClick="ColdFusion.navigate('../Bucket/BucketQuestion/RecordListingDetail.cfm?idfunction=#url.idfunction#&topicid=#topicid#','listing')">
				   </td>							   
				   <td height="17">#Parent#</td>
				   <td>#TopicPhrase#</td>
				   <td>#TopicOrder#</td>
				   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>			   
				   <td colspan="1">#OfficerFirstName# #OfficerLastName#</td>
				   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>			   	 				   
				   <td align="center" id="del_#topicid#">			    
					 <cfinclude template="RecordListingDelete.cfm">					  
				   </td>   
				   		   
			   </tr>	
								 
				 					
			</cfif>
						
		</cfloop>
		
		</cfoutput>													
					
	</table>			

</cfform>		

</td></tr></table>

<cfset ajaxonload("doHighlight")>
