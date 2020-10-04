
<!--- ---------------------------------------- --->
<!--- ---- attention sometime the workflow is open but the track close, which depends on the moment 
  in the workflow that this template is called --->
<!--- ---------------------------------------- --->  

<!--- --------close track for this person----- --->
  
<cfquery name="UpdateVacancyAction" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	 UPDATE  OrganizationObjectAction
	  SET    ActionStatus      = '2',
	         OfficerUserId     = '#SESSION.acc#',
		     OfficerLastName   = '#SESSION.last#',
		     OfficerFirstName  = '#SESSION.first#',
		     OfficerDate       = getDate(),
		     TriggerActionType = 'Arrival'	 
	  WHERE  ObjectId IN (SELECT ObjectId 
	                      FROM   OrganizationObject
                    	  WHERE  ObjectKeyValue1 = '#Object.ObjectKeyValue1#'
						  AND    ObjectKeyValue2 = '#Object.ObjectKeyValue2#'
						  AND    EntityCode = 'VacCandidate'
						  AND    Operational  = 1)
	  AND    ActionStatus = '0'
</cfquery> 	

 <!--- ------------------------------------ --->
 <!--- update track for this candidate----- --->
 <!--- ------------------------------------ --->
		 
 <cfquery name="UpdateTrackDocument" 
   datasource="AppsVacancy" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   UPDATE DocumentCandidate
	   SET    Status                 = '3',
	          StatusDate             = getDate(),
      		  StatusOfficerUserId    = '#SESSION.acc#',
	          StatusOfficerLastName  = '#SESSION.last#',
	          StatusOfficerFirstName = '#SESSION.first#'
	   WHERE  DocumentNo             = '#Object.ObjectKeyValue1#'	
	     AND  PersonNo               = '#Object.ObjectKeyValue2#'
 </cfquery>
 
 <!--- -------------------------------------------------- --->
 <!--- check if the parent document can be closed as well --->
 <!--- -------------------------------------------------- --->
 
 <!--- first we check if the workflow is still open as now we support 
 adding a last step for closing starting  20/09/2020 and then this is done manually as people might want to
 inform other candidates for example --->
 
 <cfquery name="CheckFlow" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   OrganizationObject OO INNER JOIN OrganizationObjectAction OOA ON OO.Objectid = OOA.Objectid
	   WHERE  OO.EntityCode    = 'VacDocument'	   
	   AND    OO.ObjectKeyValue1  = '#Object.ObjectKeyValue1#'	
	   AND    OO.Operational = 1 
	   AND    OOA.ActionStatus = '0'
 </cfquery>
 
<cfif checkflow.recordcount eq "0">
 		 
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
	 
</cfif>	 
 
<!--- ------------------------------------ --->
<!--- update contract to be set as cleared --->
<!--- ------------------------------------ --->
 
<cfquery name="qContract" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT  ObjectId 
		FROM    Organization.dbo.OrganizationObject
	    WHERE   ObjectKeyValue1 = '#Object.ObjectKeyValue1#'	
		AND     ObjectKeyValue2 = '#Object.ObjectKeyValue2#'	
		AND     EntityCode      = 'VacCandidate'
		AND     Operational     = 1		 
 </cfquery>
 
  <cfquery name="check" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * FROM PersonContract		  
	   WHERE  ContractId = '#qContract.ObjectId#' 
 </cfquery>
 
 <cfif check.recordcount eq "1">
  
    <!---- added by Armin on Nov 9th 2012---->
	    
		<cfset Object.ObjectKeyValue4 = qContract.ObjectId>
		<cfinclude template="../../../../Staffing/Application/Employee/Contract/ContractEditSubmitCommit.cfm">
	 	 		 
	 <!--- end of workflow action --->
 
 </cfif>
