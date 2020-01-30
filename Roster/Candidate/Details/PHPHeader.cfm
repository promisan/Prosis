  
<cfquery name="Candidate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  	SELECT A.*, R.Description
    FROM   Applicant A LEFT OUTER JOIN Ref_ApplicantClass R ON A.ApplicantClass = R.ApplicantClassId 
	WHERE  A.PersonNo = '#URL.ID#'   		  
</cfquery>

<cfif Candidate.recordcount eq "0">

	<cf_tl id = "Candidate record no longer exists" var= "1" class="message">
	<cfoutput>
		<cf_message message="#lt_text#" return="close">
	</cfoutput>
	<cfabort>

</cfif>
