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
<!--- forecast view 

Select the buckets
Outflow rules
Review demand/st
Turn-over expectations
Show roster health by month.

--->

<table>
<tr><td>The feature will allow manager to</td></tr>
	<tr><td>- select buckets</td></tr>
	<tr><td>- view demand base ST</td></tr>
	<tr><td>- define outflow expectations</td></tr>
	<tr><td>- show roster health by month for the next 24 months</td></tr>
</table>

<br>

<cfinclude template="ForecastQuery.cfm">


<cf_screentop height="100%" html="No" scroll="Yes">

<table width="95%" cellspacing="0" border="0" bordercolor="silver" cellpadding="0" align="center" class="formpadding">

	<cfquery name="Bucket" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT     B.SubmissionEdition,
	           S.EditionDescription, 
			   B.OccupationalGroup,
			   O.Description, 
			   G.Description AS GradeDescription, 
			   B.OrganizationCode, 
               R.OrganizationDescription, 
			   G.PostGradeBudget, 
			   GB.PostOrderBudget
	FROM       FunctionBucket B INNER JOIN
               OccGroup O ON B.OccupationalGroup = O.OccupationalGroup INNER JOIN
               Ref_GradeDeployment G ON B.GradeDeployment = G.GradeDeployment INNER JOIN
               Ref_SubmissionEdition S ON B.SubmissionEdition = S.SubmissionEdition INNER JOIN
               Ref_Organization R ON B.OrganizationCode = R.OrganizationCode INNER JOIN
               Employee.dbo.Ref_PostGradeBudget GB ON G.PostGradeBudget = GB.PostGradeBudget
	ORDER BY B.SubmissionEdition, B.OccupationalGroup, B.OrganizationCode, GB.PostOrderBudget	
	</cfquery>
	
	<!---
			
	<cfquery name="Bucket" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT     B.SubmissionEdition, 
		           S.EditionDescription, 
				   B.OccupationalGroup, 
				   O.Description, 
				   B.GradeDeployment, 
				   G.ListingOrder AS GradeOrder, 
	               G.Description AS GradeDescription, 
				   B.FunctionNo, 
				   F.FunctionDescription, 
				   B.OrganizationCode, 
				   R.OrganizationDescription
	    FROM       FunctionBucket B INNER JOIN
	               OccGroup O ON B.OccupationalGroup = O.OccupationalGroup INNER JOIN
	               FunctionTitle F ON B.FunctionNo = F.FunctionNo INNER JOIN
	               Ref_GradeDeployment G ON B.GradeDeployment = G.GradeDeployment INNER JOIN
	               Ref_SubmissionEdition S ON B.SubmissionEdition = S.SubmissionEdition INNER JOIN
	               Ref_Organization R ON B.OrganizationCode = R.OrganizationCode
	    ORDER BY   B.SubmissionEdition, 
		           B.OccupationalGroup, 
				   G.ListingOrder, 
				   F.FunctionDescription 
	</cfquery>
	
	--->
	
	<cfoutput query="Bucket" group="SubmissionEdition">
	
		    <tr><td>#EditionDescription#</td></tr>
			<cfoutput group="OccupationalGroup">
			<tr><td>#Description#</td></tr>
				<cfoutput group="OrganizationCode">
				<tr><td></td><td>#OrganizationDescription#</td></tr>
					<cfoutput>
					<tr><td></td><td></td>
					    <td>#PostGradeBudget#</td>
						<td></td>
						<td width="50%">
						
						
						
						</td>
						</tr>
					</cfoutput>	
				</cfoutput>
			</cfoutput>
	</cfoutput>

</table>

<!--- 

How to forecast

- Initial work to be performed

i.   People currently performing the Functional title / Grade in the mission are these considered rostered : Yes ?
ii.  People that performed the job in the past : No ?
iii.


- A. Define starting situation per bucket current levels )FCRB + Rostered

- B. Dededuct people IN the roster have been selected less than N days ago, which

--- = opening balance

- C. Define number of vacancies currently being processed for that grade/title

---- = corrected opening balance

- D0 Define ratio at opening balance

			Demand (= summed per Function/PostGrade per mission) 

			vs 
			
			Roster 	(= Rostered but not performing [A] + People currently performing [B]) 
			
			= CoverRatio

	
- D1 Apply antipated Demand per mission in the coming 12 months based on Business Rule assumptions per mission on increase/decrease 
needs per bucket = % increase / decrease

- D2 Anticipate Roster outflow because of Retirement (age) in 12 months

- D3 Apply Roster inflow from missions due to decreased demand (redeployment) = #number (relates ~ D1, but not all decrease will
result in increased numbers for [A])

- D4. Mark down the rostered candidates [A] for normal wear and tear of the rostered by decreasing NN% per month as candidate move out, are not interested
in UN anymore or not interested in the job anymore.

- D9 : calculate the expected CoverRatio per bucket by applying D1..D4 correction and compare this with the target of 125% (I saw something like that)

>> i don't agree with the ratio 3 times * vacant post ; that one does not make sense inthe above <<

- then Take action on the result.

--->
	