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
<cfinclude template="../Category/CategoryScript.cfm">

<cfajaxImport>

<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ProgramPeriod
		WHERE  ProgramCode = '#url.ProgramCode#'
		AND    Period      = '#url.period#'		
</cfquery>	

 <cfinvoke component="Service.Process.Organization.Organization"  
		   method="getUnitScope" 
		   mode="Parent" 
		   OrgUnit="#get.OrgUnit#"
		   returnvariable="orgunits">	

<cf_screenTop height="100%" html="No" jQuery="Yes" scroll="yes">
	
	<cfform action="GenderSubmit.cfm?programcode=#url.programcode#&period=#url.period#" method="POST" name="program">
	 
	<table width="100%" border="0">
	<tr><td style="padding-left:10px;padding-right:10px">
		<cfset url.attach = "0">
		<cfinclude template="../Header/ViewHeader.cfm">
	</tr>	
	
	<!---
										
	<tr class="linedotted" >	
		<td class="labellarge" style="padding-left:20px"><cfoutput>#Program.ProgramClass#</cfoutput> <cf_tl id="Gender Marker"> </td>	
		<td align="right"></td>
	</tr>
	
	---> 	
		
	<tr><td style="padding-left:10px;padding-right:10px">
		
		<cfoutput>
		<input type="hidden" name="Form.ProgramCode" value="#url.programcode#">
		</cfoutput>
	
		<cfquery name="Program" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  P.*,
					O.Mission as OrgUnitMission
			FROM    #CLIENT.LanPrefix#Program P
					INNER JOIN ProgramPeriod PP
						ON P.ProgramCode = PP.ProgramCode
					INNER JOIN Organization.dbo.Organization O
						ON PP.OrgUnit = O.OrgUnit
			WHERE   P.ProgramCode = '#URL.ProgramCode#'
			AND		PP.Period = '#URL.Period#'
		</cfquery>
		
	   <cfset mission      = program.OrgUnitMission>
	   <cfset programclass = program.programclass>
	   <cfset selectarea   = "Gender Marker">	
	   	   
		<cfinvoke component="Service.Access"
			Method="Program"
			ProgramCode="#URL.ProgramCode#"
			Period="#URL.Period#"	
			Role="'ProgramOfficer'"	
			ReturnVariable="EditAccess">
						
		<cfif EditAccess eq "EDIT" or EditAccess eq "ALL">	
	   	  
	        <cfinclude template="../Category/CategoryEntryDetail.cfm">
	   
	    <cfelse>			
										
		<cfquery name="CategoryAll" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT F.Area, 
			       F.Code, 
				   F.DescriptionMemo, 
				   F.Description, 
				   S.*
			FROM   ProgramCategory S, 
			       Ref_ProgramCategory F 
			WHERE  S.ProgramCode = '#URL.ProgramCode#'
			  AND  S.ProgramCategory = F.Code
			  AND  S.Status != '9'
			  
			  <!---
			  AND  Code IN (SELECT Category 
		                    FROM   Ref_ParameterMissionCategory 
						    WHERE  Mission = (SELECT Mission FROM Program WHERE ProgramCode = '#url.programcode#') 
							<cfif orgunits neq "">
							AND    (OrgUnit = '0'  or OrgUnit IN (#preserveSingleQuotes(orgunits)#))
							<cfelse>
							AND    (OrgUnit = '0') 
							</cfif>
							
						    AND    Period is NULL or Period = '#url.Period#'
						    AND    BudgetEarmark = 0
						    AND    Operational   = 1)	  
							--->
			  
			  <!--- Tab defined --->
			  
			  AND  Area = 'Gender Marker'	
			  	
		</cfquery>
		
		<cfinvoke component="Service.Access"
			Method="Program"
			ProgramCode="#URL.ProgramCode#"
			Period="#URL.Period#"	
			Role="'ProgramOfficer'"	
			ReturnVariable="EditAccess">
			
			<cfset editAccess = "READ">
			
						
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
						
			<tr><td style="padding:10px">
			
				<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
				 				
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
					
				    <cfoutput query="CategoryAll" group="AREA">
				    
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
										Key01Value      = "#URL.ProgramCode#"
										Key02           = "ProgramCategory"
										Key02Value      = "#code#">
																				
								</td>
								
							</tr>
							
						</cfif>											
					
					<tr><td></td></tr>
					
					<tr><td colspan="3" class="linedotted"></td></tr>
					
					<tr><td></td></tr>
					
					</cfoutput>
					
					<tr><td height="4" colspan="4"></td></tr>
					
					</cfoutput>
				
					</table>
				
				</tr>
				
				</table>
			
			</td>
			</tr>
				
			</table>
 
		
		</cfif>
	  	   
	   </td>
	</tr>   
	
	<cfif EditAccess eq "EDIT" or EditAccess eq "ALL">
	
	<tr><td width="100%" align="center" style="padding-top:3px">
		<input type="submit" name="Save" value="Save" class="button10g" style="font-size:13px;width:140px;height:25px">
	</td></tr>
	
	</cfif>
	
	</table>
	
	 </cfform>	

<cf_screenbottom html="No">
