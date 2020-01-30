
<!--- main settings + mission --->
<cfparam name="url.action" default="view">
<cfparam name="url.id1" default="">

<cfquery name="ClaimTypeMission" 
	 datasource="AppsCaseFile"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT * FROM Ref_ClaimTypeMission
		WHERE ClaimType = '#URL.ID1#'
</cfquery>
		 
		 
<cfquery name="getMission" 
datasource="AppsCaseFile"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM Ref_ParameterMission
	WHERE Mission NOT IN 
	(
		SELECT Mission FROM Ref_ClaimTypeMission WHERE ClaimType = '#URL.ID1#'
	)
</cfquery>

<cfform name="addmission" onsubmit="return false">
 
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">					
					
			<cfoutput>
			
			 <TR height="18" class="labelheader linedotted">
				   <td class="labelit">&nbsp;<cf_tl id="Claim Type"></td>
				   <td class="labelit"><cf_tl id="Mission"></td>
				   <td class="labelit"><cf_tl id="Officer"></td>		  
				   <td class="labelit"><cf_tl id="Created"></td>
				   <td align="right" class="labelit">
			   		 <cfoutput>
					 	<cfif URL.action neq "new" and getMission.RecordCount gt 0>
					    	 <A href="javascript:ColdFusion.navigate('RecordMissionListing.cfm?ID1=#URL.ID1#&action=new','listing')">
						 	<font color="0080FF">[<cf_tl id="add">]</font></a>
					 	</cfif>
					 </cfoutput>&nbsp;
				   </td>
			  </TR>
			
			<cfif url.action eq "new">
								
				    <input type="hidden" name="ClaimType" value="#url.id1#">
				
					<tr bgcolor="ffffcf" class="navigation_row">
						<td class="labelit">#url.id1#</td>
					
						<td class="labelit">
							<cfselect name="mission" required="yes" message="Please select a mission" class="regularxl">
								<cfloop query="getMission">
									<option value="#getMission.Mission#">#getMission.Mission#</option>
								</cfloop>
							</cfselect>
						</td class="labelit">
						<td colspan="3" align="right" class="labelit">
							<cf_tl id = "Save" var = "1">
							<input type="submit" 
							value="#lt_text#" 
							onclick="saveMission('new')"
							class="button10g">
						</td>
					</tr>
				
			</cfif>
			
			<cfloop query="ClaimTypeMission">
						
					<TR class="cellcontent linedotted navigation_row">
					   <td class="labelit">&nbsp;#ClaimType#</td>
					   <td height="20" class="labelit">#Mission#</td>
	   				   <td height="20" class="labelit">#OfficerFirstName# #OfficerLastName#</td>
					   <td class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
					   <td align="right">
						   	<cf_img icon="delete" onclick="deleteMission('#URL.ID1#','#Mission#')">
					   </td>
						
					 </TR>	
							
							
			</cfloop>
			</cfoutput>
																						
	</table>	

</cfform>

<cfset AjaxOnLoad("doHighlight")>