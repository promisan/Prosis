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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="ExpClass" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     DISTINCT C.ExperienceClass, 
           C.Description as ExperienceClassDescription,
           A.ApplicantNo, 
		   A.ExperienceId, 
		   C.Parent
FROM       ApplicantBackgroundField A, Ref_Experience R, Ref_ExperienceClass C
WHERE      A.ExperienceFieldId = R.ExperienceFieldId
AND        R.ExperienceClass   = C.ExperienceClass 
AND        A.ExperienceId        = '#URL.ID#'
AND        C.Parent IN (#PreserveSingleQuotes(Group)#)
AND        C.Parent IN (SELECT Parent FROM Ref_ExperienceParentTopic)
</cfquery>

<cfoutput>
<input type="hidden" name="applicantNo" value="#URL.ID1#">
<input type="hidden" name="experienceid" value="#URL.ID#">
</cfoutput>

<cfset line = 0>

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="left" class="line">

<cfloop query="ExpClass">

<tr><td colspan="4" class="labelmedium"><cfoutput><b>&nbsp;<cf_tl id="Generic skills"> #ExpClass.ExperienceClassDescription#</b></cfoutput></td></tr>

<cfquery name="TopicAll" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    '#ExperienceClass#' as ExperienceClass, T.FieldTopicId, T.Description, 'Selected' AS Selected
	FROM      ApplicantBackgroundClassTopic FT INNER JOIN
              Ref_ExperienceParentTopic T ON FT.FieldTopicId = T .FieldTopicId
	WHERE     T.Parent = '#Parent#'
	AND       FT.ExperienceClass = '#ExperienceClass#' 
	AND       FT.ExperienceId = '#URL.ID#'
	
	UNION
	
	SELECT    '#ExperienceClass#' as ExperienceClass, T.FieldTopicId, T.Description, NULL AS Selected
	FROM      Ref_ExperienceParentTopic T
	WHERE     (T.Parent = '#Parent#') AND FieldTopicId NOT IN
                    (SELECT FieldTopicId
                     FROM   ApplicantBackgroundClassTopic
                     WHERE  ExperienceClass = '#ExperienceClass#' 
					 AND    ExperienceId = '#URL.ID#')
		 
   </cfquery>
							
    <cfset rows = 0>
	<cfset cntx = 0>
							
	<cfoutput query="TopicAll">
														
	<cfif rows eq "2">
		    <TR>
			<cfset rows = 0>
			<cfset cntx = cnt+27>
	</cfif>
				
	    <cfset rows = rows + 1>
		<cfset line = line + 1>
			<td width="25%" class="regular">
			<table width="100%" bgcolor="white">
				<cfif Selected eq "">
				          <TR class="regular">
				<cfelse>  <TR class="highlight2">
				</cfif>
				<td width="5%" class="regular"></td>
			   	<td width="85%" class="labelmedium">#Description#..</font></td>
				<TD width="10%" class="regular">
				<cfset c = 1>
				<input type="hidden" name="classid_#line#" value="#ExperienceClass#">
				
				<cfif Selected eq "">
				<input type="checkbox" name="topicid_#line#" value="#FieldTopicId#"></TD>
				<cfelse>
				<input type="checkbox" name="topicid_#line#" value="#FieldTopicId#" checked></td>
			    </cfif>
			</table>
			</td>
			<cfif TopicAll.recordCount eq "1">
				<td width="25%" class="regular"></td>
			</cfif>
			
		<cfif rows eq "2">
		    </TR>
		</cfif>	
		
	 </CFOUTPUT>
									
</cfloop>

</table>

<input type="hidden" name="Line" value="<cfoutput>#line#</cfoutput>">
	
