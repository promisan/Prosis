
<!--- ---------------------------------------- --->
<!--- ---- attention sometime the workflow is open but the track close, which depends on the moment 
  in the workflow that this template is called --->
<!--- ---------------------------------------- --->  
  		 
 <cfquery name="CheckPosition" 
   datasource="AppsVacancy" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   DocumentPost
	   WHERE  DocumentNo      = '#Object.ObjectKeyValue1#'	
 </cfquery>

 <cfquery name="CheckCandidate" 
   datasource="AppsVacancy" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   DocumentCandidate
	   WHERE  DocumentNo      = '#Object.ObjectKeyValue1#'	
	   AND    Status = '3'
 </cfquery>

 <cfif CheckPosition.recordcount lte CheckCandidate.recordcount>

	  <cfquery name="CloseTrack" 
	   datasource="AppsVacancy" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   UPDATE Document
		   SET    Status                 = '1',
		          StatusDate             = getDate(),
       		      StatusOfficerUserId    = '#SESSION.acc#',
		          StatusOfficerLastName  = '#SESSION.last#',
		          StatusOfficerFirstName = '#SESSION.first#'
		   WHERE  DocumentNo             = '#Object.ObjectKeyValue1#'	
	 </cfquery>

 </cfif>
	
