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
<cfset R01 = "30. List three persons, not related to you, and who are not current United Nations Staff Members, who are familiar with your character and qualifications.  Do not repeat the names of supervisors listed under Employment.">

<table width="100%" border="0" align="center" >
	<tr><td class="title">References</td></tr>
	<tr><td bgcolor="333333"></td></tr>
	<tr></tr>
	<cfoutput>
	<tr><td >#R01#</td></tr>
	</cfoutput>

	<!--- references --->
		<cfquery name="References" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
		   	FROM  ApplicantReferenceExt
		   	WHERE PersonNo = '#PHPPersonNo#'
			Order by LastName, FirstName
		</cfquery>
			
<cfquery name="Reference_Country" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Name
   	FROM  Ref_Nation
   	WHERE Code = '#References.Country#' 
	</cfquery>	

		
		<tr></tr>	

		<tr><td>
		<table width="96%" border="0" align="center" >
		<tr></tr>

		<tr>
			<td width="25%"><i>Reference Name</i></td>
			<td width="30%"><i>Occupation or Business</i></td>
			<td width="30%"><i>Address</i></td>
			<td width="15%"><i>Telephone/Email</i></td>
		</tr>
		<tr><td colspan="4" bgcolor="333333"></tr>

		<cfloop query="References"> 
		<tr>
			<cfoutput>
			<td><b>#trim(References.FirstName) & ' ' & UCase(References.LastName)#</b></td>
			<td><b>#References.Organization#</b></td>
			<td><b>#References.Address# #References.City# #References.Zip# #Reference_Country.Name#</b></td>
			<td><b>#References.TelephoneNo# #References.EmailAddress#</b></td>
			</cfoutput>
		</tr>
		<tr></tr>
		</cfloop>

		</table>
		</td></tr>

</table>
