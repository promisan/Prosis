
<cfoutput>

<cfform name="profile#url.languagecode#">
	
	<table width="100%">
		
		<cfif url.accessmode eq "view">
			
			<tr><td colspan="2" class="linedotted"></td></tr>
			
			<tr><td style="height:25;padding-top:4px;padding-bottom:4px">
			
				<table cellspacing="0" cellpadding="0">
				<tr class="labelmedium2">
					<td>
								
					<input type="radio" name="ViewMode" id="ViewMode" value="edit" class="radiol"
	     				onclick="ptoken.navigate('#session.root#/Staffing/Application/Assignment/Review/PositionProfileContent.cfm?accessmode=edit&id=#url.id#&id1=#url.id1#&languagecode=#url.languagecode#','profilecontent#url.languagecode#')">
						
					</td>
					<td>Amend</td>
					<td style="padding-left:5px"><input type="radio" name="ViewMode" id="ViewMode" value="view" class="radiol" checked></td>
					<td><b>View</td>
				</tr>
				</table>
			
			</td></tr>
			
			<tr><td colspan="2" class="linedotted"></td></tr>
			
			<tr><td height="2" colspan="2" style="padding:4px;padding-right:20px">
			
				  <cf_ApplicantTextArea
						Table           = "Employee.dbo.PositionParentProfile" 
						Domain          = "Position"
						FieldOutput     = "JobNotes"				
						LanguageCode    = "#url.languagecode#"				
						Mode            = "View"					
						Key01           = "PositionParentId"
						Key01Value      = "#URL.ID#">			
					
				</td>
			</tr>	
		
		<cfelse>					
					
			<tr><td colspan="2" class="linedotted"></td></tr>
			
			<tr><td colspan="2" align="center">
									
				<table width="100%">
				
					<tr>
					<td width="60" style="height:25;padding-top:4px;padding-bottom:4px">		
					
						<table>
						<tr>
						
							<td><input type="radio" name="ViewMode" id="ViewMode" class="radiol" value="edit" checked></td>
							<td class="labelmedium"><b>Amend</td>
							<td style="padding-left:5px"><input type="radio" name="ViewMode" id="ViewMode" class="radiol" value="view" 
							     onclick="ptoken.navigate('#session.root#/Staffing/Application/Assignment/Review/PositionProfileContent.cfm?accessmode=view&id=#url.id#&id1=#url.id1#&languagecode=#url.languagecode#','profilecontent#url.languagecode#')">
							 </td>
							<td class="labelmedium">View</td>
						</tr>
						</table>
								
					</td>
					<td width="100%" align="right" style="padding-right:5px">
					
						<input type="button" 
					       name="Save" 
						   value="Save" 
						   style="width:140px"
						   class="button10g" 
						   onclick="updateTextArea();ptoken.navigate('#session.root#/Staffing/Application/Assignment/Review/PositionProfileSubmit.cfm?id=#url.id#&id1=#url.id1#&languagecode=#url.languagecode#','profilecontent#url.languagecode#','','','POST','profile#url.languagecode#')">
						   
					</td>
					<td id="process#url.languagecode#" align="right" width="120" class="labelit"></td>
					</tr>
				
				</table>				
				
				</td>
			</tr>	
			
			<tr><td colspan="2" class="linedotted"></td></tr>			
			<tr><td height="5"></td></tr>		
			<tr><td height="2" colspan="2" style="padding:4px">
						
				  <cf_ApplicantTextArea
						Table           = "Employee.dbo.PositionParentProfile" 
						Domain          = "Position"
						FieldOutput     = "JobNotes"				
						LanguageCode    = "#url.languagecode#"
						Mode            = "Edit"
						Height			= "200"
						Format          = "RichTextFull"
						Ajax            = "Yes"
						Key01           = "PositionParentId"
						Key01Value      = "#URL.ID#">			
				
				</td></tr>
				
				<tr><td colspan="2" align="center">
				
				<input type="button" 
				       name="Save" 
					   value="Save" 
					   style="width:140px"
					   class="button10g" 
					   onclick="updateTextArea();ptoken.navigate('#session.root#/Staffing/Application/Assignment/Review/PositionProfileSubmit.cfm?id=#url.id#&id1=#url.id1#&languagecode=#url.languagecode#','profilecontent#url.languagecode#','','','POST','profile#url.languagecode#')">
				
				</td></tr>
				
				<tr><td height="5"></td></tr>
				
		</cfif>	
		
		</TABLE>
				
		</cfform>
		
</cfoutput>		
			
<cfset AjaxOnload("initTextArea")>	