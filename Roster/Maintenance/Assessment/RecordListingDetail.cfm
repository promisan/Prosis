
<cfinvoke component="Service.Presentation.Presentation" method="highlight" returnvariable="stylescroll"/>
		
<cfparam name="url.code" default="">	

<cfparam name="form.operational" default="0">	
	
<cfquery name="Listing" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_AssessmentCategory	
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
	
    <tr class="labelheader line">
	   <td width="20"></td>
	   <td width="5%">&nbsp;Class</td>
	   <td width="50%">Skill Area</td>
	   <td width="10">Oper.</b></td>
	   <td width="20%">Officer</b></td>
	   <td width="80" align="right">Created</b></td>		
	   <td width="30"></td>			  	  
    </tr>	
			
	<cfif URL.code eq "new">
	
		<tr class="linedotted">
			<td colspan="7">
			
			<cfform method="POST" name="mytopic" onsubmit="return false">
			
				<table width="100%" align="center">
					<tr style="background-color:#f4f4f4;">
		
					<td></td>
					<td height="25">&nbsp;
					    <cfinput type="Text" 
					         value="" 
							 name="Code" 
							 message="You must enter a code" 
							 required="Yes" 
							 size="2" 
							 maxlength="20" 
							 class="regularH">
			        </td>	
										   
					<td>
					   	<cfinput type="Text" 
					         name="Description" 
							 message="You must enter a name" 
							 required="Yes" 
							 size="50" 						 
							 maxlength="50" 
							 class="regularH">
					</td>
					
					<td>  <input type="Checkbox"  name="Operational" value="1" checked> </td>
													   
					<td colspan="2" align="right">	<input type="submit" value="Save" onclick="save('new')" class="button10g"> </td>
					
					</tr>
				</table>
			
			</cfform>
				
			</td>
		</tr>
												
	</cfif>						
		
	<cfoutput>

	
	<cfloop query="Listing">
	
		<cfif URL.code eq Listing.code>		
			
			<tr class="linedotted">
				<td colspan="7">
				
					<cfform name="mytopic" onsubmit="return false">
				
					<table align="center" width="100%">
						
						<input type="hidden" name="Code" value="<cfoutput>#Code#</cfoutput>">
																
						<tr style="background-color:##f4f4f4;">
						
						   <td></td>
						   <td height="30">&nbsp;#Code#</td>
						   <td>
						   	   <cfinput type = "Text" 
							   	value        = "#description#" 
								name         = "Description" 
								message      = "You must enter a description" 
								required     = "Yes" 
								size         = "50" 
								maxlength    = "60" 
								class        = "regularH">			  
				           </td>
						   
						   <td> <input type="Checkbox" name="Operational"  value="1"  <cfif operational eq "1">checked</cfif>> </td>
								
						   <td colspan="2" align="right">  <input type="submit" value="Save" onclick="save('#code#')" class="button10g"> </td>
					    </tr>	
							
					</table>
					
					</cfform>
				</td>
			</tr>
																	
		<cfelse>
										
			<tr class="cellcontent navigation_row line">			  			   
			   <td align="center">
				  <cf_img icon="open" onclick="ColdFusion.navigate('RecordListingDetail.cfm?code=#code#','listing')" navigation="Yes">
			  </td>
			   
			   <td height="17">&nbsp;
				   <a href="javascript:ColdFusion.navigate('RecordListingDetail.cfm?code=#code#','listing')">
				   #code#</a>
			   </td>
			   <td>
			  	   <a href="javascript:ColdFusion.navigate('RecordListingDetail.cfm?code=#code#','listing')">
			   	   #description#
				   </a>
			   </td>
			  
			   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td colspan="1">#OfficerFirstName# #OfficerLastName#</td>
			   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
			   			   				   
			   <td align="center" width="20" d="del_#code#">
				
				  <cfdiv id="del_#code#">
				 
					  <cfinclude template="RecordListingDelete.cfm">
				 
				  </cfdiv>					  
				 
			   </td>   
			   		   
		   </tr>	
			 
		   <tr><td></td><td></td><td colspan="4">
		       <cf_securediv id="#code#_list" bind="url:List.cfm?code=#code#"/>			
			</td></tr>
			 					
		</cfif>
					
	</cfloop>
	</cfoutput>													
				
</table>						

