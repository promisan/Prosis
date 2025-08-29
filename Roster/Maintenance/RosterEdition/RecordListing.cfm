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
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, 
	        
			 (SELECT  count(*) 
	           FROM   FunctionOrganization
			   WHERE  SubmissionEdition = E.SubmissionEdition 
			   AND    Status = '1') as Buckets,
			  
			 (SELECT  COUNT(DISTINCT FunctionNo + ' ' + OrganizationCode + ' ' + GradeDeployment) 
			   FROM   FunctionOrganization
			   WHERE  SubmissionEdition = E.SubmissionEdition 
			   AND    Status = '1') as BucketsLogical,
			  
			 (SELECT  COUNT(DISTINCT F.OccupationalGroup + ' ' + S.OrganizationCode + ' ' + D.PostGradebudget) 
			  FROM    FunctionOrganization S, FunctionTitle F, Ref_GradeDeployment D
			  WHERE   S.SubmissionEdition = E.SubmissionEdition 
			  AND     S.GradeDeployment = D.GradeDeployment
			  AND     F.Functionno = S.FunctionNo
			  AND     Status = '1') as OccupationalCount

	FROM   Ref_SubmissionEdition E, 
	       Ref_ExerciseClass R
	WHERE E.ExerciseClass = R.ExcerciseClass
	AND   E.Owner IN (SELECT Owner FROM Ref_ParameterOwner WHERE Operational = 1)
	ORDER BY Owner,E.ExerciseClass
</cfquery>

<cf_screentop html="No" jquery="Yes">


<table width="98%" height="100%">

<cfset add          = "1">
<cfset Header       = "Roster Submission Edition"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>

<cfoutput>

<script language = "JavaScript">

	function recordadd(grp) {
	     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=580, height=660, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit");
	}

</script>	

</cfoutput>


<tr><td>

	<cf_divscroll>

		<table width="93%" align="center" class="navigation_table">
			
			<tr class="labelmedium2 line fixlengthlist">
			    <td></td>
				<td></td>
			    <td><cf_tl id="Code"></td>
				<td><cf_tl id="Description"></td>		
				<td><cf_tl id="Post type"></td>
				<td><cf_tl id="Default status"></td>
				<td><cf_tl id="Track"></td>
				<td align="right">JO</td>
				<td align="right" style="cursor: pointer;"><cf_UIToolTip  tooltip="Unique count of Function, Grade (Budget) and Organization context">Buckets</cf_UIToolTip></td>
				<td align="right" style="cursor: pointer;"><cf_UIToolTip  tooltip="Unique count of OccGroup, Grade (Budget) and Organization context">Occup.</cf_UIToolTip></td>
				<td align="right">Expiration</td>
			</tr>
			
			<tr><td height="2"></td></tr>
			
			<cfoutput query="SearchResult" group="Owner">
			
			    <tr><td height="4"></td></tr>
				<tr><td height="4"></td></tr>
				<tr class="line labelmedium2"> 
					<td colspan="11" style="font-size:24px;height:34">#owner#</td> 
				</tr>
				
				<tr><td height="4"></td></tr>
				
				<cfoutput group="ExerciseClass">
				
					<tr class="labelmedium2 line fixlengthlist">
						<td  width="15"></td>
						<td colspan="3" style="font-size:19px;height:34">#ExerciseClass#</td>
						<td colspan="7" valign="bottom"  align="right"><cfif Roster eq "1"><font color="0080C0">All Editions under this class are included in [Generic Roster Search] unless disabled</font></cfif></td>
					</tr>
								
					<cfoutput>
					  	
					    <tr class="labelmedium2 navigation_row line fixlengthlist"> 
							<td height="18"></td>
							<td width="6%" align="center"><cf_img icon="edit" onclick="recordedit('#SubmissionEdition#')" navigation="Yes"></td>		
							<td style="padding-left:4px">
							    <a href="javascript:recordedit('#SubmissionEdition#')">#SubmissionEdition#</a>
							</td>
							<td>#EditionDescription# [#EditionShort#]</td>					
							<td><cfif PostType eq "">All<cfelse>#PostType#</cfif></td>
							<td><cfquery name="Status"
									datasource="AppsSelection" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT *
										FROM Ref_StatusCode
										WHERE Owner = '#Owner#'
										AND   Id = 'Fun'
										AND   Status = '#DefaultStatus#'
									</cfquery>								
									#Status.Meaning#
							</td>
							<td><cfif EnableAsRoster eq "1">Yes</cfif></td>
							<td align="right">#buckets#</td>
							<td align="right">#bucketsLogical#</td>
							<td align="right">#OccupationalCount#</td>
							<td align="right">#Dateformat(DateExpiration, "#CLIENT.DateFormatShow#")#</td>
						</tr>								
						
					</cfoutput>	
					
				</cfoutput>	
				
			</cfoutput>
			
		</table>

</cf_divscroll>

</td>
</tr>
</table>