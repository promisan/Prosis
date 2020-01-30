
<cfparam name="url.code" default="">	

<cfparam name="form.operational" default="0">	
	
<cfquery name="Listing" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_FunctionClassificationParent
	ORDER BY ListingOrder
</cfquery>

<table width="95%" align="center" cellspacing="0" class="navigation_table">
			
    <tr class="labelheader line">
	   <td width="20"></td>
   	   <td width="20"></td>
	   <td width="10%">&nbsp;Code</td>
	   <td width="50%">Description</td>
	   <td width="10">O</td>
	   <td width="20%">Officer</td>
	   <td width="80" align="right">Created</b></td>		
	   <td width="30"></td>			  	  
    </tr>	
			
	<cfif URL.code eq "new">

		<tr>
			<td colspan="8">
				<cfform method="POST" name="mytopic" onsubmit="return false">
				
					<table width="100%" align="center">
					
						<tr style="background-color:#f4f4f4;">
							<td></td>
							<td height="25">&nbsp;
							
								    <cfinput type="Text" 
								         value="" 
										 name="Code" 
										 id="Code"
										 message="You must enter a code" 
										 required="Yes" 
										 size="2" 
										 maxlength="20" 
										 class="regularxl">
					        </td>	
												   
							<td>
								   	<cfinput type="Text" 
								         name="Description" 
										 id ="Description"
										 message="You must enter a name" 
										 required="Yes" 
										 size="50" 						 
										 maxlength="50" 
										 class="regularxl">
							</td>
							
							<td>		
							      <input type="Checkbox" name="Operational" id="Operational" value="1" checked>
							</td>
															   
							<td colspan="3" align="right">
								<input type="submit"  value="Save" 	onclick="save('new')" class="button10g">
							</td>			    
						</tr>	
					</table>
				
				</cfform>
			
			</td>
		</tr>
												
	</cfif>						
		
	<cfoutput>
		
	<cfloop query="Listing">
																								
		<cfif URL.code eq code>		
		
			<tr class="linedotted">
				<td colspan="8">
				
					<cfform name="mytopic" onsubmit="return false">
				
					<table width="100%" align="center">
					
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
									class        = "regularxl">			  
					           </td>
							   <td>   <input type="Checkbox" name="Operational" value="1"  <cfif operational eq "1">checked</cfif>> </td>
									
							   <td colspan="3" align="right"> <input type="submit"  value="Save" onclick="save('#code#')" class="button10g"> </td>
							   
						    </tr>	
					
					</table>
					
					</cfform>
					
				</td>
			</tr>
			
										
		<cfelse>
										
			<tr class="labelmedium linedotted navigation_row" >
			
			   <td align="center"><cf_img icon="expand" toggle="yes" onclick="show('#code#')"> </td>
			   <td style="padding-top:2px"><cf_img icon="edit" onclick="ColdFusion.navigate('RecordListingDetail.cfm?code=#code#','listing');" navigation="Yes"></td>
			   
			   <td height="17">&nbsp;#code#</td>
			   <td>#description#</td>
			  
			   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td colspan="1">#OfficerFirstName# #OfficerLastName#</td>
			   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
			   	   
				   
				<td align="center" width="20" id="del_#code#">
				 <cfinclude template="RecordListingDelete.cfm">					  
				</td>   
			   		   
		   </tr>	
			 
		   <tr id="#code#" class="hide"><td></td><td colspan="6">
		       <cfdiv id="#code#_list"/>			
			</td></tr>			 
			 					
		</cfif>
					
	</cfloop>
	</cfoutput>													
				
</table>						
