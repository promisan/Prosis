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
<cfquery name="getPersonSkills" 
	datasource="AppsSelection">
		SELECT	T.Description as Class,
				T.Question as Topic,
				T.ValueClass,
				ST.TopicValue as Value
		FROM	ApplicantSubmissionTopic ST
				INNER JOIN ApplicantSubmission S
					ON ST.ApplicantNo = S.ApplicantNo
				INNER JOIN Applicant A
					ON S.PersonNo = A.PersonNo
				INNER JOIN Ref_Topic T
					ON ST.Topic = T.Topic
				INNER JOIN Ref_TopicClass TC
					ON T.TopicClass = TC.TopicClass
		WHERE	A.EmployeeNo = '#url.personNo#'
		AND		T.Parent = 'DPASK1'
		AND		T.Operational = 1
		AND		LTRIM(RTRIM(ST.TopicValue)) <> ''
		AND		LTRIM(RTRIM(ST.TopicValue)) <> 'No'
		ORDER BY T.Description, T.ListingOrder ASC  
</cfquery>

<ul>
	<cfoutput query="getPersonSkills" group="Class">
		<li>#Class#<cfif ValueClass eq "memo">: #replace(replace(Value, "</p>", "", "ALL"), "<p>", "", "ALL")#</cfif></li>
		<cfset vListContent = "">
		<cfoutput>
			<cfif ValueClass neq "memo">
				<cfset vTopicValue = Topic>
				<cfif trim(lcase(value)) neq "yes" and trim(lcase(value)) neq "no">
					<cfset vTopicValue = vTopicValue & " #Value#">
				</cfif>
				<cfset vListContent = vListContent & ", #vTopicValue#">
			</cfif>
		</cfoutput>
		<cfif vListContent neq "">
			<cfset vListContent = mid(vListContent, 3, len(vListContent))>
			<ul>
				<li style="color:##919191; padding-bottom:5px;">#vListContent#.</li>
			</ul>
		</cfif>
	</cfoutput>
</ul>