<!--- verify if SKILL record submission exists --->

<cfparam name="url.source" default="#CLIENT.Submission#">

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Source
	WHERE  Source = '#url.source#' 
</cfquery>

<cfif Verify.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_Source (Source)
	    VALUES ('#url.source#')
	</cfquery>

</cfif>

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  ApplicantNo
	 FROM   ApplicantSubmission
	 WHERE  PersonNo = '#FORM.PersonNo#'
	  AND   Source   = '#url.source#'
	ORDER   BY Created DESC
</cfquery>

<cfif Verify.recordcount eq "0">

 <!--- temp measure --->
     <cfquery name="Last" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT  MAX(ApplicantNo) AS LastNo
	     FROM    ApplicantSubmission
     </cfquery>
	 
	 <cfif Last.LastNo neq "">
	    <cfset new = Last.LastNo+1>
	 <cfelse>	
	    <cfset new = "1">
	 </cfif> 

     <cfquery name="AssignNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Parameter 
	 SET    ApplicantNo = #new#
     </cfquery>

     <cfquery name="LastNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM   Parameter
	 </cfquery>
 
     <!--- Submit submission --->

     <cfquery name="InsertApplicant" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ApplicantSubmission
         (PersonNo,
		 ApplicantNo,
  		 SubmissionDate,
		 ActionStatus,
		 Source,		
		 eMailAddress,
		 LanguageId,
	 	 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
      VALUES ('#Form.PersonNo#',
	       '#LastNo.ApplicantNo#', 
           '#DateFormat(Now(),CLIENT.dateSQL)#',
		  '0',
		  '#url.source#',		  
		  '',
		  '001',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())
     </cfquery>
	 
	 <cfset appno = LastNo.ApplicantNo>

<cfelse> 

     <cfset appno = Verify.ApplicantNo>
	 
</cfif>
