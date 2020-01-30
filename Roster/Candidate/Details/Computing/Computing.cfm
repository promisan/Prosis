
<cfparam name="URL.source" 		 default="Manual">  
<cfparam name="URL.section"      default="">  
<cfparam name="URL.entryScope"   default="Backoffice">

<cfif URL.entryScope eq "Backoffice">
	
	<cfinvoke component="Service.Access"  
 	method="roster" 
 	returnvariable="AccessRoster"
 	role="'AdminRoster','CandidateProfile','RosterClear'">
 	
 <cfelseif URL.entryScope eq "Portal">
 
 	<cfset AccessRoster = "ALL">
 
</cfif>
  
<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Parameter
</cfquery>

<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   A.*, 
	         F.ExperienceFieldId,
	         F.ExperienceLevel,
			 <!---
			   F.ReviewLastName, 
			   F.ReviewFirstName,
			   F.ReviewDate,
			 --->
		     F.Status as StatusDomain,
	         R.Description,
		     R.ExperienceClass,
		     S.Source,
		     C.Description as ClassDescription
    FROM     ApplicantSubmission S,
	         ApplicantBackGround A, 
	         ApplicantBackgroundField F, 
		     Ref_Experience R,
		     Ref_Source Source,
		     Ref_ExperienceClass C
    WHERE    S.PersonNo = '#URL.ID#'
	AND      S.Source = '#url.source#'	
	AND      S.Source = Source.Source	
	AND      F.ApplicantNo = S.ApplicantNo
	AND      F.ApplicantNo = A.ApplicantNo
	AND      R.ExperienceClass = C.ExperienceClass
	AND      F.ExperienceId = A.ExperienceId
	AND      A.Status != '9'
	AND      A.ExperienceCategory = 'Miscellaneous'
	AND      F.ExperienceFieldId = R.ExperienceFieldId  
	ORDER BY ClassDescription,ExperienceStart DESC
</cfquery>

<cfparam name="url.applicantno" default="#Detail.ApplicantNo#">

<cfset URL.ID1 = Detail.ExperienceId>

<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">

 	<cfif Detail.recordcount eq "0">
	
	   <cfinclude template="ComputingEntry.cfm">
	   	   
	<cfelse>
	
	    <cfif URL.topic neq "All"> <!--- and CLIENT.submission eq "Skill" --->
		    <cfinclude template="ComputingEntry.cfm">
		<cfelse>
				
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
							
				<tr><td colspan="2" align="center" style="height:35px">
				  <cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
				  
				     <cfoutput>
				     <input class = "button10g"
						  onclick = "#ajaxLink('#SESSION.root#/roster/candidate/details/Computing/ComputingEntry.cfm?applicantno=#url.applicantno#&section=#url.section#&entryScope=#url.entryScope#&id=#url.id#&id1=#url.id1#&id2=#url.id2#&topic=#url.topic#&source=#url.source#')#"
						  style   = "width:190px;height:25" 
						  type    = "submit" 
						  name    = "editcompetence" 
						  value   = "Update competencies">
					 </cfoutput>	  
					 
				  </cfif>	 
				</td></tr>
							
			</table>
			
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
								 
			<tr><td width="100%" colspan="2">
				    <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				
				<cfif URL.Topic neq "All">
					
					<tr>
					<td colspan="5" height="23" style="padding-left:4px"><b><cf_tl id="Computing skills"></b></td>
			   		</tr> 
				</cfif>
				
				<cfif detail.recordcount eq "0">
				
					<tr>
					<td colspan="5" align="center"><font color="C0C0C0"><cf_tl id="No records found in this view"></b></td>
					</TR>
				
				</cfif>
				
				<cfoutput query="Detail" group="ExperienceClass">
					<tr><td colspan="4" class="labelmedium"><b>#ClassDescription#</td></tr>
					<tr><td></td><td colspan="5" class="linedotted"></td></tr>
				<cfoutput>
								
				<TR>				
					<td></td>
				    <TD class="labelit">#Description#</TD>
					<TD class="labelit" style="padding-left:4px">
					<cfswitch expression="#ExperienceLevel#">
						<cfcase value="1"><cf_tl id="Occasional"></cfcase>
						<cfcase value="2"><cf_tl id="Daily"></cfcase>
					</cfswitch>
					</TD>
					<TD class="labelit">#DateFormat(Created,CLIENT.DateFormatShow)#</TD>
					<TD></TD>
				</TR>
				<tr><td></td><td colspan="5" class="linedotted"></td></tr>
				</CFOUTPUT>
				</CFOUTPUT>
				</table>
				</td>
			</tr>
			</table>
												
		</cfif>   
	</cfif>
</cfif>	
