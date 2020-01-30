
	
<cfparam name="url.code" default="">


<cf_tl id = "Yes" var = "1">
<cfset vYes = lt_text>
<cf_tl id = "No"  var = "1">
<cfset vNo = lt_text>

<cfparam name="form.operational" default="0">	
	
<cfquery name="Listing" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT EC.*, CT.Description as ClaimTypeDescription
    FROM  Ref_ElementClass EC
    INNER JOIN Ref_ClaimType CT
		ON EC.ClaimType = CT.Code
	ORDER BY EC.ClaimType, EC.ListingOrder
</cfquery>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
			
    <tr style="height:20px;" class="labelheader line">
	    <td width="20"></td>
		<td width="20"></td>
	    <td><cf_tl id="Code"></td>	
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Listing Order"></td>
		<td><cf_tl id="Ref. Prefix"></td>
		<td><cf_tl id="Ref. Serial No."></td>
		<td><cf_tl id="En. Matching"></td>
		<td><cf_tl id="En. Association"></td>
		<td><cf_tl id="Association Source"></td>
		<td><cf_tl id="En. Picture"></td>
		<td><cf_tl id="Officer"></td>
	    <td><cf_tl id="Entered"></td> 
		<td></td>
    </tr>	
			
	<cfif URL.code eq "new">
				
		<tr bgcolor="f4f4f4" class="navigation_row">
		
		<td colspan="14">
		
			<cfform method="POST" name="myelement" onsubmit="return false">
			<table width="100%" align="center">
				<tr class="linedotted">
					<!--- Field: ClaimType --->
					<td height="25">&nbsp;
					
						  	 <cfquery name="qClaimType" 
								datasource="AppsCaseFile" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT Code, Description
									FROM  Ref_ClaimType
							 </cfquery>
							 
						 	 <select name="ClaimType" class="regularxl">
								 <cfoutput query="qClaimType">
								 	<option value="#Code#">#Description#</option>
								 </cfoutput>
							 </select>
			        </td>	
						
					<!--- Field: Code --->				   
					<td><cfoutput>
						<cf_tl id = "Please enter an element code" var = "1">
						<cfinput type="Text" name="Code" value="" message="#lt_text#" required="Yes" size="10" maxlength="10" class="regularxl">
						</cfoutput>
					</td>
					
					<!--- Field: Description --->
					<td>
					   <cfoutput>
						<cf_tl id = "Please enter a description" var = "1">
						<cfinput type="Text" name="Description" value="" message="#lt_text#" required="Yes" size="50" maxlength="50" class="regularxl">
						</cfoutput>
					</td>
					
					<!--- Field: Listing Order --->
					<td>
					<cfoutput>
						<cf_tl id = "Please enter a listing order" var = "1">
						<cfinput type="Text" name="ListingOrder" value="" message="#lt_text#" required="Yes" size="2" maxlength="2" class="regularxl">
					</cfoutput>	
					</td>
					
					<!--- Field: Reference Prefix --->
					<td>
					<cfoutput>
						<cf_tl id = "Please enter a unique reference prefix" var = "1">
						<cfinput type="Text" name="ReferencePrefix" value="" message="#lt_text#" required="Yes" size="2" maxlength="3" class="regularxl">
					</cfoutput>	
					</td>
					
					<!--- Field: Reference Serial No --->
					<td>
					<cfoutput>
						<cf_tl id = "Please enter a reference serial number" var = "1">
						<cfinput type="Text" name="ReferenceSerialNo" value="" message="#lt_text#" validate="integer" required="Yes" size="2" maxlength="5" class="regularxl">
					</cfoutput>	
					</td>
					
					<!--- Field: Enable matching --->
					<td>
					<cfoutput>
						<select name="EnableMatching" class="regularxl">
							<option value="1">#vYes#</option>
						<option value="0">#vNo#</option>
						</select>
					</cfoutput>
					</td>
					
					<!--- Field: Enable association --->
					<td>	
					<cfoutput>	
					     <select name="EnableAssociation" class="regularxl">
							<option value="1">#vYes#</option>
							<option value="0">#vNo#</option>
						</select>
					</cfoutput>	
					</td>
			
					<!--- Field: Association source --->
					<td>
					<cfoutput>
						<select name="AssociationSource" class="regularxl">
							<option value="1">#vYes#</option>
							<option value="0">#vNo#</option>
						</select>
					</cfoutput>
					</td>
							
					<!--- Field: Enable picture --->
					<td>	
					<cfoutput>	
					     <select name="EnablePicture" class="regularxl">
							<option value="1">#vYes#</option>
							<option value="0">#vNo#</option>
						</select>
					</cfoutput>	
					</td>
													   
					<td align="right" colspan="3">
							<cf_tl id = "Save" var = "1">
							<cfoutput>
							<input type="submit" 
								value="#lt_text#" 
								onclick="save('new')"
								class="button10g">
							</cfoutput>	
					
					</td>			    
					</tr>	
				</tr>
			</table>
			</cfform>
		</td>
										
	</cfif>						

	<cfoutput query="Listing" group="ClaimType">
		<tr>
	  		<td height="1" colspan="14">&nbsp;</td>
		</tr>				
		<tr class="linedotted">
	 		 <td colspan="14" class="labellarge">#ClaimTypeDescription#</td>
		</tr>
					
		<cfoutput>
		<cfif URL.code eq code>		
			
			<tr class="linedotted navigation_row">
				<td colspan="14">
					<cfform method="POST" name="myelement" onsubmit="return false">
					<table width="100%" align="center">
					
						 <input type="hidden" name="ElementCode" value="#Code#">
																
							<tr bgcolor="ffffcf">
							   
							   <!--- Field: ClaimType --->
							   <td height="30">
							   		 <cfquery name="qClaimType" 
										datasource="AppsCaseFile" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT Code, Description
											FROM  Ref_ClaimType
									 </cfquery>
									 
									<select name="ClaimType" class="regularxl">
										<cfloop query="qClaimType">
											<option value="#qClaimType.Code#" <cfif qClaimType.Code eq '#Listing.ClaimType#'>selected</cfif>>#qClaimType.Description#</option>
										</cfloop>
									</select>
								   <input type="hidden" name="ClaimTypeOld" value="#Listing.ClaimType#">
							   </td>
							   
							   <!--- Field: Code --->
							   <td>
							   	 #Code#
					           </td>
							   
							   <!--- Field: Description --->
							   <td>
							   		<cf_tl id = "Please enter a description" var = "1" class ="Message">
								   	<cfinput type="Text" name="Description" value="#Description#" message="#lt_text#" required="Yes" size="50" maxlength="50" class="regularxl">
							   </td>
							   
							   <!--- Field: Listing order --->
							   <td>
								    <cf_tl id = "Please enter a listing order" var = "1" class ="Message">
							  	  	<cfinput type="Text" name="ListingOrder" value="#ListingOrder#" message="#lt_text#" required="Yes" size="2" maxlength="2" class="regularxl">
							   </td>
							   
							   <!--- Field: Reference Prefix --->
								<td>
									<cf_tl id = "Please enter a unique reference prefix" var = "1">
									<cfinput type="Text" name="ReferencePrefix" value="#ReferencePrefix#" message="#lt_text#" required="Yes" size="2" maxlength="3" class="regularxl">
									<input type="Hidden" name="ReferencePrefixOld" value="#ReferencePrefix#">
								</td>
								
								<!--- Field: Reference Serial No --->
								<td>
									<cf_tl id = "Please enter a reference serial number" var = "1">
									<cfinput type="Text" name="ReferenceSerialNo" value="#ReferenceSerialNo#" message="#lt_text#" validate="integer" required="Yes" size="2" maxlength="5" class="regularxl">					
								</td>
						
							   <!--- Field: EnableMatching --->
							   <td>
				
								   <select name="EnableMatching" class="regularxl">
										<option value="1" <cfif EnableMatching eq 1>selected</cfif>>#vYes#</option>
										<option value="0"  <cfif EnableMatching eq 0>selected</cfif>>#vNo#</option>
									</select>
				
							   </td>
							   
							  <!--- Field: EnableAssociation --->
							  <td>
				
							   	<select name="EnableAssociation" class="regularxl">
									<option value="1" <cfif EnableAssociation eq 1>selected</cfif>>#vYes#</option>
									<option value="0"  <cfif EnableAssociation eq 0>selected</cfif>>#vNo#</option>
								</select>
				
							  </td>
							  
						  	<!--- Field: Association source --->
							<td>
				
								<select name="AssociationSource" class="regularxl">
									<option value="1" <cfif AssociationSource eq 1>selected</cfif>>#vYes#</option>
									<option value="0" <cfif AssociationSource eq 0>selected</cfif>>#vNo#</option>
								</select>
				
							</td>
							  
							  <!--- Field: EnablePicture --->
							  <td>
					
							   	<select name="EnablePicture" class="regularxl">
									<option value="1" <cfif EnablePicture eq 1>selected</cfif>>#vYes#</option>
									<option value="0"  <cfif EnablePicture eq 0>selected</cfif>>#vNo#</option>
								</select>
					
							  </td>
									
							   <td align="right" colspan="2">
							   <cf_tl id = "Save" var="1">
							   <input type="submit" 
							        value="#lt_text#" 
									onclick="save('#code#')"
									class="button10g">
				
								</td>
						    </tr>	
						
					</table>
					</cfform>
				</td>
			</tr>
							
																	
		<cfelse>
										
			<tr class="cellcontent linedotted navigation_row">
			
			    <td width="20">		
			  		<cf_img icon="open" onclick="ColdFusion.navigate('RecordListingDetail.cfm?code=#code#','listing')">
			    </td>	
				  			   
			    <td>
			  		<cf_img icon="expand" toggle="Yes" onclick="show('#code#')">						
			    </td>
			   
				<td>#Code#</td>	
				<td>#Description#</td>
				<td>#ListingOrder#</td>
				<td>#ReferencePrefix#</td>
				<td>#ReferenceSerialNo#</td>
				<td> <cfif EnableMatching eq 1>Yes<cfelse>No</cfif></td>
				<td> <cfif EnableAssociation eq 1>Yes<cfelse>No</cfif></td>
				<td><cfif AssociationSource eq 1>Yes<cfelse>No</cfif></td>
				<td> <cfif EnablePicture eq 1>Yes<cfelse>No</cfif></td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td> 
				
				<td>
				   <cfquery name="Check" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT TOP 1 ElementClass
					    FROM  Ref_TopicElementClass
						WHERE ElementClass = '#Code#'		
						
						UNION
						
						SELECT TOP 1 TabElementClass
						FROM Ref_ClaimTypeTab
						WHERE TabElementClass = '#Code#'				
				   </cfquery>
				   	
				  <cfif check.recordcount eq "0">
				      <A href="javascript:ColdFusion.navigate('RecordListingPurge.cfm?Code=#code#','listing')">
					   <img src="#Client.VirtualDir#/Images/delete5.gif" height="12" width="12" alt="delete" border="0" align="absmiddle">
					  </a>
				  </cfif>	
			   	</td>   
		   </tr>	
			 
		   <tr id="#code#" class="hide"><td colspan="14" id="#code#_list" align="center"></td></tr> 			 
			 					
		</cfif>

		</cfoutput>		
																	
	</cfoutput>
			
</table>						
