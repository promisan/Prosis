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


	
	