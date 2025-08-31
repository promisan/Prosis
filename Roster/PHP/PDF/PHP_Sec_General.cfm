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
<html>
<head>
<title>PHP General</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfset Q1 = "1. Family name">
<cfset Q2 = "First Name">
<cfset Q3 = "Middle Name">
<cfset Q4 = "Maiden Name, (if any)">
<cfset Q5 = "2. Date of Birth">
<cfset Q6 = "3. City of Birth">
<cfset Q7 = "Country of Birth">
<cfset Q8 = "Index No">
<cfset Q9 = "4. Country of Nationality at Birth">
<cfset Q10 = "Second Nationality (if any)">
<cfset Q11= "5. Country of Present Nationality">
<cfset Q12 = "Second Nationality (if any)">
<cfset Q13 = "6. Gender">
<cfset Q14 = "7. Height [cm]">
<cfset Q15 = "8. Weight [kg]">
<cfset Q16 = "9. Maritial Status">
<cfset Q17 = "10. Entry into the Organizations service might require assignment to any area of he world in which the Organizations might have responsibilities.">
<cfset Q18 = "Are there any limitations on your ability to engage in all travel?">
<cfset Q19 = "Are there any limitations on your ability to perform in your prospective field of work?">
<cfset Q20 = "11. Have you taken up legal permanent residence status in any country other than that of your nationality?">
<cfset Q21 = "12. If you have taken any legal steps towards changing your present nationality, explain the circumstances:">
<cfset Q22 = "13. What is your preferred field of work?">
<cfset Q23 = "14. Would you accept employment for less than six months?">
<cfset Q24 = "15. If you have previously submitted an application for employment and/or undergone any tests with the Organizations, indicate when?">
<cfset Q25 = "16. Have you ever been arrested, indicted, or summoned into court as a defendant in a criminal proceeding, or convicted, fined or imprisoned for the violation of any law (excluding minor traffic violations)?">
<cfset Q26 = "Give an explanation of each">
<cfset Q27 = "17. State any other relevant facts, include information regarding any residence outside the country of your nationality.">
<cfset Q28 = "18. Email Address:">


<cfquery name="BirthNat" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Name
   	FROM  Ref_Nation
   	WHERE Code = '#Applicant.BirthNationality#'
	</cfquery>	
	
<cfquery name="BirthNat2" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Name
   	FROM  Ref_Nation
   	WHERE Code = '#Applicant.BirthNationality2#'
	</cfquery>	
	
<cfquery name="Nation" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Name
   	FROM  Ref_Nation
   	WHERE Code = '#Applicant.Nationality#'
	</cfquery>	
	
<cfquery name="NationAdditional" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Name
   	FROM  Ref_Nation
   	WHERE Code = '#Applicant.NationalityAdditional#'
	</cfquery>	


<!--- GENERAL DETAILS --->
<!--- *************************************************************************** --->
<table width="100%" border="0" align="center" >
	<tr><td class="title">General Details</td></tr>
	<tr><td bgcolor="333333"></td></tr>
	
	<table width="100%" border="0" align="center" >
	<cfoutput>
	<tr>
	<td width="25%">#Q1#</td>
	<td width="25%">#Q2#</td>
	<td width="25%">#Q3#</td>
	<td width="25%">#Q4#</td>
	</tr>

	<tr>
	<td><b>#UCase(Applicant.LastName)#</b></td>
	<td><b>#Applicant.FirstName#</b></td>
	<td><b>#Applicant.MiddleName#</b></td>
	<td><b>#Applicant.MaidenName#</b></td>
	</tr>

	<tr></tr>
	
	<cfif un eq "1">
		
	<tr>
	<td width="25%">#Q5#</td>
	<td width="25%">#Q6#</td>
	<td width="25%">#Q7#</td>
	<td width="25%">#Q8#</td>
	</tr>

	<tr>
	<td><b>#Dateformat(Applicant.DOB, CLIENT.DateFormatShow)#</b></td>
	<td><b>#Applicant.BirthCity#</b></td>
	<td><b>#BirthNat.Name#</b></td>    <!--- CountryOfBirth needs to be pulled into Applicant, until then showing BirthNationality --->
	<!---
	<td><b>#GALApplicant.CountryOfBirth#</b></td>
	--->
	<td><b>#Applicant.IndexNo#</b></td>
	</tr>
	
	</cfif>

	<tr></tr>
	
	<tr>
	<td width="25%">#Q9#</td>
	<td width="25%">#Q10#</td>
	<td width="25%">#Q11#</td>
	<td width="25%">#Q12#</td>
	</tr>

	<tr>
	<td><b>#BirthNat.Name#</b></td>
	<td><b>#BirthNat2.Name#</b></td>
	<td><b>#Nation.Name#</b></td>
	<td><b>#NationAdditional.Name#</b></td>
	</tr>

	<tr></tr>
	
	<cfif un eq "1">
	
	<tr>
	<td width="25%">#Q13#</td>
	<td width="25%">#Q14#</td>
	<td width="25%">#Q15#</td>
	<td width="25%">#Q16#</td>
	</tr>

	<tr>
	<td><b><cfif Applicant.Gender eq "F">Female
	<cfelseif Applicant.Gender eq "M">Male</cfif></b></td>
	<td><b>#GALApplicant.SUBM_Height#</b></td>
	<td><b>#GALApplicant.SUBM_Weight#</b></td>
	<td><b>#Applicant.MaritalStatus#</b></td>
	</tr>
	
	</cfif>
	
	</cfoutput>
	</table>
</table>	

<!--- Gal applicant --->

<cfif un eq "1">

<table width="100%" border="0" align="center" >

	<cfoutput>
	<tr><td>#Q17#</td></tr>	
	<tr><td>#Q18#&nbsp;&nbsp;&nbsp;<b><cfif GALApplicant.SUBM_Disability_Travel eq "1">Yes<cfelse>No</cfif></td></tr>	
	<tr><td>#Q19#&nbsp;&nbsp;&nbsp;<b><cfif GALApplicant.SUBM_Disability_Work eq "1">Yes<cfelse>No</cfif></td></tr>	
	<tr><td>#Q20#&nbsp;&nbsp;&nbsp;<b><cfif GALApplicant.SUBM_Legal_Residence eq "1">Yes. <cfoutput>#GALApplicant.SUBM_ResidenceCountry#.</cfoutput><cfelse>No</cfif></td></tr>	
	<!---
	<tr><td>#Q21#&nbsp;&nbsp;&nbsp;<b>#GALApplicant.SUBM_Legal_Explain#</td></tr>	
	--->
	<tr><td>#Q22#&nbsp;&nbsp;&nbsp;<b>#GALApplicant.SUBM_Field_Work#</b></td></tr>	
	<tr><td>#Q23#&nbsp;&nbsp;&nbsp;<b><cfif GALApplicant.SUBM_Six_Months eq "1">Yes<cfelse>No</cfif></td></tr>		
	<tr><td>#Q24#&nbsp;&nbsp;&nbsp;<b>#Dateformat(GALApplicant.SUBM_Date_Applied_Before, CLIENT.DateFormatShow)#</b></td></tr>	
	<tr><td>#Q25#&nbsp;&nbsp;&nbsp;<b><cfif GALApplicant.SUBM_Arrested eq "1">Yes<cfelse>No</cfif></td></tr>	
	<!---
	<tr><td>#Q26#</td></tr>	
	<tr><td><b>#GALApplicant.SUBM_ArrestedExplain#</b></td></tr>	
	<tr><td>#Q27#</td></tr>	
	<tr><td><b>#GALApplicant.SUBM_Other_Information#</b></td></tr>	
	--->
	<tr><td>#Q28#&nbsp;&nbsp;&nbsp;<b>#GALApplicant.eMail#</b></td></tr>	
	</cfoutput>
</table>

</cfif>

</body>
</html>
