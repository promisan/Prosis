
<cfquery name="Check" 
	 datasource="AppsControl" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	      SELECT * FROM  SiteVersionReview
		  WHERE  ReviewId = '#URL.ReviewId#'	
</cfquery>	

<cfif check.officerUserid neq SESSION.acc>
	
	<cfquery name="Logging" 
		 datasource="AppsControl" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   INSERT INTO SiteVersionReviewLog
				  (ReviewId,
				   ActionStatus, 
				   AssessmentClass, 
				   AssessmentRisk, 
				   AssessmentNotes, 
				   OfficerUserId, 
				   OfficerLastName, 
				   OfficerFirstName, 
				   Created)
		   SELECT  ReviewId, 
		           ActionStatus, 
				   AssessmentClass, 
				   AssessmentRisk, 
				   AssessmentNotes, 
				   OfficerUserId, 
				   OfficerLastName, 
				   OfficerFirstName, 
				   Created
			FROM   SiteVersionReview
			WHERE  ReviewId = '#URL.ReviewId#'	
	</cfquery>	

</cfif>
	
<cfquery name="Check" 
	 datasource="AppsControl" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	      UPDATE SiteVersionReview
		  SET    ActionStatus = '#Form.ActionStatus#',
		         AssessmentClass = '#Form.AssessmentClass#',
			     AssessmentRisk  = '#Form.AssessmentRisk#',
			     AssessmentNotes = '#Form.AssessmentNotes#',
			     OfficerUserId   = '#SESSION.acc#',
			     OfficerLastName = '#SESSION.last#',
			     OfficerFirstName = '#SESSION.first#',
			     Created = getDate()
		  WHERE  ReviewId = '#URL.ReviewId#'	
</cfquery>	

<!--- logging --->

<cfoutput>
<input type="hidden" name="actionstatussel" id="actionstatussel" value="#Form.ActionStatus#">
</cfoutput>

<cfoutput>
Saved #timeformat(now(),"HH:MM:SS")#


<cfparam name="url.mode" default="open">

<cfif url.mode eq "close">
 <script>
 	window.close();returnValue='#url.reviewid#'
	 window.close()
 </script>
</cfif>

</cfoutput>


	
	