
<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
  	SELECT 	*,
		    (SELECT TOP 1 ObjectKeyValue4 
			 FROM     Organization.dbo.OrganizationObject 
			 WHERE    (Objectid   = L.LeaveId OR ObjectKeyValue4 = L.LeaveId)
			 AND      EntityCode = 'EntLVE') as WorkflowId	
    FROM 	PersonLeave L
	WHERE   LeaveId = '#url.ajaxid#'	
</cfquery>

<cfquery name="LeaveType" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_LeaveType
	WHERE  LeaveType = '#get.LeaveType#'
</cfquery>


<cfquery name="Org" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
  	SELECT 	O.OrgUnit, O.OrgUnitName, O.Mission
    FROM 	PersonAssignment P, Organization.dbo.Organization O
  	WHERE	P.DateEffective <= getdate() 
	  AND   P.DateExpiration >= getdate()
	  AND   P.Incumbency > '0'
	  AND   P.AssignmentStatus < '8' <!--- planned and approved --->
      AND   P.AssignmentClass = 'Regular'
      AND   P.AssignmentType  = 'Actual'
      AND   P.OrgUnit = O.OrgUnit
  	  AND   P.PersonNo = '#get.PersonNo#'
</cfquery>
		
<cfset link = "Attendance/Application/LeaveRequest/RequestView.cfm?id=#url.ajaxid#">
							
<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  *
		FROM    Person
		WHERE   PersonNo = '#get.PersonNo#'		
</cfquery>		

<cfif (get.Status eq "8" or get.Status eq "9") and get.WorkflowId eq "">

	<!--- do not show the workflow if status is cancelled and there is no workflow to prevent it is generated --->
	
<cfelseif (get.Status eq "8" or get.Status eq "9") and get.WorkflowId neq "">
											
	<cf_ActionListing 
	    EntityCode       = "EntLVE"
		EntityGroup      = ""
		EntityStatus     = ""
		ObjectReference  = "#LeaveType.Description# #DateFormat(get.DateEffective,CLIENT.DateFormatShow)# #DateFormat(get.DateExpiration,CLIENT.DateFormatShow)#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
		ObjectKey1		 = "#get.PersonNo#"
	    ObjectKey4       = "#url.ajaxid#"						
		Show             = "Yes"
		CompleteFirst    = "No"
		CompleteCurrent  = "Yes"
		Toolbar			 = "hide"
		ajaxid           = "#url.ajaxid#"							
		ObjectURL        = "#link#"
		OrgUnit 		 = "#Org.OrgUnit#"
		Mission			 = "#Org.Mission#">	<!--- grant this person on the fly access to a step --->

<cfelse>
													
	<cf_ActionListing 
	    EntityCode       = "EntLVE"
		EntityGroup      = ""
		EntityStatus     = ""
		ObjectReference  = "#LeaveType.Description# #DateFormat(get.DateEffective,CLIENT.DateFormatShow)# #DateFormat(get.DateExpiration,CLIENT.DateFormatShow)#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
		ObjectKey1		 = "#get.PersonNo#"
	    ObjectKey4       = "#url.ajaxid#"						
		Show             = "Yes"
		CompleteFirst    = "No"
		Toolbar			 = "hide"
		ajaxid           = "#url.ajaxid#"							
		ObjectURL        = "#link#"
		OrgUnit 		 = "#Org.OrgUnit#"
		Mission			 = "#Org.Mission#"
		FlyActor         = "#get.FirstReviewerUserid#"
		FlyActorAction   = "#LeaveType.ReviewerActionCodeOne#"
		FlyActor2        = "#get.SecondReviewerUserid#"
		FlyActor2Action  = "#LeaveType.ReviewerActionCodeTwo#"
		FlyActor3        = "#get.HandoverUserId#"
		FlyActor3Action  = "#LeaveType.HandoverActionCode#">	<!--- grant this person on the fly access to a step --->
	
</cfif>	

	