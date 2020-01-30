
<!--- REFERENCES--->
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
