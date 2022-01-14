
<cfoutput>

<cfquery name="history"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   DISTINCT FO.SubmissionEdition, FO.ReferenceNo, FO.FunctionId, FO.OfficerUserId, FO.OfficerLastName, FO.OfficerFirstName, FO.Created
	FROM     FunctionOrganization AS FO INNER JOIN
             Vacancy.dbo.DocumentPost AS DP ON FO.DocumentNo = DP.DocumentNo INNER JOIN
             Employee.dbo.Position AS P ON DP.PositionNo = P.PositionNo
	WHERE    P.SourcePostNumber IN (SELECT SourcePostNumber 
	                                FROM   Employee.dbo.PositionParent 
									WHERE  PositionParentid = '#url.id#')
	AND      FunctionId IN ( SELECT FunctionId FROM Applicant.dbo.FunctionOrganizationNotes )							
	ORDER BY FO.Created DESC

</cfquery>


<cfif history.recordcount eq "0">

	<cfquery name="get"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
	    FROM   Employee.dbo.PositionParent 
		WHERE  PositionParentid = '#url.id#'
	</cfquery>	
	
	<!--- we look for whide --->
	
	<cfquery name="history"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT       DISTINCT TOP (3) FO.SubmissionEdition, FO.ReferenceNo, FO.FunctionId, FO.OfficerUserId, FO.OfficerLastName, FO.OfficerFirstName, FO.Created
		FROM         FunctionOrganization AS FO INNER JOIN
		             Vacancy.dbo.DocumentPost AS DP ON FO.DocumentNo = DP.DocumentNo
		WHERE        FO.FunctionNo = '#get.FunctionNo#' 
		AND          FO.FunctionId IN (SELECT FunctionId FROM FunctionOrganizationNotes) 
		AND          FO.GradeDeployment = '#get.PostGrade#'
		ORDER BY     FO.Created DESC
	
	</cfquery>

</cfif>


<cfform name="profile#url.languagecode#">
	
	<table width="100%">
		
		<cfif url.accessmode eq "view">
			
			<tr><td colspan="2" class="linedotted"></td></tr>
			
			<tr class="line">
			
				<td style="height:25;padding-top:4px;padding-bottom:4px;width:50%">
			
				<table width="100%" class="clsNoPrint">
				
				<tr class="labelmedium2">
				
					<td>								
					<input type="radio" name="ViewMode" id="ViewMode" value="edit" class="radiol"
	     				onclick="ptoken.navigate('#session.root#/Staffing/Application/Assignment/Review/PositionProfileContent.cfm?accessmode=edit&id=#url.id#&id1=#url.id1#&languagecode=#url.languagecode#','profilecontent#url.languagecode#')">						
					</td>
					<td><cf_tl id="Amend"></td>
					<td style="padding-left:5px"><input type="radio" name="ViewMode" id="ViewMode" value="view" class="radiol" checked></td>
					<td><b><cf_tl id="View"></td>		
					
					<cfif history.recordcount gte "1">
					<td style="width:90%;padding-right:5px" align="right" id="logset"><a href="javascript:ptoken.navigate('#session.root#/staffing/application/Assignment/Review/setHistory.cfm?action=hide','logset')">Hide history</a></td>
					<cfelse>			
					<td style="width:90%;padding-right:5px" align="right"><cfif history.recordcount eq "0">No history found for this job</cfif></td>
					</cfif>
					
				</tr>
				</table>
						
				</td>			
								
				<cfif history.recordcount gte "1">
				
					<td id="logheader">
																			
					<select name="FunctionId" 
					    class="regularxxl" style="width:100%;border:0px;background-color:f1f1f1"
						onchange="ptoken.navigate('#session.root#/staffing/application/Assignment/Review/getHistory.cfm?languagecode=#url.languagecode#&id='+this.value,'log')">
					
						<cfloop query="history">					
							<cfset val = "#ReferenceNo# : #officerFirstName# #officerlastname# #dateformat(created,client.dateformatshow)#">
							<option value="#FunctionId#">#val#</option>						
						</cfloop>
					
					</select>					
					
					</td>
				
				</cfif>
				
			</tr>
						
			<tr><td valign="top" style="padding:4px;padding-top:0px;padding-right:20px;width:50%">
			
				  <cf_ApplicantTextArea
						Table           = "Employee.dbo.PositionParentProfile" 
						Domain          = "Position"
						FieldOutput     = "JobNotes"				
						LanguageCode    = "#url.languagecode#"				
						Mode            = "View"					
						Key01           = "PositionParentId"
						Key01Value      = "#url.id#">			
					
				</td>
				
				<cfif history.recordcount gte "1">
				
				<td valign="top" style="padding:4px;padding-top:0px;padding-right:2px;width:50%;background-color:ffffcf" id="log">
												
				  <cf_ApplicantTextArea
						Table           = "Applicant.dbo.FunctionOrganizationNotes" 
						Domain          = "Position"
						FieldOutput     = "ProfileNotes"				
						LanguageCode    = "#url.languagecode#"				
						Mode            = "View"					
						Key01           = "FunctionId"
						Key01Value      = "#history.functionid#">		
																
				</td>
				
				</cfif>
				
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
							<td class="labelmedium2"><b><cf_tl id="Amend"></td>
							<td style="padding-left:5px"><input type="radio" name="ViewMode" id="ViewMode" class="radiol" value="view" 
							     onclick="ptoken.navigate('#session.root#/Staffing/Application/Assignment/Review/PositionProfileContent.cfm?accessmode=view&id=#url.id#&id1=#url.id1#&languagecode=#url.languagecode#','profilecontent#url.languagecode#')">
							 </td>
							<td class="labelmedium2"><cf_tl id="View"></td>
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