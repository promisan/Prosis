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
<cfparam name="URL.PersonNo"     default=""> 
<cfparam name="URL.ApplicantNo"  default=""> 
<cfparam name="URL.Owner"        default=""> 
<cfparam name="URL.Area"         default=""> 

<cfparam name="URL.Attachment"   default="">

<cfquery name="TopicList" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT      R.Parent, 
	            P.Description AS ParentDescription, 
			    R.Description, 
			    R.Question, 
			    R.TopicClass, 
			    C.Description AS TopicClassDescription, 
			    A.ApplicantNo, 
			    A.Topic, 
			    A.ListCode, 
                A.TopicValue
	FROM        ApplicantSubmission S INNER JOIN
	            ApplicantSubmissionTopic A ON S.ApplicantNo = A.ApplicantNo INNER JOIN
                Ref_Topic R ON A.Topic = R.Topic INNER JOIN
                Ref_TopicClass C ON R.TopicClass = C.TopicClass INNER JOIN
                Ref_ExperienceParent P ON R.Parent = P.Parent
	<cfif url.personno eq "">		 			
	WHERE       A.ApplicantNo = '#url.applicantno#' 
	<cfelse>
	WHERE       S.PersonNo = '#url.personno#' 
		<cfif URL.Source neq ""> 
			AND         S.Source   = '#url.source#'
		</cfif>	 
	</cfif>
	<cfif url.owner neq "">
	AND         R.Topic IN (SELECT Topic FROM Ref_TopicOwner WHERE Owner = '#url.owner#')
	</cfif>
	<cfif url.area neq "">
	AND         (P.Area = '#url.area#' OR P.Area = 'Miscellaneous')
	</cfif>	
	<cfif URL.Attachment neq "">
		AND R.Attachment = '#URL.Attachment#'
	</cfif>
		
	AND         (len(TopicValue) >= 1 or ListCode <> '')
	AND         TopicValue != '0' 
	ORDER BY    P.SearchOrder, R.ListOrder	
		
</cfquery>


<table width="100%">
	
	<cfoutput query="TopicList" group="ParentDescription">
	
	    <tr><td colspan="2" bgcolor="E6E6E6" class="labellarge" style="padding-left:8px;height:45px;font-size:26px"><cf_tl id="#ParentDescription#"></td></tr>
	
		<cfoutput group="TopicClass">
		
		    <cfif ParentDescription neq TopicClassDescription>
			<tr><td colspan="2" bgcolor="EaEaEa" class="labelmedium" style="padding-bottom:5px;padding-left:15px;font-size:19px">#TopicClassDescription#</td></tr>
			</cfif>
						
			<cfoutput>
			
			<tr class="linedotted">
				<td valign="top" style="width:40%;padding-left:25px;" class="labelmedium">#Question#</td>
				<td valign="top" class="labelmedium" style="padding-left:4px">
				<cfif topicvalue neq "">
				#topicvalue#
				
				<cfelseif listcode neq "">
				
				<cfset cnt = 0>
				
				<cfloop index="itm" list="#listcode#">		
								
					<cfquery name="getValue" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      *
						FROM        Ref_TopicList
						WHERE       Code = '#Topic#' 
						AND         ListCode = '#itm#'
					</cfquery>
					
					 <cfif cnt gte "1"> / </cfif> #getValue.ListValue#
					
					<cfset cnt = cnt+1>
				
				</cfloop>
				
				
				</cfif>
				</td>
			</tr>
			
			</cfoutput>
	
		</cfoutput>
		
	</cfoutput>

</table>