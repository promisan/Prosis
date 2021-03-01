<!--- Create Criteria string for query from data entered thru search form --->
		
<cfparam name="url.topicid" default="">	
<cfparam name="form.operational" default="0">	

<cfquery name="ParentList" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ExperienceParent	 
</cfquery>	
	
<cfquery name="Listing" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     FunctionOrganizationTopic
	 WHERE    FunctionId = '#URL.IDFunction#'
	 ORDER BY TopicOrder, Parent
</cfquery>	

<table width="98%" align="center">
<tr>
<td width="100%">

<cfform method="POST" name="mytopic" onsubmit="return false">

	<table width="100%" class="navigation_table">
				
	    <TR class="labelmedium2 line" height="18">
		    <td width="1%" style="padding-right:4px"></td>		   
		   <td width="10%"><cf_tl id="Profile element"></td>
		   <td width="50%"><cf_tl id="Question"></td>
		   <td style="min-width:50px"><cf_tl id="Sort"></td>
		   <td style="min-width:80px"><cf_tl id="Scale"></td>
		   <td style="min-width:50px"><cf_tl id="Ena"></td>
		   <td style="min-width:100px"><cf_tl id="Officer"></td>
		   <td style="min-width:90px" align="right"><cf_tl id="Recorded"></td>			
		   <cfoutput>
		   	<td width="30" style="padding-left:4px">
			<a href="javascript:ptoken.navigate('#session.root#/Roster/RosterSpecial/Bucket/BucketQuestion/RecordListingDetail.cfm?idfunction=#url.idfunction#&topicid=new','listing')">
			[<cf_tl id="Add">]</a>
			</td>			  	  
		   </cfoutput>
	    </TR>	
						
		<cfif URL.topicid eq "new">
						
			<TR class="line labelmedium2">
			
			<td rowspan="5"></td>
			
			<td><cf_tl id="Parent"></td>						
			<td height="25" colspan="7"  style="padding-left:1px">			
				<select name="Parent" class="regularxxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
					<cfoutput query="ParentList">
						<option value="#Parent#">#Description#</option>
					</cfoutput>		
				</select>				
	        </td>				
			</tr>
			
			<tr class="line labelmedium">	
			<td><cf_tl id="Short name"></td>		
			<td colspan="7" style="padding-left:1px">
			
				<cfinput type="Text" 
						 style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
				         name="TopicSubject" 						 
						 required="Yes" 						 
						 size="50" 						 
						 maxlength="50" 
						 class="regularxxl">
			
			</td>			
			</tr>
			
			<tr class="line labelmedium">
			 <td><cf_tl id="Question"></td>								   
			<td colspan="7" style="padding-left:1px">
			
				<cftextarea name="TopicPhrase" style="padding:6px;font-size:14px;height:95px;width:99%;border:0px;border-left:1px solid silver;border-right:1px solid silver" required="Yes"></cftextarea>
									 
			</td>		
			</tr>
			
			<tr class="line labelmedium">	
			<td><cf_tl id="Sort"></td>		
			<td colspan="7" style="padding-left:1px">
			
				<table><tr><td>
				
					<cfinput type="Text" 
					         name="TopicOrder" 
							 message="You must enter an order" 
							 validate="integer"
							 required="Yes" 
							 style="text-align:center;border:0px;border-left:1px solid silver;border-right:1px solid silver"		
							 size="1" 						 
							 maxlength="2" 
							 class="regularxxl">
							 
							 <td style="padding-left:7px"><cf_tl id="Score scale"></td>
							 <td style="padding-left:3px"><cfinput validate="integer" value="10" style="text-align:center" size="3" maxlength="3" type="text" name="TopicRatingScale"></td>
							 <td style="padding-left:7px"><cf_tl id="Scale minimum"></td>
							 <td style="padding-left:3px"><cfinput validate="integer" value="6" style="text-align:center" size="3" maxlength="3" type="text" name="TopicRatingPass"></td>						 
							 <td style="padding-left:7px"><cf_tl id="Operational"></td>		
							 <td style="padding-left:5px">					
						      <input type="Checkbox" name="Operational" class="radiol" value="1" checked>			  
							</td>		
						</tr>
				</table>
			
			</td>			
			</tr>
			
			
			<tr class="line labelmedium">		
			<td></td>							   
			<td colspan="7" style="height:30px;padding-left:1px">
			
				<cfoutput>
				<input type="submit" value="Save" onclick="quesave('#url.idfunction#','new')" style="border:0px" class="button10g">
				</cfoutput>
			
			</td>	
					    
			</TR>	
																		
		</cfif>						
			
		<cfoutput>
			
		<cfloop query="Listing">
																									
			<cfif URL.topicid eq topicid>		
										
			    <input type="hidden" name="TopicId" value="<cfoutput>#TopicId#</cfoutput>">
																	
				<TR class="line labelmedium">
				
				   <td rowspan="5" style="height:30px;width:1%"></td>
							
				   <td><cf_tl id="Parent"></td>			  				   
				   <td  style="padding-left:1px">
				   
				   <select name="Parent" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
					<cfloop query="ParentList">
						<option value="#Parent#" <cfif listing.parent eq parent>selected</cfif>>#Description#</option>
					</cfloop>		
				   </select>		
				   
				   </td>
				   
				  </tr>
				  
				  <tr class="line labelmedium">	
					<td><cf_tl id="Short name"></td>		
					<td colspan="7" style="padding-left:1px">
					
						<cfinput type="Text" 
						         name="TopicSubject" 		
								 style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
								 value="#topicSubject#"				 
								 required="Yes" 									
								 size="50" 						 
								 maxlength="50" 
								 class="regularxl">
					
					</td>			
					</tr>
				  
				  <tr class="line labelmedium">  
				   <td><cf_tl id="Question"></td>
				   <td colspan="7"  style="padding-left:1px">				   
				   	<textarea name="TopicPhrase" style="font-size:14px;padding:6px;height:95px;width:99%;min-width:99%;max-width:99%;border:0px;border-left:1px solid silver;border-right:1px solid silver">#TopicPhrase#</textarea>									   	   
		           </td>
				   </tr>
				   
				   <tr class="line labelmedium">  
				   <td><cf_tl id="Order"></td>
				   <td colspan="7">
				   
				   <table><tr><td>
				
						<cfinput type="Text" 
				         name="TopicOrder" 
						 value="#TopicOrder#" 
						 message="You must enter an order" 
						 validate="integer"
						 style="text-align:center;border:0px;border-left:1px solid silver;border-right:1px solid silver"		
						 required="Yes" 
						 size="1" 						 
						 maxlength="2" 
						 class="regularxl">
							 
							 <td style="padding-left:7px"><cf_tl id="Score scale"></td>
							 <td style="padding-left:3px"><cfinput validate="integer" value="#TopicRatingScale#" style="text-align:center" size="3" maxlength="3" type="text" name="TopicRatingScale"></td>
							 <td style="padding-left:7px"><cf_tl id="Score minimum"></td>
							 <td style="padding-left:3px"><cfinput validate="integer" value="#TopicRatingPass#" style="text-align:center" size="3" maxlength="3" type="text" name="TopicRatingPass"></td>						 
							 <td style="padding-left:7px"><cf_tl id="Operational"></td>
						     <td style="padding-left:5px">
				 				 
						     <input type="Checkbox"
						       name="Operational" class="radiol"
						       value="1"
							   <cfif operational eq "1">checked</cfif>>
						   
				            </td>
						</tr>
						</table>
				 
				   </tr>
				   </td>
								   
				   <tr class="line labelmedium">  
				   <td></td>
				   <td colspan="7" style="padding-left:1px;height:30px;padding:3px">
									   
				   <input type="submit" 
				        value="Save" 
						onclick="quesave('#url.idfunction#','#topicid#')"
						class="button10g">
	
					</td>
			    </TR>	
																											
			<cfelse>
											
				<TR class="navigation_row labelmedium line">							
				   <td align="center" width="20" height="24" style="padding-top:1px;padding-right:7px">				  
					  <cf_img icon="open" onClick="ptoken.navigate('#session.root#/Roster/RosterSpecial/Bucket/BucketQuestion/RecordListingDetail.cfm?idfunction=#url.idfunction#&topicid=#topicid#','listing')">
				   </td>							   
				   <td height="17">#Parent#</td>
				   <td>#TopicPhrase#</td>
				   <td>#TopicOrder#</td>
				   <td>#TopicRatingScale# [#TopicRatingPass#]</td>
				   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>			   
				   <td>#OfficerFirstName# #OfficerLastName#</td>
				   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>			   	 				   
				   <td align="center" id="del_#topicid#" style="padding-top:2px">			    
					 	<cfinclude template="RecordListingDelete.cfm">					  
				   </td>				   		   
			   </TR>								 
				 					
			</cfif>
						
		</cfloop>
		
		</cfoutput>													
					
	</table>			

</cfform>		

</td>
</tr>
</table>

<cfset ajaxonload("doHighlight")>
