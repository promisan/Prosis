<cfparam name="url.source" default="Manual">

<cfinvoke component="Service.Access"  
 method="roster" 
 returnvariable="AccessRoster"
 role="'AdminRoster','CandidateProfile','RosterClear'">
 
<cfquery name="Topic" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_ParameterSkill
  WHERE  Code = '#URL.Topic#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
	 SELECT    A.Created as LastUpdated, R.*
	 FROM      ApplicantSubmission S, ApplicantCompetence A, Ref_Competence R
	 WHERE     A.CompetenceId = R.CompetenceId
	 AND       S.ApplicantNo  = A.ApplicantNo
	 AND       S.PersonNo     = '#URL.ID#'
	 AND       S.Source       = '#url.source#'
	 ORDER BY  CompetenceCategory, ListingOrder 
	 
</cfquery>

<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL"> 

	<cfif Detail.recordcount eq "0" <!--- and #CLIENT.submission# eq "Skill" --->>
	
	    <cfinclude template="CompetenceEntry.cfm">
		
	 <cfelse>
	 
	    <cfif URL.topic neq "All" > <!---- and #CLIENT.submission# eq "Skill" Removed by Armin May 5th 2011 --->
		    <cfinclude template="CompetenceEntry.cfm">
		<cfelse>
						
			<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">
			
			<!--- maybe best to disabled it if the source does not allow for entry, but for now we allow --->
										
				<tr>
				  <td colspan="2" style="height:40" align="right">
				  <cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
				     <cfoutput>
				     <input class="button10s"
						  onclick="#ajaxLink('#SESSION.root#/roster/candidate/details/Competence/CompetenceEntry.cfm?id=#url.id#&id2=#url.id2#&topic=#url.topic#&source=#url.source#')#"
						  style="width:150px;height:24" 
						  type="submit" 
						  name="editcompetence" 
						  value="Update competencies">
					 </cfoutput>	  
				  </cfif>	 
				  </td>
				</tr>
										
			</table>
			
			<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
			
			<tr>
			    <td width="100%" colspan="2">
				
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

				 <cfif URL.Topic neq "All">			 
				 <tr>
				 	<td class="top3n" colspan="5" height="23" class="labelit"><b><cf_tl id="Competencies"></b></td>
				 </tr>
				 </cfif>
							
				<cfif detail.recordcount eq "0">
								
					<tr>
						<td colspan="3" align="center" class="labelit"><b><cf_tl id="No records found"></b></td>
					</TR>
				
				</cfif>
				
				<cfoutput query="Detail">
									
					
						<TR class="linedotted labelit">
							<TD>#CompetenceCategory#</TD>
						    <TD>#Description#</TD>
							<TD>#DateFormat(LastUpdated,CLIENT.DateFormatShow)#</TD>						
						</TR>
															
				</CFOUTPUT>
				
				</table>
			
			</td>
			</tr>
			
			</table>
				
		</cfif>   
	</cfif>
</cfif>	