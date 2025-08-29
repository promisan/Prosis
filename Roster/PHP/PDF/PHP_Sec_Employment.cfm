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
<!--- *************************************************************************** --->
<table width="100%" border="0" align="center" >
	<tr></tr>	
	<tr><td class="title">Employment</td></tr>
	<tr><td bgcolor="333333"></td></tr>
	<tr></tr>
	<table width="95%" border="0" align="center" >
		<tr><td>26. Starting with your present post, list in reverse order every employment you have had:</td></tr>

	<cfquery name="Work"
	dbtype="query">
		SELECT * 
	   	FROM  Experience
	   	WHERE ExperienceCategory = 'Employment' 
	</cfquery>
				
	<tr></tr>

	<cfloop query="Work" startrow="1" endrow="40">
			
	<cfoutput>
	<tr><td>

	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

	<tr><td>

	<table width="100%" border="0" align="center" >
		<tr>
		<td width="50%">Job Title</td>
		<td width="30%">Type of Business</td>
		<td >From - To</td>
		</tr>
		<tr>
		<td><b>#Work.ExperienceDescription#</b></td>
		<td><b>#Work.OrganizationClass#</b></td>
		<td><b>#Trim(Dateformat(Work.ExperienceStart, CLIENT.DateFormatShow)) & ' - ' & Dateformat(Work.ExperienceEnd, CLIENT.DateFormatShow)#</b></td>
		</tr>
		
		<tr></tr>

		<tr>
		<td colspan="2">Name of Employer</td>
		<td>Name of Supervisor</td>
		</tr>
		<tr>
		<td colSpan="2"><b>#Work.OrganizationName#</b></td>
		<td><b>#Work.SupervisorName#</b></td>   
		</tr>

	</table>
	</td></tr>
	
	<tr></tr>
	
	<tr><td>
	<table width="100%" border="0" align="center" >
		<tr>
		<td width="15%">Salaries per Annum:</td>
		<td width="15%"></td>
		<td width="20%"></td>
		<td width="50%"></td>
		</tr>
		<tr>
		<td>Starting</td>
		<td>Final</td>
		<td>Currency Paid</td>
		<td>Is this a civil servant position of your Government? 
			<b><cfif #Work.OrganizationCivil# eq "1">Yes<cfelse>No</cfif></b></td>  
		</tr>
		<tr>
		<td><b>#Work.SalaryStart#</b></td>
		<td><b>#Work.SalaryEnd#</b></td>
		<td><b>#Work.SalaryCurrency#</b></td>
		<td>Is this a position within the UN Common System? 
		   <b><cfif #Work.OrganizationRelated# eq "1">Yes<cfelse>No</cfif></b></td>
		</tr>
		<tr>

		<tr></tr>

		<td Colspan="3">Telephone Number</td>
		<td>Email Address</td>
		</tr>
		<tr>
		<td Colspan="3"><b>#Work.OrganizationTelephone#</b></td>
		<td><b>#Work.OrganizationEMail#</b></td>   
		</tr>

		<tr></tr>
		
		<cfquery name="Address_Country" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT Name
		   	FROM  Ref_Nation
		   	WHERE Code = '#Work.OrganizationCountry#'
			</cfquery>	
		

		<td Colspan="4">Address of Employer</td>
		</tr>
		<tr>
		<td Colspan="4"><b>#Work.OrganizationCity# #Address_Country.Name#</b></td>
		</tr>

		<tr></tr>

		<tr>
		<td Colspan="4">Number of Employees Supervised by you: <b>#Work.StaffSupervised#</b></td>
		</tr>

		<tr></tr>

		<cfquery name="BackQuestion"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT Topic, Question
			    FROM Ref_Topic
				WHERE Parent = 'Experience'
				ORDER BY Topic
		</cfquery>		

	<cfif prefix eq "">			
		<cfquery name="WorkTopic" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TopicValue, Topic
			    FROM ApplicantBackGroundDetail
				WHERE ApplicantNo = '#Work.ApplicantNo#'
				AND   ExperienceID = '{#Work.ExperienceID#}'
		</cfquery>
			
	<cfelse>
		<cfquery name="WorkTopic" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TopicValue, Topic
			    FROM ApplicantFunctionSubmissionDetail
				WHERE   SubmissionId = '#Work.SubmissionId#'
		</cfquery>
			
	</cfif>	
	
	<cfset sel = "">
	<cfloop query="BackQuestion">
		<cfif sel eq "">
			<cfset sel = "'#Topic#'">			
		<cfelse>
		    <cfset sel = "#sel#,'#topic#'">
		</cfif>	
	</cfloop>
	
	<cfquery dbtype="query" name="Answer">
		SELECT Topic,TopicValue
		FROM  WorkTopic
		WHERE Topic IN (#preservesinglequotes(sel)#) 
	</cfquery>
		
	<cfloop Query="answer">
	
	<cfset INum = "0">
	
	<cfset INum = #INum#+1>
	
		<cfif INum lt "10">
			<cfset QNum = "0#INum#">
		<cfelse>
			<cfset QNum = "#INum#">
		</cfif>
		
		<cfquery name="BackQuestion"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT *
			    FROM Ref_Topic
				WHERE Parent = 'Experience'
				AND Topic = '#topic#'
				ORDER BY Topic
		</cfquery>
		
		<tr><td Colspan="4">#BackQuestion.Question#</td></tr>
		<tr><td Colspan="4" class="tdata">#TopicValue#</td></tr>
		<tr></tr>
	
    </cfloop>
	
	</table>
	<tr></tr>

	</td></tr>

	</table>
	<tr></tr>
	</cfoutput>	
	
		
	</td></tr>	
</cfloop>
</table>		

</table>

<cfif un eq "1">

<tr></tr>
<!--- GENERAL EMPLOYMENT QUESTIONS --->
<cfset E1 = "Have you any objections to our making inquiries of your present employer?">
<cfset E2 = "Other Agencies of the Organizations System may be interested in our applicants.  Do you have any objections to your Personal History Profile being made available to them?">
<cfset E3 = "For clerical grades only:">
<cfset E4 = "Indicate typing speed in words per minute: English - ">
<cfset E5 = "French - ">
<cfset E6 = "List any office machines or equipment you can use:">
	
<table width="95%" border="0" align="center" >
	<cfoutput>
	<tr><td>#E1#&nbsp;&nbsp;&nbsp;<b><cfif GALApplicant.SUBM_ObjectionsEmployer eq "1">Yes<cfelse>No</cfif></b></td></tr>	
	<tr></tr>
	<tr><td>#E2#&nbsp;&nbsp;&nbsp;<b><cfif GALApplicant.SUBM_Other_Agencies eq "1">Yes<cfelse>No</cfif></b></td></tr>	
	<tr></tr>
	<tr><td>#E3#</td></tr>	
	<tr><td>#E4#&nbsp;&nbsp;&nbsp;<b>#GALApplicant.SUBM_Typing_English#</b>&nbsp;&nbsp;&nbsp;#E5#&nbsp;&nbsp;&nbsp;<b>#GALApplicant.SUBM_Typing_French#</b></td></tr>	
	<tr><td>#E6#</td></tr>		
	<tr><td><b>#GALApplicant.SUBM_OfficeEquipment#</b></td></tr>		
	</cfoutput>
</table>

</cfif>


</body>
</html>
