
<!--- process roster status --->

<!--- determine input parameter --->

<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    Applicant.dbo.ApplicantReview
		WHERE   ReviewId = '#Object.ObjectKeyValue4#'
	
</cfquery>


<cfquery name="setAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE  Applicant.dbo.ApplicantReview
	 SET     Status = '0'
	 WHERE   ReviewId = '#Object.ObjectKeyValue4#'
</cfquery>

<!--- determine roster status --->
	
<cfinvoke component="Service.RosterStatus"  
	      method="RosterDeny" 
	      PersonNo= "#Action.PersonNo#"
		  Owner   = "#Action.Owner#">	
	
