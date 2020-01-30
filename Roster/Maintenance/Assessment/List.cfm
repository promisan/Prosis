
<cfquery name="Owner" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ParameterOwner	
</cfquery>

<cfquery name="List" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Assessment
	WHERE AssessmentCategory = '#URL.Code#'	
	ORDER By ListingOrder
</cfquery>

<cfquery name="Last" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Max(ListingOrder)+1 as Last
    FROM  Ref_Assessment	
	WHERE AssessmentCategory = '#URL.Code#'	
</cfquery>

<cfif Last.last eq "">

  <cfset lst = "1">
  
<cfelse>

  <cfset lst = last.last>
    
</cfif>

<cfparam name="URL.skillcode" default="">
	
<table width="100%" cellspacing="0" cellpadding="0">
				
		<cfif list.recordcount eq "0">
		  <cfset url.skillcode = "new">
		</cfif>  
		

	    <tr class="labelheader linedotted">
		   <td>&nbsp;Code</td>
		   <td width="60%">Description</td>
		   <td width="50">Order</td>
		   <td width="50">Owner</td>
		   <td width="30" align="center">Active</td>
		   <td colspan="2" align="right">
	       <cfoutput>
			 <cfif URL.skillcode neq "new">
			     <A href="javascript:ColdFusion.navigate('List.cfm?Code=#URL.Code#&skillcode=new','#url.code#_list')">
				 <font color="0080FF">[add]</font></a>
			 </cfif>
			 </cfoutput>&nbsp;
		   </td>		  
	    </tr>						
			
		<cfoutput>
		
		<cfloop query="List">
					
			<cfset nm  = SkillDescription>
			<cfset de  = SkillCode>
			<cfset ls  = ListingOrder>
			<cfset op  = Operational>
			<cfset def = Owner>
																					
			<cfif url.skillcode eq de and url.owner eq def>		
				
				<tr>
					<td colspan="7">
					
					<cfform action="ListSubmit.cfm?Code=#URL.Code#&skillcode=#url.skillcode#&owner=#def#" 
		    		method="POST" 
					name="element">
					
						<table width="100%" align="center">
							<tr>
							   <td>#de#</td>
							   <td>
							   	   <cfinput type="Text" 
								   	value="#nm#" 
									name="SkillDescription" 
									message="You must enter a description" 
									required="Yes" 
									size="60" 
									maxlength="60" 
									class="regular">
							  
					           </td>
							   <td height="22">
							   	<cfinput type="Text"
								       name="ListingOrder"
								       value="#ls#"
									   class="regular"
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
							   <td>  #def# </td>
							   <td align="center"> <input type="checkbox" name="Operational" value="1" <cfif "1" eq op>checked</cfif>> </td>
							   <td colspan="2" align="right">  <input type="submit"  value="Save"  class="button10s" style="width:50">&nbsp;</td>
						    </tr>
						</table>
						
					</cfform>
						
				</td>
			</tr>	
															
			<cfelse>								
						
				<tr class="cellcontent">
				   <td>#de#</td>
				   <td height="20">#nm#</td>
				   <td>#ls#</td>
				   <td>#def#</td>	
				   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
				   <td align="right" style="padding-top:3px;">
					   <cf_img icon="edit" onclick="ColdFusion.navigate('List.cfm?Code=#URL.Code#&skillcode=#de#&owner=#def#','#url.code#_list')">
				   </td>
			   			   
				   <cfquery name="Check" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT TOP 1 *
					    FROM  ApplicantAssessmentDetail
						WHERE SkillCode = '#de#'	
						AND   Owner     = '#def#'
				   </cfquery>
				   
				   <td align="center" width="20" style="padding-top:3px;">
				     <cfif check.recordcount eq "0">
						   <cf_img icon="delete" onclick="ColdFusion.navigate('ListPurge.cfm?code=#url.code#&skillcode=#de#&owner=#def#','#url.code#_list')">
					 </cfif>	   
					  
				    </td>
					
				 </tr>	
						
			</cfif>
						
		</cfloop>
		</cfoutput>
													
		<cfif URL.skillcode eq "new">
			
			<tr>
				<td colspan="7">
				
					<cfform action="ListSubmit.cfm?Code=#URL.Code#&skillcode=new" 
				    method="POST" 
					name="element">
					
					<table width="100%" align="center">
						<tr>
						<td height="28">
						
							    <cfinput type="Text" 
							         value="" 
									 name="Skillcode" 
									 message="You must enter a code" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regular">
				        </td>
									   
						    <td>
							   	<cfinput type="Text" 
							         name="Skilldescription" 
									 message="You must enter a name" 
									 required="Yes" 
									 size="60" 
									 maxlength="80" 
									 class="regular">
							</td>								 
							<td>
							   <cfinput type="Text" 
							      name="ListingOrder" 
								  message="You must enter an order" 
								  required="Yes" 
								  size="1" 
								  style="text-align:center"
								  value="#lst#"
								  validate="integer"
								  class="regular"
								  maxlength="2">
							</td>
							
						<td>
						  <select name="Owner" visible="Yes" enabled="Yes">
							  <cfoutput query="Owner">
							   <option value="#Owner#">#Owner#</option>
							  </cfoutput>
						  </select>
						</td>		
						
						<td align="center">
							<input type="checkbox" name="Operational" value="1" checked>
						</td>
											   
						<td colspan="2" align="right">
						<cfoutput>
							<input type="submit"  value="Add" class="button10s" style="width:50"> &nbsp;
						</cfoutput>
						</td>			    
						</tr>	
					</table>
					
					</cfform>
				</td>
			</tr>
											
		</cfif>								
</table>		
						

