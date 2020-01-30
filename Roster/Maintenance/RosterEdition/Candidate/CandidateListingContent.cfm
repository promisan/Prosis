<cfparam name="url.submissionedition" default="">
<cfparam name="url.owner"             default="">
<cfparam name="url.exerciseclass"     default="">

<cfoutput>

	<cfsavecontent variable="myquery">		
	
		SELECT A.PersonNo, 
		       A.LastName, 
			   A.FirstName, 
			   A.DOB, 
			   A.Gender, 
			   A.EMailAddress,
			   A.MobileNumber,
			   A.Nationality AS NationalityCode, 
			   N.Name AS Nationality, 
			   N.Continent,
		  	   COUNT(*) AS Applications
			   
		FROM   Applicant A
		
		INNER JOIN System.dbo.Ref_Nation N 
			ON A.Nationality = N.Code
		INNER JOIN ApplicantSubmission S
			ON A.PersonNo = S.PersonNo 
		INNER JOIN ApplicantFunction AF
			ON S.ApplicantNo = AF.ApplicantNo 
			
			<cfif url.submissionedition neq "all">
			
				AND AF.FunctionId IN (
					SELECT FunctionId
					FROM   FunctionOrganization
					WHERE  SubmissionEdition = '#url.submissionedition#' 
			)
			
			<cfelse>
			
				AND AF.FunctionId IN (
					SELECT FunctionId
					FROM   FunctionOrganization FO, Ref_SubmissionEdition S
					WHERE  FO.SubmissionEdition = S.SubmissionEdition
					AND    S.Owner = '#url.Owner#'
					AND    S.ExerciseClass = '#url.ExerciseClass#'				 
			)
			
			</cfif>
			
		GROUP BY A.PersonNo, 
		         A.LastName, 
				 A.FirstName, 
			     A.DOB, 
				 A.Gender, 
				 A.eMailAddress,
				 A.MobileNumber,
				 A.Nationality, 
				 N.Name, 
				 N.Continent
		
	</cfsavecontent>
	
</cfoutput>

<cfsavecontent variable="continentScript">
	
	<cfoutput>
  			SELECT @code, @fld, Continent
			FROM System.dbo.Ref_Nation WHERE Operational = 1 AND Code IN 
			( 
				SELECT NationalityCode
				FROM (#myquery#) AS S1
			) ORDER BY Continent 
	</cfoutput>
	
</cfsavecontent>

<cfset fields = ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm + 1>

<cfset fields[itm] = {label="LastName", 
                      field="LastName", 
					  alias="A", 
					  searchfield="LastName", 
                      filtermode="2",
					  displayfilter="Yes", 
					  search="text"}>

<cfset itm = itm + 1>

<cfset fields[itm] = {label="FirstName", 
                      field="FirstName", 
					  alias="A", 
					  searchfield="FirstName", 
                      filtermode="2",
					  displayfilter="Yes", 
					  search="text"}>

<cfset itm = itm + 1>

<cfset fields[itm] = {label="DOB", 
                      field="DOB", 
					  formatted="DateFormat(DOB,client.dateformatshow)", 
                      alias="A",
					  searchfield="DOB", 
					  filtermode="0", 
					  displayfilter="Yes", 
                      search="date"}>

<cfset itm = itm + 1>

<cfset fields[itm] = {label="Gender", 
                      field="Gender", 
					  alias="A", 
					  searchfield="Gender", 
                      filtermode="3",
					  displayfilter="Yes", 
					  search="text"}>

<cfset itm = itm + 1>

<cfset fields[itm] = {label="Continent", 
                      field="Continent", 
					  alias="N", 
					  searchfield="Continent", 
                      filtermode="2",
					  display="No", 
					  displayfilter="No", 
					  search="text"}>
					  
<cfset itm = itm + 1>

<cfset fields[itm] = {label="eMail", 
                      field="eMailAddress", 
					  alias="A", 					 					 
					  displayfilter="Yes", 
					  search="text"}>					  


<cfset itm = itm + 1>

<cfset fields[itm] = {label="Nationality", 
                      field="Nationality", 
					  alias="N", 
					  searchfield="Name", 
                      lookupgroup="Continent", 
					  lookupscript="#continentScript#", 
					  filtermode="2", 
					  displayfilter="Yes", 
					  search="text"}>

<cfset itm = itm + 1>

<cfset fields[itm] = {label="Submitted", 
                      field="Applications", 
					  searchfield="Applications", 
					  displayfilter="No",  
					  aggregate  = "sum"}>

<cfset menu = ArrayNew(1)>

<cf_tl id="Add candidate" var="1">

<cfset menu[1] = {label="#lt_text#", script="addCandidate('#url.submissionedition#','')"}>

<cf_listing header="Candidate" 
            menu="#menu#" 
			box="candidatelisting" 
            link="#session.root#/Roster/Maintenance/RosterEdition/Candidate/CandidateListingContent.cfm?systemfunctionid=#url.systemfunctionid#&SubmissionEdition=#url.submissionedition#&ExerciseClass=#url.exerciseclass#&owner=#url.Owner#" 
            html="No" 
			show="40" 
			datasource="AppsSelection" 
			listquery="#myquery#"
            listorder="LastName" 
			listorderfield="LastName" 
			listorderalias="A" 
			listorderdir="ASC"
            listgroup="Nationality" 
			listgroupdir="ASC" 
			headercolor="ffffff" 
			listlayout="#fields#"
            filtershow="Show" 
			excelshow="Yes" 
			drillmode="tab" 
			drillargument="930;1290;true;true"
            drilltemplate="Roster/Candidate/Details/PHPView.cfm?ID=" 
			drillkey="PersonNo">
			