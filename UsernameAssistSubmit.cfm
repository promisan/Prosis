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

<cfset selDate = replace("#Form.dob#","'","","ALL")>
<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat('#SelDate#',CLIENT.DateFormatShow)#">
<cfset vDOB = dateValue>

<cfquery name="Check" 
	datasource="AppsSystem">
		SELECT	U.* 
		FROM	UserNames U 
				<!--- INNER JOIN Applicant.dbo.ApplicantSubmission ASu 
					ON U.ApplicantNo = Asu.ApplicantNo
				INNER JOIN Applicant.dbo.Applicant A
					ON Asu.PersonNo = A.PersonNo --->
		WHERE 	LTRIM(RTRIM(U.FirstName)) = '#trim(form.firstname)#'
		AND		LTRIM(RTRIM(U.LastName)) = '#trim(form.lastname)#'
		<!--- AND		A.DOB = #vDOB#  --->
</cfquery>

<!--- we now record the password request in the table 
				dbo.UserPasswordAction--->


<cfif Check.recordcount eq "0">

	<font color="FF0000"><cf_tl id="No accounts found under this criteria"></font>
	
<cfelseif trim(Check.eMailAddress) eq "">

	<font color="FF0000"><cf_tl id="No email address associated to this account"></font>
	
<cfelseif Check.recordcount gt "1">

	<font color="FF0000"><cf_tl id="Multiple accounts associated to this criteria"></font>

<cfelse>

	<script>
		document.getElementById('action').className = "hide"
	</script>

	<!--- send mail --->
	<cf_mailUserNameInfo userAccount="#check.account#">
	
	<font color="008000"><cf_tl id="An message was sent to your registered email address"></font>

</cfif>