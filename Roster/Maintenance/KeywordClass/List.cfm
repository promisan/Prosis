		   
<cfquery name="List" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *,
	       (SELECT count(*)
		   FROM  ApplicantBackGroundField
		   WHERE ExperienceFieldId = R.experiencefieldid) as Exist
    FROM  Ref_Experience R
	WHERE R.ExperienceClass = '#URL.Code#'	
	ORDER By R.ListingOrder
</cfquery>

<cfquery name="Last" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Max(ListingOrder)+1 as Last
    FROM  Ref_Experience
	WHERE ExperienceClass = '#URL.Code#'	
</cfquery>

<cfif Last.last eq "">

  <cfset lst = "1">
  
<cfelse>

  <cfset lst = last.last>
    
</cfif>

<cfparam name="URL.ID2" default="">
<br>	
<table width="90%" align="center"  cellspacing="0" cellpadding="0">
				
		<cfif list.recordcount eq "0">
		  <cfset url.id2 = "">
		</cfif>  
			
		    <tr height="18" class="labelheader line">
			   <td>&nbsp;Code</td>
			   <td width="60%">Description</td>
			   <td width="50">Sort</td>
			   <td width="50"><!--- Default ---></td>			  
			   <td width="30" align="center">Active</td>
			   <td colspan="2" align="right">
		       <cfoutput>
				 <cfif URL.ID2 neq "">
				     <A href="javascript:ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=','#url.code#_list')">
					 <font color="0080FF">[add]</font></a>
				 </cfif>
				 </cfoutput>&nbsp;
			   </td>		  
		    </TR>					
				
		<cfoutput>
		
		<cfloop query="List">
					
			<cfset nm = ExperienceFieldId>
			<cfset de = Description>
			<cfset ls = ListingOrder>
			<cfset op = Status>
			<cfset def = 0>
																					
			<cfif URL.ID2 eq nm>		
								
				<tr>
					<td colspan="7">
					
						<cfform action="ListSubmit.cfm?Code=#URL.Code#&id2=#url.id2#" 
			    		method="POST" 
						name="element">
					
						<table width="100%" align="center">
						
							<input type="hidden" name="ExperienceFieldId" value="<cfoutput>#nm#</cfoutput>">
				
							<cfif currentrow neq 1>
							<tr><td height="1" colspan="7" class="line"></td></tr>		
							</cfif>
																
							<tr>
							   <td>&nbsp;#nm#</td>
							   <td>
							   
							   		<cf_LanguageInput
									TableCode       = "Ref_Experience" 
									Mode            = "Edit"
									Name            = "Description"
									Value           = "#de#"
									Key1Value       = "#nm#"
									Type            = "Input"
									Required        = "Yes"
									Message         = "Please enter a description"
									MaxLength       = "60"
									Size            = "80"
									Class           = "regularxl">
								
								<!---	
							   	   <cfinput type="Text" 
								   	value="#de#" 
									name="Description" 
									message="You must enter a description" 
									required="Yes" 
									size="60" 
									maxlength="60" 
									class="regular">
									
									--->
							  
					           </td>
							   <td height="22">
							   
							   	<cfinput type="Text"
								       name="ListingOrder"
								       value="#ls#"
									   class="regularxl"
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
							   <td>
							      <!---
							      <input type="checkbox" name="ListingDefault" value="1" <cfif "1" eq def>checked</cfif>>
								  --->
								</td>
							   <td align="center">
							      <input type="checkbox" name="Status" value="1" <cfif "1" eq op>checked</cfif>>
								</td>
							   <td colspan="2" align="right">
							   <input type="submit" 
							        value="Save" 
									class="button10s" 
									style="width:50">&nbsp;</td>
						    </TR>	
							
							<cfif currentrow lt recordcount>
								<tr><td height="1" colspan="7" class="line"></td></tr>		
							</cfif>
						
						</table>
						
						</cfform>
					</td>
				</tr>
															
			<cfelse>
								
						
				<tr class="cellcontent linedotted">
				   <td height="15" onclick="ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=#nm#','#url.code#_list')">&nbsp;#nm#</td>
				   <td onclick="ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=#nm#','#url.code#_list')">#de#</td>
				   <td onclick="ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=#nm#','#url.code#_list')">#ls#</td>
				   <td><!--- <cfif def eq "1">Yes</cfif> ---></td>	
				   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
				   <td align="right" style="padding-top:3px;">
					   <cf_img icon="edit" onclick="ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=#nm#','#url.code#_list');">
				   </td>
			   				   
				   <td align="center" width="50" style="padding-top:3px;">
				     <cfif exist gte "1">
					        #Exist#
					 <cfelse>
						   <cf_img icon="delete" onclick="ColdFusion.navigate('ListPurge.cfm?Code=#URL.Code#&ID2=#nm#','#url.code#_list');">
					 </cfif>	   
					  
				    </td>
				 </tr>	
						
			</cfif>
						
		</cfloop>
		</cfoutput>
													
		<cfif URL.ID2 eq "">
			
			<tr>
				<td colspan="7">
				
					<cfform action="ListSubmit.cfm?Code=#URL.Code#&id2=" 
				    method="POST" 
					name="element">
				
					<table align="center" width="100%">
						<TR>
							<td height="28">
							
								    <cfinput type="Text" 
								         value="" 
										 name="ExperienceFieldId" 
										 message="You must enter a code" 
										 required="Yes" 
										 size="2" 
										 maxlength="20" 
										 class="regularxl">
					        </td>
										   
							    <td>
								
									<cf_LanguageInput
										TableCode       = "Ref_Experience" 
										Mode            = "Edit"
										Name            = "Description"
										Value           = ""
										Key1Value       = ""
										Type            = "Input"
										Required        = "Yes"
										Message         = "Please enter a description"
										MaxLength       = "60"
										Size            = "80"
										Class           = "regularxl">
								
								<!---
								   	<cfinput type="Text" 
								         name="Description" 
										 message="You must enter a name" 
										 required="Yes" 
										 size="60" 
										 maxlength="80" 
										 class="regular">
										 --->
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
									  class="regularxl"
									  maxlength="2">
								</td>
								
							<td><!---
							     <input type="checkbox" name="ListDefault" value="1">
								 --->
							</td>		
							
							<td align="center">
								<input type="checkbox" name="Status" value="1" checked>
							</td>
												   
							<td colspan="2" align="center">
							<cfoutput>
							<input type="submit" 
								value="Add" 
								class="button10s" 
								style="width:43">
							
							</cfoutput>
							</td>			    
						</TR>	
					</table>
					
					</cfform>
					
				</td>
			</tr>	
											
		</cfif>								
</table>	
<br>		
						

