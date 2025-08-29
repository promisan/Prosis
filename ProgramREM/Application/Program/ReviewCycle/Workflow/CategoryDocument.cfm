<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ProgramPeriodReview S 
		WHERE  S.ReviewId = '#Object.ObjectKeyValue4#'		
</cfquery>

<cfquery name="CategoryAll" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	F.AreaCode,
				F.Area, 
				F.Code, 
				F.DescriptionMemo, 
				F.Description, 
				ISNULL((SELECT ListingOrder FROM Ref_ProgramCategory WHERE Code = F.AreaCode),0) as ParentListingOrder,
				S.*
		FROM   	ProgramCategory S, 
		       	Ref_ProgramCategory F 
		WHERE  	S.ProgramCode = '#get.ProgramCode#'
		AND  	S.ProgramCategory = F.Code
		AND  	S.Status != '9'
		<!--- hardcoded --->
		AND  	Area != 'Risk'
		ORDER BY ParentListingOrder ASC, F.AreaCode ASC, F.ListingOrder ASC
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td style="padding:10px">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	 
	<tr><td class="linedotted" colspan="2"></td></tr>
	
		<tr>
	    
		<td width="99%" colspan="2" align="center">
	    <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
		<tr><td height="1" colspan="4" class="linedotted"></td></tr>
	    <TR class="linedotted">	
		    <td class="labelit" height="20"><cf_tl id="Category"></td>
			<td class="labelit" height="20"><cf_tl id="Explanation"></td>
		    <TD class="labelit"><cf_tl id="Officer"></TD>
			<TD class="labelit"><cf_tl id="Updated"></TD>	
	    </TR>
		
		<cfif CategoryAll.recordcount eq "0">
		
		<tr><td colspan="4" align="center" class="labelmedium" style="padding-top:5px"><font color="808080">There are no records to show in this view</td></tr>
		
		</cfif>
		
	    <cfoutput query="CategoryAll" group="AreaCode">
	    
		<TR><td height="25" colspan="4" class="labellarge"><b>#Area#</b></td><TR>
		<tr><td colspan="4" class="linedotted"></td></tr>
	    
		<cfoutput>
		
	    <TR class="navigation_row">    
	    <TD valign="top" style="width:100px;padding-top:4px;padding-left:20px" class="labelit">#Description#</TD>
		<TD valign="top" style="width:50%;padding-top:4px" class="labelit">#DescriptionMemo#</TD>
		<TD valign="top" class="labelit" style="padding-top:4px">#OfficerFirstName# #OfficerLastName#</TD>
		<TD valign="top" class="labelit" style="padding-top:4px">#DateFormat(Created,CLIENT.DateFormatShow)# #TimeFormat(Created,"HH:MM")#</TD>	
	    </TR>			
		
				<cfquery name="getCodes" 
					    datasource="AppsProgram" 
			   		    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
			   				SELECT *
						    FROM   Ref_ProgramCategoryProfile
						    WHERE  Code = '#Code#'			  
			    </cfquery>		
										
				<cfif getCodes.recordcount gte "1">
				
				<tr>
					
					<td colspan="4" style="padding-left:25px;padding-right:30px">
		
						<cf_ProgramTextArea
						Table           = "ProgramCategoryProfile" 
						Domain          = "Category"			
						FieldOutput     = "ProfileNotes"
						TextAreaCode    = "#quotedvalueList(getCodes.TextAreaCode)#"
						Field           = "#code#"											
						Mode            = "View"
						Key01           = "ProgramCode"
						Key01Value      = "#get.ProgramCode#"
						Key02           = "ProgramCategory"
						Key02Value      = "#code#">
																	
					</td></tr>
				
				</cfif>											
							
		<tr><td colspan="4" style="padding-left:50px;padding-right:40px">
						
			<cfquery name="getResult" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   ProgramPeriodReviewCategory S 
					WHERE  S.ReviewId = '#Object.ObjectKeyValue4#'		
					AND    S.ProgramCategory = '#code#'
			</cfquery>
			
			<textarea name="f#code#" class="regular" style="background-color:f4f4f4;font-size:13px;border-radius:3px;padding:3px;height:80px;width:100%">#getResult.AssessmentMemo#</textarea>

		
		</td></tr>

				
		<tr><td></td></tr>
		
		</cfoutput>
		
		<tr><td height="4" colspan="4"></td></tr>
		
		</cfoutput>
	
		</table>
	
	</tr>
	
	</table>

</td>
</td>

<input type="hidden" name="savecustom" id="savecustom" value="ProgramREM/Application/Program/ReviewCycle/Workflow/CategoryDocumentSubmit.cfm">

</table>


