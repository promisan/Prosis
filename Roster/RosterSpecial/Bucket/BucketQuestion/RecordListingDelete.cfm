
<cfoutput>

   <cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT TOP 1 *
		    FROM   ApplicantFunctionTopic
			WHERE  TopicId = '#topicid#'
	   </cfquery>
	   	
	  <cfif check.recordcount eq "0">
	      <cf_img icon="delete" onclick="ptoken.navigate('#session.root#/Roster/RosterSpecial/Bucket/BucketQuestion/RecordListingPurge.cfm?idfunction=#url.idfunction#&Topicid=#topicid#','listing')">		 
	  </cfif>	   
  
</cfoutput>  