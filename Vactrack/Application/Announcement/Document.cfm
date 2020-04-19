
<cfset actionform = "Vacancy">

<cfparam name="url.wParam" default="JobProfile">
<cfif url.wParam eq "">
  <cfset url.wParam = "JobProfile">
</cfif>

<cfquery name="Doc" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  D.*, 
	        F.FunctionId as VAId, 
			F.ReferenceNo as VAReferenceNo,
			F.DateEffective as VAEffective,
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
	
	<TR class="labelmedium line">
    <TD><cf_UITooltip Tooltip="Record only if this number is already known"><cf_tl id="Job Opening No">:</cf_UITooltip></TD>
    	
	<cfif Doc.VAId neq "">
				
		<td colspan="3">
    	<cfoutput>
		<input type="text" name="ReferenceNo" class="regularxl" value="#Doc.VAReferenceNo#" size="10" maxlength="20">
		<input type="hidden" name="FunctionId" value="#Doc.VAId#">
		</cfoutput>
		</td>
	
	<cfelse>
	
		<td colspan="3">
    	<cfoutput>
		<input type="text" name="ReferenceNo" class="regularxl" value="" size="10" maxlength="20">
		<input type="hidden" name="FunctionId" value="">
		</cfoutput>
		</td>
					
	</cfif>
	
	</TR>	
	
	<TR class="labelmedium line">
    <td><cf_tl id="Announcement effective">:</td>
    <TD>
	
	    <cfoutput>
		
		<cf_intelliCalendarDate9
			FieldName="DateEffective" 
			class="regularxl"
			Default="#Dateformat(Doc.VAEffective, CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		
		<input name="Key1"       type="hidden"  value="#Object.ObjectKeyValue1#">
	    <input name="savecustom" type="hidden"  value="Vactrack/Application/Announcement/DocumentSubmit.cfm">
	    <input name="savetext"   type="hidden"  value="1">
		
		</cfoutput>
		
	</td>
	<td><cf_tl id="Announcement expiration">:</td>
	<td>
	
		   <cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			class="regularxl"
			Default="#Dateformat(Doc.VAExpiration, CLIENT.DateFormatShow)#"
			AllowBlank="False">	
			
	</td>
	</TR>		
	
	<tr><td height="2" colspan="4">
			
	<cfif Doc.VAId eq "">
		
		 <cf_ApplicantTextArea
			Table           = "FunctionTitleGradeProfile" 
			Domain          = "#url.wParam#"
			FieldOutput     = "ProfileNotes"
			Mode            = "Edit"
			Key01           = "FunctionNo"
			Key01Value      = "#Doc.FunctionNo#"
			Key02           = "GradeDeployment"
			Key02Value      = "#Doc.GradeDeployment#">
		
	<cfelse>
				
		   <cf_ApplicantTextArea
			Table           = "FunctionOrganizationNotes" 
			Domain          = "#url.wParam#"
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
