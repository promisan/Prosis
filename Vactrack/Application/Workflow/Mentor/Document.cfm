
<cfquery name="Document" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   Document	
    WHERE  DocumentNo = '#Object.ObjectKeyValue1#'	
</cfquery>	

<cfquery name="Candidate" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   DocumentCandidate D, Applicant.dbo.Applicant A
	WHERE  D.PersonNo = A.PersonNo
    AND    D.DocumentNo = '#Object.ObjectKeyValue1#'
	AND    D.PersonNo   = '#Object.ObjectKeyValue2#'
</cfquery>	


<cfquery name="Continent" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   Ref_Nation
	WHERE  Code = '#Candidate.Nationality#'	
</cfquery>	

<cfset DOBS  = dateadd("yyyy",-7,Candidate.DOB)>
<cfset DOBE  = dateadd("yyyy",7,Candidate.DOB)>

<!--- mentors in the same gender and age group +/- 5) --->

<cfquery name="Mentor" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT    PersonNo, EmployeeNo, IndexNo, 
	          LastName, LastName2, MiddleName, MiddleName2, FirstName, MaidenName, 
			  MaritalStatus, 
			  BirthCity, BirthNationality, BirthNationality2, 
			  DOB, 
			  Gender, 
			  Nationality,
			  
			  (	  SELECT     TOP 1 O.OrgUnitName
				  FROM       Employee.dbo.PersonAssignment PA INNER JOIN
			                 Employee.dbo.Position P ON PA.PositionNo = P.PositionNo INNER JOIN
	                         Organization.dbo.Organization O ON P.OrgUnitOperational = O.OrgUnit
				  WHERE      P.Mission = '#Document.Mission#' 
				  AND        (PA.DateEffective < GETDATE() + 30) 
				  AND        (PA.DateExpiration > GETDATE() + 30) 
				  AND        PA.AssignmentStatus IN ('0', '1') 
				  AND        PersonNo = A.EmployeeNo
				  ORDER BY PA.DateEffective DESC ) as OrgUnitName			  
			 
	FROM      Applicant A
	WHERE     PersonNo IN
                          (SELECT   S.PersonNo
                           FROM     ApplicantFunction AS AF INNER JOIN
                                    FunctionOrganization AS FO ON AF.FunctionId = FO.FunctionId INNER JOIN
                                    ApplicantSubmission S ON AF.ApplicantNo = S.ApplicantNo
                           WHERE    FO.Mission = '#Document.Mission#'
						   AND      FO.SubmissionEdition = 'Buddy' 
						   AND      AF.Status IN ('0', '1', '2', '3')
						  ) 
    AND      Gender = '#Candidate.Gender#' 
	AND      DOB >= #DOBS# AND DOB <= #DOBE#
	AND      Nationality IN (SELECT Code FROM System.dbo.Ref_Nation WHERE Continent = '#Continent.Continent#')
	ORDER BY LastName

</cfquery>	


<!--- based on the document (owner/mission), 
 we show buddies ApplicantFunction with status is cleared = 2 and which function organization.Mission = document.Mission and SubmissionEdition = Buddy
 
 gender same / age is similar 
 if buddy is already taken then we show the assignments for this mentor which are valid and not expired
  
 --->
 
 <table width="95%" class="navigation_table formpadding" align="center">
 
     <cfoutput>
     <tr class="line"><td colspan="8">
		 <table class="formpadding">
		 <tr><td class="labellarge" colspan="2">Applied search</td></tr>
		 <tr class="labelmedium">
		 	<td style="padding-right:30px">DOB:</td>
			<td><b>#dateformat(DOBS, client.dateformatshow)# - #dateformat(DOBE, client.dateformatshow)#</td>
		 </tr>	
		 <tr class="labelmedium">
		 	<td>Gender:</td>
			<td><b>#Candidate.Gender#</td>
		 </tr>		
		 <tr class="labelmedium">
		 	<td style="padding-right:20px">Continent:</td>
			<td><b>#Continent.Continent#</td>
		 </tr>		
		 
		 </table>	 
	 </td></tr>
	 </cfoutput>
	 
	 <tr class="labelmedium line">
	    <td></td>
	 	<td>LastName</td>
		<td>FirstName</td>
		<td>IndexNo</td>
		<td>Nat</td>
		<td>DOB</td>
		<td>Gender</td>
		<td>Office</td>
	 </tr>
	 
	 <cfoutput query="Mentor">
	 
		  <tr class="navigation_row labelmedium">
		  	<td style="padding-left:4px"><input type="radio" name="Mentor" value="#PersonNo#" class="Radiol"></td>
			<td>#LastName#</td>
			<td>#FirstName#</td>
			<td>#IndexNo#</td>
			<td>#Nationality#</td>
			<td>#dateformat(DOB,client.dateformatshow)#</td>
			<td>#Gender#</td>
			<td>#OrgUnitName#</td>
		  </tr>	  
		  <!--- check if this user has a current mentorship assignment --->
	  
	 </cfoutput>
	 
	 <tr class="line navigation_row labelmedium">
	 <td style="padding-left:4px"><input type="radio" name="Mentor" value="" class="Radiol"></td>
	 <td colspan="7">n/a</td>
	 </tr>
  
 </table>

<cfoutput> 
<input name="savecustom" type="hidden"  value="Vactrack/Application/Workflow/Mentor/DocumentSubmit.cfm">
<input name="Key1" type="hidden" value="#Object.ObjectKeyValue1#">
<input name="Key2" type="hidden" value="#Object.ObjectKeyValue2#">
</cfoutput>
 
 