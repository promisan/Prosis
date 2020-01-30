
<!--- RELATIONS --->
<!--- *************************************************************************** --->
<cfset R01 = "19. Are any of your relatives employed by a public international organization?">
<cfset R02 = "If you answered yes in 19, list any relatives employed by the United Nations or its Specialized Agencies below:">
<cfset R03 = "If you have any dependents, list them below:">

<table width="100%" border="0" align="center" >
	<tr><td class="title">Relations</td></tr>
	<tr><td bgcolor="333333"></td></tr>
	
	<tr></tr>
	<cfoutput>
	<tr><td >#R01#&nbsp;&nbsp;&nbsp;<b><cfif GALApplicant.SUBM_Relative_Employed  eq "1">Yes<cfelse>No</cfif></td></tr>
	</cfoutput>
	
	<!--- UN RELATIVES --->
	<cfif GALApplicant.SUBM_Relative_Employed eq "1">
	
		<cfquery name="Relative" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT Distinct
				RelativeFirstName,
				RelativeLastName,
				Relationship,
				Organization
		   	FROM ApplicantRelative
		   	WHERE PersonNo = '#PHPPersonNo#' 
		</cfquery>	
		
		<tr></tr>	
		<tr><td>
		<table width="96%" border="0" align="center" >
		<Cfoutput>
		<tr><td colspan="3">#R02#</td></tr>
		</Cfoutput>
		<tr></tr>

		<tr>
			<td width="30%"><i>Name</i></td>
			<td width="30%"><i>Relation</i></td>
			<td width="40%"><i>Organization</i></td>
		</tr>
		<tr><td colspan="3" bgcolor="333333"></tr>
		<cfloop query="Relative"> 
		<tr>
			<cfoutput>
			<td><b>#trim(Relative.RelativeFirstName)# #UCase(Relative.RelativeLastName)#</b></td>
			<td><b>#Relative.Relationship#</b></td>
			<td><b>#Relative.Organization#</b></td>
			</cfoutput>
		</tr>
		</cfloop>
		</table>
		</td></tr>
		</cfif>
</table>

	<!--- DEPENDENTS --->
	

	<cfquery name="Dependent" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT distinct
			FirstName,
			LastName,
			Relationship,
			DOB,
			Gender,
			BirthCity,
			BirthCountry,
			Nationality1,
			Nationality2,
			Sort_Order			
	   	FROM ApplicantDependent
	   	WHERE PersonNo = '#PHPPersonNo#'
		Order by Sort_Order
	</cfquery>	

		<tr></tr>	
		<tr><td>
		<table width="95%" border="0" align="center" >
			<Cfoutput>
			<tr><td>#R03#</td></tr>
			</Cfoutput>
		</table>
		</td></tr>	
		
		<cfif Dependent.RecordCount gte "1">
		<tr><td>
		<table width="95%" border="0" align="center" >
		<tr></tr>

		<tr>
			<td width="23%"><i>Dependent Name</I></td>
			<td width="10%"><i>Relationship</i></td>
			<td width="10%"><i>Date of Birth</i></td>
			<td width="8%"><i>Gender</i></td>
			<td width="30%"><i>City, Country of Birth</i></td>
			<td width="20%"><i>Nationalities</i></td>
		</tr>
		<tr><td colspan="6" bgcolor="333333"></tr>
		<cfloop query="Dependent"> 
		<tr>

		<cfquery name="Country" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT Name
		   	FROM  Ref_Nation
		   	WHERE Code = '#Dependent.BirthCountry#'
			</cfquery>	
		
		<cfquery name="Nationality" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT Nationality
		   	FROM  Ref_Nation
		   	WHERE Code = '#Dependent.Nationality1#'
			</cfquery>	

		<cfquery name="Nationality2" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT Nationality
		   	FROM  Ref_Nation
		   	WHERE Code = '#Dependent.Nationality2#'
			</cfquery>	

			<cfoutput>
			<td><b>#trim(Dependent.FirstName) & ' ' & UCase(Dependent.LastName)#</b></td>
			<td><b>#Dependent.Relationship#</b></td>
			<td><b>#Dateformat(Dependent.DOB, CLIENT.DateFormatShow)#</b></td>
			<td><b><cfif Dependent.Gender eq "2">Female
			<cfelseif Dependent.Gender eq "1">Male</cfif></b></td>
			<td><b>#trim(Dependent.BirthCity) & ', ' & Country.Name#</b></td>
			<td><b>#trim(Nationality.Nationality)#<cfif Nationality2.Nationality neq "">, #Nationality2.Nationality#</cfif></b></td>
			</cfoutput>
		</tr>
		</cfloop>
		</table>
		</td></tr>
		</cfif>
