<!--
    Copyright © 2025 Promisan

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

<cfset actionform = "Vacancy">

<cfparam name="url.wParam" default="JobProfile">
<cfif url.wParam eq "">
  <cfset url.wParam = "JobProfile">
</cfif>

<cfswitch expression="#url.wParam#">
	
	<cfcase value="JobProfile">
		<cfset domain = "JobProfile">	
	</cfcase>
	
	<cfcase value="ToR">
		<cfset domain = "JobProfile">	
	</cfcase>	
	
	<cfcase value="Preliminary">
		<cfset domain = "Preliminary">	
	</cfcase>	

</cfswitch>

<cfquery name="Doc" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  D.*, 
	        F.FunctionId     as VAId, 
			F.ReferenceNo    as VAReferenceNo,
			F.DateEffective  as VAEffective,
			F.DateExpiration as VAExpiration
    FROM  	Document D LEFT OUTER JOIN Applicant.dbo.FunctionOrganization F ON D.FunctionId = F.FunctionId
    WHERE 	D.DocumentNo = '#Object.ObjectKeyValue1#'	
</cfquery>

<table width="98%" align="center" bgcolor="white">
         
  <tr>
    <td colspan="2">
	
    <table width="100%" align="center" class="formpadding">
			
	<TR class="labelmedium line">
    <TD><cf_tl id="Functional title">:</TD>
    <td><cfoutput>#Doc.FunctionalTitle#</cfoutput></td>
	<TD><cf_tl id="Grade deployment">:</TD>
    <td><cfoutput>#Doc.GradeDeployment#</cfoutput>
	</td>
	</TR>	
	
	<cf_calendarScript>
	
	<cfif url.wParam neq "ToR">
	
		<TR class="labelmedium line">
		
	    <TD><cf_UITooltip Tooltip="Record only if this number is already known"><cf_tl id="Job Opening No">:</cf_UITooltip></TD>
	    	
		<cfif Doc.VAId neq "">
					
			<td colspan="3">
	    	<cfoutput>
			<input type="text" name="ReferenceNo" class="regularxxl" value="#Doc.VAReferenceNo#" size="10" maxlength="20">
			<input type="hidden" name="FunctionId" value="#Doc.VAId#">
			</cfoutput>
			</td>
		
		<cfelse>
		
			<td colspan="3">
	    	<cfoutput>
			<input type="text" name="ReferenceNo" class="regularxxl" value="" size="10" maxlength="20">
			<input type="hidden" name="FunctionId" value="">
			</cfoutput>
			</td>
						
		</cfif>
		
		</TR>	
		
	<cfelse>
	
		<tr>
			<td colspan="3">
		    	<cfoutput>
				<input type="hidden" name="ReferenceNo" class="regularxxl" value="" size="10" maxlength="20">
				<input type="hidden" name="FunctionId" value="">
				</cfoutput>
			</td>
		</tr>
				
	</cfif>	
		
	<cfif url.wParam neq "ToR">
		
		<TR class="labelmedium line">
	    <td><cf_tl id="Announcement effective">:</td>
	    <TD>
					  		
			<cf_intelliCalendarDate9
				FieldName="DateEffective" 
				class="regularxxl"
				Default="#Dateformat(Doc.VAEffective, CLIENT.DateFormatShow)#"
				AllowBlank="False">	
					
		</td>
		<td><cf_tl id="Announcement expiration">:</td>
		<td>
		
			   <cf_intelliCalendarDate9
				FieldName="DateExpiration" 
				class="regularxxl"
				Default="#Dateformat(Doc.VAExpiration, CLIENT.DateFormatShow)#"
				AllowBlank="False">	
				
		</td>
		</TR>	
	
	</cfif>
		
	
	<cfif url.wParam neq "ToR">
	
	<tr><td style="height:10px"></td></tr>
	
	<tr class="labelmedium"><td style="font-size:25px;font-weight:bold" colspan="4"><cf_tl id="Candidate Assessment Core Competencies"></td></td>	
	
	<tr><td colspan="4">
	
			<table width="99%" align="center" class="formpadding">
		   	
			<tr><td height="10px"></td></tr>
			 
			 <cfquery name="GetCompetencies" 
				 datasource="AppsSelection" 
				 username="#SESSION.Login#" 
				 password="#SESSION.dbpw#">
					  
				SELECT  CC.Description AS Category,
				        C.*,
				        (SELECT FOC.FunctionId
					     FROM   FunctionOrganizationCompetence FOC
						 WHERE  FOC.CompetenceId = C.CompetenceId
						 <cfif doc.VaId neq "">
						 AND   FOC.FunctionId = '#doc.VaId#'
						 <cfelse>
						 AND 1=0
						 </cfif>) as FunctionId		
			    FROM     Ref_Competence C
					     INNER JOIN Ref_CompetenceCategory CC ON C.CompetenceCategory = CC.Code
				WHERE    C.Operational = 1
				ORDER BY CC.Code, ListingOrder			  
			</cfquery>
				
			<cfset columns= 3>
			
			<tr>
				<td>
					
					<table width="99%" align="center">
			
					<cfoutput query="GetCompetencies" group="Category">
					 
					 	<cfset cont   = 0>
					 
						 <tr class="line">
						 	<td class="labellarge" colspan="#columns*2#">#Category#</td>
						 </tr>
						
						 <cfoutput>
						 	
							<cfif cont eq 0> <tr> </cfif>
							
							<cfif FunctionId neq "">
							   <cfset cl = "ffffcf">
							<cfelse>
							   <cfset cl = "ffffff">
							</cfif>
							
					 		<td style="background-color:###cl#" 
							    style="cursor:pointer;width:30px" align="center" class="labelmedium">
								<input type="checkbox" class="radiol" value="#CompetenceId#" name="Competence" <cfif FunctionId neq "">checked</cfif>>
								</td>
								<td class="labelmedium" style="width:30%;padding-left:4px">#Description#</td>
								<cfset cont = cont + 1>
							</td>
							<cfif cont eq columns> </tr> <cfset cont = 0> </cfif>
							
				 		  </cfoutput>
						  
						  <tr><td colspan="#columns*2#" height="15px"></td></tr>
					
					</cfoutput>
					
					</table>
		
				</td>
			</tr>	
					
		</table>
		
	</td></tr>	
	
	</cfif>
		
	<tr class="labelmedium"><td style="font-size:25px;font-weight:bold" height="2" colspan="4"><cf_tl id="Job Qualifications and special skills"></td></td>
	
	<tr><td height="2" colspan="4">
			
	<cfif Doc.VAId eq "">
	
		 <cf_ApplicantTextArea
			Table           = "FunctionTitleGradeProfile" 
			Domain          = "#domain#"
			FieldOutput     = "ProfileNotes"
			Mode            = "Edit"
			Key01           = "FunctionNo"
			Key01Value      = "#Doc.FunctionNo#"
			Key02           = "GradeDeployment"
			Key02Value      = "#Doc.GradeDeployment#">
		
	<cfelse>
					
		   <cf_ApplicantTextArea
			Table           = "FunctionOrganizationNotes" 
			Domain          = "#domain#"
			FieldOutput     = "ProfileNotes"
			Mode            = "Edit"
			Key01           = "FunctionId"
			Key01Value      = "#Doc.VAId#">
			
	</cfif>	
			
	</td></tr>	
		
</TABLE>

</td>

</tr>

</table>

<cfoutput>
<input name="Key1"       type="hidden"  value="#Object.ObjectKeyValue1#">
<input name="savecustom" type="hidden"  value="Vactrack/Application/Announcement/DocumentSubmit.cfm">
<input name="savetext"   type="hidden"  value="1">
</cfoutput>
