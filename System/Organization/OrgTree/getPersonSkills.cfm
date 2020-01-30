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